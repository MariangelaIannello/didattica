# Bash
## Paths, files and directories

```
ssh username@ip #login to a server via ssh, it will ask for your password
Ctrl+d #close session
Ctrl+c #clean the command line
top # display Linux processes
pwd #print working directory
cd #change directory (relative or absolute path)
cd .. # bring you back one directory up
 cd ~ #cd home
ls #print list of elements in directory
ls –lh # print sizes in human readable format
man list # (or any command, gives the manual for that command)
history #dispay last commands
ls *.fasta #list all fasta files
```
> **special characters:**
* ~ home directory
* . Current Directory
* / Path Directory Separator
* Space
* \* any character
* ; Shell Command Separator
* \> redirect output to new file
* \t tab
* \n end of line in bash
* \r end of line in mac
* \n\r end of line in windows
* many others (& | < ? []{} etc..)
---
## Permissions
```
sudo command #allows users to run programs if he/she has sudoer priviledges
chmod #change permissions of your files (or directory with chmod –r)  
```

![chmod](https://raw.githubusercontent.com/MariangelaIannello/didattica/main/images/chmod.png)
---


## Edit files
` vi nomefile #create new empty file`
> avoid special characters; once created new file press “i" to write, after editing press Ctrl+c+: and type wq to save and exit from file or q! to exit without saving
```
cp filename pathwheretocopy #copy file somewhere using absolute or relative path of where to copy
mv filename pathwheretocopy #mv file somewhere using absolute or relative path of where to copy
mv filename new_filename #rename file
less filename #see file
cat filename #similar to less
head filename #see first 10 rows of the file
tail filename #see last 10 rows of the file
head –n5 filename #(or tail –n 5) see only first 5 (or last) 5 rows
wc filename #outputs the number of words, lines, and characters
wc –l #outputs the number of lines
rm file #remove file
rm * #remove every file in that directory
mkdir newfoldername# make new directory
mkdir -p zmays-snps/{data/seqs,scripts,analysis} #create directory and subdirectories with one command
cp –r foldername #copy folder
mv foldername pathwheretomove #move folder
rm –r foldername #remove folder
```
> tip: be VERY careful with rm, once you removed something there is no way to undo it; remember bash is case sensitive, the file, folder or scritp "Data" is different from "data".
---
## Download and transfer data

wget can handle HTTP and FTP links
```
wget https://github.com/MariangelaIannello/didattica/archive/main.zip 
```
For public data we don’t need any authentication to gain access to this file, otherwise use flags *--user=*  and *--ask-password* 
```
curl –O link #-O saves the file with its original filename
```
curl can transfer files using more protocols than wget. It supports FTP, FTPS, HTTP, HTTPS, SCP, SFTP, TFTP, TELNET, DICT, LDAP, LDAPS, FILE, POP3, IMAP, SMTP, RTMP and RTSP

scp (secure copy): transfer data from local computer to remote host, or from two remote hosts. scp works just like cp, except we need to specify both host and path

```
scp file.fasta USERNAME@IP:/home/data/ #transfer file from server to another server or
scp –r data USERNAME@IP:/home/data/
scp –r USERNAME@IP:/home/data ./
```
## Data integrity
```
md5sum nomefile
```
---
## Compress and decompress data

```
gzip file (or folder) #compress file file.gz
bzip2 file #slower than gzip but higher compression ratio
gzip –k file #keep also the not compressed file
gunzip file.gz #uncompress file
zless file.gz #less compressed file
zgrep "word" file.gz #use grep in compressed file
```
With **gzip** you don't get compression across files, each file is compressed independent of the others in the archive, advantage: you can access any of the files contained within.

With **tar** the only gain you can expect using tar alone would be by avoiding the space wasted by the file system as most of them allocate space at some granularity.

In **tar.gz** compression: create an archieve and extra step that compresses the entire archive, you cannot access single files without decompressing them.
```
tar –czvf name_output.tar.gz name_input # c create archive; f specify new output; v verbosely;
tar -xvfz ./nome_archivio.tgz #decompress archive
```

---

## Merge and sort files
```
cat file1 file2 file3 … #merge multiple files in 1  
cat file1 file2 file3 > newfilename #redirect output to new file
sort file #sort the file, careful to computational sorting of file
sort –h file #human numeric sort
sort -t file #specify field separator (e.g., -t",")
sort -k1,1 -k2,2n file #sort by first column adn then numerically by second column
sort -k1,1 -k2,2nr file #sort by first column adn then numerically by second column in reversed order
sort -k1,1V -k2,2n file #as before but human sorted
join -1 1 -2 1 sorted_file1 sorted_file2 #join two files according to first column of each file
join -1 1 -2 1 -a 1 sorted_file1 sorted_file2 #keep also non joined rows
```
---
## Grep
```
grep "word" file #print all rows that contains "word"
grep -v "word" file #print all rows that contains exactly the pattern "word"
grep -v "word" file #inverted match, print all rows that not contain the patter "word"
grep -c "word" file #count how many rows contain the patter "word"
grep –A10 "word" file # print rows containing pattern "word" and the 10 rows after
grep –B10 "word" file # print rows containing pattern "word" and the 10 rows before
grep –C10 "word" file # print rows containing pattern "word" and the 10 rows after and before
grep "Locus10[12]" file #print Locus101 and Locus102 
greo -E "(Locus101|Locus102)" file #print Locus101 and Locus102 
```
> special characters: 
> * ^ starting with ; grep "^>" file #print lines starting with ">"
> * $ ending with ; grep ">$" file #print lines ending with ">"

> Regular Expressions: a sequence of characters that specifies a pattern
---
## Awk
```
awk '{print $1}' file #print first column
awk '{print $0}' file #print all columns
awk '{print $NF}' file #print last column
cut -f 2 file #also cut print columns, print column 2
cut  -f 3-8 # print from column 3 to 8
cut –f 3,5,7 #print column 3, 5 and 7
awk '{print $4"\t"$1}' file #change orders of column and use tab as field separator in the output
awk -F";" '{print $3,$4}" #fiels separator is ";"
awk '$1==$2 {print} #if first column = second column, print all columns
awk '$1 ~ /chr2|chr3/ { print $0 "\t" $3 - $2 }' #if first column contain "chr2" or "chr3", print all columns, and a column with the difference between $3 and $2
awk '$1 ~ /chr1/ && $3 - $2 > 10 '{print}' #if both the first column  contain "chr1" AND $3-$2>0 , print all columns
```
![awk](https://raw.githubusercontent.com/MariangelaIannello/didattica/main/images/awk.png)
---
## Bioawk

```
bioawk -c fastx '{print ">"$name"\n"$seq}' file.fastq #turn a FASTQ file into a FASTA file; fastx = input as FASTQ or FASTA; -c=unspecific tab-delimited formats
bioawk -c fastx '{print ">"$name"\n"revcomp($seq)}' file.fasta #reverse complement a sequence
bioawk -c fastx '{print $name,length($seq)}' #print name and length of sequences in fasta file
```
---
## Sed and diff
```
sed 's/Locus/Transcript/' file #for each line subtitute "Locus" with "Transcripts" at first occurrance
sed 's/Locus/Transcript/g' file #for each line subtitute "Locus" with "Transcripts" at first occurrance
sed -i 's/Locus/Transcript/g' # overwrite input with the output
sed '/Locus/d' file #delete any row containing "Locus"
diff -y file1 file2 #Compare FILES line by line and show side by side
```

> $ echo "chr1:28427874-28425431" | \
sed -E 's/^(chr[^:]+):([0-9]+)-([0-9]+)/\1\t\2\t\3/'

> chr1 28427874 28425431

The first component of this
regular expression is ^\(chr[^:]+\):. This matches the text that begins at the start of
the line (the anchor ^ enforces this), and then captures everything between \( and \).
The pattern used for capturing begins with “chr” and matches one or more characters
that are not “:”, our delimiter. We match until the first “:” through a character class
defined by everything that’s not “:”, [^:]+.
The second and third components of this regular expression are the same: match and
capture more than one number. Finally, our replacement is these three captured
groups, interspersed with tabs, \t.

> $ echo "chr1:abRsZtjf-dhThdbUdj" | \
sed -E 's/^(chr[^:]+):([a-zA-Z]+)-([a-zA-Z]+)/\1\t\2\t\3/'

> chr1 abRsZtjf dhThdbUdj
