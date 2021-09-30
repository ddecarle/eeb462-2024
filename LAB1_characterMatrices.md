# Lab One: Creating a Character Matrix

*Tutorial by Danielle de Carle*

### Introduction to the Labs

The figure below details the basic steps involved in phylogenetic analysis. Over the course of the semester, we’ll touch on each of the steps required to infer a phylogenetic tree from molecular or morphological data. 


<p align="center">
  <img width="209" height="656" src="https://github.com/ddecarle/eeb462-2021/blob/main/images/L1-Picture1.png">
</p>


Each of the seven labs will involve working through a tutorial. Sprinkled throughout the tutorial, you’ll find the questions that make up the **lab assignments**. These questions are designed as checkpoints to make sure things are going smoothly as you move through the lab. There will also be some long-answer questions, which double as an opportunity for you to practice the type of writing you’ll be using for your manuscript. Eventually, when we get into tree-building, many of these questions will be talking points you can use for writing your discussion. 

To complete the lab assignments, create a document with your answers to all the questions, and **upload it to Quercus** by the due date: **2:00 PM, one week after the lab in which they were assigned**. Bonus questions should be answered on the Discussion Board for Lab One. 


### Lab Assignment One: 
Questions: 
- [1](#question-1), [2](#question-2), [3](#question-3), [4](#question-4), [5](#question-5), [6](#question-6), [7](#question-7) *(19 points total)*
- [Bonus questions](#bonus-questions)


## Table of Contents:
 - [The Basics](#the-basics)
 - [Tutorial](#the-tutorial)
   - [Setting up your workspace](#setting-up-your-workspace)
   - [Downloading sequences](#downloading-sequences)
   - [Quality control](#quality-control)
   - [Formatting your data](#formatting-your-data)
   - [Translating sequences](#translating-sequences)
   - [Alignment](#alignment)
   - [Concatenating sequences](#concatenating-sequences)
   - [Tidying up](#tidying-up)
 

## Software

For this lab, we will be using the following software: 

- [MUSCLE](https://www.drive5.com/muscle/downloads.htm)
- [Mesquite](http://www.mesquiteproject.org/Installation.html)
- A plain text editor of your choice 


## The Basics

### A Note on operating systems 
Most tree-building software is designed and built for the Unix shell, bash. Bash is a command language that is natively used by MacOS and most Linux distributions. (It is also available in Windows 10 using the Windows Subsystem for Linux.) 

Accordingly, the tutorials in this course are also designed for bash. Be aware, however, that you will still need to download the appropriate (i.e. Windows) versions of all software. 

Throughout the tutorials, the word “terminal” will refer to the program you use to interface with the command line.


### Good computing habits
Because we will be generating a large number of files in this course, and because we will be running virtually all programs on the command line, it is important to follow a few, key rules. 

**Use succinct, informative names.** This goes for both files and folders. You may think you’ll remember what’s in `master.fasta`, or `~/Desktop/BLAH/` but I promise you’ll forget after you’ve run the same analysis 10 times, or you’re trying to submit a paper 4 months from now. Don’t worry if the names start to get a bit long: the trusty command line tab-complete feature will help you avoid making mistakes. Most importantly… **DO NOT USE SPACES** in the names of your files or folders. Most programs and programming languages interpret spaces as separations between elements in a file or script. Using spaces anywhere in your path is therefore a quick road to suffering. 

**Stay organized.** Separate your files into folders to avoid cluttering your workspace, and keep everything in a logical place. If you know you’ll be using multiple computers for a single project, make sure everything you need is accessible. Dropbox, USB keys, and hard drives are your friends. 

**Use a good text editor.** The best way to view many of the files we’ll be using (at least for the first four labs) is using a plain text editor. You probably have Text Edit or Notepad on your computer, but there are many, more powerful and more user-friendly programs out there. I, personally, prefer [Sublime Text](https://www.sublimetext.com/) or [Atom](https://atom.io/), but other popular options include [Notepad++](https://notepad-plus-plus.org/downloads/). Do ***not*** use Word, Open Office, or any other rich text editor: like using spaces in file names, they will cause you much suffering. 


### Using the command line
The vast majority of programs we’ll be using throughout the semester lack graphic user interfaces; therefore, you’ll need to be comfortable navigating your directories and running analyses on the command line. For more information about all the commands that we’ll be using, consult [this document](https://github.com/ddecarle/eeb462-2021/blob/main/CommandLineBasics.md), which details some of the most useful commands for phylogenetic analysis.  


## The Tutorial

### Setting up your workspace

Ensure that you have downloaded and unzipped all necessary [files for Lab One](https://github.com/ddecarle/eeb462-2021/blob/main/LabOne.zip). 

1.	Open a terminal window and change directories `cd` to the location where these files are saved. For most of you, this will be the Downloads folder. 

```
cd ~/Downloads
```

2.	Make a new folder on your desktop called "EEB462" and move the LabOne folder into it using the move `mv` command 

```
mkdir ~/Desktop/EEB462
mv LabOne ~/Desktop/EEB462
```

3. Move your MUSCLE program into this new folder as well (`~/Desktop/EEB462`)

4.	Navigate into the LabOne folder, and create a new folder called “Fasta”. 

```
cd ~/Desktop/EEB462/LabOne
mkdir Fasta
```

5. Move all `.fasta` files into this new folder

```
mv *.fasta Fasta
```

6. Navigate into the "Fasta" folder, and use the list directory contents command - `ls` - to view the contents of that folder

---
#### QUESTION 1 
What files are now stored in `~'Desktop/EEB462/LabOne/Fasta`? *(1 point)*

---

7.	Use the `head` command to display the first few lines of one of the files contained within the “Fasta” folder. 

```
head <fileName>
```

The output should look something like this: 

```
>sequence_one
ATCGGTACGATCGATCGATCGTAGATTCAGAGATGATCGCAACTAGCTAGCTAC
>sequence_two
ATCGGTACGATCGAATGATCGTAGATTCAGAGATGATCGCAATTTGCTAGCTCC
>sequence_three
ATCCCCTAGATCGATCGATCGTAGATTCAGAGGATCGAGCAACTAGCTAGCTAC
…
```

This is the **FASTA file format**. It consists of a sequence name (always preceded by `>`), followed by the sequence itself on a second line. This format can be used with DNA (nucleotide) or protein (amino acid) sequences. FASTA is a very simple file format, and is used as input by many of the programs we’ll be using this semester. 

### Downloading sequences

1. In Excel (or an equivalent program), open "data.xlsx"

This file includes taxonomic information for all of our taxa, as well as their common names, and the accession numbers for all genetic information we’ll be using. You may notice that the accession numbers for some of the loci are the same: this is because the COI and 16S sequences for this dataset were all mined from mitochondrial genomes. You should also notice that your “Fasta” folder is missing sequences for the 18S locus. 

2.	To procure these sequences, use NCBI’s [Batch Entrez](https://www.ncbi.nlm.nih.gov/sites/batchentrez) tool, which allows you to download several sequences from GenBank at once. 

3.	Click “**Browse**” and select “18sAccessions.txt” from the “LabOne” folder. Then, click “**Retrieve**”. 

4.	Follow the link on the next page, and you will see a list of GenBank search results. To download these results, click “**Send to**” in the upper right section of the page, then select “**File**” as your destination, and “**FASTA**” as the format. (Make sure the "**Complete Record**" option is selected.) Then click "**Create File**". 

5.	Save these results as “18s.fasta”, and store them in `~/Desktop/EEB462/LabOne/Fasta`.  

### Quality control

1.	In the terminal, navigate to the “Fasta” folder, and use the following command to determine the number of sequences in the “18s.fasta” file: 

```
grep –c '>' 18s.fasta
```

The `grep` command searches plain text files for a particular pattern or regular expression. In this case, the pattern we’re looking for is `>`. Remember that, since the file is in FASTA format, the number of greater than symbols will be equal to the number of sequences in the file. By default, grep will print any lines that match the search pattern. Here, the modifier `-c` tells the terminal to merely count the number of matches in the specified file and display the number. 

Grep should tell you that “18s.fasta” contains 18 sequences, which doesn’t jive with the 21 sequences present in “data.xlsx”. 

Luckily, there’s a file called “extraMammals.fasta” that contains additional 18S sequences. *Don’t get too excited, though…* 

2.	Examine this file in your text editor of choice (*e.g.* Sublime Text, Notepad+, etc.)

This file is slightly suspect. The title is uninformative: how do we know what type of sequences these are? **Where are the GenBank accession numbers?!** ***Are you just going to blindly trust that I’ve given you good information?*** Big mistake. 

3.	To verify these sequences, use [BLAST](https://blast.ncbi.nlm.nih.gov/Blast.cgi?PAGE_TYPE=BlastSearch). 

**BLAST** (Basic Local Alignment Search Tool) compares a sequence (or sequences) of interest to a database in order to find regions of high similarity. 

4.	Select the “**Nucleotide BLAST**” icon from the landing page. 
- Use the “**Browsee**” button to select `extraMammals.fasta`, and ensure that “**Nucleotide collection (nr/nt)**” is selected as the database. 
- Now click “**BLAST**” at the bottom of the page. 

Since your query contains multiple sequences, you can scroll through the results for each of them using the dropdown menu under “**Results For**” in the upper left corner. 

The **Graphic Summary** shows a visual representation of the most similar sequences in the database aligned to your query sequence – *i.e.* each bar represents an alignment of your sequence of interest and a sequence in the database. The length of each bar indicates the length of the database sequence relative to your sequence of interest, and the colour represents the similarity score

Red bars stretching the entire length of the query sequence represent highly similar sequences that are at least as long as your sequence of interest. 

Under **Descriptions**, you will see a list of sequences from GenBank in descending order of similarity. Clicking the **sequence name** will take you to an alignment of this sequence and your sequence of interest, while clicking the **accession number** in the rightmost column will take you to the page for that sequence. The rest of the columns list similarity metrics. In general, you’ll be most interested in the Per. Ident and E value columns. 

The **E value** describes the number of hits you would expect to see by chance when searching a database of a given size: it decreases as the score of the match increases. Generally speaking, you want your E value to be as close to 0 as possible. 

**Per. Ident** (or, identity) expresses the extent to which two sequences share the same nucleotide in the same position. Since (almost) all the data for this course were mined from GenBank, you should expect the top hit to have an identity value of 100%, indicating that the sequences are identical.

5.	Examine the BLAST results for each of the sequences in the “extraMammals.fasta” file. 

### Formatting your data

1.	Change all the sequence names in “18s.fasta” to common names (as indicated in “data.xlsx”) using the `rename.bash` script provided:

```
bash ../rename.bash
```

2.	Open “extraMammals.fasta” and delete any sequences that BLAST identified as erroneous. 

3.	Close this file, and return to your terminal window. 

4.	Use the following command to append the contents of “extraMammals.fasta” onto the end of “18s.fasta”:

```
cat extraMammals.fasta >> 18s.fasta
```

5.	Using grep as indicated above, ensure that “18s.fasta” now contains all 21 sequences for 18S. 

6.	Once you have confirmed that this is the case, delete “extraMammals.fasta”:

```
rm extraMammals.fasta
```

Your “Fasta” folder should now contain four fasta files: one for each of the four loci in our dataset.

### Translating sequences 

Before aligning our sequences, you’ll also want to translate your COI sequences into amino acid sequences. 

---
#### QUESTION 2: 

Why might we want to use amino acid sequences – rather than nucleotide sequences – for COI? Does it make sense to use amino acid sequences for COI, but not for ENAM? Why or why not?  *(4 points)*

---

1.	To translate your nucleotide sequences into amino acid sequences, use the EMBOSS tool, [Transeq](https://www.ebi.ac.uk/Tools/st/emboss_transeq/).  

2.	Under **STEP 1**, choose the “coi-barcode.fasta” file. 

3.	Under **STEP 2**, set FRAME to “2”, and set CODON TABLE to “Vertebrate Mitochondrial”.

4.	Click **Submit**. 

5.	Once the translation is complete, download the sequences, and save the file in the “Fasta” folder under the name “coi-protein.fasta”.

You’ll notice that Transeq appended `_2` to the ends of the sequence names to signify the reading frame for each translation. Because, going forward, we will need to make sure that our sequences for each organism have exactly the same name, we’ll have to fix this. 

6.	In your terminal, use the following command to clean up the sequence names, making sure that your working directory is `~/Desktop/EEB462/LabOne/Fasta`.

```
sed -i '' 's/_2//' coi-protein.fasta
```

The stream editing tool (`sed`) can be used to edit streams of text as well as files. In this case, the `-i` flag indicates that we want to do the latter. The `s/` functionality is used to substitute one string of text for another. The strings are separated by slashes. Here, we are substituting `_2` with nothing. Finally, the file name at the end of the command specifies the file we want to edit. 

Now, we’re ready to move on to the next step…

### Alignment

For these labs, we’ll be using the alignment program, MUSCLE (MUltiple Sequence Comparison by Log-Expectation). MUSCLE allows users to customize many of its parameters, such as gap opening scores, clustering methods, weighting schemes, etc. Detailed information about each of these parameters can be found in the user guide. For our purposes, however, the default parameters will be fine. 

To run a program on the command line, use the following syntax:

```
./<program> [option 1] [option 2]…
```

To run MUSCLE, we might use a command like this: 

```
./muscle3.8.31_i86darwin64 -in 16s.fasta -out 16s.fasta.align
```

You could manually type and execute the command for each alignment, but that would be tedious. Instead, let’s use a **for-loop**. 

For-loops not only expediate your analyses, they also decrease the chances that you’ll make a mistake, and make your analyses more reproducible. 

1.	Align all the files in your “Fasta” folder using the following code:

```
for locus in *.fasta*
do
./../../<MUSCLE> -in $locus -out $locus.align
done
```

This for-loop defines the variable “`locus`”. The `*` indicates that the loop should iterate through every file in the folder with the file extension “`.fasta`”. For each `.fasta` file in the folder, the loop runs MUSCLE, and creates an alignment with the extension “`.align`”. Once all alignments are complete, the loop terminates. For more information on for-loops, see the [command line basics](https://github.com/ddecarle/eeb462-2021/blob/main/CommandLineBasics.md) page. 

2.	Once you have all your alignments, create a new folder for them, and move them all to their new home: 

```
mkdir ~/Desktop/EEB462/LabOne/Alignments
mv *.align ~/Desktop/EEB462/LabOne/Alignments 
```

### Concatenating sequences

Now that you have your alignments, you’ll need to **concatenate them** into a data matrix that you can use to build phylogenetic trees. In essence, this is like stringing all the sequences for an organism together into one long gene. 

In this section, we’ll create the files we’ll need for the next three labs:
NEXUS files:

- All nucleotide sequences concatenated (COI, 16S, 18S, ENAM)
- All nucleotide and protein sequences concatenated (COI-protein, 16S, 18S, ENAM)
- Nucleotide sequences for three loci (16S, 18S, ENAM)
- Protein sequences only (COI-protein)

The reason we’ll need so many files is that many phylogenetic inference programs treat a combination of different data types (in this case, nucleotide and amino acid sequences) in their own idiosyncratic ways. This will all be demystified in the weeks to come. 

1.	Start by opening the program Mesquite. 

Making the protein-only file will be easiest, so we’ll start with that. 

2.	Click File > Open File… 
- Select the coi-protein file 
- In the “**Translate File**” window that appears, select “**FASTA (protein)**” and click “**OK**”. 
- A dialogue box will appear asking you to save your file. Save it as “`coi-protein.nex`”. 

Now, you should see your character matrix colour-coded by amino acid, with the site/character numbers along the top. This is a very useful way to visualize alignments. Use this alignment to answer the next few questions. 

---

#### QUESTION 3: 
How many characters are in your alignment? Are there any gaps? *(1 point)*

#### QUESTION 4: 
Are the following sites “parsimony informative”: a) 17, b) 23, c) 30, d) 42? Why or why not? *(4 points)*

---

3.	Close “coi-protein.nex”. 

Now, you’re going to create your first concatenated matrix. The first step in this process is to open one of your alignments in Mesquite. Generally, you want to start with the locus that has least missing data. 

4.	Open “16s.fasta.align” in Mesquite. Select “**FASTA (DNA/RNA)**” from the pop-up window.
- Save the file as “16s.nex”. 

On the left side of the screen, you should notice the words “Taxa (36 taxa)” followed by “Character Matrix…”. 

5.	Click on “**Taxa…**” > “**Rename Taxa Block**”, and rename it “16s”. 
- Do the same for “**Character Matrix**”.

Renaming these elements makes the rest of the concatenation process much easier. It also makes the resulting NEXUS file more legible. 

6.	**File** > **Include File…** and select “enam.fasta.align”.
Again, select “**FASTA (DNA/RNA)**” and rename the **Taxa Block** and **Character Matrix**.

7.	Repeat the process for the 18S alignment. 

Now that you have the three alignments open, it’s time to make **associations** between them. 

8.	Select **Taxa&Trees** > **New Association…**
- Choose “16s” as your first block for the association, and choose “enam” as the second. 
- Name the association “16s-enam”. 

You should be taken to a window that lists all the taxa in the “16s” block on the left, and contains columns labelled “Group” and “enam” (highlighted in yellow). The taxa in the “enam” block should be listed in the rightmost column. 

9. Click the title of the yellow “**enam**” column > **Auto-assign Matches…** 

Since the names of all taxa in both alignments should be the same, simply click “**OK**” in the box that appears. 

The “enam” column should now be populated with the names of all taxa for which ENAM sequences are available. 

10.	Repeat step nine to create an association between 16S and 18S. 

Now save this file: we’ll come back to it later. 

11.	**File** > **Save File As…**
Save the file as “16s-enam-18s-MAIN.nex”

This file is useful for our purposes, because we can easily come back to it and change only one aspect of our character matrix. Unfortunately, is not readable by the programs we’re going to use. Therefore, you’ll have to generate a **“Fused” NEXUS file**.

12.	**File** > **Export…** > **Fused Matrix Export (NEXUS)** > **OK**
- Unselect “Generate MrBayes block” 
- Export
- Select 16S as the master block of taxa
- Save the file as “16s-enam-18s-fuse.nex”

13.	Now, we'll be adding more loci to our MAIN file 
- Select **File** > **Include File…** > coi-barcode.fasta.align
- Rename the Taxa Block and Character Matrix as before.

14.	Create an association between 16S and COI.

15.	**File** > **Save File As…** > “16s-enam-18s-coi-MAIN.nex”

16.	**File** > **Export…** > **Fused Matrix Export (NEXUS)**
- Select 16S as the master block of taxa
- Save the file as “16s-enam-18s-coi-fuse.nex”

17.	Next, we’ll have to generate yet another type of NEXUS file for use in the program MrBayes. Open “16s-enam-18s-coi-fuse.nex”
- Because Mesquite is slightly buggy, you may see an alert like the one to the right. Simply click “OK” and save a new copy of the file. I usually just overwrite the file I currently have open. 

18. Generate a simplified NEXUS file as before:	**File** > **Export…** > **Simplified NEXUS**
Save the file as “16s-enam-18s-coi-fuseSimp.nex” 

19.	Close the file.

---

#### QUESTION 5: 
Open “16s-enam-18s-coi-fuse.nex” and “16s-enam-18s-coi-fuseSimp.nex” in your text editor. Name at least 3 ways in which the Fused NEXUS file differs from the Simplified NEXUS file.  *(3 points)*

---

Now there’s only one file to go. 

20.	Open “16s-enam-18s-MAIN.nex”... again. 

21.	Include the file “coi-protein.fasta.align” 
- Select the correct interpreter for the file
- Rename the **Taxa Block** and **Character Matrix**. 

22.	Create an association between 16s and the COI protein alignment. 

23.	**File** > **Save File As…** > “16s-enam-18s-coiProt-MAIN.nex”

24.	Export the file as a Fused NEXUS file. 
- In the dialogue box that appears, make sure to check the box that says, “**Permit fused matrix with mixed data types…**” is selected. 
- Leave the “**Generate MrBayes block**” box selected as well. 
- Save the file as “16s-enam-18s-coiProt-fuse.nex”

Mercifully, we are now finished with Mesquite. You may close the program. 

---
#### QUESTION 6: 

How long is each of the following alignments (*i.e.* how many characters does each have)? *(2 points)*

- 16S
- 18S
- ENAM
- COI (nuceotides)
- COI (amino acids)

---

### Tidying up

Before you go, you’ll have to organize your files. 

1.	**Use the command line** to create a new folder within `~/Desktop/EEB462/LabOne` called “NEXUS”. 
- Within the “NEXUS” folder, create sub-folders called “Main”, “ML” and “MrBayes”. 

2.	Move all “MAIN” files to “Main”.

3.	Move “16s-enam-18s-coi-fuseSimp.nex” and “16s-enam-18s-coiProt-fuse.nex” to “MrBayes”.

4.	Move the remaining NEXUS files (“coi-protein.nex”, “16s-enam-18s-fuse.nex”, and “16s-enam-18s-coi-fuse.nex”) to “ML”. 

---

#### QUESTION 7: 

What commands did you use to complete the tasks above? *(4 points)*

---
#### BONUS QUESTIONS:

1. Name all the phyla to which the animals in the figure at the top of the page belong.

2. When exporting files in Mesquite, you have the option to “Convert gaps to missing”. This indicates that we want to consider gaps in our alignment to represent missing data. 
a) What is the alternative to this? 
b) What is one reason why we might want to code gaps as missing data? 
c) What is one reason why we might not want to do this? 
