#!/bin/bash

echo "::group::Build-Environment"
echo "Using Seeder $SEEDER_VERSION"
echo "Using Pyenv $ENV_VERSION"
source $VIRTUAL_ENV/bin/activate
env-freeze
echo "::endgroup::"
echo "::group::SysTest-Preparation"
export PATH=$PWD/$2:$PATH
echo "Copying project to user workspace"
mkdir -p /home
cp -rfL . /home/apes
chown -R apes /home/apes
ls -ld $GITHUB_OUTPUT
projectfile=$(find /home/apes -name pysysproject.xml)
if [[ "$projectfile" == "" ]]; then
  echo "ERROR! Could not find pysysproject.xml." >> $GITHUB_STEP_SUMMARY
  exit 1;
fi
testroot=$(dirname $projectfile)
ORIGIN=$PWD
cd $testroot/$1
echo "::endgroup::"
echo "::group::Testing"
echo "Running pysys.py run --ci --outdir=CItests in $1"
runuser -u apes -- pysys.py run --ci --outdir=CItests
SUCCESS=$?
echo "::endgroup::"
echo "::group::Test-Finalization"
cd $ORIGIN
cp -rfL /home/apes $ORIGIN
if [[ $SUCCESS ]]; then
  echo "Passed system tests in \`$1\`" >> $GITHUB_STEP_SUMMARY
else
  echo "FAILED system tests in \`$1\`" >> $GITHUB_STEP_SUMMARY
fi
echo "::endgroup::"
exit $SUCCESS
