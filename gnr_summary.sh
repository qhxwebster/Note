#!/bin/bash

echo -e "# SUMMARY\n\n" > SUMMARY.md

gnrContent(){
	if [ $# -lt 2 ]; then
		return
	fi
	find $1 -maxdepth 1 -type f -name "*.md" | while read f;
	do
		name=`awk -F '/' "{print \\$(NF)}" <<< "$f"`;
		if [ $name = "README.md" ]; then continue; fi;
		echo -e "$2 [${name}](${f})\n" >> SUMMARY.md
	done
}

findDir(){
	if [ $# -lt 2 ]; then
		return
	fi
	dbase=`basename $1`
	find $1 -maxdepth 1 -type d ! -name "$dbase" | while read d;
	do
		name=`awk -F '/' "{print \\$(NF)}" <<< "$d"`;
		echo "Find in directory $name"
		echo -e "$2 [${name}](${d}/README.md)\n" >> SUMMARY.md
		gnrContent "$d" "\t${2}"
		findDir "$d" "\t${2}"
	done
}

for dd in `find . -maxdepth 1 -type d ! -name "." -and ! -name ".git"`;
do
	MainName=`awk -F '/' "{print \\$(NF)}" <<< $dd`
	echo -e "* [${MainName}](${dd}/README.md)\n" >> SUMMARY.md
	findDir $dd "\t*"
done

iconv -t UTF-8 ./SUMMARY.md > ./tmp
mv ./tmp ./SUMMARY.md
