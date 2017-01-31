+++
date = "2017-01-31T18:19:49+01:00"
title = "Running Hugo from github.io root"
menu = ""
Categories = ["Development","github","gitpages","git bash", "hugo"]
Tags = ["Development","github","gitpages","git bash", "hugo"]
Description = ""

+++

### Hugo on Github.io root
> when follwing the official guide.. atleast, not for me.. I wanted to run it from root of my github.io account, which meant setting up the deploy of hugo following this bit: https://gohugo.io/tutorials/github-pages-blog/#hosting-personal-organization-pages

> Granted, im still getting to know git, trying out the guide over multiple attempts only gave the exact same result over and over again, the deploy script would push the changes, but push em to the hugo repo, not the github.io repo, i managed to get it to work in one gitbash session, but after restarting that i was back to square one. 
This is when i started googling other results, i did find some, that did things similar to what i ended up doing was inspired heavily by the blog post here: http://charliegriefer.github.io/posts/2016/07/29/hugo-on-github-pages/ but instead with a slight modification of me copying and overwriting files from my hugo repo instead of rm'ing the folder posts folder, I was unsure how hugo handles files already being there when doing a build, and i figured that someday, down the line i might want to do things out of the posts directory.. which is why I modified the bash script to fit my needs. this was a quick and dirty kinda thing that i just wanted to get over with, All credit for the original script goes to @charliegriefer.github.io

### Notes / gotchas
* If I had rsync avalible in gitbash, i would have used it
* Since i remove all files everytime i do a deploy, all files will look like fresh files and get re-commited to the repo even tho theres nothing new in them, this is a minor detail to me, as the history of what happens in what files is being logged in my hugo soruce file repo anyway, still, its worth a mention.

~~~bash
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
	cd ../$PUBLICFOLDER
	rm -rf *
fi

echo -e "\033[0;32mMoving new html to repo folder...\033[0m"
cp -r ../$SORUCEFOLDER/public/* ../$PUBLICFOLDER
echo -e "\033[0;32mChanging to blog directory...\033[0m"
cd ../$PUBLICFOLDER

echo -e "\033[0;32mCommit and push the new build...\033[0m"
git add --a
git commit -am "Site Build (`date`)"
git push -f origin master

echo -e "\033[0;32mChange back to hugo soruce...\033[0m"
cd ../$SORUCEFOLDER

echo -e "\033[0;32mDeploy complete.\033[0m"


~~~