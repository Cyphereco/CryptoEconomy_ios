#!/bin/bash

git=$(sh /etc/profile; which git)
buildNumber=$(git rev-list HEAD | wc -l | tr -d ' ')
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $buildNumber" "${PROJECT_DIR}/${INFOPLIST_FILE}"

