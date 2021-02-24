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
* many others (& | < ? []{} etc..)
## Permissions
```
sudo command #allows users to run programs if he/she has sudoer priviledges
chmod #change permissions of your files (or directory with chmod –r)  
```

![chmod](https://raw.githubusercontent.com/MariangelaIannello/didattica/main/images/chmod.png)
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
wc filename # outputs the number of words, lines, and characters
wc –l #outputs the number of lines
rm file #remove file
rm * #remove every file in that directory
mkdir newfoldername# make new directory
mkdir -p zmays-snps/{data/seqs,scripts,analysis} #create directory and subdirectories with one command
cp –r foldername #copy folder
mv foldername pathwheretomove #move folder
rm –r foldername #remove folder
```
> tip: be VERY careful with rm, once you removed something there is no way to undo it
## Merge and sort files
```
cat file1 file2 file3 … #merge multiple files in 1  
cat file1 file2 file3 > newfilename #redirect output to new file
sort #sort the file, careful to computational sorting of file
sort –h # human numeric sort
```






