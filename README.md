# Code Health And Report Tooling (CHART)

_How smmelly is your code base?_

This project is a set of recipes for tracking the health of your code base
(geared presently for Clojure but suited for any) in the form of a graph-rich
report. In comparison, some tools (eg, codecov) already exist to aid with
seeing your progress over time in a small specific area (test coverage). But
CHART is a collection of various metrics worth tracking with a more flexible
DIY approach. The Smellables (trackable code smell indicators) are up to you,
but likely candidates include:

- docstring coverage
- unit test coverage
- FIXME/TODO/etc occurrences
- deprecations
- namespace dependency depth/magnitude
- function purity/testability
- naming consistency (aliases, etc)

Each of those becomes a section in ...

## The Report

You'll want to have an actionable, updating report that illuminates the weak
spots in your code base. See the [example report](./code-health.png) for a
model to emulate. The Report can be shared with your team on a weekly basis to
celebrate your progress (or highlight a problem), now that you've identified
your areas for improvement.

With the report in place, you're ready to explain your situation to the
stakeholders:

- Fellow devs: can start taking pride in fixing and creating healthy code
- Product: will realize the need to allot time for tech-debt
- Dev manager: will find peace of mind in seeing quality improve
- CTO: can explain to company/customers that quality is quantified/prioritized

## The Goal

**The _Goal_ is to reduce the report down to nothing.**

You'll notice that the example report does not have a _Linting_ section.
That's because the team has already completed their goal for a violation
target. Linting is a nice one to get to zero so that a zero-lint policy can be
enforced through CI.

## What you do

It is assumed that your code is managed by `git`. This is necessary to be able
to do historic checkouts to establish a base of metrics.

1. So you start by creating your own reeport template with some things you
   want to try tracking. You could just use
   [clj-kondo in "missing-docstring" mode](https://github.com/clj-kondo/clj-kondo/blob/master/doc/config.md#enable-optional-linters)
   as a starting point to see that your code documentation is severely
   lacking.

1. Then, one-time, run the scripts in "init" mode.

1. On a weekly basis, you manually run the scripts to generate a new
   weekly row in each of the TSVs. Or you could make this part of a weekly CI
   flow.

1. Present the report to your dev team to discuss what the priorities are for
   addressing the exposed shortcomings

1. Present those priorities to your Product team to justify that there is
   important tech-debt to be considered in order to keep new features rolling
   out the door!

## Creating a Smellable recipe

Some Smellables are generated from sophisticated tools (eg, cloverage,
clj-kondo). For these, you need to tell them what indicators you want to see
(or use their defaults), gather their outputs, and aggregate the output into
single numbers. Other Smellables are ad hoc, and often a matter of grepping
and counting.

Say you want to track the number of `FIXME` and `TODO` comments. Then you just
do a `grep 'FIXME|TODO' src/some_area_of_interest | wc -l` for the code you
wish to track. There is a working example included (as shown here is too
simplistic).

Each smellable is its own TSV file. Each indicator should be printed as a row
like:

    echo "FIXME\tTODO"
    ...
    echo "$nfixmes\t$ntodos"

Then you'll want a simple gnuplot description of the graph you want to plot.
Again, examples are included. A graph will end up looking something like:

![FIXMEs](example/fixmes.png)

## How it works over time

To create the initial data, code is checked out at several points in time
historically. For each checkout, analyses are run. Those analyses are
presently some widely used tools like clj-kondo, plus ad hoc greps, etc.

Then each week someone (or CI) created a new row in each TSV, and the gnuplots
are re-run.

As of right now, the script(s) are not robust or flexible. I just hand-edit
sections and run till all the functions I care about are called.
