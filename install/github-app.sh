#!/usr/bin/env sh

DIR=~/hide/dotfiles
APP=~/.config/github-app

mkdir -p $APP
ln -s $DIR/github-app/token.sh $APP/token.sh

[ -f $APP/env ] || echo "Missing $APP/env with CLIENT_ID and INSTALLATION_ID"
[ -f $APP/private-key.pem ] || echo "Missing $APP/private-key.pem"
