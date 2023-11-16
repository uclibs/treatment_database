!/bin/bash
RUBY_VERSION=$(cat .ruby-version | sed s/ruby-//)

if rbenv versions | grep -q $RUBY_VERSION; then
    echo 'Ruby' $RUBY_VERSION 'is installed'
else
    RUBY_CONFIGURE_OPTS="--disable-dtrace" rbenv install $RUBY_VERSION
fi