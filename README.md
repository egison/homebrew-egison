# homebrew-egison
Homebrew formula to install Egison

## Installation

```sh
$ brew tap egison/egison
$ brew install egison
```

### Uninstallation

```sh
$ brew remove egison
$ brew untap egison/egison
```

* * *

## For developers of this repository

### How to update binary

```sh
# Build executable binary.
$ git clone https://github.com/egison/homebrew-egison.git
$ git clone https://github.com/egison/egison.git
$ cd egison
$ cabal update
$ cabal install --only-dependencies
$ cabal configure --datadir=/usr/local/lib --datasubdir=egison
$ cabal build

# Compress binary.
$ cp dist/build/egison/egison
$ zip egison_darwin_amd64.zip egison
$ tar -zcvf egison_darwin_amd64.tar.gz egison

# Upload egison_darwin_amd64.zip
# and
# egison_darwin_amd64.tar.gz to the GitHub Releases
```

### Update formula
```sh
# Edit
$ brew edit egison/egison/egison

# Check
$ brew audit --strict egison/egison/egison

# Commit & Push

$ cd /usr/local/Homebrew/Library/Taps/egison/homebrew-egison/
$ git add <something>
$ git commit -m '<something>'
$ git push origin master
```
