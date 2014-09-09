#!/bin/bash

if [ "$#" -ne 1 ]; 
    then echo "syntax: $0 basedir"
    exit
fi

basedir=$1
echo "Using basedir $basedir"
basedir="${basedir//\//\\/}"

for file in fedora/server/config/fedora.fcfg fedora/server/config/spring/akubra-llstore.xml fedora/tomcat/conf/Catalina/localhost/fedora.xml
do
  echo Replacing in $file
  cat $file.template | sed "s/BASE-DIR-REPLACE-TOKEN/${basedir}/" > $file
done
