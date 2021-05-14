%% TEMat-article.cls
%% Copyright 2017-2020 Asociación Nacional de Estudiantes de Matemáticas
%
% This work may be distributed and/or modified under the
% conditions of the LaTeX Project Public License, either version 1.3
% of this license or (at your option) any later version.
% The latest version of this license is in
%   http://www.latex-project.org/lppl.txt
%   http://www.latex-project.org/lppl/
% And version 1.3 or later is part of all distributions of LaTeX
% version 2005/12/01 or later.
%
% This work has the LPPL maintenance status `maintained'.
% 
% The Current Maintainers of this work are
%   Editores de TEMat
%   mailto:temat@temat.es
%
%   Comisión de publicaciones de la
%   Asociación Nacional de Estudiantes de Matemáticas
%   mailto:publicaciones@anem.es
%
%   Isaac Sánchez Barrera
%   mailto:tex@isaac.sb
%
% This work consists of the files TEMat-article.cls and TEMat-fonts.sty

% Este archivo establece el formato de artículo de la revista TEMat de
% la ANEM.  Su uso es necesario cuando se quiera enviar un artículo a
% TEMat para su publicación.  Para usarlo, cargar la clase escribiendo
% el comando \documentclass{TEMat-article}.

\RequirePackage{expl3}[2015/11/15]
\RequirePackage{silence}
\RequirePackage{xparse,l3keys2e}
\ExplSyntaxOn
\tl_const:Nn \c_TEMat_Class_Name_tl        {TEMat-article}
\tl_const:Nn \c_TEMat_Class_Version_tl     {4.0.0-pre}
\tl_const:Nn \c_TEMat_Class_Date_tl        {2020/11/19}
\tl_const:Nn \c_TEMat_Class_Description_tl {
  Clase~para~art'iculos~de~TEMat
}

\ProvidesExplClass
  {\c_TEMat_Class_Name_tl}
  {\c_TEMat_Class_Date_tl}
  {\c_TEMat_Class_Version_tl}
  {\c_TEMat_Class_Description_tl}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% MENSAJES DE ERROR DE LA CLASE %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\msg_new:nnn
  { \c_TEMat_Class_Name_tl }
  { no-pdf-output }
  { Est'as~generando~un~documento~cuya~salida~no~es~PDF.\\
    Esto~no~es~algo~que~podamos~asegurar~que~vaya~a~funcionar~con~
    la~plantilla~correctamente.~Por~favor,~usa,~preferentemente,~
    `lualatex`~o~`pdflatex`.~O,~en~su~defecto,~`xelatex`.
  }

\msg_new:nnn
  { \c_TEMat_Class_Name_tl }
  { using-xetex }
  { Est'as~usando~XeLaTeX.\\
    Esto~puede~provocar~que~la~salida~no~sea~la~esperada,~
    puede~que~ocupe~m'as~p'aginas~que~usando~otros~compiladores~como~
    `lualatex`~o~`pdflatex`.\\
    En~parte~es~porque~XeLaTeX~no~es~del~todo~compatible~con~el~
    paquete~microtype.
  }
  
\msg_new:nnn
  { \c_TEMat_Class_Name_tl }
  { using-pdftex }
  { Est'as~usando~pdfLaTeX.\\
    Aunque~hemos~trabajado~para~que~la~salida~de~los~documentos~sea~
    lo~m'as~parecida~posible~entre~LuaLaTeX~y~pdfLaTeX,~puede~haber~
    algunas~diferencias~en~el~resultado.~Si~quieres~generar~un~
    documento~lo~m'as~parecido~a~la~versi'on~de~la~revista,~utiliza~
    `lualatex`.
  }

\msg_new:nnn
  { \c_TEMat_Class_Name_tl }
  { no-mathastext-old-fontspec }
  { Las~matem'aticas~no~usan~la~tipograf'ia~del~texto.\\
    Esto~es~porque~usas~una~versi'on~vieja~del~paquete~`fontspec`.~
    Actualiza~tu~instalaci'on~de~LaTeX~para~que~el~documento~se~genere~
    como~deber'ia.
  }


\msg_new:nnn
  { \c_TEMat_Class_Name_tl }
  { no-mathastext-pdflatex }
  { La~opci'on~`mathastext`~se~ha~desactivado.\\
    Esto~es~porque~usas~pdfLaTeX~y~el~soporte~que~tenemos~no~es~el~
    adecuado.~Si~quieres~usar~esta~opci'on,~compila~con~LuaLaTeX~o~
    XeLaTeX~en~modo~pdf.
  }

\msg_new:nnn
  { \c_TEMat_Class_Name_tl }
  { manual-hyperref }
  { Est'as~cargando~el~paquete~`hyperref`~manualmente.\\
    Has~decidido~cargar~el~paquete~`hyperref`~por~tu~cuenta.~Si~sabes~
    lo~que~est'as~haciendo,~no~debes~preocuparte.~En~caso~contrario,~
    est'as~jugando~con~fuego.
  }
  
%%%%%%%%%%%%%%%%%%%%%%%%
%%% PAQUETES BÁSICOS %%%
%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage{afterpackage}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% COMPROBACIÓN DE HECHOS BÁSICOS %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\bool_if:nF { \sys_if_output_pdf_p: || \sys_if_engine_xetex_p: } {
  \msg_warning:nn { \c_TEMat_Class_Name_tl } { no-pdf-output }
}

\sys_if_engine_xetex:T {
  \msg_warning:nn { \c_TEMat_Class_Name_tl } { using-xetex }
}

\bool_if:nT { \sys_if_engine_pdftex_p: && \sys_if_output_pdf_p: } {
  \msg_info:nn { \c_TEMat_Class_Name_tl } { using-pdftex }
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% HERRAMIENTAS ÚTILES PARA LA CLASE %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\prg_new_conditional:Nnn \TEMat_unicode_engine: { p, T, F, TF } {
  \bool_if:nTF {\sys_if_engine_luatex_p: || \sys_if_engine_xetex_p:}
  {\prg_return_true:}{\prg_return_false:}
}

\prg_new_conditional:Npnn \TEMat_packagelater:nn #1#2 { p, T, F, TF } {
  \@ifpackagelater{#1}{#2}{\prg_return_true:}{\prg_return_false:}
}

% Desde la versión 2017/05/29 de expl3, l3regex forma parte del kernel
% de LaTeX3 y no hace falta cargarlo individualmente.
\TEMat_packagelater:nnF { expl3 } { 2017/05/29 } {
  \RequirePackage{l3regex}
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CLAVES DE CONFIGURACIÓN DE LA CLASE %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\bool_new:N \g__TEMat_anonymous_bool
\bool_gset_false:N \g__TEMat_anonymous_bool

\bool_new:N \g__TEMat_authorversion_bool
\bool_gset_false:N \g__TEMat_authorversion_bool

\bool_new:N \g__TEMat_mathastext_bool
\bool_gset:Nn \g__TEMat_mathastext_bool {\TEMat_unicode_engine_p:}

\tl_new:N \g__TEMat_babel_tl
\tl_gset:Nn \g__TEMat_babel_tl {english}

\tl_new:N \g__TEMat_babelmain_tl
\tl_gset:Nn \g__TEMat_babelmain_tl {spanish}

\bool_new:N \g__TEMat_manualhyperref_bool
\bool_gset_false:N \g__TEMat_manualhyperref_bool

\bool_new:N \g__TEMat_bibtex_bool
\bool_gset_false:N \g__TEMat_bibtex_bool

\bool_new:N \g__TEMat_old_math_fonts_bool
\bool_gset_false:N \g__TEMat_old_math_fonts_bool

\bool_new:N \g__TEMat_no_dates_bool
\bool_gset_false:N \g__TEMat_no_dates_bool

\tl_new:N \g__TEMat_authorlist_stretch_tl
\tl_gset:Nn \g__TEMat_authorlist_stretch_tl {1.0}

\keys_define:nn { TEMatclassoptions } {
  anon .bool_gset:N = \g__TEMat_anonymous_bool,
  anon .default:n = true,
  anonymous .bool_gset:N = \g__TEMat_anonymous_bool,
  anonymous .default:n = true,
  anonimo .bool_gset:N = \g__TEMat_anonymous_bool,
  anonimo .default:n = true,
  
  authorversion .bool_gset:N = \g__TEMat_authorversion_bool,
  authorversion .default:n = true,

  mathastext .bool_gset:N = \g__TEMat_mathastext_bool,
  mathastext .default:n = true,

  babel .code:n = {\tl_gset:Nn \g__TEMat_babel_tl {#1}},
  babel-main .tl_gset:N = \g__TEMat_babelmain_tl,

  manualhyperref .bool_gset:N = \g__TEMat_manualhyperref_bool,
  manualhyperref .default:n = true,

  bibtex .bool_gset:N = \g__TEMat_bibtex_bool,
  bibtex .default:n = true,

  old-math .bool_gset:N = \g__TEMat_old_math_fonts_bool,
  old-math .default:n = true,

  authorlist-stretch .tl_gset:N = \g__TEMat_authorlist_stretch_tl,
  authorlist-stretch .default:n = {0.9},
}

\ProcessKeysOptions { TEMatclassoptions }

\bool_if:nT {\g__TEMat_authorversion_bool}{
  \bool_gset_true:N \g__TEMat_no_dates_bool
}

\LoadClass[10pt,leqno]{article}

\sys_if_engine_luatex:T {
  \IfFileExists{shellesc.sty}{\RequirePackage{shellesc}}{}
}

\DeclareDocumentCommand\TEMat@AuthorVersion { +m +m } {
  \bool_if:nTF {\g__TEMat_authorversion_bool} {#1}{#2}
}

\DeclareDocumentCommand\TEMat@NoDates { +m +m } {
  \bool_if:nTF {\g__TEMat_no_dates_bool} {#1}{#2}
}

%%%%%%%%%%%%%%%%%%%
%%% TIPOGRAFÍAS %%%
%%%%%%%%%%%%%%%%%%%

\TEMat_unicode_engine:TF
  {
    \RequirePackage[leqno]{amsmath}
    \RequirePackage{amssymb,amsthm}
    \RequirePackage[T1]{fontenc} % para las matemáticas de erewhon

    \RequirePackage[no-math]{fontspec}

    \@ifundefined{ IfFontExistsTF }
      { \RequirePackage{iffont}
        \let\IfFontExistsTF=\iffontexists
      }
      {}
    
    \IfFontExistsTF{STIX2Math.otf}
      { \bool_if:nF { \g__TEMat_old_math_fonts_bool }
          { \bool_gset_true:N \g__fontspec_math_bool }
      }
      { \bool_gset_true:N \g__TEMat_old_math_fonts_bool }

    \msg_redirect_name:nnn
      { fontspec }
      { icu-feature-not-exist-in-font }
      { none }
    
    \defaultfontfeatures[\rmfamily]{Numbers={Monospaced,Lining}}
    \defaultfontfeatures[\rmfamily,\sffamily]{Ligatures=TeX}

    \setmainfont{Erewhon}[
      Extension=.otf,
      UprightFont=*-Regular,
      FontFace={m}{it}{*-Italic},
      BoldFont=*-Bold,
      FontFace={b}{n}{*-Bold},
      BoldItalicFont=*-BoldItalic,
      SlantedFont=*-RegularSlanted,
      BoldSlantedFont=*-BoldSlanted,
      Scale=1.0,
      WordSpace=1.15,
      NFSSFamily=erewhontext,
      ]

    \bool_if:nT { \g__TEMat_old_math_fonts_bool } {
      \newdimen\orig@spc
      \orig@spc=.211em  

      \DeclareFontFamily{TU}{erewhonmath}{}
      \DeclareFontShape{TU}{erewhonmath}{m}{n}%
      {<-> \UnicodeFontFile{Erewhon-Regular}{}}%
      {\fontdimen2\font=1.15\orig@spc}

      \DeclareFontShape{TU}{erewhonmath}{b}{n}%
      {<-> \UnicodeFontFile{Erewhon-Bold}{}}%
      {\fontdimen2\font=1.15\orig@spc}
      
      \DeclareFontShape{TU}{erewhonmath}{bx}{n}%
      {<-> \UnicodeFontFile{Erewhon-Bold}{}}%
      {\fontdimen2\font=1.15\orig@spc}

      \DeclareFontShape{TU}{erewhonmath}{m}{it}%
      {<-> \UnicodeFontFile{Erewhon-Italic}{}}{\fontdimen2\font=0pt}

      \DeclareFontShape{TU}{erewhonmath}{bx}{it}%
      {<-> \UnicodeFontFile{Erewhon-BoldItalic}{}}{\fontdimen2\font=0pt}
    }
    
    \renewcommand\rmdefault{erewhontext}
    \AtBeginDocument {
      \renewcommand\rmdefault{erewhontext}
      \renewcommand\familydefault{\rmdefault}
      \fontfamily{\familydefault}\selectfont
    }

    \setmonofont{Inconsolatazi4}[
      AutoFakeSlant,
      BoldItalicFeatures={FakeSlant},
      StylisticSet={1,3}, % varqu & varl
      Extension=.otf,
      UprightFont=*-Regular,
      BoldFont=*-Bold,
      Scale=1.0,
      HyphenChar=None,
    ]

    \RequirePackage[scaled=0.96,semibold]{cabin} 
  }
  {
    \bool_gset_true:N \g__TEMat_old_math_fonts_bool
    
    \RequirePackage[scaled=0.96,semibold]{cabin}
    \RequirePackage[scaled=1.0,space=1.15]{erewhon}
    \RequirePackage[varqu,varl,scaled=1.0]{inconsolata}
    
    \RequirePackage[T1]{fontenc}       % Uses 'T1' font encoding.
    \RequirePackage[utf8]{inputenc}    % Uses unicode characters.
    \RequirePackage[leqno]{amsmath}
    \RequirePackage{amssymb,amsthm}
    
    \TEMat_packagelater:nnF { inconsolata } { 2016/12/31 }
      {% corrección cutre y rápida para las tildes en la i para
       % versiones viejas de Erewhon con pdfLaTeX...
        \def\activedotlessi{\def\i{i}}
        \let\textscOrig=\textsc
        \def\textsc{\bgroup\activedotlessi{}\textscA}
        \def\textscA#1{\textscOrig{#1}\egroup}
        \appto{\scshape}{\activedotlessi}
      }
  }

%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% SOPORTE DE IDIOMAS %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage[%
  main=\g__TEMat_babelmain_tl,%
  \g__TEMat_babel_tl,%
  spanish]
  {babel}
\spanishsignitems

\AfterPackage{tikz} {
  \usetikzlibrary{babel}
}

\RequirePackage{csquotes}

% Corrección de las tildes en los operadores matemáticos en castellano
% como mín, máx, lím...
\accentedoperators
\TEMat_unicode_engine:F {
  \cs_if_exist:NTF \es@op@ac@base {
    \DeclareDocumentCommand\es@op@ac@base { m } {\text{\upshape\mdseries\'{#1}}}
    \accentedoperators
  }{
    \unaccentedoperators
  }
}

\sys_if_engine_luatex:T { 
  \RequirePackage{luatexbase}
}

\RequirePackage[babel]{microtype}
\WarningFilter{microtype}{Unknown slot number of character}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% TIPOGRAFÍAS MATEMÁTICAS %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\ExplSyntaxOff
\DeclareDocumentCommand\TEMat@FixStixTwo { } {
  \directlua{
    local patch_stix = function (fontdata)
      if fontdata.psname == "STIXTwoMath"
      then
        local mc=fontdata.MathConstants
        local mp=fontdata.mathparameters
        if mc
        then
          mc.FractionNumeratorShiftUp = 0.90 * mc.FractionNumeratorShiftUp
          mc.FractionDenominatorShiftDown = 0.80 * mc.FractionDenominatorShiftDown
        end
        if mp
        then
          mp.FractionNumeratorShiftUp = 0.90 * mp.FractionNumeratorShiftUp
          mp.FractionDenominatorShiftDown = 0.80 * mp.FractionDenominatorShiftDown
        end
      end
    end
    luatexbase.add_to_callback(
      "luaotfload.patch_font",
      patch_stix,
      "temat_patch_stix"
    )
  }
}
\ExplSyntaxOn

\sys_if_engine_luatex:F {
  \let\TEMat@FixStixTwo=\relax
}

\RequirePackage{stackengine,scalerel}

\TEMat_unicode_engine:F {
  \providecommand\bmmax{2}
  \RequirePackage{bm}
}

\bool_if:nTF { \g__TEMat_old_math_fonts_bool } {
  \RequirePackage[
  erewhon,
  timesmathacc,
  amssymbols,
  varbb,
  bigdelims,
  slantedGreek,
  scaled=1.046]
  {newtxmath}

  \TEMat_unicode_engine:TF {
    \TEMat_packagelater:nnF { fontspec }{ 2017/01/01 } {
      \bool_if:nT { \g__TEMat_mathastext_bool } {
        \msg_warning:nn
        { \c_TEMat_Class_Name_tl }
        { no-mathastext-old-fontspec }
        
        \bool_gset_false:N \g__TEMat_mathastext_bool
      }  
    }
  }{
    \bool_if:nT { \g__TEMat_mathastext_bool } {
      \msg_warning:nn
      { \c_TEMat_Class_Name_tl }
      { no-mathastext-pdflatex }
      
      \bool_gset_false:N \g__TEMat_mathastext_bool
    }
  }

  \bool_if:nT { \g__TEMat_mathastext_bool } {
    \SetSymbolFont{letters}{normal}{TU}{erewhonmath}{m}{it}
    \SetSymbolFont{letters}{bold}{TU}{erewhonmath}{bx}{it}
    \SetMathAlphabet{\mathit}{normal}{TU}{erewhontext}{m}{it}
    \DeclareSymbolFont{punct}{TU}{erewhontext}{m}{n}
    \SetSymbolFont{punct}{bold}{TU}{erewhontext}{b}{n}
    \DeclareSymbolFont{extra}{OML}{zutmi}{m}{it}
    \SetSymbolFont{extra}{bold}{OML}{zutmi}{bx}{it}
    
    \DeclareMathSymbol{,}{\mathpunct}{punct}{"2C}
    \DeclareMathSymbol{.}{\mathord}{punct}{"2E}
    \DeclareMathSymbol{:}{\mathbin}{punct}{"3A}
    \DeclareMathSymbol{;}{\mathpunct}{punct}{"3B}
    
    \re@DeclareMathSymbol{\imath}{\mathord}{extra}{123}
    \re@DeclareMathSymbol{\jmath}{\mathord}{extra}{124}

    \re@DeclareMathSymbol{\alpha}{\mathord}{extra}{11}
    \re@DeclareMathSymbol{\beta}{\mathord}{extra}{12}
    \re@DeclareMathSymbol{\gamma}{\mathord}{extra}{13}
    \re@DeclareMathSymbol{\delta}{\mathord}{extra}{14}
    \re@DeclareMathSymbol{\epsilon}{\mathord}{extra}{15}
    \re@DeclareMathSymbol{\zeta}{\mathord}{extra}{16}
    \re@DeclareMathSymbol{\eta}{\mathord}{extra}{17}
    \re@DeclareMathSymbol{\theta}{\mathord}{extra}{18}
    \re@DeclareMathSymbol{\iota}{\mathord}{extra}{19}
    \re@DeclareMathSymbol{\kappa}{\mathord}{extra}{20}
    \re@DeclareMathSymbol{\lambda}{\mathord}{extra}{21}
    \re@DeclareMathSymbol{\mu}{\mathord}{extra}{22}
    \re@DeclareMathSymbol{\nu}{\mathord}{extra}{23}
    \re@DeclareMathSymbol{\xi}{\mathord}{extra}{24}
    \re@DeclareMathSymbol{\pi}{\mathord}{extra}{25}
    \re@DeclareMathSymbol{\rho}{\mathord}{extra}{26}
    \re@DeclareMathSymbol{\sigma}{\mathord}{extra}{27}
    \re@DeclareMathSymbol{\tau}{\mathord}{extra}{28}
    \re@DeclareMathSymbol{\upsilon}{\mathord}{extra}{29}
    \re@DeclareMathSymbol{\phi}{\mathord}{extra}{30}
    \re@DeclareMathSymbol{\chi}{\mathord}{extra}{31}
    \re@DeclareMathSymbol{\psi}{\mathord}{extra}{32}
    \re@DeclareMathSymbol{\omega}{\mathord}{extra}{33}
    \re@DeclareMathSymbol{\varepsilon}{\mathord}{extra}{34}
    \re@DeclareMathSymbol{\vartheta}{\mathord}{extra}{35}
    \re@DeclareMathSymbol{\varpi}{\mathord}{extra}{36}
    \re@DeclareMathSymbol{\varrho}{\mathord}{extra}{37}
    \re@DeclareMathSymbol{\varsigma}{\mathord}{extra}{38}
    \re@DeclareMathSymbol{\varphi}{\mathord}{extra}{39}

    \re@DeclareMathSymbol{\Gamma}{\mathalpha}{extra}{0}
    \re@DeclareMathSymbol{\Delta}{\mathalpha}{extra}{1}
    \re@DeclareMathSymbol{\Theta}{\mathalpha}{extra}{2}
    \re@DeclareMathSymbol{\Lambda}{\mathalpha}{extra}{3}
    \re@DeclareMathSymbol{\Xi}{\mathalpha}{extra}{4}
    \re@DeclareMathSymbol{\Pi}{\mathalpha}{extra}{5}
    \re@DeclareMathSymbol{\Sigma}{\mathalpha}{extra}{6}
    \re@DeclareMathSymbol{\Upsilon}{\mathalpha}{extra}{7}
    \re@DeclareMathSymbol{\Phi}{\mathalpha}{extra}{8}
    \re@DeclareMathSymbol{\Psi}{\mathalpha}{extra}{9}
    \re@DeclareMathSymbol{\Omega}{\mathalpha}{extra}{10}

    \re@DeclareMathSymbol{\leftharpoonup}{\mathrel}{extra}{40}
    \re@DeclareMathSymbol{\leftharpoondown}{\mathrel}{extra}{41}
    \re@DeclareMathSymbol{\rightharpoonup}{\mathrel}{extra}{42}
    \re@DeclareMathSymbol{\rightharpoondown}{\mathrel}{extra}{43}
    \re@DeclareMathSymbol{\lhook}{\mathrel}{extra}{44}
    \re@DeclareMathSymbol{\rhook}{\mathrel}{extra}{45}
    \re@DeclareMathSymbol{\ldotp}{\mathpunct}{extra}{58}
    \re@DeclareMathSymbol{\triangleright}{\mathbin}{extra}{46}
    \re@DeclareMathSymbol{\triangleleft}{\mathbin}{extra}{47}
    \re@DeclareMathSymbol{\star}{\mathbin}{extra}{63}
    \re@DeclareMathSymbol{\partial}{\mathord}{extra}{64}
    \re@DeclareMathSymbol{\flat}{\mathord}{extra}{91}
    \re@DeclareMathSymbol{\natural}{\mathord}{extra}{92}
    \re@DeclareMathSymbol{\sharp}{\mathord}{extra}{93}
    \re@DeclareMathSymbol{\smile}{\mathrel}{extra}{94}
    \re@DeclareMathSymbol{\frown}{\mathrel}{extra}{95}
    \re@DeclareMathSymbol{\ell}{\mathord}{extra}{96}
  }

  % Ajuste de los "acentos" en matemáticas
  % https://tex.stackexchange.com/a/271575/117845
  \NewDocumentCommand{\TEMatAltAccent}{O{}mm} % see http://tex.stackexchange.com/a/256209/117845
  {
    \global\expandafter\providecommand\csname #3#2\endcsname[1]{\ThisStyle{\setbox0=\hbox{$\SavedStyle##1$}%
        \ensurestackMath{%
          \stackon[\dimexpr-.5pt-4\LMpt#1]{\SavedStyle##1}{%
            \SavedStyle\kern.35\ht0\csname orig#2\endcsname{}}}} %ensurestackMath
    }%providecommand
    \expandafter\renewcommand\csname #2\endcsname[1]{%
      \tl_if_blank:nF { ##1 }
      {
        \regex_match:nnTF { \A \w \Z } { ##1 }
        {
          \csname #3#2\endcsname{##1}%
        }
        {
          \ifcat\noexpand##1\relax% % see http://tex.stackexchange.com/a/165908/117845
          \ifx##1\imath%
          \csname #3#2\endcsname{##1}%
          \else%
          \csname orig#2\endcsname{##1} %% probably greek letter
          \fi%
          \else% %%% multiletter
          \csname orig#2\endcsname{##1}
          \fi%
        }
      }
    }
  }

  \let\origgrave=\grave
  \TEMatAltAccent{grave}{alt}

  \let\origacute=\acute
  \TEMatAltAccent{acute}{alt}

  \let\orighat=\hat
  \TEMatAltAccent{hat}{alt}

  \let\origwidehat=\widehat
  \TEMatAltAccent{widehat}{alt}

  \let\origtilde=\tilde
  \TEMatAltAccent{tilde}{alt}

  \let\origbar=\bar
  \TEMatAltAccent{bar}{alt}

  \let\origbreve=\breve
  \TEMatAltAccent{breve}{alt}

  \let\origdot=\dot
  \TEMatAltAccent{dot}{alt}

  \let\origddot=\ddot
  \TEMatAltAccent{ddot}{alt}

  \let\origcheck=\check
  \TEMatAltAccent{check}{alt}

  \let\origvec=\vec
  \TEMatAltAccent{vec}{alt}

  \TEMat_packagelater:nnTF { newtxmath }{ 2016/03/01 }{
    \let\origdddot=\dddot
    \TEMatAltAccent{dddot}{alt}
    \let\origddddot=\ddddot
    \TEMatAltAccent{ddddot}{alt}
  }{
    \let\origdddot=\dddot
    \TEMatAltAccent[+4\LMpt]{dddot}{alt}
    \let\origddddot=\ddddot
    \TEMatAltAccent[+4\LMpt]{ddddot}{alt}
  }

  \let\origoverrightarrow=\overrightarrow
  \TEMatAltAccent[+4\LMpt]{overrightarrow}{alt}

  \let\origoverleftrightarrow=\overleftrightarrow
  \TEMatAltAccent[+4\LMpt]{overleftrightarrow}{alt}
}{
  \RequirePackage[math-style=ISO,bold-style=ISO]{unicode-math}
  \sys_if_engine_luatex:T {
    \TEMat@FixStixTwo
  }

  \RequirePackage{mathtools}
  \let\boldsymbol\symbf

  \tl_new:N \g__TEMat_erewhon_math_tl
  \IfFontExistsTF{Erewhon-Math.otf}
  { \tl_gset:Nn \g__TEMat_erewhon_math_tl {Erewhon-Math.otf} }
  { \tl_gset:Nn \g__TEMat_erewhon_math_tl {Erewhon-Regular.otf} }

  \setmathfont{STIX2Math.otf}[Scale=MatchLowercase]
  \setmathfont[range={"25C0,"25A0,"220E}]{Asana-Math.otf}
  \setmathfont[range=bb,Scale=0.94]{Asana-Math.otf}
  \setmathrm{STIX2Text}[
    Extension=.otf,
    UprightFont=*-Regular,
    FontFace={m}{it}{*-Italic},
    BoldFont=*-Bold,
    FontFace={b}{n}{*-Bold},
    BoldItalicFont=*-BoldItalic,
  ]
  \setmathfont[
    range={up/{num},
      "002C, %% Comma
      "002D, %% Period
      %"003A, %% Colon
      "003B, %% Semicolon
      "003F, %% Question mark
      "00BF, %% Inverted question mark
      "0021, %% Exclamation mark
      "00A1, %% Inverted exclamation mark
      "0025, %% Percent sign
      "20AC, %% Euro sign
      "0026, %% Ampersand
      "0040, %% At@ sign
    },
    Numbers={Monospaced,Lining}]{\g__TEMat_erewhon_math_tl}
  \setmathfont[range={"1D454,"1D467,"0067,"007A},StylisticSet={2}]{STIX2Math.otf}
  \IfFontExistsTF{FiraMath-Regular.otf}{
    \setmathfont{FiraMath-Regular.otf}[Scale=0.96,range={bfsfit->it,bfsfup->up}]
  }{}
  \setmathfont{Cabin-SemiBold.otf}[Scale=0.96,range={bfsfup/{num}}]
  \setmathfont{Cabin-SemiBoldItalic.otf}[Scale=0.96,range={bfsfit/{latin,Latin}}]
  \setmathfont[range={"2026}]{STIX2Math.otf}
  
  \setoperatorfont\mathrm

  \sys_if_engine_luatex:T {
    \Umathopopenspacing\displaystyle=1.25mu
    \Umathopopenspacing\textstyle=1.25mu
  }
  
  \renewcommand\binom[2]{\ensuremath{\mleft(\kern-.1em\genfrac{}{}{0pt}{}{#1}{#2}\kern-.1em\mright)}}

  \AtBeginDocument{
    \let\TEMat@forall=\forall
    \let\TEMat@exists=\exists
    \let\forall\relax
    \let\exists\relax
    \newcommand*\forall{\TEMat@forall\!\mathop{}}
    \newcommand*\exists{\TEMat@exists\!\mathop{}}
  }
  % \def\forall{\TEMat@forall}
  % \def\exists{\TEMat@exists}
  \prg_new_conditional:Nnn \TEMat__mathbb_custom: { p, T, F, TF } {
    \IfFileExists{untxebgmia.fd}{
      \prg_return_true:
    }{
      \prg_return_false:
    }
  }
  
  \TEMat__mathbb_custom:TF {
    % Adapted from newtxmath.sty by Michael Sharpe (LPPL licence)
    \DeclareFontFamily{U}{tematntxmia}{\skewchar \font =127}
    \DeclareFontShape{U}{tematntxmia}{m}{it}{
      <-> ntxmia
    }{}    
    \DeclareFontShape{U}{tematntxmia}{b}{it}{
      <-> ntxbmia
    }{}

    \DeclareFontShape{U}{tematntxmia}{m}{sl}{<->ssub * tematntxmia/m/it}{}
    \DeclareFontShape{U}{tematntxmia}{bx}{it}{<->ssub * tematntxmia/b/it}{}
    \DeclareFontShape{U}{tematntxmia}{b}{sl}{<->ssub * tematntxmia/b/it}{}
    \DeclareFontShape{U}{tematntxmia}{bx}{sl}{<->ssub * tematntxmia/b/sl}{}

    \DeclareSymbolFont{tematmathbb}{U}{tematntxmia}{m}{it}

    \DeclareMathSymbol{\TEMat@mathbb@A}{\mathord}{tematmathbb}{132}
    \DeclareMathSymbol{\TEMat@mathbb@B}{\mathord}{tematmathbb}{133}
    \DeclareMathSymbol{\TEMat@mathbb@C}{\mathord}{tematmathbb}{134}
    \DeclareMathSymbol{\TEMat@mathbb@D}{\mathord}{tematmathbb}{135}
    \DeclareMathSymbol{\TEMat@mathbb@E}{\mathord}{tematmathbb}{136}
    \DeclareMathSymbol{\TEMat@mathbb@F}{\mathord}{tematmathbb}{137}
    \DeclareMathSymbol{\TEMat@mathbb@G}{\mathord}{tematmathbb}{138}
    \DeclareMathSymbol{\TEMat@mathbb@H}{\mathord}{tematmathbb}{139}
    \DeclareMathSymbol{\TEMat@mathbb@I}{\mathord}{tematmathbb}{140}
    \DeclareMathSymbol{\TEMat@mathbb@J}{\mathord}{tematmathbb}{141}
    \DeclareMathSymbol{\TEMat@mathbb@K}{\mathord}{tematmathbb}{142}
    \DeclareMathSymbol{\TEMat@mathbb@L}{\mathord}{tematmathbb}{143}
    \DeclareMathSymbol{\TEMat@mathbb@M}{\mathord}{tematmathbb}{144}
    \DeclareMathSymbol{\TEMat@mathbb@N}{\mathord}{tematmathbb}{145}
    \DeclareMathSymbol{\TEMat@mathbb@O}{\mathord}{tematmathbb}{146}
    \DeclareMathSymbol{\TEMat@mathbb@P}{\mathord}{tematmathbb}{147}
    \DeclareMathSymbol{\TEMat@mathbb@Q}{\mathord}{tematmathbb}{148}
    \DeclareMathSymbol{\TEMat@mathbb@R}{\mathord}{tematmathbb}{149}
    \DeclareMathSymbol{\TEMat@mathbb@S}{\mathord}{tematmathbb}{150}
    \DeclareMathSymbol{\TEMat@mathbb@T}{\mathord}{tematmathbb}{151}
    \DeclareMathSymbol{\TEMat@mathbb@U}{\mathord}{tematmathbb}{152}
    \DeclareMathSymbol{\TEMat@mathbb@V}{\mathord}{tematmathbb}{153}
    \DeclareMathSymbol{\TEMat@mathbb@W}{\mathord}{tematmathbb}{154}
    \DeclareMathSymbol{\TEMat@mathbb@X}{\mathord}{tematmathbb}{155}
    \DeclareMathSymbol{\TEMat@mathbb@Y}{\mathord}{tematmathbb}{156}
    \DeclareMathSymbol{\TEMat@mathbb@Z}{\mathord}{tematmathbb}{157}
  
    \DeclareMathSymbol{\TEMat@mathbb@a}{\mathord}{tematmathbb}{158}
    \DeclareMathSymbol{\TEMat@mathbb@b}{\mathord}{tematmathbb}{159}
    \DeclareMathSymbol{\TEMat@mathbb@c}{\mathord}{tematmathbb}{160}
    \DeclareMathSymbol{\TEMat@mathbb@d}{\mathord}{tematmathbb}{161}
    \DeclareMathSymbol{\TEMat@mathbb@e}{\mathord}{tematmathbb}{162}
    \DeclareMathSymbol{\TEMat@mathbb@f}{\mathord}{tematmathbb}{163}
    \DeclareMathSymbol{\TEMat@mathbb@g}{\mathord}{tematmathbb}{164}
    \DeclareMathSymbol{\TEMat@mathbb@h}{\mathord}{tematmathbb}{165}
    \DeclareMathSymbol{\TEMat@mathbb@i}{\mathord}{tematmathbb}{166}
    \DeclareMathSymbol{\TEMat@mathbb@j}{\mathord}{tematmathbb}{167}
    \DeclareMathSymbol{\TEMat@mathbb@k}{\mathord}{tematmathbb}{168}
    \DeclareMathSymbol{\TEMat@mathbb@l}{\mathord}{tematmathbb}{169}
    \DeclareMathSymbol{\TEMat@mathbb@m}{\mathord}{tematmathbb}{170}
    \DeclareMathSymbol{\TEMat@mathbb@n}{\mathord}{tematmathbb}{171}
    \DeclareMathSymbol{\TEMat@mathbb@o}{\mathord}{tematmathbb}{172}
    \DeclareMathSymbol{\TEMat@mathbb@p}{\mathord}{tematmathbb}{173}
    \DeclareMathSymbol{\TEMat@mathbb@q}{\mathord}{tematmathbb}{174}
    \DeclareMathSymbol{\TEMat@mathbb@r}{\mathord}{tematmathbb}{175}
    \DeclareMathSymbol{\TEMat@mathbb@s}{\mathord}{tematmathbb}{176}
    \DeclareMathSymbol{\TEMat@mathbb@t}{\mathord}{tematmathbb}{177}
    \DeclareMathSymbol{\TEMat@mathbb@u}{\mathord}{tematmathbb}{178}
    \DeclareMathSymbol{\TEMat@mathbb@v}{\mathord}{tematmathbb}{179}
    \DeclareMathSymbol{\TEMat@mathbb@w}{\mathord}{tematmathbb}{180}
    \DeclareMathSymbol{\TEMat@mathbb@x}{\mathord}{tematmathbb}{181}
    \DeclareMathSymbol{\TEMat@mathbb@y}{\mathord}{tematmathbb}{182}
    \DeclareMathSymbol{\TEMat@mathbb@z}{\mathord}{tematmathbb}{183}
    
    \expandafter\DeclareMathSymbol\csname TEMat@mathbb@0\endcsname{\mathord}{tematmathbb}{43}
    \expandafter\DeclareMathSymbol\csname TEMat@mathbb@1\endcsname{\mathord}{tematmathbb}{44}
    \expandafter\DeclareMathSymbol\csname TEMat@mathbb@2\endcsname{\mathord}{tematmathbb}{45}
    \expandafter\DeclareMathSymbol\csname TEMat@mathbb@3\endcsname{\mathord}{tematmathbb}{46}
    \expandafter\DeclareMathSymbol\csname TEMat@mathbb@4\endcsname{\mathord}{tematmathbb}{47}
    \expandafter\DeclareMathSymbol\csname TEMat@mathbb@5\endcsname{\mathord}{tematmathbb}{48}
    \expandafter\DeclareMathSymbol\csname TEMat@mathbb@6\endcsname{\mathord}{tematmathbb}{49}
    \expandafter\DeclareMathSymbol\csname TEMat@mathbb@7\endcsname{\mathord}{tematmathbb}{50}
    \expandafter\DeclareMathSymbol\csname TEMat@mathbb@8\endcsname{\mathord}{tematmathbb}{51}
    \expandafter\DeclareMathSymbol\csname TEMat@mathbb@9\endcsname{\mathord}{tematmathbb}{52}

    \DeclareMathSymbol{\varBbbk}{\mathord}{tematmathbb}{168}

    \def\DoFutureLet{% 
    \def\@FutureLetDecide{%
      \ifx\@nil\@FutureLetToken
          \def\@FutureLetNext{\@EachCharacterDone}
      \else
          \def\@FutureLetNext{\@PickUpTheCharacter}
      \fi
      \@FutureLetNext
    }%
    \futurelet\@FutureLetToken\@FutureLetDecide}% end DoFutureLet
    \def\F@ntPrefix{TEMat@mathbb@}
    \def\@EachCharacterDone \@nil{}% cleanup---get rid of \@nil
    \def\m@keCharacter#1{\csname\F@ntPrefix#1\endcsname}
    \def\@PickUpTheCharacter#1{\m@keCharacter{#1}\DoFutureLet}
    \def\@EachCharacterDone \@nil{}
    \DeclareRobustCommand*{\TEMat@mathbb}[1]{%\gdef\F@ntPrefix{TEMat@mathbb@}%
      \DoFutureLet #1\@nil%
    }
    
    \let\origmathbb=\mathbb
    \let\mathbb=\TEMat@mathbb
  }{
    \let\TEMat@mathbb=\mathbb
  }

  \AtBeginDocument{%
    \let\mathbb\TEMat@mathbb
    \let\blacksquare=\relax
    \providecommand{\blacksquare}{\smblksquare}
  }
}


\RequirePackage{mleftright}       % Correcciones de espaciado.
\RequirePackage[makeroom]{cancel} % Opciones de cancelación en matemáticas
\RequirePackage[mode=math]{siunitx}
\sisetup{%
  exponent-product={\ensuremath{\cdot}},
  inter-unit-product={\,},
}

\appto\captionsspanish{
  \sisetup{%
    output-decimal-marker={,}
  }
}

\bool_if:nT { \g__TEMat_old_math_fonts_bool } {
  \RequirePackage{mathtools}
}

\newtagform{ANEM@math@number}{\fontsize{9pt}{9pt}\selectfont\sffamily (\bfseries}{\mdseries)}
\usetagform{ANEM@math@number}

\newcommand\ANEM@eqref[1]{(\ref{#1})}

\let\eqref\ANEM@eqref

%%%%%%%%%%%%%%%%%%
%%% ESTRUCTURA %%%
%%%%%%%%%%%%%%%%%%


\RequirePackage{environ}
\RequirePackage{graphicx}
\RequirePackage{caption}
\RequirePackage{subcaption}

\captionsetup{labelfont={sf,bf}}

\RequirePackage[dvipsnames]{xcolor}
\ExplSyntaxOff

\RequirePackage{geometry}

\geometry{
  twoside,
  a4paper,
  inner=2.7cm,
  outer=2.7cm,
  top=3.2cm,
  headsep=0.7cm,
  bottom=3.2cm,
  footskip=1cm plus 2mm minus 4mm,
}



\RequirePackage{enumitem}
\setlist[description]{font=\sffamily}
\setlist[enumerate]{font=\upshape\sffamily}
\setlist{%
  topsep={0.3em plus 0.1em minus 0.1em},%
  itemsep=0em,%{0.4em plus 0.1em minus 0.1em},%
}

\ExplSyntaxOn
\RequirePackage[bf,sf]{titlesec}

% Correcciones para titlesec en versiones antiguas del paquete
% (Ubuntu~16.04 et al.) ver http://tex.stackexchange.com/a/300259/117845
\TEMat_packagelater:nnF { titlesec }{ 2016/03/21 } {
  \TEMat_packagelater:nnT { titlesec }{ 2016/03/15 } {
    \patchcmd{\ttlh@hang}{\parindent\z@}{\parindent\z@\leavevmode}{}{}%
    \patchcmd{\ttlh@hang}{\noindent}{}{}{}%
  }
}

%%% TÍTULOS / ESTRUCTURA

% Estilo y espaciado de títulos de secciones.
\titleformat{\section}{%
  \fontsize{15}{17}\selectfont\sffamily\bfseries\raggedright%
}{\thesection.}{0.5em}{}{}
\titlespacing{\section}{0pt}{%
  1.7em plus 0.2em minus 0.4em%
}{0.5em plus 0.1em minus 0.15em}

% Estilo y espaciado de títulos de subsecciones.
\titleformat{\subsection}{%
  \fontsize{13}{15}\selectfont\sffamily\bfseries\raggedright%
}{\thesubsection.}{0.5em}{}{}
\titlespacing{\subsection}{0pt}{%
  1.5em plus 0.1em minus 0.4em%
}{0.5em plus 0.1em minus 0.15em}

% Estilo y espaciado de títulos de subsubsecciones.
\titleformat{\subsubsection}{%
  \fontsize{11}{13}\selectfont\sffamily\bfseries\raggedright%
}{\thesubsubsection.}{0.5em}{}{}
\titlespacing{\subsubsection}{0pt}{%
  1.4em plus 0.1em minus 0.35em
}{0.5em plus 0.1em minus 0.15em}

\RequirePackage{ccicons}
\RequirePackage{calc}
\RequirePackage{fancyhdr}
\newlength\TEMat@footsep
\fancypagestyle{ANEM@portada}{
  \fancyhf{}
  \fancyfoot[C]{
      \TEMat@copyright
  }
  \renewcommand{\headrulewidth}{0pt}
  \renewcommand{\footrulewidth}{0pt}
}
\fancypagestyle{ANEM@normal}{%
  \fancyhf{}%
  % En páginas pares, a la izquierda, título del artículo en la cabecera.
  \fancyhead[LE]{\TEMatShortTitle}
  
  % En páginas pares, a la izquierda, número de página en el pie de
  % página.
  \fancyfoot[LE]{\thepage}     

  \bool_if:nT { \g__TEMat_anonymous_bool } {
    \fancyfoot[CE]{\emph{(\TEMatString{draft},~\TEMatString{underReview})}}
  }

  % En páginas pares, a la derecha, enlace a la web en el pie de página.
  \TEMat@AuthorVersion{}{
  \fancyfoot[RE]{\TEMat@FooterLink\\ \BYMAT@FooterLink}}

  % En páginas pares, a la derecha, apellidos de los autores en la
  % cabecera.
  \fancyhead[RO]{\TEMatShortAuthors}

  \TEMat@AuthorVersion{} {
    % En páginas impares, a la izquierda, TEMat, volumen y año en el pie
    % de página.
    \fancyfoot[LO]{\TEMat@JournalName,~\TEMat@Volume{}~(\TEMat@VolumeYear)}

    % En páginas impares, en el centro, ISSN en el pie de página.
    \fancyfoot[CO]{e-\textsc{issn}:~\TEMat@ISSN}
  }
  
  % En páginas impares, a la derecha, número de página en el pie de página.
  \fancyfoot[RO]{\thepage} 
  \renewcommand{\headrulewidth}{0.4pt}
  \renewcommand{\footrulewidth}{0.4pt}
}
\pagestyle{ANEM@normal}

%%% BIBLIOGRAFÍA

\TEMat_unicode_engine:F {
  \DeclareUnicodeCharacter{0306}{\u{}}
}

\RequirePackage[backend=\bool_if:nTF{\g__TEMat_bibtex_bool}{bibtex}{biber},
  bibstyle=numeric,
  citestyle=numeric-comp,
  sorting=nyvt,
  natbib=true,
  sortcites=true,
  maxbibnames=99,
  maxcitenames=3,
  minnames=1,
  autocite=plain,
  uniquelist=false,
  date=comp
]{biblatex}
\ExplSyntaxOff

\RequirePackage{xpatch}  

\def\bibleftbracket{\textup{[}\begingroup\upshape}
\def\bibrightbracket{\endgroup\textup{]}}
\def\namelabeldelim{\addnbspace}
\xpretobibmacro{textcite}{\defcounter{abbrvpenalty}{9000}}{}{}

\DeclareFieldFormat{eprint:hal}{%
  \ifhyperref {%
    \textsc{hal}: \href{\haltourl#1}{\nolinkurl{#1}}%
  }{%
    \nolinkurl{#1}%
  }%
}

% \DeclareFieldFormat{eprint:arxiv}{%
%   \ifhyperref {%
%     \textsc{arXiv}: \href{https://arxiv.org/abs/#1}{\nolinkurl{#1}}%
%   }{%
%     \nolinkurl{#1}%
%   }%
% }

\DeclareFieldFormat{doi}{\url{https://doi.org/#1}}

\DeclareStyleSourcemap{
  \maps[datatype=bibtex]{
    \map{
      \step[fieldsource=howpublished, fieldtarget=note]
      \step[fieldsource=journaltitle,
        match=\regexp{\b([A-Z]{1}[A-Za-z0-9]*)\b}, replace={{}{$1}}]
    }
    \map{
      \pertype{book}
      \step[fieldset=pages,null]
      \step[fieldset=numpages,null]
    }
    \map{
      \step[fieldsource=doi,final]
      \step[fieldset=url,null]
      \step[fieldset=eprint,null]
      \step[fieldset=urldate,null]
      \step[fieldset=isbn,null]
    }
    \map{
      \step[fieldsource=fjournal,final]
      \step[fieldset=journal,null]
      \step[fieldsource=fjournal,fieldtarget=journal]
    }
    \map{
      \step[fieldsource=eprint,final]
      \step[fieldset=url,null]
      \step[fieldset=urldate,null]
    }
    \map[overwrite]{
      \step[fieldsource=author,
            match=\regexp{\x{0131}\x{0300}},
            replace=\regexp{\x{00EC}}] % i grave
      \step[fieldsource=author,
            match=\regexp{\x{0131}\x{0301}},
            replace=\regexp{\x{00ED}}] % i acute
      \step[fieldsource=author,
            match=\regexp{\x{0131}\x{0302}},
            replace=\regexp{\x{00EE}}] % i circumflex
      \step[fieldsource=author,
            match=\regexp{\x{0131}\x{0303}},
            replace=\regexp{\x{0129}}] % i tilde
      \step[fieldsource=author,
            match=\regexp{\x{0131}\x{0304}},
            replace=\regexp{\x{012B}}] % i macron
      \step[fieldsource=author,
            match=\regexp{\x{0131}\x{0306}},
            replace=\regexp{\x{012D}}] % i breve
      \step[fieldsource=author,
            match=\regexp{\x{0131}\x{0308}},
            replace=\regexp{\x{00EF}}] % i diaeresis
      \step[fieldsource=author,
            match=\regexp{\x{0131}\x{0309}},
            replace=\regexp{\x{1EC9}}] % i hook above
      \step[fieldsource=author,
            match=\regexp{\x{0131}\x{030C}},
            replace=\regexp{\x{01D0}}] % i caron
      \step[fieldsource=author,
            match=\regexp{\x{0131}\x{030F}},
            replace=\regexp{\x{0209}}] % i double grave
      \step[fieldsource=author,
            match=\regexp{\x{0131}\x{0311}},
            replace=\regexp{\x{020B}}] % i inverted breve
    }
  }
}

\ExplSyntaxOff
\appto\captionsspanish{
  \def\sin{\sen}
}

\renewcommand*{\multinamedelim}{\ifboolexpr{ test {\ifbibliography}}{;\space}{,\space}}

\ExplSyntaxOn

% \let\ANEM@dollar=$ % para corregir el coloreado de sintaxis en algunos editores...

\DefineBibliographyStrings{spanish}{andothers={\emph{et~al}\adddot}}
\DeclareFieldFormat[thesis]{title}{\mkbibemph{#1}\addperiod}

\@ifpackagelater{biblatex}{2016/03/03}
{%
  \DeclareNameAlias{sortname}{family-given}
  \DeclareNameAlias{default}{family-given}
  \renewcommand*{\mkbibnamefamily}[1]{%
    \ifmknamesc{\textsc{#1}}{#1}}
}{%
  \DeclareNameAlias{sortname}{last-first}
  \DeclareNameAlias{default}{last-first}
  \renewcommand*{\mkbibnamelast}[1]{%
    \ifmknamesc{\textsc{#1}}{#1}}
}

\renewcommand*{\mkbibnameprefix}[1]{%
  \ifboolexpr{ test {\ifmknamesc} and test {\ifuseprefix} }
    {\textsc{#1}}
    {#1}}

\def\ifmknamesc{%
  \ifboolexpr{ test {\ifbibliography}
               and ( test {\ifcurrentname{author}}
                     or ( test {\ifnameundef{author}}
                          and test {\ifcurrentname{editor}} ) ) }}
\ExplSyntaxOn

\DefineBibliographyExtras{spanish}{%
  \restorecommand\lbx@finalnamedelim
}
\DefineBibliographyExtras{english}{%
  \restorecommand\lbx@finalnamedelim
}
\renewcommand\finalandcomma{\addcomma\space}
\DefineBibliographyExtras{spanish}{%
  \renewcommand*\finalandcomma{\ifboolexpr{ test {\ifbibliography}}{\addcomma\space}{\space}}
}

%%%%%%%%%%%%%%%%%%%% INTERFAZ ANTIGUA, NECESITA RENOVAR!!!!

\RequirePackage{thmtools}


%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% HYPERREF Y COMPAÑÍA %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%

\PassOptionsToPackage{unicode}{hyperref}
\bool_if:nTF { \g__TEMat_manualhyperref_bool } {
  \msg_info:nn
    { \c_TEMat_Class_Name_tl }
    { manual-hyperref }
}{
  \RequirePackage{hyperref}
}

\AfterPackage{hyperref}{
  % Permite hacer referencias a elementos del documento y crea los
  % hipervínculos.
  \RequirePackage[noabbrev,\g__TEMat_babelmain_tl]{cleveref}
  \appto\captionsspanish{
    \crefname{section}{sección}{secciones}
    \Crefname{section}{Sección}{Secciones}
  }
  \hypersetup{
    colorlinks,
    linkcolor={red!50!black},
    citecolor={blue!40!black},
    urlcolor={blue!40!black},
    pdfview=FitH,
    pdfstartview=FitH,
    bookmarksnumbered,
    bookmarksopen,
  }

  \renewcommand{\Hy@numberline}[1]{#1.~}

  \g@addto@macro\UrlSpecials{%
    \do\`{\mbox{\UrlFont\char`\`}}%
    \do\'{\mbox{\UrlFont\char`\'}}%
    \do\l{\mbox{\UrlFont\char`\l}}%
  }

  \let\old@autoref@ANEM=\autoref
  \let\autoref=\cref
  \let\Autoref=\Cref
}

\DeclareDocumentCommand\TEMatString{ m } {
  \tl_use:c {g_TEMat_string_ #1 _tl}
}

\ExplSyntaxOff
\newcommand{\@liasenv}[2]{\newenvironment{#1}[1][\empty]{\ifx##1\empty\begin{#2}\else\begin{#2}[{##1}]\fi}{\end{#2}\ignorespacesafterend}}

\newcommand{\ifnotext@alias}[2]{%
\sbox0{#1}%
\ifdim\wd0=0pt%
\begin{#2}% if #1 is empty
\else%
\begin{#2}[#1]% if #1 is not empty
\fi%
}

\newcommand{\@@liasenv}[2]{\@liasenv{#1}{#2}\@liasenv{#1*}{#2*}}
\DeclareRobustCommand{\emth}{%
  \DeclareRobustCommand{\em}{%
    \@nomath \em \ifdim \fontdimen \@ne \font >\z@ \eminnershape \else \slshape \fi}%
  \em}

\definecolor{ANEMgris}{gray}{0.6}

%% Estilo para teoremas, lemas, proposiciones...
\appto\thmt@declaretheoremstyle@setup{%
  \kvsetkeys{thmstyle}{
    headformat={\headformat@standard@TEMat{\NOTE}},
  }
}

\newlength\TEMat@thm@above
\setlength\TEMat@thm@above{8pt plus 1pt minus 1pt}

\newlength\TEMat@thm@below
\setlength\TEMat@thm@below{2pt plus 1pt minus 1pt}

\declaretheoremstyle[ % Permite definir un nuevo estilo de entorno
  spaceabove=\TEMat@thm@above, spacebelow=\TEMat@thm@below, % Establece el espaciado por encima y debajo.
  headfont=\normalfont\sffamily\bfseries, % Establece el tipo de fuente en la cabecera.
  notefont=\normalfont, % Si hay una nota (autor, año, lo que sea), establece el estilo de fuente de esa nota.
  notebraces={(}{)}, % Establece el delimitador de la nota.
  headpunct={\normalfont.}, % Establece la puntuación con la que termina la cabecera.
  postheadspace={0.8em}, % Establece el espaciado entre cabecera y cuerpo.
  bodyfont=\emth, % Establece la fuente del cuerpo.
%  headformat={\headformat@standard@TEMat{\NOTE}},
]{ANEMteorema} % Se le da un nombre al estilo definido, para llamarlo más tarde.
  
\declaretheorem[style=ANEMteorema,
  name=\TEMatString{Theorem},
  refname={\TEMatString{theorem},\TEMatString{theorems}},
  Refname={\TEMatString{Theorem},\TEMatString{Theorems}},
]{teorema}
\declaretheorem[style=ANEMteorema,
  name=\TEMatString{Theorem},
  numbered=no,
  refname={teorema,teoremas},
  Refname={Teorema,Teoremas}]{teorema*}
\@@liasenv{thm}{teorema}
\@@liasenv{theorem}{teorema}
\@@liasenv{theo}{teorema}
\@@liasenv{teo}{teorema}
\@@liasenv{teor}{teorema}


%%%% USO RESTRINGIDO
\declaretheorem[style=ANEMteorema,
  name=\TEMatString{Theorem},
  refname={\TEMatString{theorem},\TEMatString{theorems}},
  Refname={\TEMatString{Theorem},\TEMatString{Theorems}},
]{teoremaletra}
\renewcommand{\theteoremaletra}{\Alph{teoremaletra}}
\@liasenv{theoremletters}{teoremaletra}


\declaretheorem[style=ANEMteorema,
  numberlike=teorema,
  name=\TEMatString{Lemma},
  refname={\TEMatString{lemma},\TEMatString{lemmas}},
  Refname={Lemma,Lemmas}]{lema}
\declaretheorem[style=ANEMteorema,
  numbered=no,
  name=\TEMatString{Lema},
  refname={\TEMatString{lema},\TEMatString{lemas}},
  Refname={Lema,Lemas}]{lema*}
\@@liasenv{lem}{lema}
\@@liasenv{lemm}{lema}
\@@liasenv{lemma}{lema}
\declaretheorem[style=ANEMteorema,
  numberlike=teoremaletra,
  name=\TEMatString{Lemma},
  refname={\TEMatString{lemma},\TEMatString{lemmas}},
  Refname={\TEMatString{Lemma},\TEMatString{Lemmas}}
]{lemaletra}
\renewcommand{\thelemaletra}{\Alph{lemaletra}}
\@liasenv{lemmaletters}{lemaletra}

\declaretheorem[style=ANEMteorema,
  numberlike=teorema,
  name=\TEMatString{Corollary},
  refname={\TEMatString{corollary},\TEMatString{corollaries}},
  Refname={\TEMatString{Corollary},\TEMatString{Corollaries}}]{corolario}
\declaretheorem[style=ANEMteorema,
  numbered=no,
  name=\TEMatString{Corollary},
  refname={\TEMatString{corollary},\TEMatString{corollaries}},
  Refname={\TEMatString{Corollary},\TEMatString{Corollaries}}]{corolario*}
\@@liasenv{corollary}{corolario}
\@@liasenv{corol}{corolario}
\@@liasenv{coroll}{corolario}
\@@liasenv{cor}{corolario}
\@@liasenv{coro}{corolario}
\declaretheorem[style=ANEMteorema,
  numberlike=teoremaletra,
  name=\TEMatString{Corollary},
  refname={\TEMatString{corollary},\TEMatString{corollaries}},
  Refname={\TEMatString{Corollary},\TEMatString{Corollaries}},
]{corolarioletra}
\renewcommand{\thelemaletra}{\Alph{corolarioletra}}
\@liasenv{corollaryletters}{corolarioletra}

\declaretheorem[style=ANEMteorema,
  numberlike=teorema,
  name=\TEMatString{Proposition},
  refname={\TEMatString{proposition},\TEMatString{propositions}},
  Refname={\TEMatString{Proposition},\TEMatString{Propositions}}]{proposicion}
\declaretheorem[style=ANEMteorema,
  numbered=no,
  name=\TEMatString{Proposition},
  refname={\TEMatString{proposition},\TEMatString{propositions}},
  Refname={\TEMatString{Proposition},\TEMatString{Propositions}}]{proposicion*}
\@@liasenv{prop}{proposicion}
\@@liasenv{propo}{proposicion}
\@@liasenv{propos}{proposicion}
\@@liasenv{proposit}{proposicion}
\@@liasenv{proposition}{proposicion}
\declaretheorem[style=ANEMteorema,
  numberlike=teoremaletra,
  name=\TEMatString{Proposition},
  refname={\TEMatString{proposition},\TEMatString{propositions}},
  Refname={\TEMatString{Proposition},\TEMatString{Propositions}}
]{proposicionletra}
\renewcommand{\thelemaletra}{\Alph{proposicionletra}}
\@liasenv{propositionletters}{proposicionletra}

\declaretheorem[style=ANEMteorema,
  numberlike=teorema,
  name=\TEMatString{Property},
  refname={\TEMatString{property},\TEMatString{properties}},
  Refname={\TEMatString{Property},\TEMatString{Properties}}]{propiedad}
\declaretheorem[style=ANEMteorema,
  numbered=no,
  name=\TEMatString{Property},
  refname={\TEMatString{property},\TEMatString{properties}},
  Refname={\TEMatString{Property},\TEMatString{Properties}}]{propiedad*}
\@@liasenv{propi}{propiedad}
\@@liasenv{proper}{propiedad}
\@@liasenv{property}{propiedad}
\@@liasenv{propty}{propiedad}
\declaretheorem[style=ANEMteorema,
  numberlike=teoremaletra,
  name=\TEMatString{Property},
  refname={\TEMatString{property},\TEMatString{properties}},
  Refname={\TEMatString{Property},\TEMatString{Properties}},
]{propiedadletra}
\renewcommand{\thelemaletra}{\Alph{propiedadletra}}
\@liasenv{propertyletters}{propiedadletra}

\declaretheorem[style=ANEMteorema,
  numberlike=teorema,
  name=\TEMatString{Conjecture},
  refname={\TEMatString{conjecture},\TEMatString{conjectures}},
  Refname={\TEMatString{Conjecture},\TEMatString{Conjectures}}]{conjetura}
\declaretheorem[style=ANEMteorema,
  numbered=no,
  name=\TEMatString{Conjecture},
  refname={\TEMatString{conjecture},\TEMatString{conjectures}},
  Refname={\TEMatString{Conjecture},\TEMatString{Conjectures}}]{conjetura*}
\@@liasenv{conj}{conjetura}
\@@liasenv{conjecture}{conjetura}
\@@liasenv{conjec}{conjetura}
\@@liasenv{conjet}{conjetura}
\@@liasenv{conje}{conjetura}

\declaretheorem[style=ANEMteorema,
  numberlike=teorema,
  name=\TEMatString{Fact},
  refname={\TEMatString{fact},\TEMatString{facts}},
  Refname={\TEMatString{Fact},\TEMatString{Facts}}]{hecho}
\declaretheorem[style=ANEMteorema,
  numbered=no,
  name=\TEMatString{Fact},
  refname={\TEMatString{fact},\TEMatString{facts}},
  Refname={\TEMatString{Fact},\TEMatString{Facts}}]{hecho*}
\@@liasenv{fact}{hecho}

\declaretheorem[style=ANEMteorema,
  numberlike=teorema,
  name=\TEMatString{Criterion},
  refname={\TEMatString{criterion},\TEMatString{criteria}},
  Refname={\TEMatString{Criterion},\TEMatString{Criteria}}]{criterio}
\declaretheorem[style=ANEMteorema,
  numbered=no,
  name=\TEMatString{Criterion},
  refname={\TEMatString{criterion},\TEMatString{criteria}},
  Refname={\TEMatString{Criterion},\TEMatString{Criteria}}]{criterio*}
\@@liasenv{criterion}{criterio}

\declaretheorem[style=ANEMteorema,
  numberlike=teorema,
  name=\TEMatString{Axiom},
  refname={\TEMatString{axiom},\TEMatString{axioms}},
  Refname={\TEMatString{Axiom},\TEMatString{Axioms}}]{axioma}
\declaretheorem[style=ANEMteorema,
  numbered=no,
  name=\TEMatString{Axiom},
  refname={\TEMatString{axiom},\TEMatString{axioms}},
  Refname={\TEMatString{Axiom},\TEMatString{Axioms}}]{axioma*}
\@@liasenv{axiom}{axioma}
\declaretheorem[style=ANEMteorema,
  name=\TEMatString{Axiom},
  refname={\TEMatString{axiom},\TEMatString{axioms}},
  Refname={\TEMatString{Axiom},\TEMatString{Axioms}}
]{axiomaletra}
\renewcommand{\theaxiomaletra}{\Alph{axiomaletra}}
\@liasenv{axiomletters}{axiomaletra}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Estilo para definiciones, ejemplos...
\declaretheoremstyle[
  spaceabove=\TEMat@thm@above, spacebelow=\TEMat@thm@below,
  headfont=\normalfont\sffamily\bfseries,
  notefont=\normalfont, notebraces={(}{)},
  headpunct={\normalfont.}, postheadspace={0.8em},
  bodyfont=\normalfont,
  qed={{\color{ANEMgris}\scriptsize\ensuremath{\blacktriangleleft}}},
]{ANEMdefinicion}

\declaretheorem[style=ANEMdefinicion,
  numberlike=teorema,
  name=\TEMatString{Definition},
  refname={\TEMatString{definition},\TEMatString{definitions}},
  Refname={\TEMatString{Definition},\TEMatString{Definitions}}]{definicion}
\declaretheorem[style=ANEMdefinicion,
  numbered=no,
  name=\TEMatString{Definition},
  refname={\TEMatString{definition},\TEMatString{definitions}},
  Refname={\TEMatString{Definition},\TEMatString{Definitions}}]{definicion*}
\@@liasenv{defn}{definicion}
\@@liasenv{defi}{definicion}
\@@liasenv{definition}{definicion}
\@@liasenv{defin}{definicion}
\@@liasenv{define}{definicion}

\declaretheorem[style=ANEMdefinicion,
  numberlike=teorema,
  name=\TEMatString{Example},
  refname={\TEMatString{example},\TEMatString{examples}},
  Refname={\TEMatString{Example},\TEMatString{Examples}}]{ejemplo}
\declaretheorem[style=ANEMdefinicion,
  numbered=no,
  name=\TEMatString{Example},
  refname={\TEMatString{example},\TEMatString{examples}},
  Refname={\TEMatString{Example},\TEMatString{Examples}}]{ejemplo*}
\@@liasenv{example}{ejemplo}
\@@liasenv{exmp}{ejemplo}
\@@liasenv{exa}{ejemplo}
\@@liasenv{ex}{ejemplo}
\@@liasenv{exam}{ejemplo}
\@@liasenv{examp}{ejemplo}
\@@liasenv{ejem}{ejemplo}
\@@liasenv{ejm}{ejemplo}
\@@liasenv{ejemp}{ejemplo}
\@@liasenv{ej}{ejemplo}


%% Los ejercicios tienen numeración propia dada su naturaleza
\declaretheorem[style=ANEMdefinicion,
  name=\TEMatString{Exercise},
  refname={\TEMatString{exercise},\TEMatString{exercises}},
  Refname={\TEMatString{Exercise},\TEMatString{Exercises}}]{ejercicio}
\declaretheorem[style=ANEMdefinicion,
  numbered=no,
  name=\TEMatString{Exercise},
  refname={\TEMatString{exercise},\TEMatString{exercises}},
  Refname={\TEMatString{Exercise},\TEMatString{Exercises}}]{ejercicio*}
\@@liasenv{exercise}{ejercicio}
\@@liasenv{exe}{ejercicio}
\@@liasenv{ejerc}{ejercicio}
\@@liasenv{ejer}{ejercicio}

\declaretheorem[style=ANEMdefinicion,
  numberlike=teorema,
  name=\TEMatString{Problem},
  refname={\TEMatString{problem},\TEMatString{problems}},
  Refname={\TEMatString{Problem},\TEMatString{Problems}}]{problema}
\declaretheorem[style=ANEMdefinicion,
  numbered=no,
  name=\TEMatString{Problem},
  refname={\TEMatString{problem},\TEMatString{problems}},
  Refname={\TEMatString{Problem},\TEMatString{Problems}}]{problema*}
\@@liasenv{problem}{problema}
\@@liasenv{prob}{problema}

\declaretheorem[style=ANEMdefinicion,
  numberlike=teorema,
  name=\TEMatString{Question},
  refname={\TEMatString{question},\TEMatString{questions}},
  Refname={\TEMatString{Question},\TEMatString{Questions}}]{pregunta}
\declaretheorem[style=ANEMdefinicion,
  numbered=no,
  name=\TEMatString{Question},
  refname={\TEMatString{question},\TEMatString{questions}},
  Refname={\TEMatString{Question},\TEMatString{Questions}}]{pregunta*}
\@@liasenv{question}{pregunta}
\@@liasenv{quest}{pregunta}
\@@liasenv{preg}{pregunta}

\declaretheorem[style=ANEMdefinicion,
  numberlike=teorema,
  name=\TEMatString{Hypothesis},
  refname={\TEMatString{hypothesis},\TEMatString{hypotheses}},
  Refname={\TEMatString{Hypothesis},\TEMatString{Hypotheses}}]{hipotesis}
\declaretheorem[style=ANEMdefinicion,
  numbered=no,
  name=\TEMatString{Hypothesis},
  refname={\TEMatString{hypothesis},\TEMatString{hypotheses}},
  Refname={\TEMatString{Hypothesis},\TEMatString{Hypotheses}}]{hipotesis*}
\@@liasenv{hipot}{hipotesis}
\@@liasenv{hypothesis}{hipotesis}
\@@liasenv{hypoth}{hipotesis}

\declaretheoremstyle[
  spaceabove=\TEMat@thm@above, spacebelow=\TEMat@thm@below,
  headfont=\normalfont\sffamily\bfseries,
  notefont=\normalfont, notebraces={(}{)},
  headpunct={\normalfont.}, postheadspace={0.8em},
  bodyfont=\normalfont,
  postheadhook={\hspace{0mm}\newline\nopagebreak},
]{ANEMalgoritmo}
\declaretheorem[style=ANEMalgoritmo,
  name=\TEMatString{Algorithm},
  refname={\TEMatString{algorithm},\TEMatString{algorithms}},
  Refname={\TEMatString{Algorithm},\TEMatString{Algorithms}}
]{algoritmo}
\declaretheorem[style=ANEMalgoritmo,
  numbered=no,
  name=\TEMatString{Algorithm},
  refname={\TEMatString{algorithm},\TEMatString{algorithms}},
  Refname={\TEMatString{Algorithm},\TEMatString{Algorithms}}
]{algoritmo*}
\@@liasenv{algorithm}{algoritmo}

\RequirePackage{mdframed}
\newmdenv[topline=false,rightline=false,bottomline=false,linecolor=ANEMgris,innerleftmargin=0.5em,innertopmargin=0,skipbelow=0pt]{ANEM@teoremafl}

\ExplSyntaxOn
\DeclareDocumentEnvironment{teoremafl}{ m D(){htbp} o }
{
  \let\TEMat@ORIG@caption=\caption
  \begin{figure}[#2]
    \IfValueTF{#3}{\begin{#1}[#3]}{\begin{#1}}
    \vspace*{-\baselineskip}\vspace*{-0.2em}
    \begin{ANEM@teoremafl}
}
{
    \end{ANEM@teoremafl}\end{#1}
  \end{figure}
  \let\caption=\TEMat@ORIG@caption
}
\ExplSyntaxOff

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Estilo para notas, observaciones, notación...
\declaretheoremstyle[
  spaceabove=\TEMat@thm@above, spacebelow=\TEMat@thm@below,
  headfont=\sffamily\itshape,
  notefont=\normalfont,
  headpunct={\normalfont.}, postheadspace={0.8em},
  % bodyfont={\DeclareRobustCommand{\qed}{%
  % \ifmmode%
  %   \mathqed%
  % \else%
  %   \leavevmode\unskip\nobreak\hbox{\qedsymbol}
  % \fi%
  % }%
  % \normalfont},
  notebraces={(}{)},
  % qed={{\color{ANEMgris}\makebox[0pt][r]{\hspace{-1.5em}\raisebox{-0.7ex}{\rule{1.5em}{1pt}}}}},
  qed={{\color{ANEMgris}\scriptsize\ensuremath{\blacktriangleleft}}},
]{ANEMnota}

\declaretheorem[style=ANEMnota,
  numberlike=teorema,
  name=\TEMatString{Note},
  refname={\TEMatString{note},\TEMatString{notes}},
  Refname={\TEMatString{Note},\TEMatString{Notes}}]{nota}
\declaretheorem[style=ANEMnota,
  numbered=no,
  name=\TEMatString{Note},
  refname={\TEMatString{note},\TEMatString{notes}},
  Refname={\TEMatString{Note},\TEMatString{Notes}}]{nota*}
\@@liasenv{note}{nota}

\declaretheorem[style=ANEMnota,
  numberlike=teorema,
  name=\TEMatString{Remark},
  refname={\TEMatString{remark},\TEMatString{remarks}},
  Refname={\TEMatString{Remark},\TEMatString{Remarks}}]{observacion}
\declaretheorem[style=ANEMnota,
  numbered=no,
  name=\TEMatString{Remark},
  refname={\TEMatString{remark},\TEMatString{remarks}},
  Refname={\TEMatString{Remark},\TEMatString{Remarks}}]{observacion*}
\@@liasenv{obs}{observacion}
\@@liasenv{observation}{observacion}
\@@liasenv{remark}{observacion}  

\declaretheorem[style=ANEMnota,
  numberlike=teorema,
  name=\TEMatString{Notation},
  refname={\TEMatString{notation},\TEMatString{notations}},
  Refname={\TEMatString{Notation},\TEMatString{Notations}}]{notacion}
\declaretheorem[style=ANEMnota,
  numbered=no,
  name=\TEMatString{Notation},
  refname={\TEMatString{notation},\TEMatString{notations}},
  Refname={\TEMatString{Notation},\TEMatString{Notations}}]{notacion*}
\@@liasenv{notation}{notacion}
\@@liasenv{notac}{notacion}

\declaretheorem[style=ANEMnota,
  numberlike=teorema,
  name=\TEMatString{Convention},
  refname={\TEMatString{convention},\TEMatString{conventions}},
  Refname={\TEMatString{Convention},\TEMatString{Conventions}}]{convencion}
\declaretheorem[style=ANEMnota,
  numbered=no,
  name=\TEMatString{Convention},
  refname={\TEMatString{convention},\TEMatString{conventions}},
  Refname={\TEMatString{Convention},\TEMatString{Conventions}}]{convencion*}
\@@liasenv{conven}{convencion}
\@@liasenv{convention}{convencion}

\declaretheorem[style=ANEMnota,
  numberlike=teorema,
  name=\TEMatString{Claim},
  refname={\TEMatString{claim},\TEMatString{claims}},
  Refname={\TEMatString{Claim},\TEMatString{Claims}}]{afirmacion}
\declaretheorem[style=ANEMnota,
  numbered=no,
  name=\TEMatString{Claim},
  refname={\TEMatString{claim},\TEMatString{claims}},
  Refname={\TEMatString{Claim},\TEMatString{Claims}}]{afirmacion*}
\@@liasenv{afirm}{afirmacion}
\@@liasenv{claim}{afirmacion}

\declaretheorem[style=ANEMnota,
  numberlike=teorema,
  name=\TEMatString{Case},
  refname={\TEMatString{case},\TEMatString{cases}},
  Refname={\TEMatString{Case},\TEMatString{Cases}}]{caso}
\declaretheorem[style=ANEMnota,
  numbered=no,
  name=\TEMatString{Case},
  refname={\TEMatString{case},\TEMatString{cases}},
  Refname={\TEMatString{Case},\TEMatString{Cases}}]{caso*}
\@@liasenv{case}{caso}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Estilo para las demostraciones...
\newlength{\space@length}
\let\proof\relax
\let\endproof\relax
\declaretheoremstyle[
  spaceabove=\TEMat@thm@above, spacebelow=\TEMat@thm@below,
  headfont=\sffamily\itshape,
  notefont=\sffamily\itshape,
  headpunct={\normalfont.}, postheadspace={0.8em},
  bodyfont=\normalfont,
  notebraces={}{},
  headformat={\ifnotext@proof{\NOTE}},
]{ANEMdemostracion}
\declaretheorem[style=ANEMdemostracion,
  name=\TEMatString{Proof},
  numbered=no,
  qed=\ensuremath{\blacksquare}
]{demostracion}
\@liasenv{demostracion*}{demostracion}
\@@liasenv{proof}{demostracion}
\@@liasenv{demo}{demostracion}
\@@liasenv{dem}{demostracion}

\declaretheorem[style=ANEMdemostracion,
  name=\TEMatString{Solution},
  numbered=no,
  qed=\ensuremath{\blacksquare}
]{solucion}
\@liasenv{solucion*}{solucion}
\@@liasenv{sol}{solucion}
\@@liasenv{solution}{solucion}

\newcommand{\ifnotext@proof}[1]{%
\sbox0{#1}%
\ifdim\wd0=0pt%
{\NAME}% if #1 is empty
\else%
{\settowidth{\space@length}{\ }\hskip-\space@length\NOTE}% if #1 is not empty
\fi%
}

\newcommand{\headformat@standard@TEMat}[1]{%
{\NAME}%
\sbox0{\NUMBER}%
\ifdim\wd0=0pt%
\else%
{ \NUMBER}%
\fi
\sbox0{#1}%
\ifdim\wd0=0pt%
\else%
{\NOTE}%
\fi%
}

\ExplSyntaxOn

%%%% SOPORTE PARA CIERTAS FIGURAS
\AfterPackage{standalone}{
  \sys_if_engine_luatex:T {
    \global\def\sa@buildgraphic#1{%
      \ifnum\pdf@shellescape=0
        \PackageError{standalone}{Shell escape needed to create graphic! Use the '-shell-escape' option.}{}%
      \else
        \begingroup
        \edef\file{#1}%
        \edef\outfile{\file\sa@graphicext}%
        \edef\filemodbefore{\csname pdffilemoddate\endcsname{\outfile}}%
        \let\latex\sa@build@latex
        \let\latexoptions\sa@build@latexoptions
        \let\buildjobname\sa@build@jobname
        \sa@setquote
        \let\quote\sa@build@quote
        \immediate\write18{\sa@build@command}%
        \ifx\sa@build@postcommand\@empty\else
          \immediate\write18{\sa@build@postcommand}%
        \fi
        \IfFileExists{\outfile}{%
          \edef\filemodafter{\csname pdffilemoddate\endcsname{\outfile}}%
          \ifx\filemodbefore\filemodafter
            \expandafter\ifx\csname pdffilemoddate\endcsname\relax
              \global\sa@buildsuccesstrue
            \else
              \global\sa@buildsuccessfalse
            \fi
          \else
            \global\sa@buildsuccesstrue
          \fi
        }{%
          \global\sa@buildsuccessfalse
        }%
        \endgroup
      \fi
    }
  }
  
  \newcommand*{\imagentikz}[2][]{\includestandalone[mode=buildnew,#1]{#2}}
  \sys_if_output_pdf:TF {
    \newcommand*{\imagenpstricks}[2][]{\includestandalone[mode=buildnew,build={latex=xelatex},#1]{#2}}
  }{
    \newcommand*{\imagenpstricks}[2][]{\includestandalone[mode=buildnew,#1]{#2}}
  }
}

%%%% FUNCIONES

\sys_if_engine_xetex:T {
  \defaultfontfeatures{Extension = .otf}
}
\RequirePackage{fontawesome}

\tl_gset:Nn \g__TEMat_footer_link_tl {https://temat.es/}
\tl_gset:Nn \g__BYMAT_footer_link_tl {https://bymat.webs.upv.es/index}
\tl_gset:Nn \g__TEMat_journal_name_tl {TEMat}
\tl_gset:Nn \g__TEMat_volume_tl {N}
\tl_gset:Nn \g__TEMat_volume_year_tl {AAAA}
\tl_gset:Nn \g__TEMat_issn_tl {XXXX-XXXX}
\tl_gset:Nn \g__TEMat_short_authors_tl {NO~AUTHORS~SET}
\tl_gset:Nn \g__TEMat_received_tl {\emph{(\TEMatString{draft})}}
\tl_gset:Nn \g__TEMat_accepted_tl {\emph{(\TEMatString{draft})}}
\tl_new:N \g__TEMat_abstract_tl
\tl_new:N \g__TEMat_abstract_tmp_tl
\tl_gclear_new:N \g__TEMat_ack_tl
\tl_gclear_new:N \g__TEMat_dedication_tl
\bool_new:N \g__TEMat_flushed_author_bool
\bool_gset_true:N \g__TEMat_flushed_author_bool
\bool_new:N \g__TEMat_custom_short_authors_bool

\clist_new:N \g__TEMat_msc_clist
\clist_new:N \g__TEMat_kw_clist

\tl_gclear_new:N \g__TEMat_curr_firstname_tl
\tl_gclear_new:N \g__TEMat_curr_lastname_tl
\tl_gclear_new:N \g__TEMat_curr_shortname_tl
\tl_gclear_new:N \g__TEMat_curr_email_tl
\tl_gclear_new:N \g__TEMat_curr_affiliation_tl
\tl_gclear_new:N \g__TEMat_curr_authornotemark_tl
\bool_gset_false:N \g__TEMat_curr_corresp_bool

\seq_gclear_new:N \g__TEMat_authorgroupname_seq
\seq_gclear_new:N \g__TEMat_authorgroup_seq
\seq_gclear_new:N \g__TEMat_lastname_seq
\seq_gclear_new:N \g__TEMat_firstname_seq
\seq_gclear_new:N \g__TEMat_shortname_seq
\seq_gclear_new:N \g__TEMat_email_seq
\seq_gclear_new:N \g__TEMat_affil_seq
\seq_gclear_new:N \g__TEMat_authornotemarks_seq
\seq_gclear_new:N \g__TEMat_authornotes_seq
\seq_gclear_new:N \g__TEMat_corresp_seq
\seq_gclear_new:N \g__TEMat_pdf_authors_seq

\cs_gset:Nn \__TEMat_flush_last_author: {
  \seq_gput_right:Nx \g__TEMat_authorgroup_seq
  {\seq_count:N \g__TEMat_authorgroupname_seq}

  \seq_gput_right:No \g__TEMat_firstname_seq
  {\g__TEMat_curr_firstname_tl}
  
  \seq_gput_right:No \g__TEMat_lastname_seq
  {\g__TEMat_curr_lastname_tl}
  
  \seq_gput_right:No \g__TEMat_shortname_seq
  {\g__TEMat_curr_shortname_tl}
  
  \seq_gput_right:No \g__TEMat_email_seq
  {\g__TEMat_curr_email_tl}
  
  \seq_gput_right:No \g__TEMat_affil_seq
  {\g__TEMat_curr_affiliation_tl}
  
  \seq_gput_right:No \g__TEMat_authornotemarks_seq
  {\g__TEMat_curr_authornotemark_tl}
  
  \bool_if:nTF {\g__TEMat_curr_corresp_bool} {
    \seq_gput_right:Nn \g__TEMat_corresp_seq
    {\faicon{envelope-o}}
  }{
    \seq_gput_right:Nn \g__TEMat_corresp_seq {}
  }
  
  \tl_gclear:N \g__TEMat_curr_firstname_tl
  \tl_gclear:N \g__TEMat_curr_lastname_tl
  \tl_gclear:N \g__TEMat_curr_shortname_tl
  \tl_gclear:N \g__TEMat_curr_email_tl
  \tl_gclear:N \g__TEMat_curr_affiliation_tl
  \tl_gclear:N \g__TEMat_curr_authornotemark_tl
  \bool_gset_false:N \g__TEMat_curr_corresp_bool
  \bool_gset_true:N \g__TEMat_flushed_author_bool
}

\cs_gset:Npn \__TEMat_add_author:nnn #1 #2 #3 {
  \tl_gset:Nx \g__TEMat_curr_firstname_tl { \tl_trim_spaces:n {#2} }
  \tl_gset:Nx \g__TEMat_curr_lastname_tl { \tl_trim_spaces:n {#1} }
  \tl_gset:Nx \g__TEMat_curr_shortname_tl { \tl_trim_spaces:n {#3} }
  \seq_gput_right:Nx \g__TEMat_pdf_authors_seq {
    \tl_trim_spaces:n {#2} ~ \tl_trim_spaces:n {#1}
  }
}

\cs_gset:Npn \__TEMat_add_author:nn #1 #2 {
  \__TEMat_add_author:nnn {#1} {#2} {#1}
}

\cs_gset:Nn \__TEMat_set_anonymous_data: {
  \tl_gclear:N \g__TEMat_curr_firstname_tl
  \tl_gclear:N \g__TEMat_curr_lastname_tl
  \tl_gclear:N \g__TEMat_curr_shortname_tl
  \tl_gclear:N \g__TEMat_curr_email_tl
  \tl_gclear:N \g__TEMat_curr_affiliation_tl
  \tl_gclear:N \g__TEMat_curr_authornotemark_tl
  \tl_gclear:N \g__TEMat_ack_tl
  \tl_gclear:N \g__TEMat_dedication_tl
  \bool_gset_false:N \g__TEMat_curr_corresp_bool

  \seq_gclear:N \g__TEMat_authorgroupname_seq
  \seq_gclear:N \g__TEMat_authorgroup_seq
  \seq_gclear:N \g__TEMat_lastname_seq
  \seq_gclear:N \g__TEMat_firstname_seq
  \seq_gclear:N \g__TEMat_shortname_seq
  \seq_gclear:N \g__TEMat_email_seq
  \seq_gclear:N \g__TEMat_affil_seq
  \seq_gclear:N \g__TEMat_authornotes_seq
  \seq_gclear:N \g__TEMat_authornotemarks_seq
  \seq_gclear:N \g__TEMat_corresp_seq
  \seq_gclear:N \g__TEMat_pdf_authors_seq

  \bool_gset_true:N \g__TEMat_flushed_author_bool
  
  \author{\TEMatString{anonymisedForReviews},~\TEMatString{Document}}
}

\cs_gset:Nn \__TEMat_get_authornote: {
  \seq_gpop_left:NN \g__TEMat_authornotemarks_seq \l_tmpa_tl
  \int_set:Nn \l_tmpa_int {1}
  \int_until_do:nNnn { \l_tmpa_int } > { \tl_count:N \l_tmpa_tl }{
    \tl_set:Nn \l_tmpb_tl {\tl_item:Nn \l_tmpa_tl \l_tmpa_int}
    \int_compare:nNnT {\l_tmpa_int} > {1} {
      \protect\textsuperscript{,\thinspace}
    }
    \hyperlink{@@TEMat:AN:\l_tmpb_tl}{\protect\footnotemark[\l_tmpb_tl]}
    \int_incr:N \l_tmpa_int
  }
}

\cs_gset:Nn \__TEMat_get_affiliation: {
  {
    \seq_gpop_left:NN \g__TEMat_affil_seq \l_tmpa_tl
    \int_set:Nn \l_tmpa_int {1}
    \int_until_do:nNnn { \l_tmpa_int } > { \tl_count:N \l_tmpa_tl }{
      \tl_set:Nn \l_tmpb_tl {\tl_item:Nn \l_tmpa_tl \l_tmpa_int}
      \int_compare:nNnTF {\l_tmpa_int} > {1} {
        \\[0.1em]
      }{
        \\
        \small
      }
      \l_tmpb_tl
      \int_incr:N \l_tmpa_int
    }
  }
}

\cs_gset:Nn \__TEMat_get_email: {
  {
    \seq_gpop_left:NN \g__TEMat_email_seq \l_tmpa_tl
    \int_set:Nn \l_tmpa_int {1}
    \int_until_do:nNnn { \l_tmpa_int } > { \tl_count:N \l_tmpa_tl }{
      \tl_set:Nn \l_tmpb_tl {\tl_item:Nn \l_tmpa_tl \l_tmpa_int}
      \int_compare:nNnTF {\l_tmpa_int} > {1} {
        \\[-0.5em]
      }{
        \\
        \footnotesize
      }
      \href{mailto:\l_tmpb_tl}{\nolinkurl{\l_tmpb_tl}}
      \int_incr:N \l_tmpa_int
    }
  }
}

\cs_gset:Npn \__TEMat_get_corresponding: {
  \seq_gpop_left:NN \g__TEMat_corresp_seq \l_tmpa_tl
  \tl_if_blank:oF {\l_tmpa_tl} {
    {\l_tmpa_tl}\hspace{0.7em}
  }
}

\cs_gset:Npn \__TEMat_email_command:n #1 {
  \tl_gput_right:Nx \g__TEMat_curr_email_tl { {\tl_trim_spaces:n {#1}} }
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% INTERFAZ PÚBLICA DE LA CLASE %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\providecommand\TEMat@page{1}
\AtBeginDocument{\setcounter{page}{\TEMat@page}}

\ProvideDocumentCommand\strong { m } {\textbf{#1}}
\providecommand*\extranj[2]{\texorpdfstring{\emph{\foreignlanguage{#1}{#2}}}{#2}}

\ProvideDocumentCommand\TEMatFooterLink { m } {}
\ProvideDocumentCommand\TEMatJournalName { m } {}
\ProvideDocumentCommand\TEMatVolume { m } {}
\ProvideDocumentCommand\TEMatYear { m } {}
\ProvideDocumentCommand\TEMatAccepted { m } {}
\ProvideDocumentCommand\TEMatReceived { m } {}

\DeclareDocumentCommand\TEMatTranslate { m m m }{%
  \cs_if_exist:cT {captions #1} {
    \tl_gput_right:cn {captions #1}
    {
      \tl_gset:cn {g_TEMat_string_ #2 _tl}{#3}
    }
  }
}

\DeclareDocumentCommand\TEMatDefault { m m }{%
  \tl_gset:cn {g_TEMat_string_ #1 _tl}{#2}
}

\ProvideDocumentCommand{\TEMat@FooterLink} { } {
  \expandafter\url{\g__TEMat_footer_link_tl}
}
\ProvideDocumentCommand{\BYMAT@FooterLink} { } {
  \expandafter\url{\g__BYMAT_footer_link_tl}
}
\ProvideDocumentCommand\TEMat@JournalName { } {
  \g__TEMat_journal_name_tl
}
\ProvideDocumentCommand\TEMat@Volume { } {
  \g__TEMat_volume_tl
}
\ProvideDocumentCommand\TEMat@VolumeYear { } {
  \g__TEMat_volume_year_tl
}
\ProvideDocumentCommand\TEMat@ISSN { } {
  \g__TEMat_issn_tl
}

\ProvideDocumentCommand\TEMatShortAuthors { } {
  \g__TEMat_short_authors_tl
}

\providecommand*\TEMatFullTitle {
  \tl_use:N \g__TEMat_full_title_tl
}

\newcommand\TEMatShortTitle {
  \tl_use:N \g__TEMat_short_title_tl
}

\providecommand\TEMat@header{}

\providecommand\TEMat@extranote{}

\providecommand*\TEMat@received{
  \g__TEMat_received_tl
}

\providecommand*\TEMat@accepted{
  \g__TEMat_accepted_tl
}

\providecommand*\TEMat@msc{
  \clist_use:Nn \g__TEMat_msc_clist { ,~ }
}

\providecommand*\TEMat@kw{
  \clist_use:Nn \g__TEMat_kw_clist { ,~ }
}

\ProvideDocumentCommand\TEMat@reference { m } {
  \bgroup\centering
  \par\vspace{1em}\small
  \parbox{0.85\textwidth}{
    \setlength{\parindent}{-1.75em}
    \textsf{\textbf{\TEMatString{Reference}:}}
    \hspace{0.7em plus 0.1em minus 0.2em}
    \setlength{\parindent}{0pt}\emph{(space~for~the~reference,~to~be~generated~with~the~final~proceedings)}
    \vspace{20pt}
  }\par
  \egroup
}

\newlength\TEMat@cpwidth

\ProvideDocumentCommand\TEMat@copyrighttext { } {
  \small\ccby{}\hspace{1em}
  \TEMatString{CCBY}
}

\ProvideDocumentCommand\TEMat@copyright { } {
  \centering
  \setlength{\TEMat@cpwidth}{\widthof{\TEMat@copyrighttext}}
  \parbox{\TEMat@cpwidth}{\raggedright
  \small\TEMat@copyrighttext\\
  \setlength{\dimen0}{\widthof{\ccby{}}+1em}
  \hspace{\dimen0}\url{https://creativecommons.org/licenses/by/4.0/}}
}

\ProvideDocumentCommand\copyrightnotice { +m } {
  \TEMat@AuthorVersion{%
    \RenewDocumentCommand\TEMat@copyright { } {#1}
  }{}
}

\ProvideDocumentCommand\TEMat@Acknowledgements { } {
  \tl_if_blank:oF {\g__TEMat_ack_tl} {
    \par
    \vspace{1em}
    \begingroup
    \small
    \centering%
    \parbox{0.85\textwidth}{
      \setlength{\parindent}{-1.75em}
      \setlength{\parskip}{0.5em plus 0.1em minus 0.1em}
      \textsf{\textbf{\TEMatString{Acknowledgements}:}}
      \hspace{0.7em plus 0.1em minus 0.2em}
      \setlength{\parindent}{0pt}\g__TEMat_ack_tl
    }
    \par
    \endgroup
  }
}

\ProvideDocumentCommand\TEMat@Dedication { } {
  \vspace{0.4cm plus 0.1cm minus 0.1cm}
  \bgroup
  \tl_if_blank:oF {\g__TEMat_dedication_tl} {
    \centering
    \emph{\g__TEMat_dedication_tl}
    \par
  }
  \egroup
  \vspace{0.6cm plus 0.1cm minus 0.1cm}
}

\providecommand*\TEMat@PDF@authors{
  \seq_use:Nn \g__TEMat_pdf_authors_seq { ,~ }
}

\DeclareDocumentCommand\title { o m } {
  \IfValueTF{#1}{
    \tl_gset:Nn \g__TEMat_short_title_tl {#1}
  }{
    \tl_gset:Nn \g__TEMat_short_title_tl {#2}
  }
  \tl_gset:Nn \g__TEMat_full_title_tl {#2}
  
}

\DeclareDocumentCommand\msc { m } {
  \clist_gset:Nn \g__TEMat_msc_clist { #1 }
}

\DeclareDocumentCommand\keywords { m } {
  \clist_gset:Nn \g__TEMat_kw_clist { #1 }
}

\DeclareDocumentCommand\authorgroup { m } {
  \bool_if:nF { \g__TEMat_flushed_author_bool } {
    \__TEMat_flush_last_author:
  }
  \seq_gput_right:Nn \g__TEMat_authorgroupname_seq { \tl_trim_spaces:n {#1} }
}

\DeclareDocumentCommand\author {
  s o
  > { \SplitArgument { 1 } { , } } m } {
  \bool_if:nF { \g__TEMat_flushed_author_bool }{
    \__TEMat_flush_last_author:
  }

  \bool_gset_false:N \g__TEMat_flushed_author_bool
  
  \IfBooleanT {#1} {
    \bool_gset_true:N \g__TEMat_curr_corresp_bool
  }

  \IfNoValueTF {#2} {
    \__TEMat_add_author:nn #3 
  }{
    \__TEMat_add_author:nnn #3 {#2}
  }
}

\DeclareDocumentCommand\email { m } {
  \__TEMat_email_command:n { #1 }
}

\DeclareDocumentCommand\affiliation { m } {
  \tl_gput_right:Nx \g__TEMat_curr_affiliation_tl { { \tl_trim_spaces:n {#1} } }
}

\DeclareDocumentCommand\authornotemark { m } {
  \tl_gput_right:Nx \g__TEMat_curr_authornotemark_tl { {#1} }
}

\DeclareDocumentCommand\authornote { m } {
  \seq_gput_right:Nn \g__TEMat_authornotes_seq { \tl_trim_spaces:n {#1} }
  \int_gset:Nn \g_tmpa_int { \seq_count:N \g__TEMat_authornotes_seq }
  \authornotemark{ \int_use:N \g_tmpa_int }
}

\DeclareDocumentCommand\acknowledgements { +m } {
  \tl_if_blank:nTF {#1} {
    \tl_gset:Nn \g__TEMat_ack_tl {}
  }{
    \tl_gset:Nn \g__TEMat_ack_tl { \tl_trim_spaces:n {#1} }
  }
}

\DeclareDocumentCommand\dedication { m } {
  \tl_if_blank:nTF {#1} {
    \tl_gset:Nn \g__TEMat_dedication_tl {}
  }{
    \tl_gset:Nn \g__TEMat_dedication_tl { \tl_trim_spaces:n {#1} }
  }
}

\DeclareDocumentCommand\shortauthors { m } {
  \bool_set_true:N \g__TEMat_custom_short_authors_bool
  \tl_gset:Nn \g__TEMat_short_authors_tl { \tl_trim_spaces:n {#1} }
}

\DeclareDocumentCommand\TEMat@generate@author@headers { } {
  \bool_if:NT \g__TEMat_anonymous_bool {
    \__TEMat_set_anonymous_data:
  }
  \__TEMat_flush_last_author:
  \bool_if:NF \g__TEMat_custom_short_authors_bool {
    \tl_gset:Nx \g__TEMat_short_authors_tl {
      \seq_use:Nn \g__TEMat_shortname_seq { ,~ }
    }
  }
}

\DeclareDocumentCommand\TEMat@restore@mail@command { } {
  \cs_gset:Npn \__TEMat_email_command:n ##1 {
    \href{mailto:##1}{\nolinkurl{##1}}
  }
}

\int_new:N \l__TEMat_curr_group_int
\bool_new:N \l__TEMat_printed_one_bool
\bool_set_false:N \l__TEMat_printed_one_bool

\tl_new:N \l__TEMat_baselinestretch_tl
\DeclareDocumentCommand\TEMat@process@author@list { } {
  \tl_set:Nn \l__TEMat_baselinestretch_tl { \baselinestretch }
  \def\baselinestretch{\tl_use:N \g__TEMat_authorlist_stretch_tl}\selectfont
  \int_set:Nn \l__TEMat_curr_group_int { 0 }
  \bool_until_do:nn { \seq_if_empty_p:N \g__TEMat_authorgroup_seq } {
    \seq_pop_left:NN \g__TEMat_authorgroup_seq \l_tmpa_tl
    \int_compare:nNnF {\l__TEMat_curr_group_int} = {\int_eval:n \l_tmpa_tl}{
      \int_set:Nn \l__TEMat_curr_group_int {\int_eval:n \l_tmpa_tl}
      \bool_if:NT \l__TEMat_printed_one_bool {
        \vskip 0.5em
      }
      \textbf{\textsf{\seq_item:Nn \g__TEMat_authorgroupname_seq {\l__TEMat_curr_group_int}}}\par
      \vskip -0.5em
    }
    \bool_set_true:N \l__TEMat_printed_one_bool
    \__TEMat_get_corresponding:
    \seq_pop_left:NN \g__TEMat_firstname_seq \l_tmpa_tl
    \seq_pop_left:NN \g__TEMat_lastname_seq \l_tmpb_tl
    \textsf{
      \textmd{
        \mbox{\l_tmpa_tl}~
        \mbox{\l_tmpb_tl}\__TEMat_get_authornote:
      }
    }
    \__TEMat_get_affiliation:
    \__TEMat_get_email:
    \par
  }
  \edef\baselinestretch{\tl_use:N \l__TEMat_baselinestretch_tl}\selectfont
}

\newcommand{\TEMat@select@language}[1]{\begingroup\edef\x{\endgroup%
\noexpand\selectlanguage{#1}}\x}

\DeclareDocumentCommand\TEMat@abstract { } {
  % \bool_until_do:nn { \seq_if_empty_p:N \g__TEMat_abstract_seq } {%
  %   \seq_pop_left:NN \g__TEMat_abstract_seq \l_tmpa_tl%
  %   \seq_pop_left:NN \g__TEMat_abstract_lang_seq \l_tmpb_tl%
  %   \bgroup\bgroup\TEMat@select@language{\tl_use:N \l_tmpb_tl}%
  %   \textsf{\textbf{\TEMatString{Abstract}:}}%
  %   \hspace{0.7em plus 0.1em minus 0.2em}%
  %   \l_tmpa_tl%
  %   \egroup\egroup\par%
  % }%
  % %
  \g__TEMat_abstract_tl
  \vspace{-1em}
}

\DeclareDocumentCommand\TEMat@authornotes { } {
  \vspace{0.7em}
  \int_set:Nn \l_tmpa_int { 1 }
  \bool_until_do:nn { \seq_if_empty_p:N \g__TEMat_authornotes_seq } {
    \seq_pop_left:NN \g__TEMat_authornotes_seq \l_tmpa_tl
    \tl_if_blank:oF {\l_tmpa_tl} {
      \footnotetext[\int_use:N \l_tmpa_int]{
        \Hy@raisedlink{\hypertarget{@@TEMat:AN:\int_use:N \l_tmpa_int}{}}
        \l_tmpa_tl
      }
      \int_incr:N \l_tmpa_int
    }
  }
}

% \DeclareRobustCommand{\TEMat@language}{\g__TEMat_babelmain_tl}

\RenewDocumentEnvironment{abstract}{ O{\g__TEMat_babelmain_tl} }
{
  \TEMat@add@abstract
}
{
  \endTEMat@add@abstract%
  %
  \tl_gput_right:Nn \g__TEMat_abstract_tl {
    \bgroup\bgroup%\setlength{\parskip}{0pt}
    \TEMat@select@language{#1}%
    \textsf{\textbf{\TEMatString{Abstract}:}}
    \hspace{0.7em plus 0.1em minus 0.2em}
  }
  \tl_gput_right:NV \g__TEMat_abstract_tl \g__TEMat_abstract_tmp_tl
  \tl_gput_right:Nn \g__TEMat_abstract_tl {
    \par\vspace{1em}\egroup\egroup
  }
}

\environbodyname\TEMat@env@body
\NewEnviron{TEMat@add@abstract}{%
  \tl_gset:NV \g__TEMat_abstract_tmp_tl \TEMat@env@body
}

\DeclareExpandableDocumentCommand { \printlengthas } { m m }
  { \dim_to_decimal_in_unit:nn {#1} { 1 #2 } #2 }

\ExplSyntaxOff
\setlength{\TEMat@footsep}{2\baselineskip}

\newlength\TEMatTitleSpace
\setlength{\TEMatTitleSpace}{4cm plus 1cm minus 1.5cm}

\DeclareDocumentCommand\maketitle { O{\TEMatString{TEMatAnd}} } {%
  \TEMat@generate@author@headers{}
  \newgeometry{
    inner=2.0cm,
    outer=2.0cm,
    top=3cm,
    bottom=3.2cm,
    footskip=1cm,
    footnotesep=0.7cm,
  }
  \thispagestyle{ANEM@portada}\TEMat@header{}\TEMat@extranote{}\bgroup
  ~
  \vspace{\TEMatTitleSpace}
\renewcommand*{\thefootnote}{\emph{\alph{footnote}}}%
\setcounter{footnote}{0}%
  
  \begingroup
  \centering%
  \parbox{0.9\textwidth}{\centering%
    \fontsize{20}{22}\selectfont%
    \sffamily\bfseries%
    \TEMatFullTitle
  }%
  \par
  \endgroup

  \TEMat@Dedication
  \vfill


\begin{minipage}[t]{0.32\textwidth}
    \begingroup
    \setlength{\parindent}{0pt}
    \setlength{\parskip}{1em}
    \begin{flushright}%
      \TEMat@process@author@list
    \end{flushright}
    \endgroup
  \end{minipage}\hspace{\fill}%
\begin{minipage}[t]{0.64\textwidth}
  \begingroup
  \setlength{\parindent}{0pt}
  \setlength{\parskip}{0.5em plus 0.1em minus 0.1em}
  \small%
  %\vspace{-\baselineskip}%
  \vspace{-2\parskip}%
  \TEMat@abstract%
  \begin{flushleft}
    \textsf{\textbf{\TEMatString{Keywords}:}}\hspace{0.7em plus 0.1em minus 0.2em}\TEMat@kw{}.
    \par
    \textsf{\textbf{MSC2020:}}\hspace{0.7em plus 0.1em minus 0.2em}\TEMat@msc{}.
    % \TEMat@NoDates{}{%
    %   \par
    %   \textsf{\textit{\TEMatString{Received}:}}\hspace{0.7em plus 0.1em minus 0.2em}\TEMat@received{}.
    %   \\
    %   \textsf{\textit{\TEMatString{Accepted}:}}\hspace{0.7em plus 0.1em minus 0.2em}\TEMat@accepted{}.}
  \end{flushleft}
  \endgroup
\end{minipage}
\hypersetup{%
  pdftitle={\protect\TEMatFullTitle},%
  pdfauthor={\protect\TEMat@PDF@authors},%
  pdfkeywords={\protect\TEMat@kw},%
  pdfsubject={(MSC 2010) \protect\TEMat@msc},%
  pdfinfo={%
  }%
}%
\TEMat@Acknowledgements{}%
\TEMat@AuthorVersion{}{\TEMat@reference{#1}}%
\TEMat@authornotes
  \egroup
  \clearpage
  \newgeometry{
    twoside,
    inner=2.7cm,
    outer=2.7cm,
    top=3.2cm,
    headsep=0.7cm,
    bottom=3.2cm,
    footskip=1cm,
    footnotesep=\TEMat@footsep
  }
\renewcommand*{\thefootnote}{\arabic{footnote}}
\setcounter{footnote}{0}%
\TEMat@restore@mail@command
}

\newenvironment{resumen}{\begin{abstract}}{\end{abstract}}
\let\agradecimientos\acknowledgements
\let\dedicatoria\dedication
\let\dedicatory\dedication

\AtBeginDocument{
  \newcommand*\diff{\mathop{}\!\mathrm{d}}
  \newcommand*\laplacian{\ensuremath{\upDelta}}
  \let\Laplacian\laplacian
  \let\transpose\top
}

\newcommand*\nume{\ensuremath{\mathrm{e}}}
\let\upe\nume
\newcommand*\iunit{\ensuremath{\mathrm{i}}}

\DeclarePairedDelimiter\abs{\lvert}{\rvert}%
\DeclarePairedDelimiter\norm{\lVert}{\rVert}%

\AtEndDocument{\clearpage\thispagestyle{empty}}

\AtBeginDocument{%
\setlength{\parindent}{0pt}%
\setlength{\parskip}{0.5em plus 0.2em minus 0.12em}%
}

%
%%%%%%%%%%%%%%% TRADUCCIONES ALGORITMOS
%
\AfterPackage{algpseudocode}{%
  \appto\captionsspanish{
  \algrenewcommand\algorithmicwhile{\textbf{\textsf{mientras}}}
  \algrenewcommand\algorithmicdo{\textbf{\textsf{hacer}}}
  \algrenewcommand\algorithmicif{\textbf{\textsf{si}}}
  \algrenewcommand\algorithmicelse{\textbf{\textsf{en caso contrario}}}
  \algrenewcommand\algorithmicthen{\textbf{\textsf{entonces}}}
  \algrenewcommand\algorithmicfor{\textbf{\textsf{para}}}
  \algrenewcommand\algorithmicforall{\textbf{\textsf{para cada}}}
  \algrenewcommand\algorithmicrepeat{\textbf{\textsf{repetir}}}
  \algrenewcommand\algorithmicuntil{\textbf{\textsf{hasta}}}
  \algrenewcommand\algorithmicprocedure{\textbf{\textsf{subrutina}}}
  \algrenewcommand\algorithmicfunction{\textbf{\textsf{función}}}
  \algrenewcommand\algorithmicloop{\textbf{\textsf{bucle}}}
  \algrenewcommand\algorithmicend{\textbf{\textsf{fin}}}
  \algrenewcommand\algorithmicrequire{\textbf{\textsf{Precondición}}}
  \algrenewcommand\algorithmicensure{\textbf{\textsf{Postcondición}}}
  }
  \algrenewtext{If}[1]{\algorithmicif\ #1, \algorithmicthen}
  \algrenewtext{ElsIf}[1]{\algorithmicelse, \algorithmicif\ #1, \algorithmicthen}
  \algrenewcommand{\algorithmiccomment}[1]{\hfill\(\vartriangleright\) #1}
}


% Antes de terminar con la interfaz pública de la clase, cargamos las
% herramientas internas de la revista, si es que existen.

\IfFileExists{TEMat-internals.sty}{\RequirePackage{TEMat-internals}}{}


%%% DEFAULT STRINGS

\TEMatDefault{Abstract}{\abstractname}
\TEMatDefault{TEMatAnd}{, y}
\TEMatDefault{TEMatIn}{En}
\TEMatDefault{TEMatPages}{págs.}
\TEMatDefault{Reference}{Referencia}
\TEMatDefault{Theorem}{Teorema}
\TEMatDefault{theorem}{teorema}
\TEMatDefault{Theorems}{Teoremas}
\TEMatDefault{theorems}{teoremas}
\TEMatDefault{Lemma}{Lema}
\TEMatDefault{lemma}{lema}
\TEMatDefault{Lemmas}{Lemas}
\TEMatDefault{lemmas}{lemas}
\TEMatDefault{Corollary}{Corolario}
\TEMatDefault{corollary}{corolario}
\TEMatDefault{Corollaries}{Corolarios}
\TEMatDefault{corollaries}{corolarios}
\TEMatDefault{Proposition}{Proposición}
\TEMatDefault{proposition}{proposición}
\TEMatDefault{Propositions}{Proposiciones}
\TEMatDefault{propositions}{proposiciones}
\TEMatDefault{Property}{Propiedad}
\TEMatDefault{property}{propiedad}
\TEMatDefault{Properties}{Propiedades}
\TEMatDefault{properties}{propiedades}
\TEMatDefault{Conjecture}{Conjetura}
\TEMatDefault{conjecture}{conjetura}
\TEMatDefault{Conjectures}{Conjeturas}
\TEMatDefault{conjectures}{conjeturas}
\TEMatDefault{Fact}{Hecho}
\TEMatDefault{fact}{hecho}
\TEMatDefault{Facts}{Hechos}
\TEMatDefault{facts}{hechos}
\TEMatDefault{Criterion}{Criterio}
\TEMatDefault{criterion}{criterio}
\TEMatDefault{Criteria}{Criterios}
\TEMatDefault{criteria}{criterios}
\TEMatDefault{Axiom}{Axioma}
\TEMatDefault{axiom}{axioma}
\TEMatDefault{Axioms}{Axiomas}
\TEMatDefault{axioms}{axiomas}
\TEMatDefault{Definition}{Definición}
\TEMatDefault{definition}{definición}
\TEMatDefault{Definitions}{Definiciones}
\TEMatDefault{definitions}{definiciones}
\TEMatDefault{Example}{Ejemplo}
\TEMatDefault{example}{ejemplo}
\TEMatDefault{Examples}{Ejemplos}
\TEMatDefault{examples}{ejemplos}
\TEMatDefault{Exercise}{Ejercicio}
\TEMatDefault{exercise}{ejercicio}
\TEMatDefault{Exercises}{Ejercicios}
\TEMatDefault{exercises}{ejercicios}
\TEMatDefault{Problem}{Problema}
\TEMatDefault{problem}{problema}
\TEMatDefault{Problems}{Problemas}
\TEMatDefault{problems}{problemas}
\TEMatDefault{Question}{Pregunta}
\TEMatDefault{question}{pregunta}
\TEMatDefault{Questions}{Preguntas}
\TEMatDefault{questions}{preguntas}
\TEMatDefault{Hypothesis}{Hipótesis}
\TEMatDefault{hypothesis}{hipótesis}
\TEMatDefault{Hypotheses}{Hipótesis}
\TEMatDefault{hypotheses}{hipótesis}
\TEMatDefault{Algorithm}{Algoritmo}
\TEMatDefault{algorithm}{algoritmo}
\TEMatDefault{Algorithms}{Algoritmos}
\TEMatDefault{algorithms}{algoritmos}
\TEMatDefault{Note}{Nota}
\TEMatDefault{note}{nota}
\TEMatDefault{Notes}{Notas}
\TEMatDefault{notes}{notas}
\TEMatDefault{Remark}{Observación}
\TEMatDefault{remark}{observación}
\TEMatDefault{Remarks}{Observaciones}
\TEMatDefault{remarks}{observaciones}
\TEMatDefault{Notation}{Notación}
\TEMatDefault{notation}{notacion}
\TEMatDefault{Notations}{Notaciones}
\TEMatDefault{notations}{notaciones}
\TEMatDefault{Convention}{Convención}
\TEMatDefault{convention}{convención}
\TEMatDefault{Conventions}{Convenciones}
\TEMatDefault{conventions}{convenciones}
\TEMatDefault{Claim}{Afirmación}
\TEMatDefault{claim}{afirmación}
\TEMatDefault{Claims}{Afirmaciones}
\TEMatDefault{claims}{afirmaciones}
\TEMatDefault{Case}{Caso}
\TEMatDefault{case}{caso}
\TEMatDefault{Cases}{Casos}
\TEMatDefault{cases}{casos}
\TEMatDefault{Proof}{Demostración}
\TEMatDefault{proof}{demostración}
\TEMatDefault{Proofs}{Demostraciones}
\TEMatDefault{proofs}{demostraciones}
\TEMatDefault{Solution}{Solución}
\TEMatDefault{solution}{solución}
\TEMatDefault{Solutions}{Soluciones}
\TEMatDefault{solutions}{soluciones}
%
\TEMatDefault{Acknowledgements}{Agradecimientos}
\TEMatDefault{Keywords}{Palabras clave}
\TEMatDefault{Received}{Recibido}
\TEMatDefault{Accepted}{Aceptado}
\TEMatDefault{anonymisedForReviews}{anonimizado para revisión}
\TEMatDefault{Document}{Documento}
\TEMatDefault{draft}{borrador}
\TEMatDefault{underReview}{en revisión}
\TEMatDefault{CCBY}{%
Este trabajo se distribuye bajo una licencia Creative Commons Reconocimiento 4.0 Internacional}

%%% SPANISH STRINGS

\TEMatTranslate{spanish}{Reference}{Referencia}
\TEMatTranslate{spanish}{TEMatAnd}{, y}
\TEMatTranslate{spanish}{TEMatIn}{En}
\TEMatTranslate{spanish}{TEMatPages}{págs.}
\TEMatTranslate{spanish}{Theorem}{Teorema}
\TEMatTranslate{spanish}{theorem}{teorema}
\TEMatTranslate{spanish}{Theorems}{Teoremas}
\TEMatTranslate{spanish}{theorems}{teoremas}
\TEMatTranslate{spanish}{Lemma}{Lema}
\TEMatTranslate{spanish}{lemma}{lema}
\TEMatTranslate{spanish}{Lemmas}{Lemas}
\TEMatTranslate{spanish}{lemmas}{lemas}
\TEMatTranslate{spanish}{Corollary}{Corolario}
\TEMatTranslate{spanish}{corollary}{corolario}
\TEMatTranslate{spanish}{Corollaries}{Corolarios}
\TEMatTranslate{spanish}{corollaries}{corolarios}
\TEMatTranslate{spanish}{Proposition}{Proposición}
\TEMatTranslate{spanish}{proposition}{proposición}
\TEMatTranslate{spanish}{Propositions}{Proposiciones}
\TEMatTranslate{spanish}{propositions}{proposiciones}
\TEMatTranslate{spanish}{Property}{Propiedad}
\TEMatTranslate{spanish}{property}{propiedad}
\TEMatTranslate{spanish}{Properties}{Propiedades}
\TEMatTranslate{spanish}{properties}{propiedades}
\TEMatTranslate{spanish}{Conjecture}{Conjetura}
\TEMatTranslate{spanish}{conjecture}{conjetura}
\TEMatTranslate{spanish}{Conjectures}{Conjeturas}
\TEMatTranslate{spanish}{conjectures}{conjeturas}
\TEMatTranslate{spanish}{Fact}{Hecho}
\TEMatTranslate{spanish}{fact}{hecho}
\TEMatTranslate{spanish}{Facts}{Hechos}
\TEMatTranslate{spanish}{facts}{hechos}
\TEMatTranslate{spanish}{Criterion}{Criterio}
\TEMatTranslate{spanish}{criterion}{criterio}
\TEMatTranslate{spanish}{Criteria}{Criterios}
\TEMatTranslate{spanish}{criteria}{criterios}
\TEMatTranslate{spanish}{Axiom}{Axioma}
\TEMatTranslate{spanish}{axiom}{axioma}
\TEMatTranslate{spanish}{Axioms}{Axiomas}
\TEMatTranslate{spanish}{axioms}{axiomas}
\TEMatTranslate{spanish}{Definition}{Definición}
\TEMatTranslate{spanish}{definition}{definición}
\TEMatTranslate{spanish}{Definitions}{Definiciones}
\TEMatTranslate{spanish}{definitions}{definiciones}
\TEMatTranslate{spanish}{Example}{Ejemplo}
\TEMatTranslate{spanish}{example}{ejemplo}
\TEMatTranslate{spanish}{Examples}{Ejemplos}
\TEMatTranslate{spanish}{examples}{ejemplos}
\TEMatTranslate{spanish}{Exercise}{Ejercicio}
\TEMatTranslate{spanish}{exercise}{ejercicio}
\TEMatTranslate{spanish}{Exercises}{Ejercicios}
\TEMatTranslate{spanish}{exercises}{ejercicios}
\TEMatTranslate{spanish}{Problem}{Problema}
\TEMatTranslate{spanish}{problem}{problema}
\TEMatTranslate{spanish}{Problems}{Problemas}
\TEMatTranslate{spanish}{problems}{problemas}
\TEMatTranslate{spanish}{Question}{Pregunta}
\TEMatTranslate{spanish}{question}{pregunta}
\TEMatTranslate{spanish}{Questions}{Preguntas}
\TEMatTranslate{spanish}{questions}{preguntas}
\TEMatTranslate{spanish}{Hypothesis}{Hipótesis}
\TEMatTranslate{spanish}{hypothesis}{hipótesis}
\TEMatTranslate{spanish}{Hypotheses}{Hipótesis}
\TEMatTranslate{spanish}{hypotheses}{hipótesis}
\TEMatTranslate{spanish}{Algorithm}{Algoritmo}
\TEMatTranslate{spanish}{algorithm}{algoritmo}
\TEMatTranslate{spanish}{Algorithms}{Algoritmos}
\TEMatTranslate{spanish}{algorithms}{algoritmos}
\TEMatTranslate{spanish}{Note}{Nota}
\TEMatTranslate{spanish}{note}{nota}
\TEMatTranslate{spanish}{Notes}{Notas}
\TEMatTranslate{spanish}{notes}{notas}
\TEMatTranslate{spanish}{Remark}{Observación}
\TEMatTranslate{spanish}{remark}{observación}
\TEMatTranslate{spanish}{Remarks}{Observaciones}
\TEMatTranslate{spanish}{remarks}{observaciones}
\TEMatTranslate{spanish}{Notation}{Notación}
\TEMatTranslate{spanish}{notation}{notacion}
\TEMatTranslate{spanish}{Notations}{Notaciones}
\TEMatTranslate{spanish}{notations}{notaciones}
\TEMatTranslate{spanish}{Convention}{Convención}
\TEMatTranslate{spanish}{convention}{convención}
\TEMatTranslate{spanish}{Conventions}{Convenciones}
\TEMatTranslate{spanish}{conventions}{convenciones}
\TEMatTranslate{spanish}{Claim}{Afirmación}
\TEMatTranslate{spanish}{claim}{afirmación}
\TEMatTranslate{spanish}{Claims}{Afirmaciones}
\TEMatTranslate{spanish}{claims}{afirmaciones}
\TEMatTranslate{spanish}{Case}{Caso}
\TEMatTranslate{spanish}{case}{caso}
\TEMatTranslate{spanish}{Cases}{Casos}
\TEMatTranslate{spanish}{cases}{casos}
\TEMatTranslate{spanish}{Proof}{Demostración}
\TEMatTranslate{spanish}{proof}{demostración}
\TEMatTranslate{spanish}{Proofs}{Demostraciones}
\TEMatTranslate{spanish}{proofs}{demostraciones}
\TEMatTranslate{spanish}{Solution}{Solución}
\TEMatTranslate{spanish}{solution}{solución}
\TEMatTranslate{spanish}{Solutions}{Soluciones}
\TEMatTranslate{spanish}{solutions}{soluciones}
%
\TEMatTranslate{spanish}{Acknowledgements}{Agradecimientos}
\TEMatTranslate{spanish}{Keywords}{Palabras clave}
\TEMatTranslate{spanish}{Received}{Recibido}
\TEMatTranslate{spanish}{Accepted}{Aceptado}
\TEMatTranslate{spanish}{anonymisedForReviews}{anonimizado para revisión}
\TEMatTranslate{spanish}{Document}{Documento}
\TEMatTranslate{spanish}{draft}{borrador}
\TEMatTranslate{spanish}{underReview}{en revisión}
%
\TEMatTranslate{spanish}{CCBY}{%
Este trabajo se distribuye bajo una licencia Creative Commons Reconocimiento 4.0 Internacional}
%
%
%
%%%%%%% ENGLISH STRINGS
\TEMatTranslate{english}{Reference}{Reference}
\TEMatTranslate{english}{TEMatAnd}{, and}
\TEMatTranslate{english}{TEMatIn}{In}
\TEMatTranslate{english}{TEMatPages}{pp.}
\TEMatTranslate{english}{Theorem}{Theorem}
\TEMatTranslate{english}{theorem}{theorem}
\TEMatTranslate{english}{Theorems}{Theorems}
\TEMatTranslate{english}{theorems}{theorems}
\TEMatTranslate{english}{Lemma}{Lemma}
\TEMatTranslate{english}{lemma}{lemma}
\TEMatTranslate{english}{Lemmas}{Lemmas}
\TEMatTranslate{english}{lemmas}{lemmas}
\TEMatTranslate{english}{Corollary}{Corollary}
\TEMatTranslate{english}{corollary}{corollary}
\TEMatTranslate{english}{Corollaries}{Corollaries}
\TEMatTranslate{english}{corollaries}{corollaries}
\TEMatTranslate{english}{Proposition}{Proposition}
\TEMatTranslate{english}{proposition}{proposition}
\TEMatTranslate{english}{Propositions}{Propositions}
\TEMatTranslate{english}{propositions}{propositions}
\TEMatTranslate{english}{Property}{Property}
\TEMatTranslate{english}{property}{property}
\TEMatTranslate{english}{Properties}{Properties}
\TEMatTranslate{english}{properties}{properties}
\TEMatTranslate{english}{Conjecture}{Conjecture}
\TEMatTranslate{english}{conjecture}{conjecture}
\TEMatTranslate{english}{Conjectures}{Conjectures}
\TEMatTranslate{english}{conjectures}{conjectures}
\TEMatTranslate{english}{Fact}{Fact}
\TEMatTranslate{english}{fact}{fact}
\TEMatTranslate{english}{Facts}{Facts}
\TEMatTranslate{english}{facts}{facts}
\TEMatTranslate{english}{Criterion}{Criterion}
\TEMatTranslate{english}{criterion}{criterion}
\TEMatTranslate{english}{Criteria}{Criteria}
\TEMatTranslate{english}{criteria}{criteria}
\TEMatTranslate{english}{Axiom}{Axiom}
\TEMatTranslate{english}{axiom}{axiom}
\TEMatTranslate{english}{Axioms}{Axioms}
\TEMatTranslate{english}{axioms}{axioms}
\TEMatTranslate{english}{Definition}{Definition}
\TEMatTranslate{english}{definition}{definition}
\TEMatTranslate{english}{Definitions}{Definitions}
\TEMatTranslate{english}{definitions}{definitions}
\TEMatTranslate{english}{Example}{Example}
\TEMatTranslate{english}{example}{example}
\TEMatTranslate{english}{Examples}{Examples}
\TEMatTranslate{english}{examples}{examples}
\TEMatTranslate{english}{Exercise}{Exercise}
\TEMatTranslate{english}{exercise}{exercise}
\TEMatTranslate{english}{Exercises}{Exercises}
\TEMatTranslate{english}{exercises}{exercises}
\TEMatTranslate{english}{Problem}{Problem}
\TEMatTranslate{english}{problem}{problem}
\TEMatTranslate{english}{Problems}{Problems}
\TEMatTranslate{english}{problems}{problems}
\TEMatTranslate{english}{Question}{Question}
\TEMatTranslate{english}{question}{question}
\TEMatTranslate{english}{Questions}{Questions}
\TEMatTranslate{english}{questions}{questions}
\TEMatTranslate{english}{Hypothesis}{Hypothesis}
\TEMatTranslate{english}{hypothesis}{hypothesis}
\TEMatTranslate{english}{Hypotheses}{Hypotheses}
\TEMatTranslate{english}{hypotheses}{hypotheses}
\TEMatTranslate{english}{Algorithm}{Algorithm}
\TEMatTranslate{english}{algorithm}{algorithm}
\TEMatTranslate{english}{Algorithms}{Algorithms}
\TEMatTranslate{english}{algorithms}{algorithms}
\TEMatTranslate{english}{Note}{Note}
\TEMatTranslate{english}{note}{note}
\TEMatTranslate{english}{Notes}{Notes}
\TEMatTranslate{english}{notes}{notes}
\TEMatTranslate{english}{Remark}{Remark}
\TEMatTranslate{english}{remark}{remark}
\TEMatTranslate{english}{Remarks}{Remarks}
\TEMatTranslate{english}{remarks}{remarks}
\TEMatTranslate{english}{Notation}{Notation}
\TEMatTranslate{english}{notation}{notation}
\TEMatTranslate{english}{Notations}{Notations}
\TEMatTranslate{english}{notations}{notations}
\TEMatTranslate{english}{Convention}{Convention}
\TEMatTranslate{english}{convention}{convention}
\TEMatTranslate{english}{Conventions}{Conventions}
\TEMatTranslate{english}{conventions}{conventions}
\TEMatTranslate{english}{Claim}{Claim}
\TEMatTranslate{english}{claim}{claim}
\TEMatTranslate{english}{Claims}{Claims}
\TEMatTranslate{english}{claims}{claims}
\TEMatTranslate{english}{Case}{Case}
\TEMatTranslate{english}{case}{case}
\TEMatTranslate{english}{Cases}{Cases}
\TEMatTranslate{english}{cases}{cases}
\TEMatTranslate{english}{Proof}{Proof}
\TEMatTranslate{english}{proof}{proof}
\TEMatTranslate{english}{Proofs}{Proofs}
\TEMatTranslate{english}{proofs}{proofs}
\TEMatTranslate{english}{Solution}{Solution}
\TEMatTranslate{english}{solution}{solution}
\TEMatTranslate{english}{Solutions}{Solutions}
\TEMatTranslate{english}{solutions}{solutions}
%
\TEMatTranslate{english}{Acknowledgements}{Acknowledgements}
\TEMatTranslate{english}{Keywords}{Keywords}
\TEMatTranslate{english}{Received}{Received}
\TEMatTranslate{english}{Accepted}{Accepted}
\TEMatTranslate{english}{anonymisedForReviews}{anonymised for reviews}
\TEMatTranslate{english}{Document}{Document}
\TEMatTranslate{english}{draft}{draft}
\TEMatTranslate{english}{underReview}{under review}
%
\TEMatTranslate{english}{CCBY}{%
This work is distributed under a Creative Commons Attribution 4.0 International licence}

%%%%%%% BRITISH STRINGS
\TEMatTranslate{british}{Reference}{Referenece}
\TEMatTranslate{british}{TEMatAnd}{, and}
\TEMatTranslate{british}{TEMatIn}{In}
\TEMatTranslate{british}{TEMatPages}{pp.}
\TEMatTranslate{british}{Theorem}{Theorem}
\TEMatTranslate{british}{theorem}{theorem}
\TEMatTranslate{british}{Theorems}{Theorems}
\TEMatTranslate{british}{theorems}{theorems}
\TEMatTranslate{british}{Lemma}{Lemma}
\TEMatTranslate{british}{lemma}{lemma}
\TEMatTranslate{british}{Lemmas}{Lemmas}
\TEMatTranslate{british}{lemmas}{lemmas}
\TEMatTranslate{british}{Corollary}{Corollary}
\TEMatTranslate{british}{corollary}{corollary}
\TEMatTranslate{british}{Corollaries}{Corollaries}
\TEMatTranslate{british}{corollaries}{corollaries}
\TEMatTranslate{british}{Proposition}{Proposition}
\TEMatTranslate{british}{proposition}{proposition}
\TEMatTranslate{british}{Propositions}{Propositions}
\TEMatTranslate{british}{propositions}{propositions}
\TEMatTranslate{british}{Property}{Property}
\TEMatTranslate{british}{property}{property}
\TEMatTranslate{british}{Properties}{Properties}
\TEMatTranslate{british}{properties}{properties}
\TEMatTranslate{british}{Conjecture}{Conjecture}
\TEMatTranslate{british}{conjecture}{conjecture}
\TEMatTranslate{british}{Conjectures}{Conjectures}
\TEMatTranslate{british}{conjectures}{conjectures}
\TEMatTranslate{british}{Fact}{Fact}
\TEMatTranslate{british}{fact}{fact}
\TEMatTranslate{british}{Facts}{Facts}
\TEMatTranslate{british}{facts}{facts}
\TEMatTranslate{british}{Criterion}{Criterion}
\TEMatTranslate{british}{criterion}{criterion}
\TEMatTranslate{british}{Criteria}{Criteria}
\TEMatTranslate{british}{criteria}{criteria}
\TEMatTranslate{british}{Axiom}{Axiom}
\TEMatTranslate{british}{axiom}{axiom}
\TEMatTranslate{british}{Axioms}{Axioms}
\TEMatTranslate{british}{axioms}{axioms}
\TEMatTranslate{british}{Definition}{Definition}
\TEMatTranslate{british}{definition}{definition}
\TEMatTranslate{british}{Definitions}{Definitions}
\TEMatTranslate{british}{definitions}{definitions}
\TEMatTranslate{british}{Example}{Example}
\TEMatTranslate{british}{example}{example}
\TEMatTranslate{british}{Examples}{Examples}
\TEMatTranslate{british}{examples}{examples}
\TEMatTranslate{british}{Exercise}{Exercise}
\TEMatTranslate{british}{exercise}{exercise}
\TEMatTranslate{british}{Exercises}{Exercises}
\TEMatTranslate{british}{exercises}{exercises}
\TEMatTranslate{british}{Problem}{Problem}
\TEMatTranslate{british}{problem}{problem}
\TEMatTranslate{british}{Problems}{Problems}
\TEMatTranslate{british}{problems}{problems}
\TEMatTranslate{british}{Question}{Question}
\TEMatTranslate{british}{question}{question}
\TEMatTranslate{british}{Questions}{Questions}
\TEMatTranslate{british}{questions}{questions}
\TEMatTranslate{british}{Hypothesis}{Hypothesis}
\TEMatTranslate{british}{hypothesis}{hypothesis}
\TEMatTranslate{british}{Hypotheses}{Hypotheses}
\TEMatTranslate{british}{hypotheses}{hypotheses}
\TEMatTranslate{british}{Algorithm}{Algorithm}
\TEMatTranslate{british}{algorithm}{algorithm}
\TEMatTranslate{british}{Algorithms}{Algorithms}
\TEMatTranslate{british}{algorithms}{algorithms}
\TEMatTranslate{british}{Note}{Note}
\TEMatTranslate{british}{note}{note}
\TEMatTranslate{british}{Notes}{Notes}
\TEMatTranslate{british}{notes}{notes}
\TEMatTranslate{british}{Remark}{Remark}
\TEMatTranslate{british}{remark}{remark}
\TEMatTranslate{british}{Remarks}{Remarks}
\TEMatTranslate{british}{remarks}{remarks}
\TEMatTranslate{british}{Notation}{Notation}
\TEMatTranslate{british}{notation}{notation}
\TEMatTranslate{british}{Notations}{Notations}
\TEMatTranslate{british}{notations}{notations}
\TEMatTranslate{british}{Convention}{Convention}
\TEMatTranslate{british}{convention}{convention}
\TEMatTranslate{british}{Conventions}{Conventions}
\TEMatTranslate{british}{conventions}{conventions}
\TEMatTranslate{british}{Claim}{Claim}
\TEMatTranslate{british}{claim}{claim}
\TEMatTranslate{british}{Claims}{Claims}
\TEMatTranslate{british}{claims}{claims}
\TEMatTranslate{british}{Case}{Case}
\TEMatTranslate{british}{case}{case}
\TEMatTranslate{british}{Cases}{Cases}
\TEMatTranslate{british}{cases}{cases}
\TEMatTranslate{british}{Proof}{Proof}
\TEMatTranslate{british}{proof}{proof}
\TEMatTranslate{british}{Proofs}{Proofs}
\TEMatTranslate{british}{proofs}{proofs}
\TEMatTranslate{british}{Solution}{Solution}
\TEMatTranslate{british}{solution}{solution}
\TEMatTranslate{british}{Solutions}{Solutions}
\TEMatTranslate{british}{solutions}{solutions}
%
\TEMatTranslate{british}{Acknowledgements}{Acknowledgements}
\TEMatTranslate{british}{Keywords}{Keywords}
\TEMatTranslate{british}{Received}{Received}
\TEMatTranslate{british}{Accepted}{Accepted}
\TEMatTranslate{british}{anonymisedForReviews}{anonymised for reviews}
\TEMatTranslate{british}{Document}{Document}
\TEMatTranslate{british}{draft}{draft}
\TEMatTranslate{british}{underReview}{under review}
%
\TEMatTranslate{british}{CCBY}{%
This work is distributed under a Creative Commons Attribution 4.0 International licence}