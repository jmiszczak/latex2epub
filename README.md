# latex2epub

Simple workflow for converting LaTeX projects into ePUB files.

## Introduction

If you need to sync content from LaTeX with ebook, this project gives you a
template to start with. The content is developed in LaTeX, converted into
Markdown, and next into ePub. This enables you to produce high-quality 
PDF version and eBook version a the same time.

## Requirements

* Perl for converting LaTeX into Markdown
* Pandoc for converting Markdown into ePub
* Bash for running the scripts.

## Usage

Just run `./latex2epub.sh` in the `Markdown` directory. You can alter
`latexDir` and `resEbook` in this file to point to your source files and resultig epub.

## Impoartant files

Markdown directory contains some files needed during the conversion.

* `files.txt` - list of LaTeX files (without extensin) used to produce Markdown.
  This list is also used to assemble ePub, hene it should be ordered according to the 
  desired order of chapters in the ebook.
* `metadata.yaml` - metadata used by Pandoc to produce ePub. You need to conslt
  https://pandoc.org/MANUAL.html for more info.
