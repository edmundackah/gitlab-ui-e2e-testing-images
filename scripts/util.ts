import { readFileSync } from "fs-extra";
import { EOL } from "os";

export interface Build {
    name: string
    args?: string[]
}

export const NO_SPACES_REGEX = "^[^\\s]*$";

const isWhitespaceString = (str: string) => str.replace(/\s/g, '').length;

export const readFileToArray = (path: string) : string[] => {
    return readFileSync(path, {encoding: "utf-8"})
    .split(EOL)
    .filter((p) => isWhitespaceString(p)); // remove empty strings
}

export const parseArgs = (args?: string[]) : string => {
    let output: string = "";
    if (args !== undefined) {
        args.forEach((element: string) => {
            output = output + ` --build-arg ${element}`;
        });
    } else output = "none";

    return output;
};