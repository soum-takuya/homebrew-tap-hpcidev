# homebrew-tap for HPCI

## Bottles (Packages)

- hpcissh
  - <https://github.com/hpci-auth/hpcissh-clients>
- jwt-agent
  - <https://github.com/oss-tsukuba/jwt-agent>
- oidc-agent-cli@5
  - <https://github.com/indigo-dc/oidc-agent>
  - without oidc-prompt

## Instructions for users

### Tap this repository

- brew tap hpci-auth/tap

### Install

- brew install BOTTLE_NAME
- (Ex.) brew install hpcissh

### Uninstall

- brew uninstall BOTTLE_NAME
- (Ex.) brew uninstall hpcissh

### Untap this repository

- brew untap hpci-auth/tap

## Instructions for developers

### Check files in local before "git push"

- `REPOSITORY=$(brew --repo hpci-auth/tap-localtest)`
- .`/check-before-push.sh [Formula name]`
  - The `${REPOSITORY}` directory is created automatically
  - Installing, Testing and Uninstalling all formulae or a specified formula
- Untap the symlink
  - `rm ${REPOSITORY}`

### Release (push and merge)

https://brew.sh/2020/11/18/homebrew-tap-with-bottles-uploaded-to-github-releases/

- (In local)
  - git checkout -b <BRANCH_NAME(any)>
  - (Edit files)
  - (git add ...)
  - git commit
  - git push origin <the BRANCH_NAME>
- (In GitHub Web UI)
  - Create a pull request (the BRANCH_NAME to main branch)
  - Wait until the pull request’s checks become green.
  - Then label your pull request with the `pr-pull` label.
  - After a couple of minutes...
    - PR closed automatically,
    - bottles uploaded automatically,
    - commits pushed to the main branch automatically

### GitHub Actions Runner

https://docs.github.com/en/actions/reference/runners/github-hosted-runners#standard-github-hosted-runners-for-public-repositories
