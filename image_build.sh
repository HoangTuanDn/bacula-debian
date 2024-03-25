#!bin/bash

while getopts "t:" flag
do
  # shellcheck disable=SC2220
  case "${flag}" in
    t) tag="${OPTARG}";;
  esac
done

echo "### Build bacula-base ###"
docker buildx build -t nhtdn/bacula-base:"$tag" --build-arg B_VERSION="$tag" bacula-base

echo "### Build bacula-catalog ###"
docker buildx build -t nhtdn/bacula-catalog:"$tag" --build-arg B_VERSION="$tag" bacula-catalog

echo "### Build bacula-dir ###"
docker buildx build -t nhtdn/bacula-dir:"$tag" --build-arg B_VERSION="$tag" bacula-dir

echo "### Build bacula-fd ###"
docker buildx build -t nhtdn/bacula-fd:"$tag" --build-arg B_VERSION="$tag" bacula-fd

echo "### Build bacula-sd ###"
docker buildx build -t nhtdn/bacula-sd:"$tag" --build-arg B_VERSION="$tag" bacula-sd

echo "### Build bacula-web ###"
docker buildx build -t nhtdn/bacula-web:"$tag" --build-arg B_VERSION="$tag" bacularis
