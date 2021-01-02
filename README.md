# latex2epub

Simple workflow for converting LaTeX projects into ePUB files.

## Introduction

If you need to sync content from LaTeX with ebook, this project gives you a
template to start with. The content is developed in LaTeX, converted into
Markdown, and next into ePub format. This enables you to produce high-quality 
PDF version and eBook version a the same time, and to control the structure
of the resulting ebook.

## Requirements

* Perl for converting LaTeX into Markdown, takes care of translating LaTeX
  commands into MD and needs to know what command it has to convert.
* [Pandoc](https://pandoc.org/) for converting Markdown into ePub.
* Bash for running the scripts.

The scripts were testes and used under Ubuntu 18.04, with Pandoc 2.5 and Perl 5.

## Usage

Just run `./latex2epub.sh` in the `Markdown` directory. You can alter
`latexDir` and `resEbook` in this file to point to your source files and resultig epub.

## Important files

Markdown directory contains some files needed during the conversion.

* `files.txt` - list of LaTeX files (without extension) used to produce Markdown.
  This list is also used to assemble ePub, hence it should be ordered according to the 
  desired order of chapters in the final ebook.
* `metadata.yaml` - metadata used by Pandoc to produce ePub. You need to consult
  https://pandoc.org/MANUAL.html for more info.

## Examples

* I. Miszczak, [Gallipoli Peninsula and the Troad](https://www.amazon.com/gp/product/B07NCQPD9Y/), 2019.
* I. Miszczak, *The Secrets of Ephesus*, [eBook](https://www.amazon.com/gp/product/B07NCQPD9Y/) and [paperback](https://www.amazon.com/dp/8395654014/) 2020.
