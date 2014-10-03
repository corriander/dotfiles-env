#!/bin/sed -f
# Properly align output of dict -d wn word (dictionary: `dict-wn`)
#
# Indentation of WordNet 3.0 is screwed up, and fixing the dictionary
# itself is a task I'd rather not get into. So here is a quick filter
# to adjust the indentation.

# Lines are of one of the following forms:
#
# ..word[.word]*
# ......[(adv|adj|v|n) ][0-9]\+: definition
# ......\s\+continued definition

# Match 1st sense for adjective/adverb class and remove 1 space
s/^ \(\s\+ad[v|j] 1:\)/\1/

# Match 1st sense for noun/verb class and add a space
s/^\(\s\+[v|n] 1:\)/ \1/

# Match 2nd-9th sense lines and add 3 leading space
s/^\(\s\+[2-9]:\)/   \1/

# Match 10-99th sense lines and add 2 leading space (align `:`)
s/^\(\s\+[0-9]\{2\}:\)/  \1/

# DON'T match word header or first lines of a sense (i.e N: text...)
# indent all others 12 spaces (orig. indentation is context-dependent)
/^\(  [^ ]\|.\+[0-9]: \)/! s/^\s\+/            /
