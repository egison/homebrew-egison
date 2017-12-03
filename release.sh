#!/bin/bash

# ===================================
# Automated build script for Egison
# Required Environment Variables:
#  * TRAVIS_BUILD_DIR -- Given by TravisCI
#  * ID_RSA           -- Given by TravisCI's settings screen
#                        FYI: https://travis-ci.org/egison/homebrew-egison/settings
#  * GITHUB_AUTH      -- Given by TravisCI's settings screen.
#                        Auth token for GitHub Rest API.
# ===================================
set -ue

FNAME=$(echo "egison_$(uname)_$(uname -m)" | tr '[:upper:]' '[:lower:]' | tr -dc 'a-z0-9._')
THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LATEST_VERSION=
CURRENT_VERSION=
TARGET_BRANCH="master"
BUILDER_REPO="egison/homebrew-egison"
BUILDER_REPO_NAME=${BUILDER_REPO##*/}
BUILD_REPO="egison/egison"
RELEASE_TARBALL="${TRAVIS_BUILD_DIR:-$THIS_DIR}/${FNAME}.tar.gz"
## User-Agent starts with Travis is required (https://github.com/travis-ci/travis-ci/issues/5649)
COMMON_HEADER=("-H" "User-Agent: Travis/1.0" "-H" "Authorization: token $GITHUB_AUTH" "-H" "Accept: application/vnd.github.v3+json" "-L" "-f")
RELEASE_API_URL="https://api.github.com/repos/${BUILDER_REPO}/releases"

# Initialize SSH keys
init () {
  printf "Host github.com\n\tStrictHostKeyChecking no\n" >> $HOME/.ssh/config
  echo "${ID_RSA}" | base64 --decode | gzip -d > $HOME/.ssh/id_rsa
  chmod 600 $HOME/.ssh/id_rsa
  git config --global user.name "greymd"
  git config --global user.email "greengregson@gmail.com"
}

get_version () {
  git clone -b "${TARGET_BRANCH}" "git@github.com:${BUILDER_REPO}.git" "${THIS_DIR}/${BUILDER_REPO_NAME}"
  cd "${THIS_DIR}/${BUILDER_REPO_NAME}"
  curl -f -v -H "User-Agent: Travis/1.0" \
       -H "Authorization: token $GITHUB_AUTH" \
       -L "https://api.github.com/repos/${BUILD_REPO}/releases/latest" > "./latest.json"
  LATEST_VERSION=$(cat "./latest.json" | jq -r .tag_name | tr -d '\n')
  CURRENT_VERSION=$(cat "./VERSION" | tr -d '\n')
  rm "./latest.json"
  rm -rf "${THIS_DIR}/${BUILDER_REPO_NAME}"
  cd "${THIS_DIR}"
}

bump () {
  local _sha256hash
  local _release_id
  local _new_release_info
  if [[ "${CURRENT_VERSION}" == "${LATEST_VERSION}" ]];then
    echo "Skip git push. It is latest version." >&2
    exit 0
  fi
  # Build tarball
  ( build )
  if [[ ! -s "${RELEASE_TARBALL}" ]];then
    echo "Failed to create '${RELEASE_TARBALL}'"
    exit 1
  fi

  git clone -b "${TARGET_BRANCH}" \
    "git@github.com:${BUILDER_REPO}.git" \
    "${THIS_DIR}/${BUILDER_REPO_NAME}"

  cd "${THIS_DIR}/${BUILDER_REPO_NAME}"

  # Edit files
  _sha256hash=$(shasum -a 256 "${RELEASE_TARBALL}" | perl -anle 'print $F[0]')
  perl -i -pe 's/VERSION = ".*"/VERSION = "'${LATEST_VERSION}'"/' "./egison.rb"
  perl -i -pe 's/sha256 ".*"/sha256 "'${_sha256hash}'"/' "./egison.rb"
  echo "$LATEST_VERSION" > "./VERSION"

  # Crete versions and make changes to GitHub
  git add "./VERSION" "./egison.rb"
  git commit -m "[skip ci] Bump version to ${LATEST_VERSION}"

  ## Clean tags just in case
  _release_id=$(get_release_list | jq '.[] | select(.tag_name == "'${LATEST_VERSION}'") | .id')
  ## If there is already same name of the release, delete it.
  if [[ "${_release_id}" != "" ]]; then
    delete_release "${_release_id}" || exit 1
    git push :"${LATEST_VERSION}"  || true
    git tag -d "${LATEST_VERSION}" || true
  fi

  ## Push changes
  git push origin "${TARGET_BRANCH}"

  # Create new release
  _new_release_info=$(create_release "${LATEST_VERSION}" "${TARGET_BRANCH}")
  _upload_url=$(echo "${_new_release_info}" | jq -r .upload_url | perl -pe 's/{.*}//')
  upload_assets "${_upload_url}" "${RELEASE_TARBALL}"
}

build () {
  local _workdir="work-$RANDOM"
  git clone -b "${LATEST_VERSION}" \
    "https://github.com/${BUILD_REPO}.git" "${THIS_DIR}/egison"
  cd "${THIS_DIR}/egison"
  cabal update
  cabal install --only-dependencies
  cabal configure --datadir=/usr/local/lib --datasubdir=egison
  cabal build
  mkdir -p "${_workdir}/bin"
  mkdir -p "${_workdir}/lib/egison"
  cp "${THIS_DIR}/egison/dist/build/egison/egison" "${_workdir}/bin"
  cp -rf "${THIS_DIR}/egison/lib" "${_workdir}/lib/egison"
  tar -zcvf "${RELEASE_TARBALL}" \
    -C "${THIS_DIR}/egison/${_workdir}" bin lib
  rm -rf ${THIS_DIR}/egison
  echo "${RELEASE_TARBALL} is successfully created." >&2
}

get_release_list () {
  curl -v -H "User-Agent: Travis/1.0" \
    -H "Authorization: token $GITHUB_AUTH" \
    "${RELEASE_API_URL}"
}

delete_release () {
  local _id="$1"
  curl "${COMMON_HEADER[@]}" \
  -X DELETE "${RELEASE_API_URL}/${_id}"
}

create_release () {
  local _tag="$1" ;shift
  local _branch="$1" ;shift
  curl "${COMMON_HEADER[@]}" \
    -X POST \
    -d '{
      "tag_name": "'${_tag}'",
      "target_commitish": "'${_branch}'",
      "name": "'${_tag}'",
      "body": "Bump version to '${_tag}'",
      "draft": false,
      "prerelease": false
    }' \
  "${RELEASE_API_URL}"
}

upload_assets () {
  local _url="$1"; shift
  local _file="$1"; shift
  curl "${COMMON_HEADER[@]}" \
    -H "Content-Type: $(file -b --mime-type "${_file}")" \
    --data-binary @"${_file}" \
    "${_url}?name=$(basename ${_file})"
}

main () {
  local _cmd
  _cmd="${1-}"
  shift || true
  case "$_cmd" in
    init)
      init
      ;;
    bump)
      get_version
      bump
      ;;
    *)
      exit 1
  esac
}

main "$@"
