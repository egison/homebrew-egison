# homebrew-egison
Homebrew formula to install Egison

## Installation

```sh
$ brew tap egison/egison
$ brew update
$ brew install egison
```

## For developers of this repository

### How to update binary

```sh
$ git clone https://github.com/egison/homebrew-egison.git
$ git clone https://github.com/egison/egison.git
$ cd egison
$ cabal update
$ cabal install --only-dependencies
$ cabal configure --datadir=/usr/local/lib --datasubdir=egison
$ cabal build

$ cd ..
$ cp egison/dist/build/egison/egison homebrew-egison/bin/egison
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
