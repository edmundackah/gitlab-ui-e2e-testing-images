import { Draft07, Draft, JsonError } from "json-schema-library";
import fs from "fs-extra";

const NO_SPACES_REGEX = "/^[^\s]*$";

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
let changeLog: string[] = fs.readFileSync("changes.txt", {encoding: "utf-8"}).split("\r\n");

//filter changelog for build.json files
changeLog = changeLog.filter((p) => p.endsWith("build.json"));

let messages: string[] = [];

//validate each modified build.json file
changeLog.forEach((element, index, arr) => {
    //read build json file
    const json = fs.readJSONSync(element);

    //validate with JsonSchema
    const res: JsonError[] = jsonSchema.validate(json);
    res.length > 0 && messages.push(`\n${element} failed validation with the following errors:\n`);
    res.forEach((element) => messages.push(`\t${element.message}`));
});

messages.forEach((element) => console.error(element));

process.exit(messages.length > 0 ? 1 : 0);