#!/bin/bash

echo -e "\033[0;32mDeploying new page...\033[0m"

echo -e "\033[0;32mGenerating new html...\033[0m"
hugo -t hugo-redlounge

echo -e "\033[0;32mMoving new html to repo folder...\033[0m"
mv public ../canderkov.github.io
echo -e "\033[0;32mChanging to blog directory...\033[0m"
cd ../canderskov.github.io

echo -e "\033[0;32mCommit and push the new build...\033[0m"
git add --a
git commit -am "Site Build (`date`)"
git push -f origin master

echo -e "\033[0;32mChange back to hugo soruce...\033[0m"
cd ../CAnderskov-hugo

echo -e "\033[0;32mDeploy complete.\033[0m"
