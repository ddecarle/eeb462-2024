# Introduction to the Command Line

Tutorial by Viviana Astudillo-Clavijo & Danielle de Carle

Below are some commands you'll need over the course of these labs. For the following examples, imagine we are working on a computer with the following file structure.
  
![sample file tree](https://github.com/ddecarle/eeb462/blob/master/file-tree.png)

When using this page, keep in mind that this is only a very cursory treatment of the bash commands. More information about each of these commands and its usage can be found in the manual by typing 

```bash
man <command>
```

Use the arrow keys to scroll within any `man` page and press `q` to exit when you're done. 

As is always the case with programming, ***the internet is your friend***. 

### Table of Contents: 
 - [Exploring Directories](#xexploring-directories)
 - [Tab Complete](#tab-complete)
 - [Creating and Deleting Files](#creation-and-destruction)
 - [Moving and Copying Files](#moving-and-copying-files)
 - [Wildcards](#wildcards)
 - [Redirecting Outputs (piping](#redirecting-outputs)
 - [Finding (and editing) patterns](#finding-and-editing-patterns)
 - [Making it all work for you](#making-it-all-work-for-you)
 - [For Loops](#for-loops)


## Exploring Directories
Here are some useful commands for navigating and exploring directories. You will use these a lot

```bash
cd <directory>
```

To navigate directories via the command line, type `cd` followed by the path to the directory
that you want to navigate into. For example:

```bash
cd ~/Documents/MyCourses/PhyloCourse
```

Once you execute this command, “PhyloCourse” will be your new working directory. You now have access to all the files within this directory, and don’t have to type the entire path to locate them. If the directory that you want to navigate to is nested within your current working director, then you only need to specify the path from that point on. For example, if you now want to navigate into the folder `sequences`, you only need to type

```bash
cd sequences
```
If you are starting from `PhyloCourse`, and you want to navigate into `fastasequences`, then you would use the command

```bash
cd sequences/fastasequences
```
you can also backtrack into enclosing folders using two dots: 

```bash
cd ..
```
If you are within `fastasequences`, for example, using the command above would make `sequences` your working directory.

If you are within `fastasequences` and you want to navigate back to `PhyloCourse`, use

```bash
cd ../..
```

If you are within `PhyloCourse`, and decide that you want to listen to some sick tunes, you can use this command: 

```bash
cd ../../../Music
```

If you forget which folder you’re in, or need to know the path to your current working directory, you can use the “print working directory” command:

```bash
pwd
```

To print the names of all visible files and folders within the working directory, use

```bash
ls
```

If you want to quickly check the contents of a file, you can use the head and tail commands.

```bash
head <file name>
```

displays the first 10 lines of a file. You can use the modifier `-n` to change the number of lines that are displayed. To display the first 15 lines of a file, use the following command:

```bash
head -n 15 <file name>
```

The `tail` command works the same way, only it displays the end of a file rather than the beginning.

[Back to top](#introduction-to-the-command-line)

## Tab Complete
If you want to avoic making mistakes while typing (or you'e too lazy to type more than you ***absolutely have to***, Tab Complete is the feature for you!

At any point, when entering the name of a file or folder, press “tab”, and your terminal will automatically complete whatever you’re typing.
If you’re in the folder `MyCourses`, and you want to change directories into `Another Course`, simply type:`cd A`+ tab.  

If there’s more than one file or folder that meets your criterion, simply press “tab” twice to bring up a list of all possible options. For example, say you’re located in `fastasequences` and you want to open a file. You could type the following to view a list of all files beginning with “1”:
`nano 1`+ tab + tab

This feature is especially useful when considering that informative file names can easily become
long and unwieldy.

[Back to top](#introduction-to-the-command-line)

## Creation and Destruction
To create a folder from the command line, use the command:

```bash
mkdir <folder name>
```

To make a folder called `New` in your current working directory, type:

```bash
mkdir new
```
If you just received a large amount of sequence data, you might use the following command to create a folder in which to store it:

```bash
mkdir ~/Documents/MyCourses/PhyloCourse/sequences/RawSequences
```
Of course, you can also delete files and folders:

```bash
rm <file>
```
You can specify the name of a single file, or use [wildcards](#wildcards) to delete multiple files at once. To delete directories as well as files, use the following modifiers:

```bash
rm -d <folder>
rm –r <folder>
```

The first will only delete folders that are empty, while the second will delete the specified folder and all its contents. When using this command, **please be careful**. You cannot recover deleted files, and if you use it in the wrong place, you can do something tragic, like deleting your entire operating system.

[Back to top](#introduction-to-the-command-line)

## Moving and Copying Files
Rearranging your files is easy.

```bash
mv <target file> <target destination>
```
Just like with cd, you can use the absolute or relative path to move files. If `sequences` is your current working directory, and you want to move `16s.fasta` from `fastasequences` to `PhyloCourse`, you can use either of the following commands:

```bash
mv fastasequences/16s.fasta ~/Documents/MyCourses/PhyloCourse/
mv fastasequences/16s.fasta ..
```
Copying commands works similarly:

```bash
cp <target file> <target destination>
```
A useful shortcut to use is the period `.`, which signifies the current directory. For example, if you’re in the `fastqsequences` folder, and you want to copy `enam.fasta` into your working directory, you could use either of these commands:

```bash
cp ../fastasequences/enam.fasta
    ~/Documents/MyCourses/PhyloCourse/sequences/fastqsequences
cp ../fastasequences/enam.fasta .
```

[Back to top](#introduction-to-the-command-line)

## Wildcards
Wildcards are characters that have an alternate meaning in the command line than in regular language. They can be very useful for attempting to locate and manipulate large amounts of data or text that have something in common (*e.g.* part of the name, or a file extension). Here are some of the most useful wildcards and regex (regular expressions).

```bash
?
```

The question mark represents any single character from `a-z` and `0-9`. So if you type `ma?`, it can be interpreted as `maa`, `mab`, ..., `maz`, `ma0`, ..., `ma9`.

```bash
*
```
The asterisk represents any number of characters. `ma*` can be interpreted as a huge number of things, including `maa`, `master`, `master.txt`, and even `ma` itself.

```bash
[]
```
Square brackets indicate a range of characters, with the possible options enclosed within. You can use a comma or dash to separate items in the range of options. If commas are used, then the possible interpretations are limited to one of the characters listed. If a dash is used, then any character within the specified range is possible. So `h[o,m,l]n` could specify one of `hon`, `hmn`, or `hln`, while `h[o-r]n` could specify `hon`, `hpn`, `hqn`, or `hrn`.

```bash
!
```
This is a logical expression, specifying not. It is interpreted as referring to anything **not** matching the associated character. For example, `[!s].txt` refers to all the text files that do not contain an “s” in the name.

```bash
^
```
This character refers to the beginning of a line of text. `^y` refers to lines starting with “y”.

```bash
$
```
This character refers to the end of a line of text. `Y$` refers to lines ending with “Y”.

```bash
\
```
Sometimes, you want to use the wildcards as they would be used in regular language. For instance, you might want to actually print the characters `*` or `?`. The backslash is an **escape character**. If you put it in front of a wildcard or regular expression (a.k.a. regex), then the following character will be interpred as text. For example, `*9` could represent anything ending with “9”, wheras `\*9` would be strictly interpreted as “*9” only.

[Back to top](#introduction-to-the-command-line)

## Redirecting Outputs
Whenever you run a command, the default is to print the result right onto the command line. Sometimes, however, you want to store the output or do something else with it. That is where redirecting and piping come in handy.

```bash
<command> > <file name>
```
the `>` character redirects the output of the preceding command into a new file, specified by the
file name. For example:

```bash
echo ‘I love Phylogenetics’
```
prints “I love Phylogenetics” into the command line, but

```bash
echo ‘I love Phylogenetics’ > Phylo.txt
```

prints nothing in the terminal, and instead creates the file `Phylo.txt` which now contains your profession of love. It is important to note that, if a file with the name `Phylo.txt` already exists, it will be **overwritten** with this new content without any warning to you.

```bash
<command> >> <file name>
```
`>>` is similar to `>`, except that, after a file with the specified name has been created, the output is appended (*i.e.* tacked on) to the end of this file, rather than overwriting it. For example, 

```bash 
echo ‘I am learning so much’ >> Phylo.txt
```
adds a new line with “I am learning so much” to the existing `Phylo.txt` file.

If you want to execute a few commands before saving the output to a file, you can use **piping**: 

```bash 
<command> | <command> > <file name>
```
Piping is specified by placing the `|` character between different commands. The output of the command before the pipe is directed (or, “piped”) to serve as the input for the next command. You can use as many pipes as you want, so long as the output of one command is usable as input for the next. The end of a chain of piped commands is often a file name, specifyng where the final output should be saved. If no file name is specified, then the outcome is simply printed to the terminal.

```bash
cat Phylo.txt | tr ‘\n’ ‘ ‘ > PhyloOneLine.txt
```
This line of code opens the file `Phylo.txt` and, rather than printing it in the terminal, pipes it to the `tr` command, which replaces the end-of-line character (`\n`) with spaces (`‘ ‘`) and saves the new contents to a file called `PhyloOneLine.txt`. (Fittingly, this new file will contain the same information as the first one, but it'll all be on... one line.)

Piping can make your code more efficient by allowing to do everything you need before saving the output. Without it, you might end up with 10 files containing intermediate results, rather than a single file with the desired output. Furthermore, since reading and writing many files requires a lot of memory, piping is a good way to speed up your analyses.

[Back to top](#introduction-to-the-command-line)

## Finding (and editing) patterns
There are many ways to search for and edit strings of text on the command line. Two of the most common are `grep` and `sed`.

`Grep` searches for patterns in a file, and prints lines that match those patterns. The general syntax is:
```bash 
grep [options] <pattern> <file>
```
Combining `grep` (and `sed`, for that matter) with [wildcard](#wildcards) characters and regex makes this a very powerful tool.
Some common modifiers:

- `grep -F` interprets patterns as fixed strings (*i.e.* regular language), rather than regex 
- `grep -c` displays the number of times a pattern appears, rather than the lines themselves
- `grep -n` displays the line number for each pattern match

For example, if you want to know how many sequences are in `coi.fasta`, you could use the following command:

```bash
grep -c ‘>’ coi.fasta
```
if you wanted to know whether the string `!$^` occurred in any of your .fasta files, you could use either of the following:

```bash
grep ‘\!\$\^” *.fasta
grep -F ‘!$^” *.fasta
```
If you want to know where in your files the sequence for the taxon `flyingFox` is located, you could try
```bash
grep -n ‘flyingFox’ *.fasta
```

`Sed` is similar to grep, but it is designed to edit text rather than simply searching for patterns.
The general syntax is:

```bash
sed [options] <script> <file name>
```

The following command, for example, would replace all instances of the word `bear` with the generic name `Ursus`, and write the result to a new file called `output.txt`:

```bash
sed ‘s/bear/Ursus/’ *.fasta > output.txt
```
to edit a file “in place” – *i.e.* to change the target file rather than piping or saving the output to a new one – use the option `-ie`:

```bash
sed -ie ‘s/bear/Ursus/’ *.fasta
```
You can also use `sed` to manipulate text in other ways.

```bash
sed ’30,35d’ allTaxa.txt > noMonkeys.txt
```
Deletes lines 30-35 in the input, `allTaxa.txt`, and prints it to the output (`30,35` is the range of lines; `d` is the delete command).

```bash
sed ‘/^anteater/q’
```
Prints all input until a line beginning with `anteater` is found. If such a line is found, `sed` will stop printing (as indicated by the "quit" command, `q`); if it is not found, `sed` will continue printing until the end of the file is reached.

A comprehensive list of `sed` commands can be found on the `man` page.

[Back to top](#introduction-to-the-command-line)

## Making it all work for you
This is where the command line starts to get powerful. You can use wildcards, directory navigation, and redirection to locate and manipulate large numbers of files at the same time. For example:

`ls *.fasta` locates all files with the `.fasta` extension

`rm Seqs[!9].fasta` deletes all `.fasta` files with the word “Seqs” and no number 9 in the file name.

Now, let’s say that you have a bunch of `.fasta` files in your working directory, and that the file names are the names of exons to which the sequences belong.

```bash
ls *.fasta | oi ‘s/\.fasta//’ | tr ‘\n’ ‘ ‘ > exonNames.txt
```
This line of code is very useful. It finds all `.fasta` files in the working directory, pipes those files over to the command `sed`, which searches for the `.fasta` string in these file names (notice that the backslash is being used to escape the dot, which is a wildcard character), and replaces it with nothing (*i.e.* it gets rid of the `.fasta` extension). It then pipes the list of altered file names over to `tr`, which replaces the end-of-line `\n` – which would normally be present after each file name – with a space `‘ ‘`. Finally, it redirects this list to a new file called `exonNames.txt`. This new file contains a list of all exons, on one line. 

Why is this so useful? See the [For Loops](#for-loops) section.

[Back to top](#introduction-to-the-command-line)

## For Loops
In phylogenetics, especially with the growing trend of “big data phylogenetics” (*i.e.* phylogenomics), we are often faced with the issue of having to repeat a task for many files. Sometimes, “many files” means hundreds or thousands. And because mistakes happen – and often – it is not uncommon to have to redo the task again for all of these files many more times. In these cases, for-loops will save you.

For-loops essentially function like, well, a loop. They apply a task specified by your commands to each element in a list, one at a time, until the task has been completed for all elements in that list. For-loops have a simple basic structure:

```bash
for <variables> in <list of strings separated by spaces>
do
<commands for ${variable}.file>
done
```
A for-loop is opened with a line of text starting with for that defines the elements that the for-loop should be applied to. The user defines a variable (this can be any word), and provides a list of elements (*e.g.* file names) that they wish to apply the for-loop to. For each iteration of the for-loop, that variable is assigned to a new element in the list. That is, for the duration of one iteration, the variable = a particular list element.

The `do` command simply tells the computer that you are now going to specify the commands to be applied to the elements in the list. The user specifies how elements should be used by commands using the `${variable} string` (*e.g.* `${variable}.fasta` would call on file names containing one of the list elements in its name).

Finally, `done` tells the computer that you are finished applying commands to a specific element, and you should move onto the next one. For-loops work iteratively; they start by assigning the variable to the first element, apply all commands, and then move onto the next one. When `done` is reached following the last element in the list, the for-loop ends. The `for`, `do`, and `done` commands are usually specified on different lines for clarity. 

Different programming languages may implement for-loops in different ways, but the basic structure remains the same. 

As an example, let’s say that you have DNA sequences for 3 loci (`RYR3`, `COI`, and `NADH`) for each of 10 species in separate files (total: 30 files). Here is a sample of those files:

```bash
RYR3_Sp1.fasta
RYR3_Sp2.fasta
...
RYR3_Sp10.fasta
COI_Sp1.fasta
...
NADH_Sp10.fasta
```
You want to combine the sequences for the 10 species into 3 files, one for each of the 3 genes, then align each of these. It would be quite cumbersome to do this by hand, but pretty easy with a for-loop.

```bash
for seq in RYR3 COI NADH
do
cat ${seq}_*.fasta > ${seq}_Concat.fasta
./muscle –in ${seq}_Concat.fasta –out ${seq}_align.fasta 
done
```
Here, we define a variable called `seq` that will be used to call on the elements `RYR3`, `COI`, and `NADH` in the for-loop. The loop first assigns the variable `seq` to the first list element, which in this case is `RYR3`. Then, it begins executing the commands with `${seq}` referring to the current variable (*i.e.* `RYR3`). 

The first command concatenates the sequences for all 10 species sharing the same “seq” identity (*i.e.* `RYR3`) at the beginning of the file name (the `*` wildcard ensures that the files with any species in their names are included), and saves the concatenated sequences to a new file whose name includes the name of the enclosed sequences. 

The next command uses the `muscle` tool to align sequences in the new, concatenated file, and saves the output to a new file, also named after the enclosed sequences. In the first iteration of the loop, the outputted files would be `RYR3_Concat.fasta` and `RYR3_align.fasta`. 

Once the first iteration is completed, the variable is reassigned to the next element (in this case, `COI`) and the commands are run again. The variable is recycled for each new cycle of the for-loop until all elements have been used. At this point, the done command signifies the closing of the loop.

[Back to top](#introduction-to-the-command-line)
