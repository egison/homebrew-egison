# homebrew-egison
Homebrew formula to install Egison

## Installation

```sh
$ brew tap greymd/egison
$ brew update
$ brew install egison
```

## For developers

### Update binary

```
$ cabal update
$ cabal install --only-dependencies
$ cabal configure --datadir=/usr/local/lib --datasubdir=egison
$ cabal build
```

And upload `dist/build/egison/egison`

### Update formula
```sh
# Edit
$ brew edit greymd/egison/egison

# Check
$ brew audit --strict greymd/egison/egison

# Commit & Push

$ cd /usr/local/Homebrew/Library/Taps/greymd/homebrew-egison/
$ git add egison.rb
$ git commit -m 'Something'
$ git push origin master
```
