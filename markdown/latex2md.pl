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
  s/\\chapter\*\{(.*)\}/\# $1/g;
  s/\\chapter\{(.*)\}/\# $1/g;
  s/\\addcontentsline\{toc\}\{chapter\}\{(.*)\}/# $1/g;
  s/\\subsection\*\{(.*)\}/\#\#\# $1/g;
  s/\\subsubsection\*\{(.*)\}/\#\#\#\# $1/g;
  
  # lists
  s/\\begin\{itemize\}/\n/g;
  s/\\end\{itemize\}/\n/g;
  s/\\begin\{enumerate\}\[.*\]/\n/g;
  s/\\setlist\[.*\]\{.*\}//g;
  s/\\end\{enumerate\}/\n/g;
  s/:\s*\\item/:\n\n\+/g;
  s/\s*\\item/\n\+/g;
  
  # images
  s/\\insertImage[P]?\{(.*)\}/\![](\.\.\/\.\.\/photos\/final-eb\/$1.jpg)/g;
  s/\\begin\{figure\}//g;
  s/\\end\{figure\}//g;
  s/\\caption\*\{.*\}//g;
  s/.*?\\includegraphics.*?\{(..\/mapy_en\/.*?)\}/\![]($1)/g;
  
  # custom commands
  s/\\smallPlaceCoordinates\{(.*)\}/**Coordinates:** $1\n/g;
  s/\\placeCoordinates\{(.*)\}/**Coordinates:** $1\n/g;
  s/\\transportMode\{(.*)\}/**$1**/g;
  s/\\ie/i.e /;

  # environments
  s/\\begin\{quotation\}/\n*/g;
  s/\\end\{quotation\}/*\n/g;

  s/\\begin\{displayquote\}\n/\n/g;
  s/\\end\{displayquote\}\n/\n/g;

  s/\\begin\{center\}/<p style="text-align: center;">/g;
  s/\\end\{center\}/<\/p>/g;

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
  if (m/\\textit\{/) {
    $inEnv = "textit";
    s/\\textit\{/\<i\>/g;
  }

  if ($inEnv =~ "textit" and m/\}/) {
      s/\}/\<\/i\>/g;
      $inEnv = "";
  }

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
  s/\\\\/\<br \/\>/g;
  s/\\-//g;
  
  # LaTeX commands
  s/\\def.*\n//g;
  s/\\setcounter.*\}\n//g;
  s/\\setlength.*\}\n//g;
  s/\\pagenumbering.*\}\n//g;
  s/\\pagestyle.*\}\n//g;
  s/\\addcontentsline.*\}\n//g;
  s/\\markboth\{.*\}\n//g;
  s/^%/\n/g;
  s/^%.*\n/\n/g;
  s/~/ /g;
  s/^\{/ /g;
  s/^\}/ /g;
  s/\\mbox\{(.*?)\}/$1/g;
  s/\\vspace\{.*?\}//g;
  
  # add new line at the end
  #eof && do {print; print "\n\n"}

  print;
  eof && print "\n";

}
