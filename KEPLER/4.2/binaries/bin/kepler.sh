#!/bin/bash
# This script starts Kepler.
# Run with -h to see all command-line options.
# This script is auto-generated by the 'ant make-startup-script' command.

CUR_DIR=`pwd`
SCRIPT_DIR=`dirname $BASH_SOURCE`
cd $SCRIPT_DIR
java -classpath ../lib/build-area/lib/ant.jar:../lib/kepler.jar org.kepler.build.runner.Kepler  "$@"
cd $CUR_DIR
