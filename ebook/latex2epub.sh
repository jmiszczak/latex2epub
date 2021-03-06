#!/bin/bash

# first parameter can be an ISBN number
isbn=`echo $1 | sed s/.yaml//g`
echo '[LATEX2EPUB] Building ' $isbn'.epub...'

# assume that latex files are in ../paperback folder
latexDir=../paperback
resEbook=$isbn.epub

for f in `cat files.txt` ; do
  perl latex2md.pl < $latexDir/$f.tex > $f.md 
done

# process Markdown using Pandoc
echo '[LATEX2EPUB] Processing Markdown files...'
for i in `cat files.txt`
do
  echo $i.md
done | xargs /usr/bin/pandoc \
  -o $resEbook \
  -t epub3 \
  --toc \
  --toc-depth=2 \
  --epub-chapter-level=2 \
  $isbn.yaml

echo '[LATEX2EPUB] Done.'
