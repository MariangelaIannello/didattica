#!/bin/bash
#$1=diamond annotation
#$2=taxon to keep
#$3=fasta file

mkdir tmp_dir

awk '{print $1,$6}' "$1" > tmp_dir/tmp
cd tmp_dir
awk '{print $NF}' tmp > tmp1
taxonkit lineage tmp1 --data-dir /var/local/taxonkit/ > tmp3
paste tmp tmp3 > tmp4

grep "$2" tmp4 | awk '{print $1}' | sort | uniq -c > hit_selected_taxon
awk '{print $1}' tmp | sort | uniq -c > hit_diamond

paste hit_diamond hit_selected_taxon | awk '$5=$3/$1*100 {print $0}' | awk '$5==100 {print $0}' | awk '{print $2}' > keep_these
file="keep_these" ; name=$(cat $file) ; for i in $name ; do grep -w -A1 $i ../"$3"; done > ../"$1"_"$2"_filter.fasta

grep -c ">" ../"$1"_"$2"_filter.fasta > n_filtered
grep -c ">" ../"$3" > n_tot

echo "Filtering step completed! Kept" "$(<n_filtered)"  "out of" "$(<n_tot)" "sequences"

cd ..
rm -r tmp_dir
