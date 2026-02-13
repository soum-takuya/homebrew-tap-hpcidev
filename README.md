# homebrew-tap for HPCI

## For users

### Tap this repository

- brew tap hpci-auth/tap

### Install

- brew install hpcissh
- brew install jwt-agent

### Uninstall

- brew uninstall BOTTLE

### Untap

- brew untap hpci-auth/tap

## For developers

### Check files in local before "git push"

- WORKDIR=$(basename $(pwd))
  - This "git clone"ed directory
  - Name format: homebrew-TAPNAME
- HOMEBREW_PREFIX=$(brew --prefix)
  - (Ex.) macOS: /opt/homebrew
- mkdir ${HOMEBREW_PREFIX}/Library/Taps/USERNAME(any name)/
- ln -s $(pwd) /opt/homebrew/Library/Taps/USERNAME/
- UNINSTALL=1 ./check-before-push.sh USERNAME/TAPNAME [Formula name]
  - installing, testing and uninstalling all formulae or a specified formula
- Untap the symlink
  - rm /opt/homebrew/Library/Taps/USERNAME/homebrew-TAPNAME
  - rmdir /opt/homebrew/Library/Taps/USERNAME

### Release (push and merge)

https://brew.sh/2020/11/18/homebrew-tap-with-bottles-uploaded-to-github-releases/

- (in local)
  - git checkout -b ANYNAME(branch name)
  - (Edit files)
  - (git add ...)
  - git commit
  - git push
- (in GitHub Web UI)
  - Create a pull request (the ANYNAME to main branch)
  - Wait until the pull request’s checks become gree.
  - Then label your pull request with the `pr-pull` label.
  - After a couple...
    - PR closed,
    - bottles uploaded,
    - commits pushed to the main branch

### GitHub Actions Runner

https://docs.github.com/en/actions/reference/runners/github-hosted-runners#standard-github-hosted-runners-for-public-repositories
