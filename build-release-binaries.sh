#!/usr/bin/env bash


set -u -e -o pipefail

if [[ -z "${VERSION}" ]] ; then
  echo 'ERROR: Missing VERSION env'
  exit 1
fi

echo "go install ghr"
go install github.com/tcnksm/ghr@latest

mkdir -p dist

for build in $(ls .build); do
  echo "Creating archive for ${build}"

  cp LICENSE README.md ".build/${build}/"

  if [[ "${build}" =~ windows-.*$ ]] ; then

    # Make sure to clear out zip files to prevent zip from appending to the archive.
    rm "dist/${build}.zip" || true
    cd ".build/" && zip -r --quiet -9 "../dist/${build}.zip" "${build}" && cd ../
  else
    tar -C ".build/" -czf "dist/${build}.tar.gz" "${build}"
  fi
done

cd dist
ls -la
sha256sum *.gz *.zip > sha256sums.txt
ls -la
cd ..

echo "Done"