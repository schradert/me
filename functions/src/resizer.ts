import { File } from "@google-cloud/storage";
import { CloudFunctionsContext } from "@google-cloud/functions-framework/build/src/functions";
import sharp from "sharp";
import pino from "pino";

export const logger = pino();

/**
 * TYPES
 */
type EventFuncParams = [file: File, context: CloudFunctionsContext];
export type EventFunc = (...args: EventFuncParams) => Promise<void>;
type EventFuncWithFolder = EventFunc extends (...args: infer U) => infer R
  ? (...args: [...U: Parameters<EventFunc>, folder: string]) => R
  : never;

/**
 * DEFAULTS
 */
const ObjectTyped = {
  keys: Object.keys as <O extends Record<string, unknown>>(
    obj: O
  ) => Array<string>,
};
const defaultImageSize = {
  avatar: [160, 160],
  bg: [1800, 1000],
  project: [300, 200],
};
const supportedImgTypes = ObjectTyped.keys(defaultImageSize);

/**
 * Extension of Cloud Function handling Cloud Storage events to specify folder
 * @param file the file object passed as payload in the Cloud Function
 * @param folder the "folder" on Cloud Storage to be listening for events on
 * @returns
 */
export const imgResizer: EventFuncWithFolder = async (file, _, folder) => {
  const imgType = new RegExp(folder + "[/](\\w+)[/]", "g").exec(file.name)?.[1];

  if (!imgType) {
    logger.info("File not uploaded to the portfolio project. Ignoring.");
    return;
  }

  if (!supportedImgTypes.includes(imgType)) {
    logger.info(`
      File added to portfolio, but subfolder "${imgType}" is not in the list of
      supported image types "${supportedImgTypes.join(", ")}"
    `);
    return;
  }

  const newDims = defaultImageSize[imgType as keyof typeof defaultImageSize];
  const resizer = sharp()
    .webp({ nearLossless: true })
    .resize(...newDims)
    .on("error", (error) => logger.error("Image resizer failed: " + error));

  file
    .createReadStream()
    .pipe(resizer)
    .pipe(file.createWriteStream())
    .on("error", (error) => logger.error(error))
    .on("finish", async () => {
      logger.info("File upload completed!");
      const newFilename = file.name.replace(/\.(jpg|png|webp)$/, ".webp");
      await file.rename(newFilename);
      logger.info(
        `File ${file.name} successfully overwritten as ${newFilename}`
      );
    });
};
