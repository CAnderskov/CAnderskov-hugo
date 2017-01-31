#!/bin/bash
SORUCEFOLDER="CAnderskov-hugo"
PUBLICFOLDER="canderskov.github.io"

echo -e "\033[0;32mDeploying new page...\033[0m"

echo -e "\033[0;32mGenerating new html...\033[0m"
hugo -t hugo-redlounge


echo -e "\033[0;32mChecking if directory exists..\033[0m"
if [ ! -d "../$PUBLICFOLDER" ]; then
	PWD=pwd
  	cd ..
   echo -e "\033[0;32mNo github.io repo folder found, pulling fresh version into $PWD...\033[0m"
   git clone git@github.com:CAnderskov/canderskov.github.io.git
else
	echo -e "\033[0;32mDirectory found, cleaning folder for new build..\033[0m"
	rm -rf *
fi

echo -e "\033[0;32mMoving new html to repo folder...\033[0m"
cp public/* ../$PUBLICFOLDER
echo -e "\033[0;32mChanging to blog directory...\033[0m"
cd ../$PUBLICFOLDER

echo -e "\033[0;32mCommit and push the new build...\033[0m"
#git add --a
#git commit -am "Site Build (`date`)"
#git push -f origin master

echo -e "\033[0;32mChange back to hugo soruce...\033[0m"
cd ../$SORUCEFOLDER

echo -e "\033[0;32mDeploy complete.\033[0m"
