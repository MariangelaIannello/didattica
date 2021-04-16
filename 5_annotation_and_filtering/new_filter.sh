#!/bin/bash

#Filter contaminats from fasta
#Usage: bash filter.sh <diamond_annotation(with taxis as last column)> <taxon_to_keep> <fasta_file>

mkdir tmp_dir
awk -F"\t" '{print $1,$NF}' "$1" > tmp_dir/loci_taxid_all
cd tmp_dir


while grep -q ";" loci_taxid_all; do
sed -i -E 's/(^[^ ].*) ([0-9]+);/\1 \2 \n\1 /g' loci_taxid_all
done

#from taxid to whole taxonomic lineage
awk '{print $1}' loci_taxid_all | sort | uniq -c | awk '{print $2,$1}' | sort > n_diamond_hit
awk '{print $2}' loci_taxid_all | sort | uniq > uniq_taxid
taxonkit lineage uniq_taxid --data-dir /var/local/taxonkit/ > whole_taxonomic_lineage

#file="uniq_taxid" ; name=$(cat $file) ; for i in $name ; do ete3 ncbiquery --search $i --info; done > whole_taxonomic_lineage


#grep lineages with selected taxon
grep "$2" whole_taxonomic_lineage | awk '{print $1}' > filtered_id

#grep loci with taxid belonging to the selected taxon
file="filtered_id" ; name=$(cat $file) ; for i in $name ; do grep -w $i loci_taxid_all ; done > loci_filtered_id
awk '{print $1}' loci_filtered_id | sort | uniq -c | awk '{print $2,$1}' > n_selected_taxon

#select only loci where 100% of annotations had a taxid belonging to the selected taxon
join n_diamond_hit n_selected_taxon | awk '$4=$3/$2*100 {print $0}' | awk '$4==100 {print $0}' | awk '{print $1}' > keep_these

#filter fasta
file="keep_these" ; name=$(cat $file) ; for i in $name ; do grep -w -A1 $i ../"$3"; done > ../"$3"_"$2"_filter

#stats
grep -c ">" ../"$3"_"$2"_filter > n_filtered
grep -c ">" ../"$3" > n_tot

echo "Filtering step completed! Kept" "$(<n_filtered)"  "out of" "$(<n_tot)" "sequences"
cd ..
