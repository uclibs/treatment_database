#!/bin/bash
# Note: Change this to be the version on ruby needed on the server.
# Could change this to read the .ruby-version in the project
RUBY_VERSION=2.7.5

if rbenv versions | grep -q $RUBY_VERSION; then
    echo 'Ruby' $RUBY_VERSION 'is installed'
else
    rbenv install $RUBY_VERSION
fi