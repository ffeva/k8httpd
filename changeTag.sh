#!/bin/bash
sed "s/tagVersion/$1/g" Deploy.yml > Deploy-httpd.yml
