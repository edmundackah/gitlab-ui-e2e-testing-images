import { Draft07, Draft, JsonError } from "json-schema-library";
import { readFileToArray, NO_SPACES_REGEX } from "./util";
import { readJSONSync } from "fs-extra";
import { error } from "console";
import { EOL } from "os";


const schema = {
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

const jsonSchema: Draft = new Draft07(schema);

//read changes.txt file into array
let changeLog: string[] = readFileToArray("changes.txt");

let messages: string[] = [];

//validate each modified build.json file
changeLog.forEach((element, index, arr) => {
    //read build json file
    const json = readJSONSync(element);

    //validate with JsonSchema
    const res: JsonError[] = jsonSchema.validate(json);

    res.length > 0 && messages.push(`\n${element} failed validation with the following errors:\n`);
    res.forEach((element) => messages.push(`\t${element.message}`));
});

messages.forEach((element) => error(element));

process.exit(messages.length > 0 ? 1 : 0);