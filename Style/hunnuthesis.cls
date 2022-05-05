%---------------------------------------------------------------------------%
%-                                                                         -%
%-                           Document Class                                -%
%-                                                                         -%
%---------------------------------------------------------------------------%
%- Copyright (C) Tao Wu <taotaomails@gmail.com> 
%- This is free software: you can redistribute it and/or modify it
%- under the terms of the GNU General Public License as published by
%- the Free Software Foundation, either version 3 of the License, or
%- (at your option) any later version.
%---------------------------------------------------------------------------%
%->> Identification
%---------------------------------------------------------------------------%
\NeedsTeXFormat{LaTeX2e}%
\newcommand*\@iflatexlater{\@ifl@t@r\fmtversion}%
\@iflatexlater{2019/01/01}{}{%
    \ClassError{hunnuthesis}{TeXLive/MikTex >= 2019 is required ...}{}%
}
\ProvidesClass{hunnuthesis}[2017/10/01 v1.0 LaTeX document class]%
%---------------------------------------------------------------------------%
%->> Declare options
%---------------------------------------------------------------------------%
%-
%-> Layout
%-
\DeclareOption{oneside}{%
    \PassOptionsToClass{oneside}{ctexbook}%
}
\DeclareOption{twoside}{%
    \PassOptionsToClass{twoside}{ctexbook}%
}
\newif\ifhunnu@print \hunnu@printfalse
\DeclareOption{print}{%
    \PassOptionsToClass{twoside}{ctexbook}%
    \hunnu@printtrue%
}
%-
%-> Language
%-
\newif\ifhunnu@plain \hunnu@plainfalse
\DeclareOption{scheme=plain}{% enable plain writing style
    \PassOptionsToClass{scheme=plain}{ctexbook}%
    \hunnu@plaintrue%
}
%-
%-> Draft version info
%-
\newif\ifhunnu@versioninfo \hunnu@versioninfofalse
\DeclareOption{draftversion}{%
    \hunnu@versioninfotrue%
}
%-
%-> Handle non-implemented options
%-
\DeclareOption*{%
    \PassOptionsToClass{\CurrentOption}{ctexbook}%
}
%-
%-> Terminates all options processing
%-
\ProcessOptions\relax%
%---------------------------------------------------------------------------%
%->> Load class information
%---------------------------------------------------------------------------%
\LoadClass[UTF8,a4paper,zihao=-4]{ctexbook}%
\@ifclasslater{ctexbook}{2017/01/01}{}{%
    \ClassError{hunnuthesis}{ctex >= 2017/01/01 is required ...}{}%
}
%---------------------------------------------------------------------------%
%->> Required packages
%---------------------------------------------------------------------------%
\RequirePackage{ifxetex}% LaTeX engine detection
\RequirePackage{etoolbox}% a toolbox of programming facilities
\newcommand{\hunnuifstreq}{\expandafter\ifstrequal\expandafter}% expansion control
\newcommand{\hunnuifstrbk}{\expandafter\ifblank\expandafter}% expansion control
\RequirePackage{expl3}% LaTeX3 programming environment
\ExplSyntaxOn
\newcommand{\hunnulntotab}[2][1pt]{% convert lines into table lines
    \seq_set_split:NnV \l_tmpa_seq {\\} {#2}
    \clist_set_from_seq:NN \l_tmpa_clist \l_tmpa_seq
    \clist_clear:N \l_tmpb_clist
    \clist_map_inline:Nn \l_tmpa_clist
      {%
        \clist_put_right:Nn \l_tmpb_clist 
          { \ulenhance[#1]{\ulextend{##1}} }
      }
    %\clist_show:N\l_tmpb_clist% show the content of comma list
    \clist_use:Nn \l_tmpb_clist { \\ & }
}
\ExplSyntaxOff
%---------------------------------------------------------------------------%
%->> Load class configuration
%---------------------------------------------------------------------------%
\AtEndOfPackage{% class cfg loaded after package to make preamble commands take effect
    \makeatletter
    \InputIfFileExists{Style/hunnuthesis.cfg}{}{}
    \makeatother
}
%---------------------------------------------------------------------------%
%->> Page layout
%---------------------------------------------------------------------------%
%- use \topmargin insead of \voffset to shift the complete text vertically
%- use \<odd|even>sidemargin insead of \hoffset to shift text horizontally
%- part one -- horizontal widths
%- left side width + textwidth + right side width = paperwidth
%- binding side width + textwidth + nonbinding side width = paperwidth
%- binding side width of [odd, even] page = [left, right] side width
%- left side width of [odd, even] page = 1.0in (fixed) + hoffset + [odd, even]sidemargin
%- assuming A4 paper (210mm x 297mm)
\setlength{\textwidth}{146.6mm}% set required text width first
\setlength{\hoffset}{0mm}% set horizontal offset
\ifhunnu@print% if print layout enabled
    \setlength{\oddsidemargin}{12.6mm}% binding side margin
    \setlength{\evensidemargin}{0mm}% ensure uniform binding side width for printing
\else
    \setlength{\oddsidemargin}{6.3mm}% left side margin
    \setlength{\evensidemargin}{6.3mm}% ensure uniform left side width for EThesis
\fi
\setlength{\marginparwidth}{35pt}% width of margin notes
\setlength{\marginparsep}{10pt}% width of space between body text and margin notes
%- part two -- vertical heights
%- top height + textheight + bottom height = paperheight
%- top height = 1.0in (fixed) + voffset + topmargin + headheight + headsep 
\setlength{\textheight}{246.2mm}% set required text height first
\setlength{\voffset}{0mm}% set vertical offset
\setlength{\topmargin}{-10.4mm}% vertical margin above header
\setlength{\headheight}{12pt}% header height
\setlength{\headsep}{17.5pt}% vertical margin between header and body text
\setlength{\footskip}{10.4mm}% vertical margin between footer and body text
%- specifies the amount of space between paragraphs.
\setlength{\parskip}{0.5ex plus 0.25ex minus 0.25ex}
%- line spacing
\linespread{1.6}% line space setting
\raggedbottom% prevent adding vertical white space in strange places
%- default pagestyle is page number at bottom without headers and footers
\pagestyle{plain}

%---------------------------------------------------------------------------%
%->> Style control commands
%---------------------------------------------------------------------------%
%- redefine cleardoublepage to have page style argument
\renewcommand{\cleardoublepage}[1][plain]{%
    \clearpage\if@twoside\ifodd\c@page\else%
    \thispagestyle{#1}%
    \hbox{}\newpage\if@twocolumn\hbox{}\newpage\fi\fi\fi%
}
%- underline
\ifxetex%
    \RequirePackage{ulem}%
\else%
    \RequirePackage{ulem}%
\fi
\newcommand{\ulunify}[1]{\uline{#1}}% unified name
\newcommand{\ulenhance}[2][1pt]{% enhanced underline
    \def\ULthickness{#1}% set thickness
    \setlength{\ULdepth}{0.5em}% set depth
    \expandafter\ulunify\expandafter{#2}% linebreak fix
}
\newcommand{\ulhshift}{-4em}% horizontal shift on underline
\newcommand{\ulextend}[2][350pt]{% extend underline length
    \hbox to #1{\hfill\hspace*{\ulhshift}#2\hfill}}
%---------------------------------------------------------------------------%
%->> Titlepage
%---------------------------------------------------------------------------%
%-
%-> Chinese item commands
%-
\def\hunnu@value@ch@confidential{}
\newcommand{\confidential}[1]{\def\hunnu@value@ch@confidential{#1}}
\def\hunnu@value@ch@orderid{}
\newcommand{\orderid}[1]{\def\hunnu@value@ch@orderid{#1}}
\def\hunnu@value@ch@classid{}
\newcommand{\classid}[1]{\def\hunnu@value@ch@classid{#1}}
\def\hunnu@value@ch@udc{}
\newcommand{\udc}[1]{\def\hunnu@value@ch@udc{#1}}
\def\hunnu@value@ch@schoollogo{}
\newcommand{\schoollogo}[2][]{\def\hunnu@value@ch@schoollogo{\hunnuifstrbk{#1}{\zihao{-2}\bfseries\sffamily #2}{\includegraphics[#1]{#2}}}}
\def\hunnu@value@ch@title{}
\def\hunnu@value@ch@titlemark{}
\renewcommand{\title}[2][\hunnu@value@ch@title]{%
    \def\hunnu@value@ch@title{#2}
    %\def\hunnu@value@ch@titlemark{\MakeUppercase{#1}}}
    \def\hunnu@value@ch@titlemark{#1}}
\def\hunnu@value@ch@author{}
\renewcommand{\author}[1]{\def\hunnu@value@ch@author{#1}}
\def\hunnu@value@ch@advisor{}
\newcommand{\advisor}[1]{\long\def\hunnu@value@ch@advisor{#1}}
\def\hunnu@value@ch@advisors{}
\newcommand{\advisors}[1]{\long\def\hunnu@value@ch@advisors{#1}}
\def\hunnu@value@ch@degree{}
\newcommand{\degree}[1]{\def\hunnu@value@ch@degree{#1}}
\def\hunnu@value@ch@degreetype{}
\newcommand{\degreetype}[1]{\def\hunnu@value@ch@degreetype{#1}}
\def\hunnu@value@ch@subject{}
\newcommand{\subject}[1]{\def\hunnu@value@ch@subject{#1}}
\def\hunnu@value@ch@major{}
\newcommand{\major}[1]{\def\hunnu@value@ch@major{#1}}
\def\hunnu@value@ch@research{}
\newcommand{\research}[1]{\def\hunnu@value@ch@research{#1}}
\def\hunnu@value@ch@paperid{}
\newcommand{\paperid}[1]{\def\hunnu@value@ch@paperid{#1}}
\def\hunnu@value@ch@studentid{}
\newcommand{\studentid}[1]{\def\hunnu@value@ch@studentid{#1}}
\def\hunnu@value@ch@institute{}
\newcommand{\institute}[1]{\long\def\hunnu@value@ch@institute{#1}}
\def\hunnu@value@ch@school{}
\newcommand{\school}[1]{\def\hunnu@value@ch@school{#1}}
\def\hunnu@value@ch@orginization{}
\newcommand{\orginization}[1]{\def\hunnu@value@ch@orginization{#1}}
\def\hunnu@value@ch@completedate{}
\newcommand{\completedate}[1]{\def\hunnu@value@ch@completedate{#1}}
\def\hunnu@value@ch@submitdate{}
\newcommand{\submitdate}[1]{\def\hunnu@value@ch@submitdate{#1}}
\def\hunnu@value@ch@studydatefrom{}
\newcommand{\studydatefrom}[1]{\def\hunnu@value@ch@studydatefrom{#1}}
\def\hunnu@value@ch@studydateto{}
\newcommand{\studydateto}[1]{\def\hunnu@value@ch@studydateto{#1}}
\def\hunnu@value@ch@date{}
\renewcommand{\date}[1]{\def\hunnu@value@ch@date{#1}}
%-
%-> English item commands
%-
\def\hunnu@value@en@title{}
\def\hunnu@value@en@titlemark{}
\newcommand{\TITLE}[2][\hunnu@value@en@title]{%
    \def\hunnu@value@en@title{#2}
    %\def\hunnu@value@en@titlemark{\MakeUppercase{#1}}}
    \def\hunnu@value@en@titlemark{#1}}
\def\hunnu@value@en@author{}
\newcommand{\AUTHOR}[1]{\def\hunnu@value@en@author{#1}}
\def\hunnu@value@en@advisor{}
\newcommand{\ADVISOR}[1]{\def\hunnu@value@en@advisor{#1}}
\def\hunnu@value@en@degree{}
\newcommand{\DEGREE}[1]{\edef\hunnu@value@en@degree{\zap@space#1 \@empty}}% expand and remove space
\def\hunnu@value@en@degreetype{}
\newcommand{\DEGREETYPE}[1]{\def\hunnu@value@en@degreetype{#1}}
\def\hunnu@value@en@thesistype{}
\newcommand{\THESISTYPE}[1]{\def\hunnu@value@en@thesistype{#1}}
\def\hunnu@value@en@major{}
\newcommand{\MAJOR}[1]{\def\hunnu@value@en@major{#1}}
\def\hunnu@value@en@institute{}
\newcommand{\INSTITUTE}[1]{\def\hunnu@value@en@institute{#1}}
\def\hunnu@value@en@school{}
\newcommand{\SCHOOL}[1]{\def\hunnu@value@en@school{#1}}
\def\hunnu@value@en@date{}
\newcommand{\DATE}[1]{\def\hunnu@value@en@date{#1}}
%-
%-> Detect and adjust items
%-
\AtEndPreamble{%
    \hunnuifstreq{\hunnu@value@en@degree}{Bachelor}{%
        \def\hunnu@label@ch@thesis{\hunnu@label@ch@thesis@bac}%
        \def\hunnu@label@ch@author{\hunnu@label@ch@author@bac}%
        \def\hunnu@label@ch@major{\hunnu@label@ch@major@bac}%
        \def\hunnu@label@ch@institute{\hunnu@label@ch@institute@bac}%
        \def\hunnu@value@en@thesistype{\hunnu@value@en@thesistype@bac}%
        \def\maketitle{\maketitle@xpdc}
        \def\MAKETITLE{\MAKETITLE@xpdc}
    }{%
    \hunnuifstreq{\hunnu@value@en@degree}{Master}{%
        \def\hunnu@label@ch@thesis{\hunnu@label@ch@thesis@mas}%
        \def\hunnu@label@ch@author{\hunnu@label@ch@author@mas}%
        \def\hunnu@label@ch@major{\hunnu@label@ch@major@mas}%
        \def\hunnu@label@ch@institute{\hunnu@label@ch@institute@mas}%
        \def\hunnu@value@en@thesistype{\hunnu@value@en@thesistype@mas}%
        \def\maketitle{\maketitle@xpdc}
        \def\MAKETITLE{\MAKETITLE@xpdc}
    }{%
    \hunnuifstreq{\hunnu@value@en@degree}{Doctor}{%
        \def\hunnu@label@ch@thesis{\hunnu@label@ch@thesis@doc}%
        \def\hunnu@label@ch@author{\hunnu@label@ch@author@doc}%
        \def\hunnu@label@ch@major{\hunnu@label@ch@major@doc}%
        \def\hunnu@label@ch@institute{\hunnu@label@ch@institute@doc}%
        \def\hunnu@value@en@thesistype{\hunnu@value@en@thesistype@doc}%
        \def\maketitle{\maketitle@xpdc}
        \def\MAKETITLE{\MAKETITLE@xpdc}
    }{%
    \hunnuifstreq{\hunnu@value@en@degree}{Postdoctor}{%
        \def\hunnu@label@ch@thesis{\hunnu@label@ch@thesis@pdc}%
        \def\hunnu@label@ch@author{\hunnu@label@ch@author@pdc}%
        \def\hunnu@label@ch@major{\hunnu@label@ch@major@pdc}%
        \def\hunnu@label@ch@institute{\hunnu@label@ch@institute@pdc}%
        \def\hunnu@value@en@thesistype{\hunnu@value@en@thesistype@pdc}%
        \def\maketitle{\maketitle@pdc}
        \def\MAKETITLE{\MAKETITLE@pdc}
    }{%
        \ClassWarning{hunnuthesis}{Invalid value of '\string\DEGREE', please check the spelling}%
    }}}}%
}
%-
%-> Define Chinese style
%-
\newcommand{\maketitle@xpdc}{%
    \cleardoublepage
    \thispagestyle{empty}
    \begin{center}
        \linespread{1.6}
        \zihao{4}\bfseries

        \hfill{} \hunnuifstrbk{\hunnu@value@ch@confidential}{}{\hunnu@label@ch@confidential \ulenhance{\ulextend[50pt]{\hspace*{-\ulhshift}\zihao{5}\hunnu@value@ch@confidential}}}

        \vspace*{\stretch{4}}

        {\hunnu@value@ch@schoollogo}

        \vspace*{\stretch{2}}

        {\zihao{1}\bfseries\sffamily {\hunnu@label@ch@thesis}}

        \vspace*{\stretch{3}}

        {\zihao{-3}\bfseries\sffamily \ulenhance[1.5pt]{\hunnu@value@ch@title}}

        \vspace*{\stretch{3}}

        \def\tabcolsep{1pt}
        \def\arraystretch{1.3}

        \begin{tabular}{cc}
            \makebox[.3\linewidth][s]{\hunnu@label@ch@author} & \ulenhance[1.0pt]{\makebox[.5\linewidth]{\hunnu@value@ch@author}}\\
            \makebox[.3\linewidth][s]{\hunnu@label@ch@degreetype} & \ulenhance[1.0pt]{\makebox[.5\linewidth]{\hunnu@value@ch@degreetype}}\\
            \makebox[.3\linewidth][s]{\hunnu@label@ch@advisor} & \ulenhance[1.0pt]{\makebox[.5\linewidth]{\hunnu@value@ch@advisor}}\\
            \makebox[.3\linewidth][s]{\hunnu@label@ch@major} & \ulenhance[1.0pt]{\makebox[.5\linewidth]{\hunnu@value@ch@major}}\\
            \makebox[.3\linewidth][s]{\hunnu@label@ch@paperid} & \ulenhance[1.0pt]{\makebox[.5\linewidth]{\hunnu@value@ch@paperid}}\\
        \end{tabular}

        \vspace*{\stretch{4}}

        {{\hunnu@value@ch@school}学位评定委员会办公室}


        {\zhnumsetup{time=Chinese} \hunnu@value@ch@date}

        \vspace*{\stretch{4}}
    \end{center}
    \clearpage
    \if@twoside
        \thispagestyle{empty}
        \ifhunnu@versioninfo
            \vspace*{\stretch{1}}
            \begin{footnotesize}
                \noindent
                Draft Version (\today)
            \end{footnotesize}
        \fi
        \cleardoublepage[empty]
    \else
        \ifhunnu@versioninfo
            \thispagestyle{empty}
            \vspace*{\stretch{1}}
            \begin{footnotesize}
                \noindent
                Draft Version (\today)
            \end{footnotesize}
            \cleardoublepage[empty]
        \fi
    \fi
    \ifhunnu@print%
        \hypersetup{% set hyperlinks
            hidelinks,% remove link color and border
        }
    \fi
}
\newcommand{\maketitle@pdc}{%
    \cleardoublepage
    \thispagestyle{empty}
    \begin{center}

        \vspace*{30pt}

        \linespread{2.0}
        \zihao{4}

        \makebox[3.0em][s]{\hunnu@label@ch@classid} \ulenhance{\ulextend[6em]{\zihao{5}\hunnu@value@ch@classid}} \hfill{} \hunnu@label@ch@confidential \ulenhance{\ulextend[6em]{\zihao{5}\hunnu@value@ch@confidential}}

        \makebox[3.0em][s]{\hunnu@label@ch@udc} \ulenhance{\ulextend[6em]{\zihao{5}\hunnu@value@ch@udc}} \hfill{} \hunnu@label@ch@orderid \ulenhance{\ulextend[6em]{\zihao{5}\hunnu@value@ch@orderid}}

        \vspace*{\stretch{6}}

        {\ziju{1.5}\hunnu@value@ch@schoollogo}

        \vspace*{\stretch{1}}

        {\zihao{-2}\bfseries\sffamily{\ziju{0.5}\hunnu@label@ch@thesis}}

        \vspace*{\stretch{3}}

        {\zihao{-1} \ulenhance[1.5pt]{\hunnu@value@ch@title}}

        \vspace*{\stretch{2.5}}

        \hunnu@value@ch@author

        \vspace*{\stretch{2.5}}


        \def\tabcolsep{1pt}
        \def\arraystretch{1.3}
        \begin{tabular}{l@{\quad}c}
            \hunnu@label@ch@completedate & \ulenhance{\ulextend[200pt]{\hunnu@value@ch@completedate}}\\
            \hunnu@label@ch@submitdate & \ulenhance{\ulextend[200pt]{\hunnu@value@ch@submitdate}}\\
        \end{tabular}

        \vspace*{\stretch{2}}

        \hunnu@value@ch@institute

        \hunnu@value@ch@date

        \vspace*{\stretch{4}}
    \end{center}
    \clearpage
    \if@twoside
      \thispagestyle{empty}
      \cleardoublepage[empty]
    \fi
    \ifhunnu@print%
        \hypersetup{% set hyperlinks
            hidelinks,% remove link color and border
        }
    \fi
}
%-
%-> Define English style
%-
\newcommand{\MAKETITLE@xpdc}{%
    \cleardoublepage
    \thispagestyle{empty}

    \begin{center}
        \linespread{1.6}
        \zihao{4}\bfseries

        \vspace*{30pt}

        \begin{tabular*}{\textwidth}{l@{\extracolsep\fill}l}
            分类号 \ulenhance[1.0pt]{\makebox[.2\linewidth]{}} &
            密级 \ulenhance[1.0pt]{\makebox[.24\linewidth]{公开}} \\
            学校代码 \ulenhance[1.0pt]{\makebox[.17\linewidth]{10542}} &
            学号 \ulenhance[1.0pt]{\makebox[.24\linewidth]{\hunnu@value@ch@studentid}}
        \end{tabular*}

        \vspace*{\stretch{2}}

        {\zihao{-2} \ulenhance[1.5pt]{\hunnu@value@ch@title}}

        {\zihao{-3}\bfseries \ulenhance[1.5pt]{\hunnu@value@en@title}}
 

        \vspace*{\stretch{3}}

        \def\tabcolsep{1pt}
        \def\arraystretch{1.3}

        \begin{tabular}{cc}
            \makebox[.3\linewidth][s]{\hunnu@label@ch@author} & \ulenhance[1.0pt]{\makebox[.5\linewidth]{\hunnu@value@ch@author}}\\
            \makebox[.3\linewidth][s]{\hunnu@label@ch@advisor} & \ulenhance[1.0pt]{\makebox[.5\linewidth]{\hunnu@value@ch@advisor}}\\
            \makebox[.3\linewidth][s]{\hunnu@label@ch@major} & \ulenhance[1.0pt]{\makebox[.5\linewidth]{\hunnu@value@ch@major}}\\
            \makebox[.3\linewidth][s]{\hunnu@label@ch@research} & \ulenhance[1.0pt]{\makebox[.5\linewidth]{\hunnu@value@ch@research}}\\
        \end{tabular}
        

        \vspace*{\stretch{3}}

        \vspace*{\stretch{1}}

        {{\hunnu@value@ch@school}学位评定委员会办公室}

        {\zhnumsetup{time=Chinese} \hunnu@value@ch@date}

        \vspace*{\stretch{3}}
    \end{center}
    \clearpage
    \if@twoside
      \thispagestyle{empty}
      \cleardoublepage[empty]
    \fi
}
\newcommand{\MAKETITLE@pdc}{%
    \cleardoublepage
    \thispagestyle{empty}
    \begin{center}
        \linespread{2.0}
        \zihao{4}

        \vspace*{50pt}

        {\zihao{3} \hunnu@value@ch@title}

        \vspace*{\stretch{3}}

        {\zihao{-3} \hunnu@value@en@title}

        \vspace*{\stretch{3}}

        \def\tabcolsep{1pt}
        \def\arraystretch{1.3}
        \begin{tabular}{l@{\quad}l}
            \makebox[11em][s]{\hunnu@label@ch@author} & \hunnu@value@ch@author\\
            \makebox[11em][s]{\hunnu@label@ch@subject} & \hunnu@value@ch@subject\\
            \makebox[11em][s]{\hunnu@label@ch@major} & \hunnu@value@ch@major\\
        \end{tabular}

        \vspace*{\stretch{3}}

        \hunnu@label@ch@studydatefrom \quad \hunnu@value@ch@studydatefrom

        \hunnu@label@ch@studydateto \quad \hunnu@value@ch@studydateto

        \vspace*{\stretch{3}}

        \hunnu@value@ch@orginization

        \hunnu@value@ch@date

        \vspace*{\stretch{3}}
    \end{center}
    \thispagestyle{empty}
    \cleardoublepage[empty]
    \if@twoside
      \thispagestyle{empty}
      \cleardoublepage[empty]
    \fi
}
%---------------------------------------------------------------------------%
%->> Author's declaration
%---------------------------------------------------------------------------%
\newcommand{\makedeclaration}{%
    \cleardoublepage
    \thispagestyle{empty}
    {
        \linespread{1.6}
        \zihao{-4}

        \vspace*{2ex}

        \begin{center}
            {\zihao{4}\bfseries\sffamily \hunnu@label@ch@declare@creativity}
        \end{center}

        {\hunnu@value@ch@declare@creativity}

        \vspace*{3ex}

        {\noindent 学位论文{\hunnu@label@ch@declare@author \hspace*{19em} \hunnu@label@ch@declare@date}}

        % {\hfill{} {\hunnu@label@ch@declare@date \hspace*{14em}}}

        \vspace*{6ex}

        \begin{center}
            {\zihao{4}\bfseries\sffamily \hunnu@label@ch@declare@rights}
        \end{center}

        {\hunnu@value@ch@declare@rights}

        {\hunnu@value@ch@declare@rule}

        \vspace*{3ex}

        {{\hunnu@label@ch@declare@author \hspace*{21em} \hunnu@label@ch@declare@date}}

        {{\hunnu@label@ch@declare@advisor \hspace*{21em} \hunnu@label@ch@declare@date}}

        \vspace*{3ex}
    }
    \clearpage
    \clearpage
    \if@twoside
        \thispagestyle{empty}
        \cleardoublepage[empty]
    \fi
}
%---------------------------------------------------------------------------%
%->> New environments
%---------------------------------------------------------------------------%
%- define chinese keywords
\newcommand{\keywords}[1]{%
    \vspace{\baselineskip}
    \noindent {\bfseries \hunnu@label@ch@keywords} #1}
%- define engish keywords
\newcommand{\KEYWORDS}[1]{%
    \vspace{\baselineskip}
    \noindent {\bfseries \hunnu@label@en@keywords} #1}
%---------------------------------------------------------------------------%
%->> Structure elements
%---------------------------------------------------------------------------%
\ifhunnu@plain%
    \def\contentsname{\hunnu@label@en@tocname}
    \def\listfigurename{\hunnu@label@en@lsfigname}
    \def\listtablename{\hunnu@label@en@lstabname}
    \def\bibname{\hunnu@label@en@bibname}
    \def\refname{\hunnu@label@en@bibname}
    \def\algname{\hunnu@label@en@algname}
    \def\bibetal{\hunnu@label@en@bibetal}
    \def\biband{\hunnu@label@en@biband}
    \def\axiomname{\hunnu@label@en@axiomname}
    \def\theoremname{\hunnu@label@en@theoremname}
    \def\lemmaname{\hunnu@label@en@lemmaname}
    \def\corollaryname{\hunnu@label@en@corollaryname}
    \def\assertionname{\hunnu@label@en@assertionname}
    \def\propositionname{\hunnu@label@en@propositionname}
    \def\conjecturename{\hunnu@label@en@conjecturename}
    \def\definitionname{\hunnu@label@en@definitionname}
    \def\examplename{\hunnu@label@en@examplename}
    \def\remarkname{\hunnu@label@en@remarkname}
    \def\proofname{\hunnu@label@en@proofname}
    \def\@title{\hunnu@value@en@titlemark}
    \def\@author{\hunnu@value@en@author}
\else
    \def\contentsname{\hunnu@label@ch@tocname}
    \def\listfigurename{\hunnu@label@ch@lsfigname}
    \def\listtablename{\hunnu@label@ch@lstabname}
    \def\algname{\hunnu@label@ch@algname}
    \def\bibname{\hunnu@label@ch@bibname}
    \def\refname{\hunnu@label@ch@bibname}
    \def\bibetal{\hunnu@label@ch@bibetal}
    \def\biband{\hunnu@label@ch@biband}
    \def\axiomname{\hunnu@label@ch@axiomname}
    \def\theoremname{\hunnu@label@ch@theoremname}
    \def\lemmaname{\hunnu@label@ch@lemmaname}
    \def\corollaryname{\hunnu@label@ch@corollaryname}
    \def\assertionname{\hunnu@label@ch@assertionname}
    \def\propositionname{\hunnu@label@ch@propositionname}
    \def\conjecturename{\hunnu@label@ch@conjecturename}
    \def\definitionname{\hunnu@label@ch@definitionname}
    \def\examplename{\hunnu@label@ch@examplename}
    \def\remarkname{\hunnu@label@ch@remarkname}
    \def\proofname{\hunnu@label@ch@proofname}
    \def\@title{\hunnu@value@ch@titlemark}
    \def\@author{\hunnu@value@ch@author}
\fi
%---------------------------------------------------------------------------%
%->> Structure layout
%---------------------------------------------------------------------------%
%- chapter
\ctexset {
    chapter = {
        format = \linespread{1.0}\zihao{4}\bfseries\sffamily\centering,
        nameformat = {},
        titleformat = {},
        number = \arabic{chapter},
        numberformat = \rmfamily,
        aftername = \quad,
        beforeskip = {7pt},
        afterskip = {18pt},
        pagestyle = plain,
    }
}
%- section
\ctexset {
    section = {
        format = \linespread{1.0}\zihao{-4}\sffamily\raggedright,
        numberformat = \rmfamily,
        aftername = \quad,
        beforeskip = {24pt},
        afterskip = {6pt},
    }
}
%- subsection
\ctexset {
    subsection = {
        format = \linespread{1.0}\zihao{-4}\sffamily\raggedright,
        numberformat = \rmfamily,
        aftername = \quad,
        beforeskip = {12pt},
        afterskip = {6pt},
    }
}
%- subsubsection
\ctexset {
    subsubsection = {
        format = \linespread{1.0}\zihao{-4}\sffamily\raggedright,
        numberformat = \rmfamily,
        aftername = \quad,
        beforeskip = {12pt},
        afterskip = {6pt},
    }
}
%- appendix
\ctexset {
    appendix = {
        %numbering = true|false,
        %number = \rmfamily\Alph{chapter},
    }
}
%---------------------------------------------------------------------------%
%->> Configure table of contents
%---------------------------------------------------------------------------%
%- the table of contents is specified by defining \l@chapter, \l@section, ...
%- most commands are then defined with the \@dottedtocline:
%- \@dottedtocline{⟨level⟩}{⟨indent⟩}{⟨numwidth⟩}{⟨title⟩}{⟨page⟩}
%- ⟨level⟩    an entry is produced only if ⟨level⟩ <= value of the tocdepth counter
%-            note, \chapter is level 0, \section is level 1, etc
%- ⟨indent⟩   indentation from the outer left margin of the start of the contents line
%- ⟨numwidth⟩ width of a box in which the section number is to go
%- <title>    title
%- <page>     page number

%- parameters for spacing and length in toc
\def\@dotsep{1.5mu}% separation between dots in mu units
\def\@pnumwidth{2em}% width of a box in which the page number is put
\def\@tocrmarg{2em}% right margin for multiple line entries, \@tocrmarg ≥ \@pnumwidth
\def\@chaptervspace{1ex}% vertical space between chapter titles

%- redefine dottedtocline from classes.dtx and latex.ltx
\renewcommand*{\@dottedtocline}[5]{% [<level>,<indent>,<numwidth>,<title>,<page>]
    \ifnum #1>\c@tocdepth \else
        \vskip \z@ \@plus.2\p@
        {\leftskip #2\relax \rightskip \@tocrmarg \parfillskip -\rightskip
        \parindent #2\relax\@afterindenttrue
        \interlinepenalty\@M
        \leavevmode \zihao{-4}\sffamily
        \@tempdima #3\relax
        \advance\leftskip \@tempdima \null\nobreak\hskip -\leftskip
        {#4}\nobreak
        \leaders\hbox{$\m@th\mkern \@dotsep \cdot\mkern \@dotsep$}\hfill
        \nobreak
        \hb@xt@\@pnumwidth{\hfil\normalfont \normalcolor #5}%
        \par\penalty\@highpenalty}%
    \fi
}
%- redefine l@part from book.cls to add dotted toc line
\renewcommand*{\l@part}[2]{% [<title>,<page>]
    \ifnum \c@tocdepth >-2\relax
        \addpenalty{-\@highpenalty}%
        \addvspace{2.25em \@plus\p@}%
        \setlength\@tempdima{3em}%
        \begingroup
            \parindent \z@ \rightskip \@pnumwidth
            \parfillskip -\@pnumwidth
            {\leavevmode
            \zihao{4}\sffamily #1
            \leaders\hbox{$\m@th\mkern \@dotsep \cdot\mkern \@dotsep$}% add dotted toc line
            \hfil \hb@xt@\@pnumwidth{\hss #2}}\par
            \nobreak
            \global\@nobreaktrue
            \everypar{\global\@nobreakfalse\everypar{}}%
        \endgroup
    \fi
}
%- redefine l@chapter from book.cls to add dotted toc line
\renewcommand*{\l@chapter}[2]{% [<title>,<page>]
    \ifnum \c@tocdepth >\m@ne
        \addpenalty{-\@highpenalty}%
        \vskip \@chaptervspace \@plus\p@
        \setlength\@tempdima{1.5em}%
        \begingroup
            \parindent \z@ \rightskip \@pnumwidth
            \parfillskip -\@pnumwidth
            \leavevmode \zihao{4}\sffamily
            \advance\leftskip\@tempdima
            \hskip -\leftskip
            #1\nobreak
            \leaders\hbox{$\m@th\mkern \@dotsep \cdot\mkern \@dotsep$}% add dotted toc line
            \hfil \nobreak\hb@xt@\@pnumwidth{\hss #2}\par
            \penalty\@highpenalty
        \endgroup
    \fi
}
%- redefine indentation for others
\renewcommand*\l@section{\@dottedtocline{1}{1em}{1.8em}}
\renewcommand*\l@subsection{\@dottedtocline{2}{2em}{2.8em}}
\renewcommand*\l@subsubsection{\@dottedtocline{3}{3em}{3.8em}}
\renewcommand*\l@paragraph{\@dottedtocline{4}{4em}{4.8em}}
\renewcommand*\l@subparagraph{\@dottedtocline{5}{5em}{5.8em}}
\renewcommand*\l@figure{\@dottedtocline{1}{1em}{1.8em}}
\renewcommand*\l@table{\@dottedtocline{1}{1em}{1.8em}}
%---------------------------------------------------------------------------%
\endinput

