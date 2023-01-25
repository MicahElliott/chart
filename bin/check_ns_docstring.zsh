#! /bin/zsh

# Reject NSs touched that have missing docstring

echo "Checking for missing NS docstrings"

cljfiles=$(git diff --name-only origin/master | grep '\.clj$')
if (( $#cljfiles == 0 )); then echo "No clj files in this PR\nOK"; exit; fi

# Find files with occurrence of `ns` followed by immediately (next line) by `(:require`
culprits=$(grep -Plzo '\(ns [a-z].*\n +\(:require' $(git diff --name-only origin/master | grep '\.clj$') )
# print "count" ${#culprits}

if (( $#culprits > 0 )) ; then
    echo "ERROR: You touched file(s) that are missing a namespace-level docstring."
    echo "\nCULPRITS:\n$culprits"
    echo "\nYou presumably know enough about this NS to change it, so please add a docstring while you're at it."
    echo "If you are not confident in writing a paragraph about its purpose, please consult someone from its git-history and ask them to send you a blurb."
    echo "Or, mark this NS as ^:deprecated"
else
    echo "OK"
fi
