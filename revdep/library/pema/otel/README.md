
<!-- README.md is generated from README.Rmd. Please edit that file -->

# otel

> OpenTelemetry API for R packages and projects

<!-- badges: start -->

![lifecycle](https://lifecycle.r-lib.org/articles/figures/lifecycle-experimental.svg)
[![R-CMD-check](https://github.com/r-lib/otel/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/r-lib/otel/actions/workflows/R-CMD-check.yaml)
[![R-CMD-check](https://github.com/r-lib/otel/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/r-lib/otel/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/r-lib/otel/graph/badge.svg)](https://app.codecov.io/gh/r-lib/otel)
<!-- badges: end -->

OpenTelemetry is an observability framework.
[OpenTelemetry](https://opentelemetry.io/) is a collection of tools,
APIs, and SDKs used to instrument, generate, collect, and export
telemetry data such as metrics, logs, and traces, for analysis in order
to understand your software’s performance and behavior.

For an introduction to OpenTelemetry, see the [OpenTelemetry website
docs](https://opentelemetry.io/docs/).

To learn how to instrument your R code, see [Getting
Started](https://otel.r-lib.org/reference/gettingstarted.html). For
project status, installation instructions and more, read on.

## Features

- Lightweight packages. otel is a small R package without dependencies
  and compiled code. otelsdk needs a C++11 compiler and otel.
- Minimal performance impact when tracing is disabled. otel functions do
  not evaluate their arguments in this case.
- Zero-code instrumentation support. Add tracing to (some) functions of
  selected packages automatically.
- Configuration via environment variables.
- Minimal extra code. Add tracing to a function with a single extra
  function call.
- Production mode: otel functions do not crash your production app in
  production mode.
- Development mode: otel functions error early in development mode.

## Getting started

Set `otel_tracer_name` to the desired tracer name. (See
`?otel_tracer_name`.) Then add `otel::start_local_active_span()` calls
to the functions you want to trace:

``` r
otel_tracer_name <- "<package-id>"
fn <- function(...) {
  spn <- otel::start_local_active_span("fn")
  ...
}
```

See [Getting
Started](https://otel.r-lib.org/reference/gettingstarted.html) for
details.

## The otel and otelsdk R packages

Use the [otel](https://github.com/r-lib/otel) package as a dependency if
you want to instrument your R package or project for OpenTelemetry.

Use the [otelsdk](https://github.com/r-lib/otelsdk) package to produce
OpenTelemetry output from an R package or project that was instrumented
with the otel package.

## Reference Documentation

- otel: <https://otel.r-lib.org/reference/>
- otelsdk: <https://otelsdk.r-lib.org/reference/>

## Status

The current status of the major functional components for OpenTelemetry
R is as follows:

| *Traces*                                                                                      | *Metrics*                                                                                     | *Logs*                                                                                        |
|-----------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------|
| [Development](https://opentelemetry.io/docs/specs/otel/versioning-and-stability/#development) | [Development](https://opentelemetry.io/docs/specs/otel/versioning-and-stability/#development) | [Development](https://opentelemetry.io/docs/specs/otel/versioning-and-stability/#development) |

## Version support

otel and otelsdk support R 3.6.0 and higher on Unix and R 4.3.0 or
higher on Windows.

## Installation

Install otel from CRAN:

``` r
# install.packages("pak")
pak::pak("otel")
```

You can install the development version of otel from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("r-lib/otel")
```

## Repositories

- otel: <https://github.com/r-lib/otel>
- otelsdk: <https://github.com/r-lib/otelsdk>

## License

MIT © Posit, PBC
