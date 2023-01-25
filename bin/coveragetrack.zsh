#! /bin/zsh

# Generate a 6-month docreport of docstring coverage percentage over time.
# Then run this weekly!
#
# NOTE: This is not a robust script. You may want to hand-edit it before running.

docreport=docs/reports/doccov.tsv
nsdocreport=docs/reports/nsdoccov.tsv
fixmereport=docs/reports/fixme.tsv

# Kondo has a linter that can be exclusively enabled to docreport on missing docstrings
doccnt() {
    clj-kondo --lint ./src/clj \
              --config '^:replace {:linters {:missing-docstring {:level :warning}}}' |
        wc -l
}

# Generate a single line of current chechout's coverage
gendoccovrow() {
    dt=$1
    tot=$(grep '^(defn' src/clj/**/*.clj | wc -l)
    missing=$(doccnt)
    covpct=$(( (tot - missing) / ${tot}. ))
    print "$dt\t$missing\t$tot\t$covpct" >>$docreport
    print "Generated new row in $docreport"
}

# Generate a single entry for FIXMEs, TODOs, etc (thx for the idea, Michael!)
genfixmerow() {
    dt=$1
    # local todo=$(grep -E '\b(TODO|FIXME|HACK|XXX)\b' src/clj/**/*.clj | wc -l)
    local fixme=$(grep -E '\bFIXME\b' src/clj/**/*.clj | wc -l)
    local todo=$(grep -E '\bTODO\b' src/clj/**/*.clj | wc -l)
    local hack=$(grep -E '\bHACK\b' src/clj/**/*.clj | wc -l)
    local xxx=$(grep -E '\bXXX\b' src/clj/**/*.clj | wc -l)
    print "$dt\t$todo\t$fixme\t$hack\t$xxx" >>$fixmereport
    print "Generated new row in $fixmereport"
}

## NS docstrings: long, short, missing
gennsdocstringrow() {
    integer total_with_docs=$(grep -Pzo '\(ns .*\n +".*' src/clj/**/*.clj | wc -l) # total with docstrings (224)
    integer total_nss=$(print -l src/clj/**/*.clj | wc -l) # total NSs (851)
    integer short_docs=$(grep -Pzo '\(ns .*\n +".*' src/clj/**/*.clj | grep -Ea '".*"' | wc -l) # simplistic one-line docstrings (84)
    integer missing_docs=$(( total_nss - total_with_docs ))
    integer long_docs=$(( total_with_docs - short_docs ))
    print "$dt\t$short_docs\t$long_docs\t$missing_docs\t$total_nss" >>$nsdocreport
}

# Generate a 6-mo historical TSV by checkout-ing a bunch in a loop
genhistory() {
    # print "WEEK\tMISSING\tTOTAL\tCOVERAGEPCT" >$docreport
    # print "WEEK\tFIXME\tTODO\tHACK\tXXX" >$fixmereport
    # print "WEEK\tSHORT\tLONG\tMISSING\tTOTAL" >>$nsdocreport
    for w in {1..23}; do
        local dt=$(date -I -d "+ $((7 * $w - 165)) days")
        git checkout $(git rev-list -n 1 --before="$dt 13:37" master)
        # Uncomment the one you want to activate
        # gendoccovrow $dt
        # genfixmerow $dt
        gennsdocstringrow $dt
    done
}

# Capture: deprecations, bubble, keybank

# Generate a new row for each report
oneweek() {
    gendoccovrow $(date -I)
    genfixmerow  $(date -I)
    gennsdocstringrow $(date -I)
    print "You may want to create/merge a PR for the new rows you generated."
}
# Default: generate just a single new line appended to docreport
# oneweek

# One time: generate original reports
genhistory
