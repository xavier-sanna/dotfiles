#!/bin/bash

atac_dir=./.atac

if [ -d $atac_dir ]; then
	atac --directory "$atac_dir"
else
	echo ".atac directory not found in project root"
fi
