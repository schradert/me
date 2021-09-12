import * as functions from "../src/resizer";
import fs from "fs";
import path from "path";
import sharp from "sharp";
import sizeOf from "image-size";
// import { assert } from "console";

const mockFile = {
  createWriteStream: jest.fn().mockImplementation(() => {
    return fs.createWriteStream(path.resolve(process.cwd(), "data/write.webp"));
  }),
  createReadStream: jest.fn().mockImplementation(() => {
    return fs.createReadStream(path.resolve(process.cwd(), "data/read.png"));
  }),
  rename: jest.fn().mockImplementation(async (name: string) => {
    fs.rename("data/write.webp", "data/read.webp", (error) => {
      if (error) throw error;
    });
  }),
};

const origImageSize = sizeOf("data/read.png");
console.assert(origImageSize.height != 160);
console.assert(origImageSize.width != 160);
console.assert(origImageSize.type != "webp");

const mockBucket = {
  file: jest.fn((filename: string) => ({
    name: filename,
    ...mockFile,
  })),
};

const mockStorage = {
  bucket: jest.fn(() => mockBucket),
};

jest.mock("@google-cloud/storage", () => {
  return {
    Storage: jest.fn(() => mockStorage),
  };
});

import { Storage, File } from "@google-cloud/storage";
import { assert } from "console";

function createFile(filename: string): File {
  const bucketName = "test-bucket";
  const storage = new Storage();
  const bucket = storage.bucket(bucketName);
  return bucket.file(filename);
}

const context = {
  eventType: "google.storage.object.finalize",
};
const folder = "portfolio";

describe("portfolioImageResizer", () => {
  let logSpy: jest.SpyInstance, funcSpy: jest.SpyInstance;

  beforeEach(async () => {
    logSpy = jest.spyOn(functions.logger, "info"); //mockImplementation();
    funcSpy = jest.spyOn(functions, "imgResizer");
  });

  afterEach(() => {
    logSpy.mockRestore();
    funcSpy.mockRestore();
  });

  afterAll(() => {
    jest.clearAllMocks();
  });

  test("ignores files uploaded outside portfolio section", async () => {
    const file = createFile("not-portfolio/test.png");
    await functions.imgResizer(file, context, folder);
    expect.assertions(2);
    expect(funcSpy).toHaveBeenCalled();
    expect(logSpy).toHaveBeenCalledWith(
      "File not uploaded to the portfolio project. Ignoring."
    );
  });

  test("warns of file not being configured", async () => {
    const file = createFile("portfolio/invalid/test.png");
    await functions.imgResizer(file, context, folder);
    expect.assertions(2);
    expect(funcSpy).toHaveBeenCalled();
    expect(logSpy).toHaveBeenCalledWith(`
      File added to portfolio, but subfolder "invalid" is not in the list of
      supported image types "avatar, bg, project"
    `);
  });

  test("converts an image to the correct size by configured subdirectory it was added to", async () => {
    fs.rmSync("data/write.webp", { force: true });

    const file = createFile("portfolio/avatar/test.png");

    // prevent any untracked logging from messing with test output
    sharp().on = jest.fn(function (this: any, event, callback) {
      if (event === "finish") callback();

      const newImageSize = sizeOf("data/write.webp");
      assert(newImageSize.height === 160);
      assert(newImageSize.width === 160);
      assert(newImageSize.type === "webp");
      fs.rmSync("data/write.webp", { force: true });

      return this;
    });

    await functions.imgResizer(file, context, folder);

    expect.assertions(1);
    expect(funcSpy).toHaveBeenCalled();
  });
});
