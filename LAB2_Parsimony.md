# Lab Two: Parsimony 

*Tutorial by Danielle de Carle*

### Introduction

#### Assumptions of Parsimony

Maximum parsimony derives from Occam's Razor: a principle which states that "entities should not be multiplied without necessity". For our purposes, "entities" refer to evolutionary events, or character changes.

Following from that, parsimony has three main assumptions:

- In the absence of evidence to the contrary, assume homology
- All characters are equally informative 
- All character state changes are equally likely

The last two assumptions, while common, are not universal. Characters or state changes may be weighted or ordered in order to better reflect our understanding of evolution.  

When assigning **weight** to certain characters, we assume that changes to some characters "cost" more than changes in others. For example, you may decide that a change in the colouration of an insect is twice as likely as a change in the number of eyes it has. You would therefore assign the "eyes" character a cost of two, meaning that any change adds two steps to the total length of the tree (rather than one, as a change in colour would). Weights can also be applied to character state changes - *e.g.* our insect may be more likely to lose eyes than gain them, or - for nucleotide data - transitions may be twice as likely as transversions. Finally, we may decide to **order** character state changes, so that evolutionary changes are restricted to follow a certain path. For example, we may decide that flowers cannot change from white to purple without first becoming red, or that lizards may lose their legs but not regain them. 

#### Parsimony: a dirty word?

