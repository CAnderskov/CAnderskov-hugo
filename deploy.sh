#!/bin/bash

echo -e "\033[0;32mDeploying new page...\033[0m"

echo -e "\033[0;32mDeleting old folder...\033[0m"
rm -rf ../canderskov.github.io

echo -e "\033[0;32mChanging to blog directory...\033[0m"
cd ../canderskov.github.io
git pull 

echo -e "\033[0;32mAdding git remote...\033[0m"

echo -e "\033[0;32mRunning hugo...\033[0m"
hugo -d ../canderskov.github.io


echo -e "\033[0;32mCommit and push the new build...\033[0m"
git add --a
git commit -am "Site Build (`date`)"
git push origin master

echo -e "\033[0;32mChange back to hugo soruce...\033[0m"
cd ../CAnderskov-hugo

echo -e "\033[0;32mDeploy complete.\033[0m"
