# Bash 

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
* > redirect output to new file
* many others (& | < ? []{} etc..)
## Permissions
```
sudo command #allows users to run programs if he/she has sudoer priviledges
chmod #change permissions of your files (or directory with chmod –r)  
```

![chmod](https://raw.githubusercontent.com/MariangelaIannello/didattica/main/images/chmod.png)
## Edit files
vi nomefile #create new empty file
