#!/bin/bash

CUR_DIR=$(dirname $(readlink -f $0))
if [ ! -f "$CUR_DIR/server_dependency.sh" ]; then
  echo "Lack of file $CUR_DIR/server_dependency.sh" && exit -1
fi

. $CUR_DIR/server_dependency.sh

$ACCOUNT_ON      && bash $CUR_DIR/ACCOUNT.sh stop
