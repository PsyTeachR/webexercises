%% amsmath commands supported since 4.2.2 (PDF), 4.2.0 (HTML)
%% unfortunately commands in #1 really do need 8 escapes ...

\newcommand{\Seqn}{\ifelse{latex}{\Sexpr[results=rd]{if (getRversion() >= "4.2.2") "\\\\\\\\eqn{#1}" else "\\\\\\\\verb{#2}"}}{\ifelse{html}{\Sexpr[results=rd]{if (getRversion() >= "4.2.0") "\\\\\\\\eqn{#1}" else "\\\\\\\\verb{#2}"}}{\Sexpr[results=rd]{"\\\\\\\\eqn{#2}"}}}}

\newcommand{\Sdeqn}{\ifelse{latex}{\Sexpr[results=rd]{if (getRversion() >= "4.2.2") "\\\\\\\\deqn{#1}" else "\\\\\\\\preformatted{#2}"}}{\ifelse{html}{\Sexpr[results=rd]{if (getRversion() >= "4.2.0") "\\\\\\\\deqn{#1}" else "\\\\\\\\preformatted{#2}"}}{\Sexpr[results=rd]{"\\\\\\\\deqn{#2}"}}}}
