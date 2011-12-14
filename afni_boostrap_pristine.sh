#!/bin/bash

set -eu
cd ~/git/afni-pristine

/bin/ls $HOME/tarballs/X/afni-*tgz | sort \
| while read f; do 
	fn=$(basename $f); 
	ver=$(GIT_DIR=../afni.git git log --format=%s --grep="Imported from tarball: $fn" | sed -e 's,Importing AFNI \(0.[0-9]*\)~dfsg.*,\1,g');
	[ -z "$ver" ] && ver=`echo $fn | sed -e 's,.*afni-\([0-9]*\)\.tgz,0.\1,g'` || :
	# workaround for git-i-o unable to determine the name nor giving option to specify it
	tf=/tmp/${fn/-/_}
	tf=${tf/.tgz/.orig.tar.gz}
	ln -fs $f $tf
	git-import-orig --no-interactive --pristine-tar $tf -u $ver --verbose;
	rm -f $tf ~/git/afni_*.orig.tar.gz
done
