import { imgResizer } from "./resizer";
import type { EventFunc } from "./resizer";

export const portfolioImageResizer: EventFunc = async (...args) => {
  const folderName = "portfolio";
  await imgResizer(...args, folderName);
};
