# homebrew-egison
Homebrew formula to install Egison

## Installation

```sh
$ brew tap egison/egison
$ brew install egison
```
### Upgrade

```sh
$ brew tap egison/egison
$ brew upgrade egison
```

### Uninstallation

```sh
$ brew remove egison
$ brew untap egison/egison
```

* * *

## For developers of this repository

### How to build binary (egison)

```sh
$ git clone https://github.com/egison/egison.git
$ cd egison
$ cabal v2-update
$ cabal v2-install --only-dependencies --lib
$ cabal v2-configure
$ cabal v2-build
$ _pathsfile="$(find "./dist-newstyle" -type f -name 'Paths_egison.hs' | head -n 1)"
$ perl -i -pe 's@datadir[ ]*=[ ]*.*$@datadir = "/usr/local/lib/egison"@' "$_pathsfile"
$ cp "$_pathsfile" ./hs-src
$ cabal v2-build
$ file $(find "./dist-newstyle" -type f -name 'egison')
```

### How to build binary (egison-tutorial)

```sh
$ git clone https://github.com/egison/egison-tutorial.git
$ cd egison-tutorial
$ cabal v2-update
$ cabal v2-configure
$ cabal v2-build
$ mkdir bin
$ cp $(find dist-newstyle/ -type f  -name egison-tutorial) ./bin/egison-tutorial-impl
$ printf '%s\n%s\n' '#!/bin/sh' 'egison_datadir=/usr/local/lib/egison egison-tutorial-impl "$@"' > ./bin/egison-tutorial
$ chmod +x ./bin/egison-tutorial
$ file_name="egison-tutorial_$(uname | sed 's/./\L&/')_$(uname -m)_$(awk '/Version:/{print $NF}' egison-tutorial.cabal ).zip"
$ zip -r "$file_name" bin
### => get zip file
$ shasum -a 256 "$file_name"
### => get hash
```

Update `egison-tutorial.rb`

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
