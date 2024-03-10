import { parseArgs, readFileToArray, Build } from "./util";
import { readJSONSync, writeFileSync } from "fs-extra";
import { info, debug } from "console";
import { EOL } from "os";

const changeLog: string[] = readFileToArray("jobs.txt");

debug(changeLog);

let templates: string[] = [];

if (changeLog.length > 0) {

  //build dynamic ci yaml
  const createJob = (config: Build, source: string) => { return `
  deploy:${config.name}:
    stage: deploy
    image: silverarrow/cypress-13-edge-chrome-firefox-node-20:latest
    script:
      - cd ${source}
      - ls
      - >
        if [[ "${parseArgs(config.args)}" != "none" ]]; then
          echo docker build -t ${config.name}:latest ${parseArgs(config.args)} .
        else 
          echo docker build -t ${config.name}:latest .
        fi
  `};

  changeLog.forEach((file: string) => {
      const build: Build[] = readJSONSync(file);

      //directory of build.json file
      const source = file.replace("build.json", "");

      build.forEach((config: Build) => {
          templates.push(createJob(config, source));
      });
  });

} else {
  
  const noJobs = `
  deploy:no-changes-found:
    stage: deploy
    image: silverarrow/cypress-13-edge-chrome-firefox-node-20:latest
    script:
      - echo "skipping child pipeline(s), no build.json changes found"`;
  
  templates.push(noJobs);
  
}

writeFileSync('dynamic-gitlab-ci.yml', templates.join(""));