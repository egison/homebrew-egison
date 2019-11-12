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

### How to build binary

```sh
$ git clone https://github.com/egison/egison.git
$ cd egison
$ cabal update
$ cabal install --only-dependencies --lib
$ cabal configure
$ _pathsfile="$(find "./dist-newstyle" -type f -name 'Paths_egison.hs' | head -n 1)"
$ perl -i -pe 's@datadir[ ]*=[ ]*.*$@datadir = "/usr/local/lib/egison"@' "$_pathsfile"
$ cp "$_pathsfile" ./hs-src
$ cabal build
$ $(find "./dist-newstyle" -type f -name 'egison')
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
