% insert reference #1 - key, #2 - package
%% changing to cache bib as insertCite does
\newcommand{\insertRef}{\Sexpr[results=rd,stage=build]{Rdpack::insert_ref(key="#1",package="#2")}}
%\newcommand{\insertRef}{\Sexpr[results=rd,stage=install]{if(!exists(".Rdpack.currefs")) .Rdpack.currefs <- new.env(); Rdpack::insert_ref(key="#1",package="#2", cached_env=.Rdpack.currefs)}}

% insert reference #1 - keys, #2 - package
\newcommand{\insertCiteOnly}{\Sexpr[results=rd,stage=build]{if(!exists(".Rdpack.currefs")) .Rdpack.currefs <- new.env();Rdpack::insert_citeOnly(keys="#1",package="#2", cached_env=.Rdpack.currefs,cite_only=TRUE)}}
\newcommand{\insertCite}{\Sexpr[results=rd,stage=build]{if(!exists(".Rdpack.currefs")) .Rdpack.currefs <- new.env();Rdpack::insert_citeOnly(keys="#1",package="#2", cached_env=.Rdpack.currefs)}}
\newcommand{\insertNoCite}{\Sexpr[results=hide,stage=build]{if(!exists(".Rdpack.currefs")) .Rdpack.currefs <- new.env();Rdpack::insert_citeOnly(keys="#1",package="#2", cached_env=.Rdpack.currefs,dont_cite=TRUE)}}

\newcommand{\insertAllCited}{\Sexpr[results=rd,stage=build]{if(!exists(".Rdpack.currefs")) .Rdpack.currefs <- new.env();Rdpack::insert_all_ref(.Rdpack.currefs)}}

\newcommand{\insertCited}{\Sexpr[results=rd,stage=build]{if(!exists(".Rdpack.currefs")) .Rdpack.currefs <- new.env();Rdpack::insert_all_ref(.Rdpack.currefs, empty_cited = TRUE)}}

% insert reference #1 - key, #2 - package
%\newcommand{\runExamples}{\Sexpr[results=rd,stage=build]{deparse({#1})}}
\newcommand{\runExamples}{\Sexpr[results=rd,stage=build]{Rdpack:::run_examples(quote({#1}))}}
%\newcommand{\printExample}{\Sexpr[results=rd,stage=build]{Rdpack:::run_examples(quote({#1}), Rdsection = "\\\\\\\\preformatted")}}

\newcommand{\printExample}{\Sexpr[results=rd,stage=build]{.Rdpack.e <- environment();Rdpack:::run_examples(quote({#1}), local = .Rdpack.e, Rdsection = "preformatted")}}
%\newcommand{\printExample}{\Sexpr[results=rd,stage=build]{Rdpack:::run_examples(quote({#1}), local = parent.frame(), Rdsection = "preformatted")}}

% insert reference #1 - filename, #2 - package
\newcommand{\insertFig}{\Sexpr[results=rd,stage=build]{Rdpack:::insert_fig("#1","#2", { #3 })}}
\newcommand{\makeFig}{\Sexpr[results=hide,stage=build]{Rdpack:::insert_fig("#1","#2", { #3 }, insert=FALSE)}}
