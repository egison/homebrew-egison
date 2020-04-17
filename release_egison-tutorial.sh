#!/bin/bash

# ===================================
# Automated build script for Egison
# Required Environment Variables:
#  * TRAVIS_BUILD_DIR -- Given by TravisCI
#  * TRAVIS_REPO_SLUG -- Givven by TravisCI
#  * ID_RSA           -- Given by GitHub's secrets.
#  * API_AUTH         -- Given by GitHub's secrets.
#                        Auth token for GitHub Rest API.
# ===================================
set -e

readonly FNAME=$(echo "egison-tutorial_$(uname)_$(uname -m)" | tr '[:upper:]' '[:lower:]' | tr -dc 'a-z0-9._-')
readonly THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LATEST_VERSION=
CURRENT_VERSION=
RELEASE_ARCHIVE=
readonly GITHUB_AUTH="${GITHUB_AUTH:-$API_AUTH}"
readonly TARGET_BRANCH="master"
readonly BUILDER_REPO="${TRAVIS_REPO_SLUG:-$GITHUB_REPOSITORY}" # egison/homebrew-egison
readonly BUILDER_REPO_NAME=${BUILDER_REPO##*/}
readonly BUILD_REPO="egison/egison-tutorial"
## User-Agent starts with Travis is required (https://github.com/travis-ci/travis-ci/issues/5649)
readonly COMMON_HEADER=("--retry" "3" "-H" "User-Agent: Travis/1.0" "-H" "Authorization: token $GITHUB_AUTH" "-H" "Accept: application/vnd.github.v3+json" "-L" "-f")
readonly RELEASE_API_URL="https://api.github.com/repos/${BUILDER_REPO}/releases"

# Initialize SSH keys
init () {
  echo "start init"
  printf "Host github.com\n\tStrictHostKeyChecking no\n" >> "$HOME"/.ssh/config
  echo "${ID_RSA}" | base64 --decode | gzip -d > "$HOME"/.ssh/id_rsa
  chmod 600 "$HOME"/.ssh/id_rsa
  git config --global user.name "greymd"
  git config --global user.email "yamadagrep@gmail.com"
}

get_version () {
  LATEST_VERSION=$(get_latest_release_cabal "${BUILD_REPO}")
  CURRENT_VERSION=$(get_latest_release_tap "${BUILDER_REPO}" "egison-tutorial" ) # pass "egison/homebrew-egison" "egison-tutorial"
  RELEASE_ARCHIVE="${TRAVIS_BUILD_DIR:-$THIS_DIR}/${FNAME}_${LATEST_VERSION}.zip"
  readonly LATEST_VERSION CURRENT_VERSION RELEASE_ARCHIVE
}

bump () {
  echo "start bump"
  local _sha256hash
  local _release_id
  if [[ "${CURRENT_VERSION}" == "${LATEST_VERSION}" ]];then
    echo "Skip git push. It is latest version." >&2
    exit 0
  fi
  ## check tags
  _release_id=$(get_release_list | jq '.[] | select(.tag_name == "'"${LATEST_VERSION}"'") | .id')

  ## If there is already same name of the release, delete it.
  if [[ "${_release_id}" == "" ]]; then
    echo "egison binary have not been released yet."
    exit 1
  fi

  # Build tarball
  ( build )
  if [[ ! -s "${RELEASE_ARCHIVE}" ]];then
    echo "Failed to create '${RELEASE_ARCHIVE}'"
    exit 1
  fi

  _upload_url=$(get_release_list | jq -r '.[] | select(.tag_name == "'"${LATEST_VERSION}"'") | .upload_url' | perl -pe 's/{.*}//')
  upload_assets "${_upload_url}" "${RELEASE_ARCHIVE}"

  rm -rf "${THIS_DIR:?}/${BUILDER_REPO_NAME}"
  git clone -b "${TARGET_BRANCH}" \
    "git@github.com:${BUILDER_REPO}.git" \
    "${THIS_DIR}/${BUILDER_REPO_NAME}"

  cd "${THIS_DIR}/${BUILDER_REPO_NAME}"

  # Edit files
  _sha256hash=$(shasum -a 256 "${RELEASE_ARCHIVE}" | perl -anle 'print $F[0]')
  perl -i -pe 's/VERSION = ".*"/VERSION = "'"${LATEST_VERSION}"'"/' "./egison-tutorial.rb"
  perl -i -pe 's/sha256 ".*"/sha256 "'"${_sha256hash}"'"/' "./egison-tutorial.rb"
  echo "${LATEST_VERSION}-$(date +%s)" > "./VERSION_egison-tutorial"

  # Crete versions and make changes to GitHub
  git add "./VERSION_egison-tutorial" "./egison-tutorial.rb"
  git commit -m "[skip ci] Bump version to ${LATEST_VERSION} (egison-tutorial)"

  ## Push changes
  git push origin "${TARGET_BRANCH}"

}

# for egison-tutorial
build () {
  echo "start build"
  local _exefile
  local _workdir="work-$RANDOM"
  git clone "https://github.com/${BUILD_REPO}.git" "${THIS_DIR}/egison-tutorial"
  cd "${THIS_DIR}/egison-tutorial"

  cabal v2-update
  cabal v2-install
  cabal v2-configure
  cabal v2-build
  echo "egison-tutorial is successfully build." >&2

  _exefile="$(find "${THIS_DIR}/egison-tutorial/dist-newstyle/" -type f  -name egison-tutorial | head -n 1)"
  ## Exit the function if file is not executable file.
  file "$_exefile" | grep -q 'executable' || return 1

  mkdir -p "${_workdir}/bin"
  mkdir -p "${_workdir}/lib/egison-tutorial"

  cp "${_exefile}" "${_workdir}/bin/egison-tutorial-impl"
  printf '%s\n%s\n' '#!/bin/sh' 'egison_datadir=/usr/local/lib/egison-tutorial egison-tutorial-impl "$@"' > "${_workdir}/bin/egison-tutorial"
  chmod +x "${_workdir}/bin/egison-tutorial"

  git clone -b "${LATEST_VERSION}" \
    "https://github.com/egison/egison.git" "${THIS_DIR}/egison-tutorial/egison"

  cp -rf "${THIS_DIR}/egison-tutorial/egison/lib" "${_workdir}/lib/egison-tutorial"
  (
    cd "${THIS_DIR}/egison-tutorial/${_workdir}"
    zip -r "${RELEASE_ARCHIVE}" bin lib
  )
  rm -rf "${THIS_DIR}"/egison-tutorial
  echo "${RELEASE_ARCHIVE} is successfully created." >&2
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
      "tag_name": "'"${_tag}"'",
      "target_commitish": "'"${_branch}"'",
      "name": "'"${_tag}"'",
      "body": "Bump version to '"${_tag}"'",
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
    "${_url}?name=$(basename "${_file}")"
}

get_latest_release_cabal () {
  local _repo="$1"
  echo "get_latest_release start $_repo" >&2
  curl --retry 3 -f -v -H "User-Agent: Travis/1.0" \
       -H "Authorization: token $GITHUB_AUTH" \
       -L "https://raw.githubusercontent.com/${_repo}/master/${_repo/*\/}.cabal" \
       | awk '/Version:/{print $NF}' > ./latest
  _ret=$?
  if [[ $_ret != 0 ]] || [[ ! -s "./latest" ]]; then
    exit 1
  fi
  cat "./latest"
  rm "./latest"
  echo "get_latest_release end $_repo" >&2
}

get_latest_release_tap () {
  local _repo="$1" ;shift
  local _recipe="$1"
  echo "get_latest_release start $_repo" >&2
  curl --retry 3 -f -v -H "User-Agent: Travis/1.0" \
       -H "Authorization: token $GITHUB_AUTH" \
       -L "https://raw.githubusercontent.com/${_repo}/master/${_recipe}.rb" \
       | grep -m 1 'VERSION' | awk '{print $NF}' | xargs > ./latest
  _ret=$?
  if [[ $_ret != 0 ]] || [[ ! -s "./latest" ]]; then
    exit 1
  fi
  cat "./latest"
  rm "./latest"
  echo "get_latest_release end $_repo" >&2
}


get_latest_release () {
  local _repo="$1"
  echo "get_latest_release start $_repo" >&2
  curl --retry 3 -f -v -H "User-Agent: Travis/1.0" \
       -H "Authorization: token $GITHUB_AUTH" \
       -L "https://api.github.com/repos/${_repo}/releases/latest" > "./latest.json"
  _ret=$?
  if [[ $_ret != 0 ]] || [[ ! -s "./latest.json" ]]; then
    exit 1
  fi
  jq -r .tag_name < "./latest.json" | tr -d '\n'
  rm "./latest.json"
  echo "get_latest_release end $_repo" >&2
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
