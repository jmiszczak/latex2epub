#!/usr/bin/perl

use strict;
use warnings;

local $/ = "";

my $inEnv = "";

while (<>) {

  # sections rules 
  # should be customized taking into account the structure of the final epub
  s/\\chapter\{Preface\}/\# Preface {epub:type=preface}/g;
  s/\\part\*\{Appendices\}/# Appendices {epub:type=appendix}/g;
  s/\\chapter\{Bibliography\}/# Bibliography/g;
  s/\\part\{(.*)\}/\# $1/g;
  s/\\chapter\*\{(.*)\}/\# $1/g;
  s/\\chapter\{(.*)\}/\# $1/g;
  s/\\addcontentsline\{toc\}\{chapter\}\{(.*)\}/\# $1/g;
  s/\\section\*\{(.*)\}/\#\# $1/g;
  s/\\subsection\*\{(.*)\}/\#\#\# $1/g;
  s/\\subsubsection\*\{(.*)\}/\#\#\#\# $1/g;
  s/\\paragraph\{(.*)\}/__$1__/g;
  
  # lists
  s/\\bibitem\{.*\}\n/+ /g;
  s/\\begin\{itemize\}/\n/g;
  s/\\end\{itemize\}/\n/g;
  s/\\begin\{enumerate\}/\n/g;
  s/\\setlist\[.*\]\{.*\}//g;
  s/\\end\{enumerate\}/\n/g;
  s/:\s*\\item/:\n\n\+/g;
  s/\s*\\item/\n\+/g;
  
  # images
  s/\\insertImage[P]?\{(.*)\}/\![](\.\.\/\.\.\/photos\/final-eb\/$1.jpg)/g;
  s/\\insertImageRelax\{(.*)\}/\![](\.\.\/\.\.\/photos\/final-eb\/$1.jpg)/g;
  s/\\insertMap[R]?\{(.*)\}/\![](\.\.\/\.\.\/photos\/final-eb\/$1.jpg)/g;
  s/\\begin\{figure\}//g;
  s/\\end\{figure\}//g;
  s/\\caption\*\{.*\}//g;
  s/.*?\\includegraphics.*?\{(..\/mapy_en\/.*?)\}/\![]($1)/g;
  
  # custom commands
  s/\\smallPlaceCoordinates\{(.*)\}/**Coordinates:** $1\n/g;
  s/\\placeCoordinates\{(.*)\}/**Coordinates:** $1\n/g;
  s/\\transportMode\{(.*)\}/**$1**/g;
  s/\\ie/i.e /;
  s/\\greek\{(.*)\}/$1/g;
  s/\\bulg\{(.*)\}/$1/g;

  # environments
  s/\\begin\{quotation\}/\n*/g;
  s/\\end\{quotation\}/*\n/g;

  s/\\begin\{quote\}/\n\>/g;
  s/\\end\{quote\}/\n/g;

  s/\\begin\{displayquote\}\n/\<blockquote\>\n/g;
  s/\\end\{displayquote\}\n/\<\/blockquote\>\n/g;

  s/\\begin\{center\}/<p style="text-align: center;">/g;
  s/\\end\{center\}/<\/p>/g;

  s/\\begin\{flushright\}/\n/g;
  s/\\end\{flushright\}/\n/g;

  s/\\begin\{minipage\}\{.*?\}//g;
  s/\\end\{minipage\}//g;

  # bibliography using BibTeX generated files
  s/\\begin\{thebibliography\}\{.*\}//g;
  s/\\end\{thebibliography\}//g;

  # bibliography in many files using BibLaTeX
  if (m/\\begin\{refsection\}\[(.*?)\]/) {
    system('pybtex-format', '--style=unsrt', '--output-backend=markdown', "../paperback/$1.bib", "$1.bib.md");
    system('cat', $1.'.bib.md');
    system('rm', $1.'.bib.md');
  }
  s/\\begin\{refsection\}\[.*\]//g;
  s/\\end\{refsection\}//g;
  s/\\nocite\{.*\}//g;
  s/\\printbibliography\[.*\]//g;

  # some formatting
  s/\\%/%/g;
  s/\\\\\[.*?\]//g;
  s/\\\&/\&amp\;/g;
  s/\{\\sc (.*)\}/$1/g;
  s/\\emph\{(.*?)\}/*$1*/g; # if emph is on single line
  s/\\emph\{(.*?)(\n)(.*?)\}\)/*$1$2$3*)/g; # if emph is on exactly two lines
  s/\\textbf\{(.*)\}/**$1**/g;
  s/\\vspace\*\{(.*)\}//g;
  s/\\noindent//g;
  s/\\fancyhead\{\}//g;
  s/\{\\Large.*\}//g;

  # multiline textit
  #  if (m/\\textit\{/) {
  #    $inEnv = "textit";
  #    s/\\textit\{/\<i\>/g;
  #  }
  #
  #  if ($inEnv =~ "textit" and m/\}/) {
  #      s/\}/\<\/i\>/g;
  #      $inEnv = "";
  #  }

  # multiline em
  if (m/\{\\em/) {
    $inEnv = "em";
    s/\{\\em\ /\<i\>/g;
  }

  if ($inEnv =~ "em" and m/\}/) {
      s/\}/\<\/i\>/g;
      $inEnv = "";
  }


  # layout, hyphenation
  s/\\hfill//g;
  s/\\newpage/\n/g;
  s/\\clearpage/\n/g;
  s/\\\\/\<br \/\>/g;
  s/\\-//g;
  s/\{\\nobreak (.*?)\}/$1/g;
  
  # LaTeX commands
  s/\\def.*\n//g;
  s/\\setcounter.*\}\n//g;
  s/\\setlength.*\}\n//g;
  s/\\pagenumbering.*\}\n//g;
  s/\\pagestyle.*\}\n//g;
  s/\\addcontentsline.*\}\n//g;
  s/\\markboth\{.*\}\n//g;
  s/\n\\newblock//g;
  s/^%/\n/g;
  s/^%.*\n/\n/g;
  s/~/ /g;
  s/^\{/ /g;
  s/^\}/ /g;
  s/\\mbox\{(.*?)\}/$1/g;
  s/\\vspace\{.*?\}//g;
  s/\\hspace\{.*?\}/\n\n/g;
  s/\\phantom\{.*?\}//g;
 

  # some math
  s/\$\{\}\_(.*?)\$/\<sub>$1\<\/sub\>/g; 
  # add new line at the end
  #eof && do {print; print "\n\n"}

  print;
  eof && print "\n";

}
