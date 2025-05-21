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
projectfile=$(find /home/apes -name pysysproject.xml)
if [[ "$projectfile" == "" ]]; then
  echo "ERROR! Could not find pysysproject.xml." >> $GITHUB_STEP_SUMMARY
  exit 1;
fi
testroot=$(dirname $projectfile)
ORIGIN=$PWD
cd $testroot/$1
OUSER=$(ls -ld $GITHUB_OUTPUT | awk 'NR==1 {print $3}')
OGROUP=$(ls -ld $GITHUB_OUTPUT | awk 'NR==1 {print $4}')
chown -R apes $GITHUB_OUTPUT
echo "::endgroup::"
echo "::group::Testing"
echo "Running pysys.py run --ci --outdir=CItests in $1"
runuser -u apes -- pysys.py run --ci --outdir=CItests
SUCCESS=$?
echo "::endgroup::"
echo "::group::Test-Finalization"
chown -R $OUSER:$OGROUP $GITHUB_OUTPUT
cd $ORIGIN
cp -rfL /home/apes $ORIGIN
if [[ $SUCCESS ]]; then
  echo "Passed system tests in \`$1\`" >> $GITHUB_STEP_SUMMARY
else
  echo "FAILED system tests in \`$1\`" >> $GITHUB_STEP_SUMMARY
fi
echo "::endgroup::"
exit $SUCCESS
