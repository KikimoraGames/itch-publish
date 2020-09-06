#!/bin/sh
set -e

export BUTLER_API_KEY=$INPUT_BUTLERAPIKEY

if [ -z "$BUTLER_API_KEY" ] ; then
  echo "BUTLER_API_KEY not set. Follow instructions on https://itch.io/docs/butler/login.html#running-butler-from-ci-builds-travis-ci-gitlab-ci-etc to get your key."
  exit 1
fi

src=$INPUT_GAMEDATA
itchUsername=$INPUT_ITCHUSERNAME
itchGameId=$INPUT_ITCHGAMEID
buildChannel=$INPUT_BUILDCHANNEL

flags=""

if [ ! -z "$INPUT_BUILDNUMBER" ]
then
    flags="${flags} --userversion ${INPUT_BUILDNUMBER}"
elif [ ! -z "$INPUT_BUILDNUMBERFILE" ]
then
     flags="${flags} --userversion-file ${INPUT_BUILDNUMBERFILE}"
fi

butler push "${src}" $itchUsername/$itchGameId:$buildChannel $flags