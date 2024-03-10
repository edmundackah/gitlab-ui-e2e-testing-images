import { readFileSync, readJSONSync, readJsonSync, writeFileSync } from "fs-extra";
import { log } from "console";
import { EOL } from "os";
import { parseArgs, readFileToArray, Build } from "./util";

const changeLog: string[] = readFileToArray("jobs.txt");

console.log(changeLog);

let templates: string[] = [];

//build dynamic ci yaml
templates.push(`image: silverarrow/cypress-13-edge-chrome-firefox-node-20:latest

stages:
  - test
`);

const createJob = (info: Build) => { return `
${info.name}:
  stage: test
  script:
    - >
      if [[ "${parseArgs(info.args)}" != "none" ]]; then
        echo docker build -t ${info.name}:latest ${parseArgs(info.args)} .
      else 
        echo docker build -t ${info.name}:latest .
      fi
`};

changeLog.forEach((element) => {
    const build: Build[] = readJsonSync(element);

    build.forEach((element: Build) => {
        templates.push(createJob(element));
    });
});

writeFileSync('dynamic-gitlab-ci.yml', templates.join(""));