In contemporary systematic research, parsimony trees are seldom used as a final product. The primary reason for this is that the fundamental assumption(s) of parsimony are demonstrably false in many situations: it is possible to more accurately estimate the process of evolution using statistical models. (The secondary reason is a colossal nerd war that took place in the '90s.) 

It also bears noting that parsimony can outperform likelihood for particular datasets, or when specific types of evolutionary processes are at play, but the degree to which these issues apply to real datasets or affect the quality of our phylogenetic inferences is debatable. For an approachable exploration of the biases toward which both parsimony and likelihood are prone, see [Swofford et al. 2001](https://www.jstor.org/stable/pdf/3070852.pdf?casa_token=m9pL7EqYpkgAAAAA:Yel2SDyznRU-RIrrcG2ttZJA0W926pfuWDu19qPuGeLFuUv9ozlXsw8uYtEuwqCsMPS9mhjnyjIA9DTQ6FhaR7uZwnkrHgrc9t9bJMNIwA5DYqxoZr7w).

Philosophical considerations aside, **parsimony has two considerable advantages**:

1. Parsimony is (comparatively) fast

    Because of its speed, parsimony is particularly useful for assessing the quality of your data before running a more computationally intensive analysis (*e.g.* Bayesian inference), and for analyses that require the generation of many trees (*e.g.* when running simulations)

2. Parsimony trees are a direct representation of the data in your matrix

    If your analyses recover relationships that seem at odds with your expectations, a parsimony tree will help you pinpoint the particular taxa or data driving that relationship. If nothing in your alignment(s) or parsimony tree(s) seems out of place, the problem is likely to be with your model or the way you have parameterized your analyses. 
    
Today, we will be learning to conduct parsimony analyses using PAUP*, and touch on some other features you may find likely for your project: scripting and constrained analyses.  


### Lab Assignment Two:

Questions: *(21 points total)*

 - [1](#question-1), [2](#question-2), [3](#question-3), [4](#question-4), [5](#question-5), [6](#question-6), [7](#question-7), [8](#question-8), [9](#question-9), [10](#question-10)
 - [Bonus Question](#bonus-question)

## Table of Contents
- [Software](#software)
- [Tutorial](#tutorial)
  - [Using TNT](#using-tnt) 
  - [Parsimony Analysis 101](#parsimony-analysis-101)
  - [Examining Trees](#examining-trees)
  - [Combining Multiple Data Types](#combining-multiple-data-types)
  - [Constrained Analyses](#constrained-analyses)
- [Appendix A: The Script Explained](#appendix-a-the-script-explained)
- [Appendix B: Making TNT files](#appendix-b-making-tnt-files)

## Software

For this lab, we will be using the following software: 

- [TNT](http://www.lillo.org.ar/phylogeny/tnt/)
- [Python](https://www.python.org/downloads/)
    - Folks using MacOS will already have Python on their computers
    - Windows users can install Python through the [Windows App Store](https://www.microsoft.com/en-ca/p/python-39/9p7qfqmjrfp7?activetab=pivot:overviewtab)
- [FigTree](http://tree.bio.ed.ac.uk/software/figtree/)
- A plain text editor of your choice 

**A word of warning:** TNT is a bit of a beast: it has no real manual, the interface is unintuitive, and it's rather buggy. We put up with these shortcomings, however, because TNT is very powerful: its tree searching algorithm is more thorough and more efficient than any other commonly used software.

As you struggle through this lab, please know that I’ve done everything I can to alleviate your suffering. Power through, and you will be rewarded with unbridled knowledge (of phylogenetic analysis using TNT).   

## Tutorial

To begin this tutorial, download and unzip all the files under the Lab Two section of the Modules tab in Quercus. Your Lab Two folder should contain the following items:

- allNuc 
  - `16s-enam-18s-coi.tnt`
  - `STATS.RUN`
- nucConstrain
  - `16s-enam-18s-coi.tnt`
  - `STATS.RUN`
- nucProt
  - `16s-enam-18s-coiProt.tnt`
  - `STATS.RUN`
- `tnt_tree_clean.py`
- `tnt.command` (for MacOS)
- `tnt.exe` (for Windows)
- `TNTscript.run`

### Using TNT

The basic format for any TNT command is `<command> <option>;` - *e.g.* `log parsimonyAnalysis.txt;`

When specifying more than one option for the same command, the format is as follows: 
`<command>: <option 1> <value> <option 2> <value>…;` - *e.g.* `xmult: replic 1000 ratchet 5 fuse 5 hits 10;`

It is particularly important to note that **every command ends with a semicolon**.

For this lab, we'll be using a script to run analyses in TNT, so you shouldn't run into *too* many problems, but if you need more information, you can bring up the "help" page for any command like so: `help <command>;` - *e.g.* `help taxonomy;`.

The first time you use TNT, you may be asked to agree to their terms of service. If so, follow the prompts on the screen until your terminal window looks something like this:

<p align="center">
  <img width="576" height="394" src="https://github.com/ddecarle/eeb462/blob/master/Screen%20Shot%202021-02-03%20at%2002.04.10.png">
</p>

**CAUTION:** If you want to resize your terminal window, do so ***before*** opening TNT. Resizing it while tnt is running makes it break.

[back to top](#table-of-contents)

### Parsimony Analysis 101

1. Copy `TNTscript.run` to each of these three folders: allNuc nucConstrain, and nucProt

2. Move into the **allNuc** folder and open `TNTscript.run` in your text editor

You'll see a number of lines beginning with the word `quote` followed by a TNT command on the line below. TNT ignores all lines beginning with `quote`, so these lines simply explain what the following command is doing. All of these commands are explained in detail in [Appendix A: The Script Explained](#appendix-a-the-script-explained), but you'll only need to change a few of them for the purposes of this lab (and probably for analyses you run in the future). 

Before we begin, we'll have to make some changes to this script.

1. On **line 5**, replace `<log-name>` with an informative file name for this analysis 

2. On **line 14**, replace `<matrix.tnt>` with the name of our data matrix - `16s-enam-18s-coi.tnt`

3. Add `quote` to the beginning of **line 36**. During the lab, we'll only be running a short search, but for your project, you'll want to use a more rigorous search instead. The search settings listed here are a good guideline, but you may wish to use parameters that are more or less thorough. Ultimately, you'll want to strike a balance between the thoroughness of the search and the amount of time it takes to complete. 

4. Add `quote` to the beginning of **line 62**. Similarly to step 3, we'll  only have time to run a short bootstrap analysis during the lab, but you'll want to be more thorough later.

5. Save your changes.

Now it's time to **begin the analysis**. 

6. Open a terminal window and navigate to your allNuc folder. If the LabTwo folder is inside the EEB462 folder on your desktop, use the following commands:

  - MacOS: `cd ~/Desktop/EEB462/LabTwo/allNuc`
  - Windows: `cd /mnt/c/Users/<your-username>/Desktop/EEB462/LabTwo/allNuc`
 
7. Launch TNT

  - Mac: `./../tnt.command`
  - Win: `./../tnt.exe`

8. Once TNT is up and running, use the TNT script to execute your analysis: `run TNTscript.run;`

**A WORD OF WARNING:** Do NOT scroll in your terminal window while TNT is running. Scrolling makes it break.
  
When your analysis has finished, you should see the following message: 

```
RUN COMPLETE
CLOSING ALL OPEN FILES
tnt*>       
```

9. Exit TNT using the quit command: `quit;`

The last TNT idiosyncrasy that we will encounter (…hopefully), is the tree output. TNT prints its trees in a particular format that can’t be read by most other programs. Luckily, I’ve provided you with a script that converts the TNT tree format into a more legible tree file.

10. Run the tree conversion script: `python ../tnt_tree_clean.py`

---
#### QUESTION 1 
What is the length of the best scoring tree? *(1 point)*

#### QUESTION 2
How many MPTs were encountered? *(1 point)*

#### QUESTION 3
What are the CI and RI for your tree? *(1 point)*

---

[back to top](#table-of-contents)

### Examining Trees

1. Open `consensus_bootstraps.tnttre.tre` in FigTree

    A dialogue box will appear asking you to assign a name to the labels in the tree file. These labels are your bootstrap values: enter, “bootstrap” and click OK. 

FigTree allows you to customize many aspects of your tree’s appearance. You may wish to use these options when creating figures for your manuscript. 

2.	**Display bootstrap values** on your tree:

  - Tick the box next to “Node Labels”
  - Expand the “Node Labels” menu by clicking the arrow to the left
  - In the “Display” menu, select “bootstrap”

3.	**Reroot the tree**: Select a single taxon as the outgroup, and click the “Reroot” icon in the top left corner of the window. 

Use your tree to answer the following questions: 

---
#### QUESTION 4
Why is there no support value for the node connecting the outgroup to the remaining taxa? Was there a support value for the placement of this taxon before you rerooted the tree? *(2 points)*

#### QUESTION 5
Are any of the orders non-monophyletic? If so, which? Are they paraphyletic or polyphyletic? *(2 points)*

#### QUESTION 6
Which higher-level clade (i.e. smaller than infraclass, but larger than order) is not recovered? *(1 point)*

---

[back to top](#table-of-contents)

### Combining multiple data types

Today, we'll be working with files that combine nucleotide (DNA) and amino acid (protein) data, but the same principles apply for any combination of DNA, protein, and morphological data. For instructions on making TNT files with more than one type of data, see [Appendix B: Making TNT Files](#Appendix-b-making-tnt-files).

As before, we'll have to make some changes to our TNT script. 

1. Navigate to your nucProt folder and open `TNTscript.run` in your text editor. 

2. Make the following changes: 

  - On **line 5**, replace `<log-name>` with an informative file name 
  - On **line 14**, replace `<matrix.tnt>` with the name of the correct data matrix
  - Add `quote` to the beginning of **line 36** and **line 62**  (we'll be running shorter analyses again this time)
 
3. Save your changes.

4. Open a terminal window, navigate to your nucProt folder, and launch TNT as before

5. Use the TNT script to execute your analysis: `run TNTscript.run;`

6. When the analyses are complete, quit TNT (`quit;`) and use the script to reformat the trees: `python ../tnt_tree_clean.py`

---
#### QUESTION 7
Report the length of the most parsimonious tree, the number of trees encountered, the CI and RI for your new tree. *(3 points)*

---

7. As before, examine the tree in FigTree, making sure to re-root the tree using the same taxon. 

--- 
#### QUESTION 8
Contrast this tree with the one generated using an all-nucleotide alignment. Think about how support values may differ, in addition to the topology. Keep in mind the phylogenetic groupings mentioned in the data table (`data.xlsx`). *(4 points)*

---

[back to top](#table-of-contents)


### Constrained Analyses

Although Euarchontoglires (rodents, lagomorphs, treeshrews, colugos, and primates) is a considered to be a robust clade, neither of our analyses today recovered it. In situations such as this, you may wish to “constrain” your analysis to recover a given topology decided *a priori*. In this way, you can examine the effect of this constraint on your overall tree score, or on other aspects of the topology. 

1. Navigate to your nucConstrain folder and open `TNTscript.run` in your text editor. 

2. Make the following changes to the script:

  - On **line 5**, replace `<log-name>` with an informative file name 
  - On **line 14**, replace `<matrix.tnt>` with the name of the correct data matrix
  - Add `quote` to the beginning of **line 36** and **line 62**  (we'll be running shorter analyses again this time)
  
Now we'll make some changes specific to constrained analyses. For more detailed information about these commands, see [Appendix A](#appendix-a-the-script-explained).
 
3. Remove `quote` from the beginning of **line 27** and **line 28**

4. On **line 27**, replace `<tree>` with the following tree: `(hare rabbit macaque gibbon orangutan guineaPig porcupine vole mouse rat)` 

  This indicates that we ***only*** want TNT to recover trees in which members of the Euarchontoglires form a clade, but we ***don't*** want to specify what the relationships between any of those taxa should look like. **NOTE:** The bootstrap trees will also be generated using this constraint. 
  
5. Save these changes, and close the file. 

6. In your terminal, navigate to the nucConstrain folder; launch TNT; and conduct your analyses using hte script as before. 

7. Once the analysis is finished, quit TNT and run the `tnt_tree_clean.py` script to reformat your trees

8. Examine the trees and your log file(s) to answer the following questions:

--- 
#### QUESTION 9
What is the length of the tree recovered by the constrained analysis? How does that compare to the length of the unconstrained tree generated by the same matrix? Do you think this increase in tree length is significant? Does it change your feelings toward the findings of the unconstrianed analysis? *(3 points)*

#### QUESTION 10
Which (if any) of the trees you generated do you trust the most? Can you trust some parts of the tree(s) over others? What additional types of evidence might you examine to help you make a decision about the “true” systematic groupings? *(3 points)*

---

#### BONUS QUESTION

In the following tree, node x has a bootstrap support value of 90%. What topology did the other 10% of bootstrap trees support? Choose one of the following, and explain your answer.

<p align="center">
  <img src="https://github.com/ddecarle/eeb462/blob/master/Picture1.png">
</p>


 - a.	It is not possible to know
 - b.	Any other grouping not represented in this tree
 - c.	A sister group relationship between taxa A & C
 - d.	A sister group relationship between taxa B & C
 - e.	Other (explain your answer)

---

[back to top](#table-of-contents)

## Appendix A: The Script Explained 

**The following is an explanation of all commands in `TNTscript.run`.**

`log <log-name>.txt;` - opens a log file to record everything that is printed to our terminal while TNT is running, including stats and errors. **This is very important.**

`mxram 100000;` - increases the amount of RAM TNT is able to use. The default setting is pitifully small, so forgetting to change this setting is likely to crash the program. Don’t worry if your computer doesn’t have this much RAM: TNT will only use as much as it can. 

`rseed *;` - defines the starting tree for your analysis. Generally, we begin our tree searches with a random tree, but you can also specify a particular tree, or a specific tree number. Keeping track of the starting tree will help us repeat our analyses, or examine the effects of the starting tree on the result. 

`proc <matrix.tnt>;` - imports your data matrix

`taxname =;` - indicates that you want to retain the taxon names from your matrix. In TNT, you can refer to specific taxa by number, according to the order in which they are listed in your matrix (**numbering starts at 0** instead of one). For example, in `16s-enam-18s-coi.tnt`, sloth is taxon 0, hedgehog is taxon 1, macaque is taxon 2, etc. If you want to be able to refer to your taxa by name as well, you’ll need to use this command.

`hold 100000;` - sets an upper limit on the number of trees TNT can hold in memory. While performing a tree search, TNT all the most parsimonious trees (MPTs) as well as the trees to which those are being compared. It is a good idea to set this limit high so as to minimize the chances that it will be hit during your analysis. 

`tsave *mpts.tnttre;` - creates a file to contain all the most parsimonious trees (MPTs) recovered by your tree search.

The next two commands are used for constrained tree searches only: 

`force = <tree>;` - specifies the constraint tree. During tree searches, TNT will only recover trees corresponding to the topology indicated to the right of the equals sign (*i.e.* the constraint tree). The topology must be in **bracket notation**, and can encompass all taxa in your dataset, or just a subset of them. You can refer to the taxa in this tree using their names as well as their corresponding numbers: for example, if you wanted to find the shortest tree in which sloths were the sister group to a clade composed of hedgehogs and macaques, you could use either of the following commands: `force = (sloth (hedgehog macaque));` or `force = (0 (1 2);`. 

`constrain =;` - indicates that the constraint tree should be enforced during the tree search

`xmult: replic 100 ratchet 5 nodrift nofuse fits 10;` - specifies parameters for a fast heuristic search: our search should consist of 100 replications. Each replication should consist of 5 iterations of the ratchet, followed by 5 rounds of tree fusing. The final option stipulates that the search should finish early if the best tree length is encountered 10 times.

`xmult: replic 1000 ratchet 5 nodrift fuse 5 hits 10;` - specifies parameters for a thorough heuristic tree search

`xmult;` - begins the heuristic tree search

`save;` - saves the MPTs

`tsave/;` - closes the tree file

`nelsen *;` - generates a strict consensus of all trees in memory (in this case, all MPTs recovered during your search)

`tchoose /;` - retains only the newest tree (the strict consensus) and discards the others from memory

`tplot;` - plots the tree

`run STATS.RUN;` - calls the `STATS.RUN` script to calculate consistency and retention indices (CI & RI)

`ttags =;` - indicates that "tree tags" should be saved (in this case, that will be bootstrap support values)

`blength *0;` - indicates that branch lengths should be saved

`tsave *consensus_bootstraps.tnttre;` - opens a file to contain the consensus tree with bootstrap values

`resample boot replic 100 [xmult = replic 5 ratchet 3];` - specifies parameters for a quick round of bootstrapping. Here, we'll be running 100 rounds of bootstrapping. The commands inside the square brackets specify the heuristic search settings for each round of bootstrapping (here, 5 replications with 3 rounds of the ratchet). 

`resample boot replic 1000;` - specifies parameters for more thorough bootstrapping. If there are no square brackets defining heuristic search parameters, TNT will use default settings to perform tree searches. The "gold standard" is to use the same settings you used for your initial tree search, but - especially for larger datasets - this can be prohibitively time-consuming. 

`save*;` - saves bootstrap values on the consensus tree

`tsave/;` - closes the tree file 

`ttags -;` - clear ttags

`log/;` - stop logging

`proc/;` - close the matrix

[back to top](#table-of-contents)


## Appendix B: Making TNT files

TNT files can be made in Mesquite using the same processes used in [Lab One](https://github.com/ddecarle/eeb462-2021/blob/main/LAB1_characterMatrices.md): 

1. Generate a **fused NEXUS file**

2. With that file open, select **File** > **Export...** > **TNT**

Unfortunately, if you want to create a TNT file that contains **multiple types of data**, Mesquite isn't quite up to the task. Instead, you'll have to follow these steps. For the sake of this tutorial, let's say we're working with two partitions: a nucleotide alignment of 3 loci - `16s-enam-18s.tnt` - and an amino acid alignment for one locus - `coi-protein.tnt`.

1. Generate TNT files for each partition

2.	In your text editor, open both files “16s-enam-18s.tnt” and “coi-protein.tnt”. 

TNT files can support partitioned data matrices. These partitions can contain the same types of data, or they can contain a mixture of data types. In the latter case, a few adjustments have to be made. 

32.	In “16s-enam-18s.tnt”, change “nstates” from “dna;” to “num 21;”. 

  This signifies that there are 21 different states in the matrix as a whole, but the matrix is neither strictly protein, nor strictly DNA. 

33.	Change the number of characters (*i.e.* the first number) on **line 3**   to reflect the fact that we are adding a new partition. The new number should be equal to the length of both character matrices added together.

34.	 Create a new line before the start of your character matrix that reads `&[DNA]`. 
The ampersand indicates the beginning of a new partition, while the text within the brackets tells TNT what type of data to expect.

35.	After the end of your DNA matrix (but before the semi-colon), paste your protein matrix, preceded by a line that reads `&[PROT]`. 

36.	Save the file as `16s-enam-18s-coiProt.tnt` and close your text editor. You can now use this file for analysis in TNT

[back to top](#table-of-contents)





