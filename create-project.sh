#!/usr/bin/env bash

PROJECT=$1
declare -a ENVIRONMENTS=("moc" "quicklab")

if [ $# -eq 0 ]; then
    echo "usage: create-projects.sh PROJECT_NAME"
    exit 1
fi

BASE_DIR="base/$PROJECT"

if [ -d "$base_dir" ]; then
    echo "Project already exists."
    exit 1
fi

for ENV in ${ENVIRONMENTS[@]}; do
  ENV_DIR=overlays/$ENV/$PROJECT
  if [ -d "$ENV_DIR" ]; then
    echo "Project already exists."
    exit 1
  fi
done

mkdir $BASE_DIR
pushd $BASE_DIR
kustomize create
popd

for ENV in ${ENVIRONMENTS[@]}; do
  ENV_DIR=overlays/$ENV/$PROJECT
  mkdir $ENV_DIR
  pushd $ENV_DIR
  kustomize create --resources ../../../$BASE_DIR
  popd
done
