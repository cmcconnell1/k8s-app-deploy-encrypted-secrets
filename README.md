# Kubernetes Deployment with Encrypted Secrets
#### Overview
- Uses simple Kubernetes manifests (as templates) and a build script with SED to set requisite variables for each environment.
- Used git-crypt to encrypt secrets.
- Possible use cases:
  - lack of team knowledge with Kubernetes, etc.
  - teams with resource constraints or wishing to avoid complexity--Helm charts, Kustomize, etc.
  - rapidly implement CI/CD for your application/service in Kubernetes (where your manifests don't change often/much).

##### Note: 
For development branch/environment, automatically builds the Kubernetes manifests and then applies to cluster upon git push--for stage and production branches/environments, this can easily be modified as desired by changing the logic in the `Jenkinsfile`.

#### Requisite Environment Variables: 
  - Just set requisite variables for the environment and commit with git--see below and Jenkinsfile, etc.
#### Encrypted and Managed Secrets
  - Secrets are encrypted and checked in to git and then are decrypted with the git-crypt key and passed to Kubernetes during execution of the `./development/myap.secrets` file.
  - To provide secure encrypted secrets management, we use git-crypt--see the `./secrets/development/myap.secrets` file. 
  - If you do choose to use git-crypt, the first step is to git-crypt init, followed by a git-crypt export of the keyfile:
    - `git-crypt init`  
    - `git-crypt export-key ~/.git-crypt-keys/myapp.key`

    - Provide you have the key distribute it to you other team members and automated processes, CI/CD (jenkins), etc.
    - Unlock / decrypt any/all encrypted files with: 
    - i.e.: `git-crypt unlock ~/.git-crypt-keys/myapp.key`

  - The secrets we create in the myapp.secrets file are available to Kubernetes and are used in the deployment.yaml--the template excerpt shown below: 
  ```console
      spec:
      containers:
      - name: "myapp"
        image: "__MYAPP_REPO__:__BUILD_VERSION__"
        envFrom:
        - configMapRef:
            name: "myapp-config"
        - secretRef:
            name: "myapp-secrets"
  ```
##### NOTE: ensure your .gitattributes file is committed before committing sensitive files.
- Ensure that your file(s) will be encrypted
- ref: https://www.agwa.name/projects/git-crypt
```console
git-crypts status -e
```
Note the secrets file was committed without being encrypted on purpose so that you could see the contents of the file--see the git-crypt docs.
Always commit all ./.gitattributes files first, then sensitive files/data.

##### Deploy Project
- Deploys myapp to requisite environments controlled/gated by specific branch (and requisite Jenkinsfile code/logic).

- Each branch has a corresponding environment (with separate kubernetes clusters, kubeconfig files and Jenkinsfile logic, etc.).
- I.e.: We have `development` configured here, and you can copy the vars file and build script for each additional env/branch you want.
  - `development` set to the default github project repo branch.
  - `stage`
  - `production`

#### Example Workflow
- `development` branch/environment workflow 
  - `git co development`
  - Update `development.vars` file and commit to `development` branch (see Jenkinsfile)
    - Upon `git push origin development`, the `Jenkinsfile` will trigger the build of your kubernetes manifests when it executes the: `build-development-myapp-manifests` script
- Note: To support additional environments, simply copy and rename this script for each additional desired branch/environment.
        - I.e.: `stage`, `production`, etc.

#### Notes:
- As noted above, simply copy the requisite build script and variables for each additional branch/environment you wish to add to CI/CD
- I.e.: to add a stage environment/branch
  - git co -b stage
  - `cp build-development-myapp-manifests build-stage-myapp-etl-manifests`
  - NOTE: Modify requisite vars and logic--i.e.: decide on your git commit/deploy strategy and update the Jenkinsfile, etc. accordingly.

- production (repeat above notes/steps for `stage`, but substitute `production`)
