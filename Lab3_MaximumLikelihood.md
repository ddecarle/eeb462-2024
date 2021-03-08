# Lab Three: Model Testing & Maximum Likelihood

### Introduction

Today marks your first foray into model-based phylogenetic analyses. 

Of course, before you can conduct a model-based analysis, you must first determine which model of evolution to use. In this lab, we'll learn the basics of model testing, and maximum likelihood tree inference. We'll also **compare trees using topology tests**. 

#### Why use models?

As we discussed in [Lab Two](https://github.com/ddecarle/eeb462-2021/blob/main/LAB2_Parsimony.md), the assumptions of parsimony are rarely - if ever - met in real datasets. Two of these assumptions are particularly improbable: i) all character state changes are equally likely, and ii) unless there is evidence to the contrary, characters with the same state are homologous.

The use of models in phylogenetic analysis addresses these assumptions. Models assign probabilities to the rates at which characters change over time, and have differing number of parameters to describe changes between character states and the rates at which these changes occur. The actual values (*i.e.* probabilities) for these parameters may be fixed, or they may vary according to a distribution.

We can then evaluate the overall likelihood of a particular tree - taking into account both the topology and the branch lengths - according to the model (and its parameter values) and your dataset. 


#### Assumptions of Maximum Likelihood in phylogenetic analyses

Maximum likelihood analysis involves a few key assumptions: 

1.  **Statistical consistency**: The larger your dataset, the more your results will converge on the truth. 

    Although this concept is widely used in statistics broadly, but its relationship to phylogenetic analysis is rather complicated. We'll talk more about this in future labs. 
  
2. Evolution produces fully bifurcating trees

    As with parsimony analysis, we can produce consensus trees for maximum likelihood analyses, so you may see ML trees that contain polytomies. However, any individual ML tree search will always return a topology that is fully resolved.   

3. Your model of evolution is accurate.

    It's highly unlikely that any of our models completely captures the process of evolution. In spite of that, however, we often converge on the same - or similar - answers using different models and/or independent datasets; for the purposes of this class, you don't have to worry about this too much.

### Lab Assignment Three:

Questions: *(23 points total)*

 - [1](#question-1), [2](#question-2), [3](#question-3), [4](#question-4), [5](#question-5), [6](#question-6), [7](#question-7), [8](#question-8), [9](#question-9)
 - [Bonus Question](#bonus-question)

## Table of Contents

- [Software](#software)
- [Tutorial](#tutorial)
  - [Using IQ-TREE](#using-iq-tree)
  - [Partitioning Your Dataset](#partitioning-your-dataset)
  - [Model Testing, Tree Inference, and Bootstrapping](#model-testing-tree-inference-and-bootstrapping)
  - [Combining Multiple Data Types](#combining-multiple-data-types)
  - [Topology Tests](#topology-tests-comparing-trees-statistically)
- [Appendix A: Constrained Tree Searches in IQ-TREE](#appendix-a-constrained-analyses-in-iq-tree)
- [Appendix B: Is Model Testing Necessary?](#appendix-b-is-model-testing-actually-necessary)

## Software

For this lab, we'll be using the following software:

- [IQ-TREE](http://www.iqtree.org/)
- [FigTree](http://tree.bio.ed.ac.uk/software/figtree/)
- a plain-text editor of your choice

**NOTE:** The IQ-TREE documentation is great. Seriously. I wrote [a whole rant about it](#using-iq-tree) below. 


## Tutorial

Begin by downloading and unzipping all necessary files from the Lab Three section of the Modules tab in Quercus. 

1. Locate the "NEXUS/ML" folder you created as part of [Lab One](https://github.com/ddecarle/eeb462-2021/blob/main/LAB1_characterMatrices.md) 
2. Copy `16s-enam-18s-coi-fuse.nex` into the "LabThree/allNuc" folder
3. Copy `16s-enam-18s-fuse.nex` and `coi-protein.nex` into "LabThree/nucProt"
4. Move the "LabThree" folder into the "EEB462" folder on your desktop
5. Move the IQ-TREE executable to the "LabThree" folder 


### Using IQ-TREE

IQ-TREE is a user-friendly command line program that can conduct many analyses useful for pretty much every aspect of tree-building. In addition to performing maximum likelihood tree searches, IQ-TREE can also be used for model testing, comparing topologies, ancestral sequence reconstruction, and more. 

Unlike the programs we have used so far, IQ-TREE is not particularly interactive: instead, every element of your analysis should be specified as part of the same command. This may make IQ-TREE a little harder to learn, but it makes automation much easier. 

The basic syntax for an IQ-TREE command is as follows:

```
./iqtree -s <alignment> [option1] [option2] ...
```

**The [IQ-TREE Documentation](http://www.iqtree.org/doc/) is a really excellent resource**. It contains several tutorials, as well as thorough explanations of all analyses. It often includes links to papers and blog posts which explain the analyses in more detail. (The blog posts are particularly great, because they're written in plain-language.)

For our purposes, the [Command Reference](http://www.iqtree.org/doc/Command-Reference) will especially useful: it contains detailed information about the various options, and provides many examples.

[back to top](#table-of-contents)

### Partitioning Your Dataset

Before we determine the best model for our analyses, we'll need to define the different partitions in our dataset. In other words, we need to tell IQ-TREE where each locus begins and ends in our concatenated alignment(s). In additioning to partitioning a dataset into loci, one can further partition protein-coding loci into codon positions. 

Given this information, IQ-TREE will determine the model that best explains each partition, then determine the optimal number of partitions (*i.e.* whether all the possible partitions you specified are actually necessary).

For more information about the effects of partitioning on tree inferences, see this paper by [Kainer & Lanfear (2015) - *Molecular Biology and Evolution*](https://academic.oup.com/mbe/article/32/6/1611/1068429).

---

#### QUESTION 1

Why do we partition our dataset before model testing? Why might we want to partition protein-coding loci into individual codon positions? *(2 points)*

---

To define the partitions in our dataset, we will need to create a NEXUS file that tells IQ-TREE where each of our partitions begin and end.

1. Open `16s-enam-18s-coi-fuse.nex` in your text editor and locate the "LABELS" block. 

  (Remember that "blocks" are sections of a NEXUS file starting with `BEGIN <block-name>;` abnd ending with `END;`.)
  
2. In another window of your text editor, open the file `nucPartition.nex`.

3. Replace each instance of `XXX` in `nucPartition.nex` with the corresponding values from the "LABELS" block in `16s-enam-18s-coi-fuse.nex`. 

    Make sure there are no spaces on either side of the hyphens. 
  
    You'll notice that there are three designated partitions for each of the coding loci: one for each codon position. The number to the right of the hyphen (*i.e.* the end point of the locus) will be the same for all three partitions, but the number to the left of the hyphen should increase by one for each consecutive position. The number after the slash indicates that we are only interested in every third character. In other words, we're specifying that `coi1` consists of every third nucleotide from sites 1-659; `coi2` is every third nucleotide from sites 2-659, and so on. 

    For example, if COI spanned characters 1-659 in your alignment, your partitions would be specified like this:

    ```
    charset coi1 = 1-659\3;
    charset coi2 = 2-659\3;
    charset coi3 = 3-659\3; 
    ```
  
4. Save and close `nucPartition.nex`. 

[back to top](#table-of-contents)

### Model Testing, Tree Inference, and Bootstrapping

One of the perks of using IQ-TREE is that it can run model testing, tree inference, and bootstrapping in one fell swoop. 

1.	Open a terminal window, and navigate to the “LabThree/allNuc” folder. 

  - MacOS: `cd ~/Desktop/EEB462/LabThree/allNuc`
  - Windows: `cd /mnt/c/Users/<your-username>/Desktop/EEB462/LabThree/allNuc`

2. Run IQ-TREE using the following command:

    Mac: 
`./../iqtree -s 16s-enam-18s-coi-fuse.nex -spp nucPartition.nex -m TESTMERGE -mset mrbayes –ninit 100 -bb 1000 -wbt`

    Windows: 
`./../iqtree.exe -s 16s-enam-18s-coi-fuse.nex -spp nucPartition.nex -m TESTMERGE -mset mrbayes –ninit 100 -bb 1000 -wbt`

After executing this command, you should see some sign that IQ-TREE is working (or you'll get an error message). While you’re waiting for IQ-TREE to finish running, let’s break down that command a little:

  - `-s`: specifies the alignment you want to use for your analysis
  
  - `-spp`: specifies a partition file, and indicates that you wish to allow for the possibility that each partition evolves at a different rate
  
  - `-m`:	indicates that we want to perform model testing:
  
    - The option `TESTMERGE` indicates two things: 
      - We want to use the results of this test to immediately perform a tree search once model testing is completed
      - IQ-TREE should attempt to merge all proposed partitions to minimize the total number of partitions used in the analysis: this reduces the amount of necessary computing power and helps to avoid over-parameterization of the model.

  - `-mset`:	tells IQ-TREE to test only a subset of all possible models
  
    - In this case, we only want to entertain models that are implemented in MrBayes (the software we’ll be using in Lab Four). **For morphological data**, use the option `-mset MK`.

  - `-ninit`: specifies the number of replications the heuristic search should run
  
    - For the purposes of the lab, 100 replications are used to save time. Ideally (and for your project), you would use a more thorough search – e.g. 1000 replications or more.

  - `-bb`: specify the number of bootstrap replicates 
  - `-wbt`: save bootstrap trees to a file ending in `.ufboot`

Once IQ-TREE has finished running, you’ll see that it has generated a number of output files. The log file (`nucPartition.nex.log`) very helpfully contains a description of the information stored in each file. 

3. Generate a 50% majority rule bootstrap consensus tree using the following command: 

    Mac: 
`./../iqtree -t *.ufboot -con -minsup 0.5`

    Windows: 
`./../iqtree.exe -t *.ufboot -con -minsup 0.5`

---

Use the output files to answer the following questions:  

#### QUESTION 2 

What model partitioning scheme was used to conduct the tree search? Why are some loci treated as different partitions if they are ascribed the same model of evolution? *(3 points)*

#### QUESTION 3 

Examine `nucPartition.nex.iqtree`. What is the difference between the maximum likelihood tree and the consensus tree (in terms of how each is generated)? What is the log likelihood score of each? Which would you choose to include in a paper, and what is your justification for this choice? *(4 points)*

---

[back to top](#table-of-contents)

### Combining Multiple Data Types

In IQ-TREE, the main difference between analyses using one type of data and those using multiple types is the formatting of the partition files. 

IQ-TREE is unable to process a single matrix containing more than one type of data. Instead, it requires that different data types be stored in different files. This is why we generated both `16s-enam-18s-fuse.nex` and `coi-protein.nex`. 

1. In the "LabThree/nucProt" folder, open both matrices as well as `nucProtPartition.nex` in your text editor. 

2. Fill in the partition file as before. (Since the COI protein alignment only consists of one locus, the  "partition" should just be the total length of the alignment.) Save `nucProtPartition.nex` and close it.

    You'll notice that, in addition to the names of the loci, this partition file also denotes the name of the file where each partition can be found. 

3. Run IQ-TREE using the same options as before. Even though our alignments are located in multiple files, we only need to specify one of them in the IQ-TREE command. (It doesn't matter which alignment file you choose.)

    Mac: 
`./../iqtree -s 16s-enam-18s-fuse.nex -spp nucProtPartition.nex -m TESTMERGE -mset mrbayes –ninit 100 -bb 1000 -wbt`

    Windows: 
`./../iqtree.exe -s 16s-enam-18s-fuse.nex -spp nucProtPartition.nex -m TESTMERGE -mset mrbayes –ninit 100 -bb 1000 -wbt`

---

#### QUESTION 4 

Compare the consensus trees generated by the all nucleotide dataset and the combined nucleotide and protein dataset. Consider the following questions: Are all groupings (as defined in `data.xlsx`) monophyletic? Do support values vary across trees? How much do the topologies differ? Upload both trees as part of your assignment: either as a screenshot or a separate file. *(4 points)*

#### QUESTION 5

How do the two trees generated under the maximum likelihood optimality criterion differ (*e.g.* in terms of topology and support) from the parsimony trees you generated last week? *(1 point)*

#### QUESTION 6

Overall, you should have noticed that the bootstrap values are higher for maximum likelihood trees than for parsimony trees generated using the same dataset. What are some possible reasons for this trend? Think about the problem in a general sense, rather than in the context of your specific dataset. *(2 points)*

#### QUESTION 7

What do branch lengths represent on a maximum likelihood tree? How does this differ from the branch lengths on a parsimony tree? *(2 points)*

---

[back to top](#table-of-contents)

### Topology Tests: Comparing Trees (Statistically)

By now, you will have realized that it’s easy enough to compare trees in a qualitative sense, but comparing them quantitatively is complex. 

Are trees generated under different optimality criteria directly comparable? What about trees generated under the same optimality criterion using different datasets? Are support metrics – such as bootstrap values – comparable between trees? The answer to all these questions is, unfortunately, no.

To quantitatively assess whether topologies are significantly different from one another, the Shimodaira-Hasegawa (SH) and Approximately Unbiased (AU) tests are frequently used ([Shimodaira & Hasegawa, 1999](https://www.researchgate.net/publication/31240073_Multiple_Comparisons_of_Log-Likelihoods_with_Applications_to_Phylogenetic_Inference); [Shimodaira 2002](https://www.researchgate.net/publication/11294828_An_Approximately_Unbiased_Test_of_Phylogenetic_Tree_Selection)). For a thorough review of these tests, as well as their hypotheses, applications, and underlying assumptions, see [Goldman et al. (2000) - *Systematic Biology*](https://www.researchgate.net/publication/11263157_Likelihood-based_tests_of_topologies_in_phylogenetics). 

#### How does it work?

All of these analyses operate under the **null hypothesis** that, given the model, all topologies are equally well supported by the data. 

The **alternative hypothesis** is that - given the model - at least one topology is a significantly worse explanation of the data. 

The test proceeds as follows: 

1. Calculate the difference in log-likelihood (&#948;) between the toplogies of interest.
2. Using bootstrap replicated datasets, generate an expected distribution of &#948;.
3.	For each topology, determine whether the true value of &#948; falls outide the expected distribution of values for &#948;. 
4. If so, the null hypothesis is rejected, and we can conclude that at least one of the trees is a significantly worse explanation of the dataset.

The main difference between the SH and AU tests is that **the AU test corrects for multiple comparisons**. In other words, when comparing more than two topologies at a time, the AU test should be used. 

IQ-TREE can conduct SH and AU tests simultaneously. The results of the tests are expressed as standard *p*-values, wherein values less than 0.05 can be considered significant. Remember that, in this case, **a significant *p*-value indicates that the tree is worse than at least one of the other trees compared**. 

#### Let's do this... 

For this section of the tutorial, you’ll be conducting topology tests to compare the ML tree you just generated (using the nucleotide dataset) to the most parsimonious tree, and the constrained tree you generated last week using the same dataset.

Topology tests require the following input files: 

- The matrix used to generate the trees
- The partition file, if applicable
- A file containing all the trees (in newick format) you want to compare 

**NOTE:** Newick is simply a particular file format for phylogenetic trees. Trees can be easily converted to Newick using FigTree: Simply open your tree in FigTree, select “File > Export trees…” and select “Newick” from the drop-down menu. You can also use this feature to convert your trees to other formats, such as NEXUS. 

Conveniently, IQ-TREE outputs all topologies in Newick format. Trees resulting from TNT analyses, however, need to be converted. I’ve already done this for you, so the “topologyTest” folder should already contain two trees in Newick format: `MPconsensus.new”`and `MPconstrain.new`. 

1. Copy `16s-enam-18s-coi-fuse.nex`, `nucPartition.nex.contree`, and `nucPartition.nex.best_scheme.nex` from the "allNuc" folder into "LabThree/topologyTest"

    `nucPartition.nex.best_scheme.nex` contains the results of the model testing from our first tree search. The file is very similar to the first partition file we generated, but it includes an additional command to specify which models should be applied to each partition.

2. Concatenate all three trees into the same file for analysis: 

- in your terminal window, navigate to "LabThree/topologyTest"
- use the following commands to combine your trees into one file:

    ```
    cat nucPartition.nex.contree >> allTrees.txt
    cat *.new >> allTrees.txt
    ```
3. Run your topology test

    Mac: `./../iqtree -s 16s-enam-18s-coi-fuse.nex -spp nucPartition.nex.best_scheme.nex -z allTrees.txt -n 0 -zb 10000 -au`
    
    Win: `./../iqtree/exe -s 16s-enam-18s-coi-fuse.nex -spp nucPartition.nex.best_scheme.nex -z allTrees.txt -n 0 -zb 10000 -au`

As before, let’s break down that command: 
The `-s` and `-spp` options are used exactly as before to specify the matrix, partition file, and models.

- `-z`: specifies the file containing the trees you wish to compare
- `-n 0`: indicates that you do not wish to do a ML tree search as part of this analysis
- `-zb`: determines the number of bootstrap datasets you wish to generate. 10,000 is the recommended minimum value
- `-au`: tells IQ-TREE to conduct an AU test in addition to the other topology tests

Once your analysis is complete, the results of the topology tests will be printed to the file `nucPartition.nex.best_scheme.nex.iqtree`. You can find them under the heading `USER TREES` in a conveniently formatted table with a nice little legend underneath. (For the purposes of this lab, ignore the results of the RELL, KH, and ELW tests.)

---

#### QUESTION 8

What do the results of the topology test show? *(2 points)*

#### QUESTION 9

Are there any elements of this test that may bias the results for or against trees generated under parsimony or likelihood? *(3 points)*

---
[back to top](#table-of-contents)

## Appendix A: Constrained Analyses in IQ-TREE

When exploring various phylogenetic hypotheses for a given group, you may wish to conduct constrained analyses similar to the ones we generated using TNT last week. 

In IQ-TREE, this process is simple. 

First, you will need to generate a constraint tree in Newick format. The tree can either encompass all taxa, or only a subset of them. If you wanted to constrain hedgehogs and pangolins to form a monophyletic group sister to whales, for example, your constraint tree would look like this:

`((hedgehog, pangolin), whale);`

Save your constraint tree in the same folder as your matrix and partition file (if applicable). 

When running your tree search, use the option `-g` to indicate that you want to run a constrained analysis, and add it to the command you used to run your original tree search. For example, to run a constrained analysis on the nucProt dataset, you could use the following command: 

Mac: 
`./iqtree -s 16s-enam-18s-fuse.nex -spp nucProtPartition.nex -m TESTMERGE -mset mrbayes –g <constraint_tree_file> –ninit 100 -bb 1000 -wbt`

Cygwin: 
`./iqtree.exe -s 16s-enam-18s-fuse.nex -spp nucProtPartition.nex -m TESTMERGE -mset mrbayes –g <constraint_tree_file> –ninit 100 -bb 1000 -wbt`


---

#### BONUS QUESTION

Identify the order that is recovered as polyphyletic in both ML trees you generated today. Conduct a tree search using the “Nucleotide” dataset that constrains this order to be monophyletic. Then, conduct a topology test: Are the constrained and unconstrained trees significantly different from one another? 

---

[back to top](#table-of-contents)

## Appendix B: Is Model Testing Actually Necessary? 

Model selection can take a very long time, especially for larger datasets. Not to mention that, the more trees you build, the more you'll notice that GTR models are selected *at least* half the time, if not more often. 

If that's the case, can't we just choose a GTR model *a priori* and do away with the whole process? 

This paper by [Abadi & al. (2019) - *Nature Communications*](https://www.nature.com/articles/s41467-019-08822-w) seemed to suggest that model testing may not actually be mandatory. However, subsequent work has revealed several holes in their study. 

As it turns out, model choice does indeed impact tree topologies. Furthermore, forgoing model selection and choosing complex models (such as GTR) *a priori* can be more computationally intensive than simply doing the model testing and performing the tree search with a simpler model. See [this blog post](https://www.michaelgerth.net/news--blog/why-we-should-not-abandon-model-selection-in-phylogeny-reconstruction) and [the resulting manuscript](https://www.biorxiv.org/content/10.1101/849018v1) from Michael Gerth for more details. 

**TL;DR** Yes, you should do model testing.
 
[back to top](#table-of-contents)
