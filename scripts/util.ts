import { readFileSync } from "fs-extra";
import { EOL } from "os";

export const NO_SPACES_REGEX = "^[^\\s]*$";

export const schema = {
    type: "array",
    minItems: 1,
    items: {
        type: "object",
        required: ["name"],
        properties: {
            name: {
                type: "string",
                pattern: NO_SPACES_REGEX,
                minimum: 3
            },
            args: {
                type: "array",
                items: {
                    type: "string",
                    pattern: NO_SPACES_REGEX,
                    minimum: 3
                }
            }
        }
    }
};

export interface Build {
    name: string
    args?: string[]
}

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

export const checkForDuplicateNames = (arr: Build[]): void => {
    const nameSet = new Set<string>();

    for (const obj of arr) {
        if (nameSet.has(obj.name)) {
            throw new Error(`Duplicate name found: "${obj.name}"`);
        }
        nameSet.add(obj.name);
    }
}