# Lab 7: Phylogenomics III - Gene Trees vs. Species Trees

*Tutorial by Viviana Astudillo-Clavijo*

### Background

Scientists have long differentiated between gene and species trees ([Maddison, 1997 – *Systematic Biology*](https://academic.oup.com/sysbio/article-pdf/46/3/523/19501929/46-3-523.pdf)). Gene trees represent allele relationships for a given gene, while species trees represents taxonomic relationships (*i.e.* between populations, species, genera, etc.). 

Because speciation events are often accompanied by the fixation of different alleles, gene trees are a useful proxy for inferring species relationships. Traditional molecular phylogenetic approaches (*e.g.* concatenation methods) infer species relationships by summarizing the allelic relationships of a subset of loci. The assumption is that the majority of base pair (bp) differences between species will be the result of fixation following the splitting of an ancestral population, and therefore the topologies supported by the largest number of bp differences should be a good approximation of species relationships. 

However, we now know that several common biological processes, such as **incomplete lineage sorting**, **hybridization** and **horizontal gene transfer**, can result in widespread disagreement between gene trees for different loci and between gene trees and the species tree (*i.e.* gene tree discordance). Gene tree discordance is particularly common in clades that experienced episodes of rapid diversification because the rapid splitting of populations leaves little time for the fixation of many different alleles before the next speciation event (*i.e.* incomplete lineage sorting).  

As a result, a whole suite of new methods for estimating species trees while accounting for gene tree discordance have been developed in the last few years. All of these approaches are consistent with the multi-species coalescent model and can be broadly grouped into two main types of methods: [**Summary Methods**](#summary-methods) and [**Co-Estimation Methods**](#co-estimation-methods) (**Fig. 1**).


<p align="center">
  <img src="https://github.com/ddecarle/eeb462-2021/blob/main/images/L7-Picture1.png">
  
</p>

| Figure 1 |
| ---- |
| &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Comparison of the steps involved in generating species trees using Summary & Co-Estimation methods &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | 

#### Summary Methods

These types of approaches estimate the species tree from a set of gene trees that were previously estimated using other methods (*e.g.* RAxML or Mr. Bayes). 

- **Input:** Gene trees. Some methods will accept gene trees with polytomies, while others will only accept fully resolved gene trees. 
- **Advantages:**
  - (i)	Fast and computationally feasible for hundreds to thousands of genes and taxa. 
  - (ii)	Consistent under the multi-species coalescent.
  - (iii)	Outperform traditional concatenation approaches in cases with high amounts of incomplete lineage sorting. 
- **Disadvantages:** 
  - (i)	Data loss due to the use of gene trees instead of full genes. 
  - (ii)	Difficult to account for gene tree estimation error as a source of gene tree discordance because usually only the best gene trees for each gene are used. 
  - (iii)	Assume that incomplete lineage sorting is the main source of gene tree discordance, and does not account for other sources, such as hybridization and horizontal gene transfer. Summary approaches can be misled when sources other than incomplete lineage sorting are responsible for gene tree discordance. 
  - (iv) Difficult to interpret branch lengths 
- **Some summary-based methods:** ASTRAL, MP-EST, STAR.

#### Co-Estimation Methods

These types of approaches estimate both gene trees and species trees simultaneously from aligned sequence data. 

- **Input:** Multiple sequence alighments for each locus
- **Advantages:**
  - (i) No data loss, because sequences – rather than gene trees – are used
  - (ii) The use of multiple individuals per species allows for the direct application of mathematical population-based models of evolution
- **Disadvantages:**
  - (i) Computationally intensive & therefore limited to small numbers of taxa
  - (ii) Some methods require many individuals per species in order to make the best use of population-based models of evolution
- **Some co-estimation methods:** \*Beast

### A Note on Quartets

We will be using ASTRAL-III to build our species tree, which, like a few other summary methods, uses a **quartet approach** to infer species relationships. The quartet approach basically breaks a big problem down into a few smaller more tangible ones. A subset of four taxa (from the whole collection of taxa) are sampled at a time and all three of the possible topologies for their relationships are drawn (*i.e.* three alternative quartet trees). The quartet trees are then compared to inputted gene trees, and the quartets that are present in the largest number of gene trees are assembled into the species tree. If instead we tried to proposed all (or even a decent sample) of the possible topologies for all species at once, we would be waiting a long time for an answer, since the number of possible rooted topologies for even a moderate 10 taxa is 34,459,425. Thus the quartet approach speeds up species tree inference substantially, which makes it possible to build trees for hundreds or thousands of taxa while also accounting for heterogeneity in the evolutionary history of a large number of loci. 


### Lab Assignment 7

Questions: *(31 points total)*

 - [1](#question-1), [2](#question-2), [3](#question-3), [4](#question-4), [5](#question-5), [6](#question-6), [7](#question-7)

## Table of Contents

- [Tutorial](#tutorial)
  - [Preparing Your Working Directory](#prepare-your-working-directory) 
  - [Concatenation ML Tree](#concatenation-ml-phylogeny-raxml)
  - [Species Tree](#species-tree)
    - [ML Gene Trees](#i-ml-gene-trees-raxml)
    - [Inferring the Species Tree](#ii-inferring-the-species-tree-astral-iii)


## Software

For this lab, we'll be using the following software:

- [Mesquite](http://www.mesquiteproject.org/Installation.html)
- [RAxML](https://www.drive5.com/muscle/downloads.htm): "Randomized Axelerated Maximum Likelihood" – maximum likelihood tree inference software
  - [RAxML Manual](https://cme.h-its.org/exelixis/resource/download/NewManual.pdf)
  - [Stamatakis, 2014 – *Bioinformatics*](https://academic.oup.com/bioinformatics/article/30/9/1312/238053): (original publication)
- [ASTRAL-III](https://github.com/smirarab/ASTRAL): "Accurate Species TRee ALgorithm" – quartet-based inference of species trees given a set of unrooted gene trees
  - [ASTRAL-III Manual](https://github.com/smirarab/ASTRAL/blob/master/astral-tutorial-template.md)
  - [Zhang *et al.*, 2018 – *BMC Bioinformatics*](https://bmcbioinformatics.biomedcentral.com/articles/10.1186/s12859-018-2129-y): (original publication)
- [FigTree](http://tree.bio.ed.ac.uk/software/figtree/)

Don't forget to ***consult the [Command Line Basics](https://github.com/ddecarle/eeb462-2021/blob/main/CommandLineBasics.md) tutorial*** for more in-depth explanations of scripting and for loops.

As with [Lab 5](https://github.com/ddecarle/eeb462-2021/blob/main/Lab5_Phylogenomics1.md) & [Lab 6](https://github.com/ddecarle/eeb462-2021/blob/main/Lab6_Phylogenomics2.md), you'll also need your [SciNet login information](https://docs.google.com/spreadsheets/d/17IvhbKuhfztwHabd2wutmKfHzgghxrFleCcJrwidcw8/edit#gid=0).

## Tutorial

| Main Objective for This Lab: |
| ---- |
| In today’s lab we will be inferring phylogenies for our geophagine cichlid species using the alignments generated in last lab. We will estimate two trees with two different methods: (1) maximum likelihood (ML) concatenation and (2) ASTRAL-III species trees.  | 

<p align="center">
  <img src="https://github.com/ddecarle/eeb462-2021/blob/main/images/L7-Picture2.jpg">
</p>

### Prepare Your Working Directory

1. Login to Scinet and move into the `eeb462share` directory.

2. Make a folder called "TREES": `mkdir TREES`

3. Within the `TREES` folder, make two sub-folders: "Concat" for our concatenation tree, and "ASTRAL" for our species tree: `mkdir TREES/{Concat,ASTRAL}`

Recall that, in our last lab, we needed to adjust our sequence files so that they were properly formatted for the software being used. We need to do this again in this lab for our tree-building software.

When building phylogenies based on multiple loci, it is imperative that the tips (in this case, our species) are named *identically* across all locus alignments. Differently-named loci will be treated as different tips. 

4. Look into one of the alignments: `head -2 Aligns_edited/ENSONIE00000005149_MUSCLEaligned.fasta`

Note that the descriptor for each species is currently formatted as `>Locus_Taxon`. So *A. cacatuoides*, for example, is currently represented by multiple names in each of the alignments for which *A. cacatuoides* has data. (*e.g.*, `ENSONIE00000005149_A_cacatuoides`, `ENSONIE00000110949_ A_cacatuoides`, etc.)

This was useful when we were aligning sequences, but it will be problematic for tree-building: under this naming scheme, these different *A. cacatuoides* samples will be treated as different tips, and *A. cacatuoides* will therefore appear multiple times in the resulting phylogeny (once for each locus). 

To rename tips so that they are identical across loci, we simply have to get rid of the locus name and leave only the species (*i.e.* so that all alignments have *A. cacatuoides* represented as `A_cacatuoides`). 

5. Run the following for-loop, then look into one of your alignments using the `head` command to confirm the changes. 

    ```
    for exon in ENSONIE00000005149 ENSONIE00000015639 ENSONIE00000021168 ENSONIE00000023461 ENSONIE00000029595 ENSONIE00000034582 ENSONIE00000042474 ENSONIE00000044242 ENSONIE00000048423 ENSONIE00000061707 ENSONIE00000075454 ENSONIE00000110949 ENSONIE00000130663 ENSONIE00000141538 ENSONIE00000265157 ENSONIE00000265161 ENSONIE00000265364 ENSONIE00000265379_GPR85
    do
    
    #Get rid of locus name from sequences within each alignment
    sed -i "s/${exon}_//" Aligns_edited/${exon}_MUSCLEaligned.fasta
    
    done 
    
    ```
6. Confirm your changes: `head -2 Aligns_edited/ENSONIE00000130663_MUSCLEaligned.fasta`

7. Finally, load the necessary modules for today's lab:

    ```
    module load gcc
    module load raxml
    module load java
    module load astral
    ```

[back to top](#table-of-contents)

### Concatenation ML Phylogeny (RAxML)

Concatenation has long been the most widely-used approach for molecular tree building. It consists of **joining sequence alignments for all loci end-to-end to generate a single long alignment** known as the **supermatrix**. Each taxon in the supermatrix then has one sequence that is a combination of all loci. The supermatrix is the input data for phylogenetic inference.  

Let’s concatenate our edited alignments into a supermatrix. While you could write a script to concatenate loci, it is easily done in GUI software like Mesquite. 

8. In a new terminal window that is ***not*** signed into SciNet, navigate to your `LabFive` directory, and make a new folder to hold your concatenated alignment: `mkdir Concat`

9. Navigate into the new `Concat` folder, and download the alignments that we just worked on from SciNet. Be sure to replace `<username>` with your username. 

    ```
    scp <username>@teach.scinet.utoronto.ca:/scratch/t/teacheeb462/<username>/eeb462share/Aligns_edited/\*.fasta .
    ```

10. Open one of the alignments in Mesquite by clicking **File** > **Open File** > select the first file in your list of fasta alignments > select **Fasta(DNA/RNA)** > **OK**. (***Tip:** Open the alignments in the order that they appear in the folder – i.e. alphabetically – so that you don’t get confused.*)

11. To open the next alignment click on **File** > **Link File…** > select the next \*.fasta alignment file > select **Fasta(DNA/RNA)** > **OK**. 

12. Repeat this **Link File** step for the remaining fasta alignments. (Files must be linked in order to concatenate them.) 

13. When all 18 alignments have been opened correctly (*i.e.* the last 17 linked with the first) click **Character** > **Concatenate Character Matrices** > **OK**. Then select the character matrices corresponding to our loci by selecting all rows from the Character Matrix column in the table that appears. With all matrices selected, click **List** > **Utilities** > **Concatenate Selected Matrices**. A window of options will pop up; leave both options unchecked and press **OK**. A new row (row 19) will appear in the Character Matrix column called **(Character Matrix) + (Character Matrix) + …)**.

14. View your concatenated supermatrix. Click **Characters** > **Extra Matrix Editor** >  and select the concatenated (*i.e.* **(Character Matrix) + (Character Matrix) + …**) matrix. A new tab with your concatenated matrix should open. The rows should contain your 10 taxa. Some gaps will have been introduced to fill in spaces where a taxon is missing an entire locus (*e.g.* scroll through A. cacatuoides, which was missing a few loci). 

---
#### QUESTION 1 

How long is the concatenated supermatrix? *(1 point)*

---

15. Export the supermatrix. Click **File** > **Export** > select **FASTA (DNA/RNA)** > **OK** > select your supermatrix in the window that pops up > **OK** > make sure that **include gaps** is checked > **Export** > name your file **Concat_18Loci.fasta** > **Save**.

16. Upload this supermatrix back to SciNet: From the terminal window whose working directory is set to your local directory with the exported supermatrix, run the following. As always, replace `<username>` with your username. 

    ```
    scp Concat_18Loci.fasta <username>@teach.scinet.utoronto.ca:/scratch/t/teacheeb462/<username>/eeb462share/TREES/Concat
    ```

17. Now that the supermatrix is in place, in the terminal window that is ***logged into SciNet***, move into the Concat folder: `cd TREES/Concat`

18. As before, we'll need to modify our `*.fasta` file to make sure that the entire sequence for each taxon is on the same line. **NOTE:** This is an annoying feature of Mesquite. If you use other sequence editing software (*e.g.* Geneious), you can more easily export sequences with all bases on the same line.

    ```
    cat Concat_18Loci.fasta | sed '/^>/ s/^/ /' | sed '/^ >/ s/$/ /' | tr -d '\n' | tr ' ' '\n' | sed '/^$/d' > Concat_18Loci2.fasta
    mv -f Concat_18Loci2.fasta Concat_18Loci.fasta
    ```

19. Run the following command to build a ML phylogeny with RAxML. It will take about 5 minutes to complete. While it only takes a single line of code to run RAxML, there are a number of decisions to make that will define how your tree is built. Read through the explanation below while RAxML runs.  

    ```
    raxmlHPC-PTHREADS -T 2 -f a -p 1234 -x 2345 -N 1000 -m GTRGAMMA -o O_niloticus -s Concat_18Loci.fasta -n Geophagini_ConcatTREE.tre 
    ```

  - `raxmlHPC-PTHREADS`: RAxML has a number of versions to meet different data requirements and machine capabilities. These allow you to break an analyses up into parts (*i.e.* threads) that run concurrently, often distributed across multiple nodes on a computer. The purpose is to speed large jobs up significantly, such as phylogenomic analyses on hundreds of taxa. 
  - `-T 2`: specifies that we want to run this job with 2 **threads**. The version of RAxML, number of threads and number of nodes to use depends on the size of your job and computing environment. Since our job is actually quite small, we will use only 2 threats, the minimum allowed on SciNet. 
  - `-f a`: `-f` sets the **algorithm** to be used for analyses. RAxML has several algorithms available. We will use the “rapid bootstrapping and searches for best-scoring ML tree in one run” algorithm, which is represented by `a`. See the [RAxML manual](https://cme.h-its.org/exelixis/resource/download/NewManual.pdf) for all available algorithms.  
  - `-p 1234`: This parameter sets a **random seed for the tree search**. Any random combination of numbers can be assigned here. Now every time you re-run the analyses with the same seed, it starts from the same random starting point. Technically, you don’t have to set a seed, but you should because it makes your ML search reproducible.  
  - `-x 2345`: Turns on **rapid bootstrapping** and sets a **random seed**.
  - `-N 1000`: Number of **bootstrap replicates** to run (in this case, 1,000).
  - `-m GTRGAMMA`: Specifies the **substitution model** to use in tree inference. Various GTR models are available for nucleotide data in RAxML. We will use GTR+G for our supermatrix. This is one of the most comprehensive models available for nucleotide data and has already been identified as the most appropriate for this dataset in previous work. In your own work, you should first run another model testing software (*e.g.* IQ-TREE, PartitionFinder, etc.) to determine the best partitions and models for your data.
  - `-o O_niloticus`: Assigns an **outgroup** taxon (the African *O. niloticus* in our case) to be used in rooting the tree. The outgroup name in the raxml command and in alignments must match exactly. If you don’t specify an outgroup, then your tree will simply be unrooted and can be rooted later (This is what we will be doing for our gene trees in the next section).
  - `-s`: specifies the **input data** (*i.e.* the concatenated supermatrix)
  - `-n`: The extension to add to **output filenames**. Several output files are created, and all start with the prefix `raxml`. The string that you specify here will be added appended to the end. 

While the search is occurring, RAxML prints out progress reports to the terminal. Some of the information provided includes the current bootstrap replicated, time taken for bootstrapping, ML search, time taken for ML search, and files created. 

20. Once your run has completed, take a look at the files that were created: `ls` (A brief description of each is provided below.)

  - `Concat_18Loci.fasta.reduced`: A copy of our supermatrix excluding taxa that have identical sequences, in case you want to re-run analyses with only variable taxa. 
  - `RAxML_bestTree.Geophagini_ConcatTREE.tre`: The best ML tree. (This tree is not annotated – *i.e.* it contains no bootstrap values.)
  - `RAxML_bootstrap.Geophagini_ConcatTREE.tre`: 1,000 bootstrap trees.
  - `RAxML_bipartitions.Geophagini_ConcatTREE.tre`: The best ML tree annotated with bootstrap support on the nodes.
  - `RAxML_bipartitionsBranchLabels.Geophagini_ConcatTREE.tre`: The best ML tree annotated with bootstrap support on the branches.
  - `RAxML_info.Geophagini_ConcatTREE.tre`: Text document with a summary of analyses. It contains the same information that was printed to the terminal during your analyses.
 
Each file contains information that can be used for different purposes. We will be making use of the `*bestTree*`, `*bootstrap*`, `*bipartitions*` and `*info*` files in this lab.  

---
#### QUESTION 2

Explore the contents of the `RAxML_info*` file. Scroll through the file to find the information requested in the following questions. 

  - a) How many distinct alignment patterns (*i.e.* variable sites) does our supermatrix have? What proportion of the total length does this amount to (***hint:** divide the number of variable sites by the total length of the supermatrix*)? What does this value mean in terms of the phylogenetic informativeness of our dataset? Does this value seem normal, too low or too high for our loci? Explain. *(3 points)*
  - b) What is the final ML Optimization Likelihood? *(1 point)*
  - c) What was the overall execution time for the full analysis? *(1 point)*

---

21. Download resulting concatenation tree files from SciNet to a folder of your choice. As before, in a terminal window that is ***not signed in to SciNet***, `cd` to the folder that you want to put your trees into (`... /LabFive/TREES/concat`) and then run the following command, replacing `<username>` with your username and entering the password when prompted. 

    ```
    scp <username>@teach.scinet.utoronto.ca:/scratch/t/teacheeb462/<username>/eeb462share/TREES/Concat/\*.tre .
    ```

22. Open the annotated concatenated tree (`RAxML_bipartitions.Geophagini_ConcatTREE.tre`) in FigTree, and use the **Display** drop-down menu in the **Node Labels** tab to show the bootstrap values. 

After examining the tree, leave the window open: we'll return to it once we have constructed our species tree. 

[back to top](#table-of-contents)

### Species Tree

#### I. ML Gene Trees (RAxML)

Now that we have our concatenation tree, let’s infer a species a tree! 

As mentioned previously, we are using a **summary approach**, which **takes gene trees as input**. So, the first step in building a species tree is building gene trees for each of our loci. Gene trees will be inferred in RAxML. 

23. In SciNet, navigate back to the `eeb462share` directory, and make a new folder within the `ASTRAL` directory to hold your gene trees. (Then, confirm that your folder was created using `ls`.)
  
    ```
    cd $SCRATCH/eeb462share
    mkdir TREES/ASTRAL/geneTrees
    
    ls TREES/ASTRAL
    ```
  
24. Use the following for loop to make 18 maximum likelihood gene trees using the edited alignments that we have stored in the `Aligns_edited` directory. The outputted gene trees will be stored in the `TREES/ASTRAL/geneTrees` directory. We are running RAxML in almost the same way as for the concatenated tree, except that this time **no outgroup taxon is specified**, because ASTRAL takes unrooted gene trees as input. (It will take close to 15 minutes for all of your gene trees to be complete.)

    ```
    cd Aligns_edited
    
    for exon in ENSONIE00000005149 ENSONIE00000015639 ENSONIE00000021168 ENSONIE00000023461 ENSONIE00000029595 ENSONIE00000034582 ENSONIE00000042474 ENSONIE00000044242 ENSONIE00000048423 ENSONIE00000061707 ENSONIE00000075454 ENSONIE00000110949 ENSONIE00000130663 ENSONIE00000141538 ENSONIE00000265157 ENSONIE00000265161 ENSONIE00000265364 ENSONIE00000265379_GPR85 
    do
    raxmlHPC-PTHREADS -T 2 -f a -p 1234 -x 2345 -N 1000 -m GTRGAMMA -s ${exon}_MUSCLEaligned.fasta -n ${exon}_geneTree.tre
    mv *.tre ../TREES/ASTRAL/geneTrees
    done
    cd ..
    ```
25. When the analyses have completed, confirm that your gene trees have been created: `ls TREES/ASTRAL/geneTrees/RAxML_bestTree* | wc -l`

  - `ls` looks for all files beginning with `RAxML_bestTree` and `wc -l` counts the located files. The number 18 should be printed out, corresponding to the 18 ML gene trees that you made. 

[back to top](#table-of-contents)

#### II. Inferring the Species Tree (ASTRAL-III)

We're almost there! Just a few more file modifications, and then we can make the species tree!

26. Move into the `TREES/ASTRAL` directory. (It is easier to work from here.)

27. Copy the ASTRAL executable and its library folder from `eeb462share/astralEx` into this folder. (These need to be in your working directory for ASTRAL to run.)

    ```
    cp -r ../../astralEx/lib/ .
    cp ../../astralEx/astral.5.6.3.jar .
    ```

There are many options for quantifying node support in ASTRAL. Since we used bootstrapping for the concatenated tree, we will use bootstrapping for the species tree as well so that we can compare. With this in mind, ASTRAL requires two input files to run:

  - 1. A single file containing all of the best ML gene trees (*i.e.* the `RAxML_bestTree.*.tre` files) in Newick format
  - 2. A text file listing the path to the bootstrap tree files (*i.e.* the `RAxML_bootstrap.*.tre` files) for the 18 gene trees.

28. Concatenate the best gene tree files into a single file called `bestGeneTrees.tre`: `cat geneTrees/*bestTree* >> bestGeneTrees.tre`

29. The `>>` specifies that each successive`*bestTree*` file should be added to a new line in the same file (rather than overwriting the contents of the file). So the `bestGeneTrees.tre` file should have 18 lines. Confirm with `wc -l`.

30. Concatenate the paths for the bootstrap tree files into a single file called `bootstrapTrees.txt`: `find geneTrees -type f -name "*bootstrap*" >> bootstrapTrees.txt`

  - This command translates as: `find` in the `geneTrees` directory objects of `type` file (specified by `f`) with a name containing the string bootstrap and save the path to these to a new line in a single file called `bootstrapTrees.txt`. 
  - look into the contents of the file to confirm that it also has 18 lines: 

    ```
    wc -l bootstrapTrees.txt 
    ```

Ok. ***NOW*** let's build our species tree.

31. Run ASTRAL using the following command:

    ```
    java -jar astral.5.6.3.jar -i bestGeneTrees.tre -b bootstrapTrees.txt -r 700 -t 8 -s 2468 -o Geophagini_AstralTREE_BS.tre 2> Geophagini_AstralTREE_BS.log 
    ```

ASTRAL is really fast, so it will only take a few seconds to get a tree. Here is what the above command is doing:

 - `java -jar astral.5.6.3.jar`: ASTRAL is software built and run in Java. (The executable is in the `.jar` format.) Accordingly, in order to use ASTRAL, you have to call on `java -jar` to interpret the script.
 - `-i`: specifies the **input file** containing the 18 ML gene trees.
 - `-b`: specifies the file containing the **paths** to the 18 bootstrap tree files for the 18 gene trees. This is necessary when running ASTRAL with multi-locus bootstrapping.
 - `-r 700`: indicates that you want to perform 700 **bootstrap replicates**. 
 - `-s 2468`: sets a **random seed** for replicability (like we did with RAxML). 
 - `-o`: specifies an **output filename** for the resulting Astral tree. 
 - `2>`: specifies that documentation of the process and resulting tree statistics should be saved to a file with the specified name instead of being printed out onto the terminal. 

The resulting `Geophagini_AstralTREE_BS.tre` file contains 702 trees: The first 700 are bootstrap replicates, 701 is a bootstrap consensus tree and 702 is the ASTRAL tree annotated with bootstrap support. We will look at this output file in a moment, but for now...

32. ...save the final ASTRAL tree to its own file called `Geophagini_AstralTREE.tre`: `tail -1 Geophagini_AstralTREE_BS.tre > Geophagini_AstralTREE.tre`

ASTRAL has a parameter `t` that allows you to annotate a species tree with a number of different support measures. Alternative quartet support is a useful annotation. It shows the percentage of gene trees in the dataset that support the three possible alternative topologies (denoted q1, q2 and q3 in the tree) for each node. "Q1" refers to the topology that is shown in your tree, while "q2" and "q2" correspond to the two alternative resolutions of that node.

**A quartet support of 1 means that all gene trees support that node, while values less than 1 indicate some support for one or both of the two alternative topologies.**  


33. Annotate the species tree that we just generated with alternative quartet support:

    ```
    java -jar astral.5.6.3.jar -q Geophagini_AstralTREE.tre -i bestGeneTrees.tre -t 8 -s 2468 -o Geophagini_AstralTREE-q1q2q3.tre 2> Geophagini_AstralTREE-q1q2q3.log 
    ```
    
    - `-q`: specifies a species tree that is to be annotated as **input**. 
    - `-t 8`: specifies alternative quartet support as the desired node annotation. 

**NOTE:** because we are just annotating our species tree with new values, the topologies of our two species trees are identical. The only difference is that one is annotated with bootstrap values, while the other shows alternative quartet support. 

34. Download the two species trees and their log files from SciNet to the `... LabFive/TREES/ASTRAL` folder on your computer.

    ```
    scp <username>@teach.scinet.utoronto.ca:/scratch/t/teacheeb462/<username>/eeb462share/TREES/ASTRAL/Geophagini_AstralTREE-q1q2q3\* .
    scp <username>@teach.scinet.utoronto.ca:/scratch/t/teacheeb462/<username>/eeb462share/TREES/ASTRAL/Geophagini_AstralTREE_BS.log .
    scp <username>@teach.scinet.utoronto.ca:/scratch/t/teacheeb462/<username>/eeb462share/TREES/ASTRAL/Geophagini_AstralTREE.tre .
    ```

---
#### QUESTION 3 

Open `Geophagini_AstralTREE-q1q2q3.log` in your text editor, and use it to answer the following questions about the species tree. (You may want to re-read the [note on quartets](#a-note-on-quartets) from the beginning of the tutorial as a refresher). 

  - a) How many gene trees have missing taxa? Why are they missing?  *(1 point)*
  - b) In addition to scoring quartet support for each node, ASTRAL quantifies quartet support for the whole species tree. One measure of support that is calculated is the **quartet score**, which is simply the sum of quartet topologies in gene trees that are also in the species tree. From this ASTRAL calculates the **normalized quartet score**, which is the proportion of gene tree quartets that support the species tree. A normalized quartet score of 1 means that all gene trees agree with the species tree and thus there is no gene tree heterogeneity. What are the quartet and normalized quartet scores for our species tree? *(1 point)*
  - c)	Does it appear that our loci are characterized by a low, intermediate or high level of gene tree discordance? Provide support from the ASTRAL analyses for your answer. *(1 point)*
  - d)	What are some of the possible sources of gene tree discordance in our dataset? Remember to consult the slides from Lecture 9. You may also find it useful to refresh your knowledge of cichlid biology by re-reading the introduction to cichlids provided in the first phylogenomics lab (*i.e.* [Lab 5](https://github.com/ddecarle/eeb462-2021/blob/main/Lab5_Phylogenomics1.md)). *(1 point)*


#### QUESTION 4

A major criticism of summary species tree approaches is that they assume that any difference in gene tree topology is the result of biological processes. But, incorrectly or incompletely resolved gene trees are another possible contributor. Since we did not watch the evolutionary process, it is difficult to differentiate between biological and gene tree estimation error as sources of variation in our gene trees. 

  - a) What effect would you expect high gene tree estimation error to have on the normalized quartet score (*i.e.* would it cause it to go up or down)? Why? *(2 points)*
  - b) How would this change in quartet score affect our interpretation of gene tree discordance? *(1 point)*
  - c) How might the topology of our species tree be affected? *(1 point)*

#### QUESTION 5

Paste a screenshot of the concatenation and two species trees (*i.e.* with bootstrap and quartet annotations), as shown in FigTree, here. Given the three trees informative figure legends and use them to answer the following questions. 

  - a) Do the topologies of the concatenation and species tree differ in any way? Discuss some possible reasons for this result. *(2 points)*
  - b) Are bootstrap values generally the same between the concatenation and species trees or does one consistently overestimate node support? *(2 points)*
  - c) Are there any regions of the tree that appear more problematic than others, regardless of approach? What might be the cause of this? *(2 points)*

#### QUESTION 6

For your two species trees, examine the support values (*i.e.* bootstraps and quartet support) for each node.

  - a) What would you consider to be a "good" quartet support score? Why? *(2 points)*
  - b) Are there any nodes with high bootstrap support and low quartet support or *vice versa*? Which ones (if any)? *(1 point)*
  - c) Which type of support value – bootstrap or quartet support – do you think is more informative for phylogenomic trees? Why? *(2 points)*
  - d) Would quartet support be useful/informative for multilocus phylogenies? Why or why not? *(3 points)*


#### QUESTION 7

Given what you now know about concatenation and species tree approaches, if you were to conduct a phylogenomics project of your own, would you prefer one approach over the other? Explain. If you were to use both, would you be inclined to put more confidence in the results of one over the other? Explain. *(3 points)*

---

[back to top](#table-of-contents)

***THAT'S IT!!***

We've taken raw Next Generation Sequencing reads, processed them for quality, assembled the reads to generate sequences for our target loci, aligned our loci, edited our alignments, and – finally – inferred some trees!

Thanks for all your hard work and participation! &#9786;


