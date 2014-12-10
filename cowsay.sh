#! /bin/sh

COW=`ls /usr/share/cowsay/cows | sort -R | tail -1`
COW=`basename "$COW" .cow`

fortune | tr '\n' '$' | sed 's/$\t\t\-\-/\n        --/g' | tr '$' ' ' | \
sed 's/\(A\|Q\):\t/$$\1:/g' | sed 's/^$\+//g' | tr '$' '\n' | \
cowsay -f "$COW"
