#!/bin/sed -f
# Output of wordnet dictionary definitions is colourised on this
# system. Strip redundant delimiting punctuation.
s/[{}]//g
s/\[syn/|synonyms/g
s/\[ant/|antonyms/g
s/\]//g
#s/;//g
