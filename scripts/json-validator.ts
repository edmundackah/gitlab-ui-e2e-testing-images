import { Draft07, Draft, JsonError } from "json-schema-library";
import { readFileToArray, schema, checkForDuplicateNames } from "./util";
import { readJSONSync } from "fs-extra";
import { error } from "console";

const jsonSchema: Draft = new Draft07(schema);

//read changes.txt file into array
let changeLog: string[] = readFileToArray("changes.txt");

let messages: string[] = [];

//validate each modified build.json file
changeLog.forEach((element, index, arr) => {
    //read build json file
    const json = readJSONSync(element);

    //check for duplicate image name
    checkForDuplicateNames(json);

    //validate with JsonSchema
    const res: JsonError[] = jsonSchema.validate(json);

    res.length > 0 && messages.push(`\n${element} failed validation with the following errors:\n`);
    res.forEach((element) => messages.push(`\t${element.message}`));
});

messages.forEach((element) => error(element));

process.exit(messages.length > 0 ? 1 : 0);