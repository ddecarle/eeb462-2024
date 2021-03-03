# Lab Four: Bayesian Analysis 

### Introduction

Today, we’re delving into Bayesian phylogenetic analysis using MrBayes. MrBayes is by far the most user-friendly interface we have used to date. If you ever run into trouble, simply type `help <command_name>;` for detailed information about each of the possible parameters and their implementation. 

MrBayes is also very popular, meaning that **there are plenty of excellent tutorials and other resources available** online. I encourage you to explore these if you hit any snags.

##### On an unrelated note...

Since we're nearing the end of the lab material that will be relevant to your term projects, you may be interested to know the following bits of information: 

- MrBayes is available on SciNet! If your analyses are taking a long time to run, you can use the SciNet computing cluster to save yourself some time and CPU power. We'll talk more about how to do this in the next lab.

- [MBL Workshop on Molecular Evolution](https://molevolworkshop.github.io/schedule/): Slides, tutorials, and some recorded lectures from the [annual phylogenetics workshop](https://www.mbl.edu/education/courses/workshop-on-molecular-evolution/) at the Marine Biological Labratory in Woods Hole. I can't say enough good things about this workshop and the people who teach it. If you're looking for ideas for extra analyses, more detail about the methods we've covered in lecture and lab, or just another explanation of the course material, this is as great place to look.

- [PhyloMeth](http://phylometh.info/syllabus.html): This is a freely-available online course about phylogenetic methods created by [Dr. Brian O'Meara](http://brianomeara.info/). The syllabus is quite comprehensive - in addition to phylogenetic inference, it covers downstream analyses such as dating trees, implementing phylogenetic comparative methods (*e.g.* estimating diversification, finding correlations between characters, etc.), and simulating data. The course uses different tree-building software than we have used so far in the labs, but the basic principles remain the same. If you're looking for additional analyses, this is a fantastic resource. 

### Lab Assignment Four

Questions: *(28 points total)*

 - [1](#question-1), [2](#question-2), [3](#question-3), [4](#question-4), [5](#question-5), [6](#question-6), [7](#question-7), [8](#question-8), [9](#question-9), [10](#question-10), [11](#question-11)
 - [Bonus Question](#bonus-question)

 ## Table of Contents
 
 - [Software](#software)
 - [Resources](#resources)
 - [Tutorial](#tutorial)
   - [The Bayes Block](#the-bayes-block)
   - [Partitioning Data](#partitioning-data)
   - [Specifying Models in MrBayes](#specifying-models-in-mrbayes) 	
  	 - [I. IQ-TREE's model selection output](#making-sense-of-iq-trees-model-selection-output)
  	 - 	[II. Specifying models](#specifying-models)
  	 -  [III. Priors](#priors)
   - [The MCMC Simulation](#the-mcmc-simulation)
   - [Running the Analysis](#running-the-analysis)
   - [Evaluating Convergence: Stopping Your Analysis](#evaluating-convergence-stopping-your-analysis)
   - [After the Simulation](#after-the-simulation)
 - Appendices:
   - [Appendix A: MCMC Simulation Parameters](#mcmc-simulation-parameters)
   - [Appendix B: Specifying Alternative Models](#appendix-b-specifying-alternative-models)
       - [Amino Acid Models](#amino-acid-models)
       - [Morphological Models](#the-mk-model-for-morphological-data)	
   - [Appendix C: Restarting Analyses](#appendix-c-restarting-analyses)

## Software
 
For this lab, we'll be using the following software:

- [MrBayes](http://nbisweden.github.io/MrBayes/download.html)
- [FigTree](http://tree.bio.ed.ac.uk/software/figtree/)
- [Tracer](https://beast.community/tracer)
- a plain-text editor of your choice

## RESOURCES:

- [MrBayes Wiki](http://mrbayes.sourceforge.net/wiki/index.php/Manual_3.2) - includes the manual, tutorials, and summaries of models
- [Zwickl & Holder 2004 - *Systematic Biology*](https://academic.oup.com/sysbio/article/53/6/877/1651008#124599109) - Model Parameterization, Prior Distributions, and the General Time-Reversible Model in Bayesian Phylogenetics
  - an excellent, not-super-technical paper about models and priors in Bayesian phylogenetics
- [Archibald *et al.* 203 - *Taxon*](https://www.researchgate.net/publication/275922362_Bayesian_Inference_of_Phylogeny_A_Non-Technical_Primer) - Bayesian Inference of Phylogeny: A Non-Technical Primer
 
## Tutorial
Begin by downloading and unzipping all necessary files from the Lab Three section of the Modules tab in Quercus. 

1. Locate the "NEXUS/MrBayes" folder you created as part of [Lab One](https://github.com/ddecarle/eeb462-2021/blob/main/LAB1_characterMatrices.md) 
2. Copy `16s-enam-18s-coi-fuseSimp.nex` into the "LabFour/allNuc" folder
3. Copy `16s-enam-18s-coiProt-fused.nex` into "LabFour/nucProt"
4. Move the "LabFour" folder into the "EEB462" folder on your desktop
5. Move the correct MrBayes executable to the "LabFour" folder: 
	- MacOS: `mb`
	- Windows: `mb.3.2.7-win64.exe`

### The Bayes Block

Like some of the programs we have already used in this class, MrBayes uses NEXUS files. In addition to reading your matrix from the Data block, **MrBayes can also read information stored in a block**.

A **Bayes block** is formatted like any other block in a NEXUS file, and is essentially a script for running MrBayes. One major advantage of using a Bayes block is that you can keep all your information in the same file. This is not only helpful for running analyses, but also for ensuring that your research is reproducible. It is common practice for researchers to publish their data matrices in NEXUS format with the Bayes block included. (It is a good idea to do this for your final project.)

Throughout the majority of this tutorial, we'll create a Bayes block to run a tree search for the `allNuc` dataset. 

_Remember_: ***All commands - both in MrBayes and in a NEXUS file must end with a semicolon.***

1. Open `16s-enam-18s-coi-fuseSimp.nex` in your text editor. 

2. At the bottom of the file (after the `END;` command, type `begin MRBAYES;` on a new line

As with any analysis, the first thing you want to do is begin a log to save all text that's printed to the terminal during your analysis.

3. On another line, enter the following command: `log start filename=allNuc_log.txt;`

[back to top](#table-of-contents)

### Partitioning Data

The next lines in your MrBayes block will specify the optimal partitioning scheme as indicated by IQ-TREE.

4. Open the `nucPartition.nex.best_scheme.nex` file that you generated as part of [Lab Three](https://github.com/ddecarle/eeb462-2021/blob/main/Lab3_MaximumLikelihood.md) in your text editor. (It should be located in `../LabThree/allNuc`)

Because IQ-TREE conveniently outputs the results of its model test in NEXUS format, most of the relevant information can simply be copy-and-pasted into your MrBayes block.  

5. To define the partitions for your analysis, copy lines 3 - 9 (*i.e.* all lines beginning with `charset` into your Bayes block.

Once we've defined the partitions, we need to indicate which partitioning scheme we want to use. 

6. On a new line, enter the following commands: 

```
partition bestScheme = 7: 16s, enam1_enam2, enam3 18s, coi1, coi2, coi3;
set partition = bestScheme;
```

This creates a new partitioning scheme called `bestScheme` that contains 7 partitions; it then lists the identities of those partitions and tells MrBayes to implement the scheme we just specified. 

[back to top](#table-of-contents)

### Specifying Models in MrBayes

#### I. Making sense of IQ-TREE's model selection output

The model partitions in the “best_scheme” file generated by IQ-TREE cannot be interpreted by MrBayes as-is. Therefore, before we can specify the models for our Bayesian analyses, we will need to understand IQ-TREE’s model testing output.

7. Examine `nucPartition.nex.best_scheme.nex` in your text editor.

The lines following `charpartition mymodels = ` indicate the best model for each of our seven partitions. The model itself is indicated by a three-letter code and is usually followed by a series of parameters that account for different types of rate heterogenetiy across sites. Some common parameters are as follows:

- `+F`: indicates that base frequencies should be empirically calculated from your data. (This is the default option for models - such as GTR - that include unequal base frequencies.)
- `+I`: allows for a proportion of invariable (*i.e.* unchanging) sites
- `+G`: discrete gamma model - nucleotides may evolve at different rates according to a gamma distribution; may be followed by a number (*e.g.* `G4`) indicating the optimal number of rate categories
- `+ASC`: ascertainment bias correction for datasets that do not contain constant sites (*i.e.* SNP and morphological data)

More information about IQ-TREE's model selection output can be found on the [IQ-TREE Substitution Models](http://www.iqtree.org/doc/Substitution-Models) page.

[back to top](#table-of-contents)

#### II. Specifying models

Models cannot be specified by name in MrBayes. Instead, they are specified by their properties. All properties of a model can be specified using two commands: `lset` and `prset`.

`lset` is used to parameterize elements of the likelihood model of nucleotide evolution, and `prset` is used to specify priors. 

A typical `lset` command is as follows:

```
lset applyto=(99) nst=1 rates=invgamma ngammacat=4;
```
- `applyto`: indicates the partition to which you would like to apply this model. In this case, we’re applying the model to the 99th partition in the list
- `nst`: specifies the number of substitution types in your model
- `rates`: indicates the type of rate heterogeneity (if any). The `invgamma` option specifies a proportion of invariant sites (`+I`) and gamma-distributed rates (`+G`)
- `ngammacat`: specifies the number of gamma rate categories

The `applyto` and `nst` options _must always be present_ in your lset commands; `rates` and `ngammacat` may not need to be included, depending on the model. You can also use `lset` to specify other options, such as codon table if applicable. For more information, use the MrBayes help command, or consult the [MrBayes wiki](http://mrbayes.sourceforge.net/wiki/index.php/Manual_3.2).

A typical `prset` command might look like this: 

```
prset applyto=(99) statefreqpr=fixed(equal);
```
- `statefreqpr`: indicates whether base frequencies should be fixed or not. When base frequencies are not fixed, MrBayes allows them to vary according to a Dirichlet distribution that is initially informed by the empirical frequency of each base (A, T, G, or C) in your dataset.

Note that, in our `lset` command, we specified the number of substitution types, but did not indicate whether or not base frequencies could vary. In MrBayes, the default settings allow for unequal base frequencies, so in order to use models with *fixed* base frequencies, we need to use the above command. 

The `+F` parameter can be considered equal to `statefreqpr=dirichlet;` since this is the default setting in MrBayes, it does not need to be explicitly specified. This means that partitons which uses models with variable base frequencies, no prset command is necessary.

---

#### QUESTION 1

What model was specified by the example `lset` and `prset` commands above? *(1 point)*

---

8. Use the `lset` and `prset` commands to specify the correct model for each partition according to `nucPartition.nex.best_scheme.nex`. Remember that there should be an `lset` command for each partition, but some (or all) partitions may *not* need a `prset` command. All commands should be entered on their own line. 
	- Because we’re not working with morphological or SNP data, ignore the `+ASC` parameter.

If you are unsure about the properties of any models, refer to the slides from Lecture Five, or [the incredibly helpful Wikipedia article about models of DNA substitution](https://en.wikipedia.org/wiki/Models_of_DNA_evolution).

[back to top](#table-of-contents)

#### III. Priors

In addition to specifying certain apects of your substitution model, the `prset` command is also used to set the priors for your analyses.

Since, in this case, we don’t have any great relevant information about how we expect evolution to have behaved, we’re going to use MrBayes’s default settings.

We will, however, use the `prset` and `unlink` commands to indicate that we want values for certain model parameters to vary independently among partitions.

9. Add the following commands to your MrBayes block:

```
prset applyto=(all) ratepr=variable;
unlink statefreq=(all) revmat=(all) shape=(all) pinvar=(all) tratio=(all);

```
This `prset` command indicates that you want to allow the nucleotude substitution rate to vary independently across all of your partitions. 

Intuitively, the `unlink` command also allows values for each of the following priors to vary independently between partitions: 

- `statefreq`: frequency of each character state in your dataset 
- `revmat`: substitution rates of the GTR model
- `shape`: gamma distribution shape parameter
- `pinvar`: proportion of invariant sites
- `tratio`: transition/transversion rate ratio

[back to top](#table-of-contents)

### The MCMC Simulation 

The next commands in your MrBayes block specify the settings to use for the MCMC simulation that will generate the posterior distribution of tree topologies and parameter values. Those posterior distributions will eventually be summarized to produce your tree.

10. On a new line in your MrBayes block, enter the following commands:

```
mcmcp ngen=150000 printfreq=1000 samplefreq=1000 nruns=2 nchains=4 starttree=random filename=allNuc relburnin=yes burninfrac=0.25 savebrlens=yes;
mcmc;
```

The `mcmcp ... ;` command is used to set the parameters for the MCMC simulation, and `mcmc;` initiates the simulation. 

Detailed information on each of the parameters can be found in [The Appendix](#Appendix-MCMC-parameters).

[back to top](#table-of-contents)

### The End of the Bayes Block

The final commands in the MrBayes block generate summary statistics (`sump;`) and a consensus tree (`sumt;`) , and end the log.

11. On a new line in your MrBayes block, enter the following commands:

```
sump;
sumt contype=halfcompat;
log stop;
```

The `contype` option determines which type of consensus tree we want to generate. Here, we have specified a 50% majority rule consensus tree, which contains all clades present in &#8805; 50% of the trees in your posterior distribution. Alternatively, we could generate a maximum clade credibility tree (`contype=allcompat`), which combines all non-contradictory clades present in your distribution. **Majority rule consensus trees are most commonly reported**.

12. End the MrBayes block using the following command: `END;`

13. Save `16s-enam-18s-coi-fuseSimp.nex` and close the file. 

[back to top](#table-of-contents)

### Running the Analysis

Once you’ve written your Bayes Block, running an analysis is easy.

14. In your terminal, navigate to `.../LabFour/allNuc`, and start MrBayes using the following command: 

    - MacOS: `./../mb`
    - Windows: `./../mb.3.2.7-win64.exe`

15. When MrBayes has started, load your matrix: `exec 16s-enam-18s-coi-fuseSimp.nex;`

MrBayes will automatically read your Bayes block and begin running the MCMC simulation.

Before long, the program should start to print the output of the simulation to your terminal. The output will look something like this:

<p align="center">
  <img src="https://github.com/ddecarle/eeb462/blob/master/Picture1.png">
</p>

The **generation number** is listed in the leftmost column. Following that, you’ll see the **likelihood values** for every chain in the simulation. The chains from each of the two runs are separated by an asterisk. The values in round brackets represent *heated chains*, whereas the ones in square brackets represent the *cold chains*. 

**Heated and cold chains** essentially have different criteria for accepting or rejecting a newly proposed parameter value: heated chains can accept more different – sometimes, less optimal – values allowing them to make larger jumps in tree space (hopefully) escaping local optima. Cold chains, on the other hand, make only small moves in tree space, allowing them to more thoroughly explore a particular area. The number of heated and cooled chains does not change, but chains alternate between being heated and cooled throughout the simulation to thoroughly search many areas of tree space.

[back to top](#table-of-contents)

### Evaluating Convergence: Stopping Your Analysis

The end goal of any MCMCMC is to generate convergent runs.

MCMC runs are said to have converged when they have generated **highly similar posterior distributions**, indicating that they have thoroughly searched the entirety of tree space. 

Conversely, if the distributions of proposed values for your runs are vastly different from one another, this is an indication that your simulation has not been sufficiently long, or that one or both of your runs is stuck at a local optimum.

Although we can never be truly certain that we have performed a thorough search of tree space, we can evaluate the convergence of our runs in a number of ways.

The **average standard deviation of split frequencies** (SDSF) is printed to the terminal at regular intervals (see image above). It is a metric of how similar (*i.e.* convergent) the distributions generated by the two runs are to one another. The value should be as close to zero as possible, but anything &#8804; 0.01 is considered acceptable.

Some simulations may not reach an acceptable Average SDSF in any practical amount of time (*i.e.* tens of millions of generations). Although this is not ideal, if the Average SDSF has been stable for many generations, and the other criteria are met, you can stop your simulation.

You will notice that MrBayes has generated several output files, including a `.p` file for each of your runs (*i.e.* `allNuc.run1.p` and `allNuc.run2.p`). The `.p` files are important for evaluating whether your runs have converged, and can be examined at any point during or after the simulation.

16. Open Tracer

17. Select "**File > Import Trace File...**" and open the two `.p` files from the allNuc analysis. 

On the left, you’ll see a list of all parameters estimated as part of your MCMC simulation. For each parameter, the **mean value** and the **effective sample size (ESS)** are displayed. The ESS values are colour coded, such that poor values (*i.e.* < 100) are shown in red, middling values (*i.e.* between 100 and 200) are shown in orange, and “good” values (*i.e.* &#8805; 200) are shown in black. The first item on the list (**LnL**) represesnts the **likelihood scores of the trees** in the distribution. You can examine the parameter values for the `.p` files separately or together. (Use the “Trace Files” box in the top left to toggle between these options.)

In an ideal scenario, all ESS values would be well above 200, and the data for each parameter would follow a normal distribution.

The panels on the right can display these data in a number of ways.

<p align="center">
  <img src="https://github.com/ddecarle/eeb462/blob/master/Picture2.png">
</p>

18. Click the "**Trace**" button near the top of the screen.

This screen displays the **trace plots**, with likelihood scores on the y-axis and the generation number on the x-axis. The burn-in portion of the distribution is displayed in grey; remember that these trees are ignored for the
purposes of calculating summary statistics
and generating your consensus tree.

The plot below depicts a run that has reached **stationarity** (often called the “fuzzy caterpillar”). Parameter values are said to have reached stationarity when they fluctuate around a single point. This is exactly what you hope to see.

<p align="center">
  <img src="https://github.com/ddecarle/eeb462/blob/master/Picture3.png">
</p>

If your trace plots do not resemble a fuzzy caterpillar, this is an indication that your simulation is not adequately searching tree space, and you may need to start your simulation again, perhaps using different tree searching parameters.

[back to top](#table-of-contents)

### After the Simulation
 
Once the MCMCMC simulation has finished, MrBayes will summarize the posterior distributions to generate your consensus tree and a number of statistics.

#### I. Open the log file

The output generated by MrBayes is extremely helpful: each of the summary statistics is accompanied by an in-depth explanation of what the statistics measure and how they can be interpreted.

19. Open `allNuc_log.txt` in your text editor, and use it to answer the following questions:

---

#### QUESTION 2

What was the final value of average SDSF for your runs? *(1 point)*


#### QUESTION 3

According to the overlay plot, have your runs reached stationarity? *(1 point)*

#### QUESTION 4

Find the “Model parameter summaries” table.

a) How many samples were produced by each run? How many are included in the data summarized in the table? Why is there a discrepancy between these two numbers? *(2 points)* 

b) Do the data in this table indicate that your runs have converged? How do you know? *(2 points)*

#### QUESTION 5

How many trees are included in the distribution? *(1 point)*

---

#### II. Trees

The consensus tree generated by MrBayes is stored in the `allNuc.con.tre` file.

20. Open the consensus tree in FigTree and re-root it using the appropriate outgroup. 

21. Tick the "**Node Labels**" box and select "**Display > prob**" to show the posterior probability values for each node

---

#### QUESTION 6

What do posterior probability values represent? How do they differ from bootstrap values? *(2 points)*


#### QUESTION 7

Describe the tree, paying attention to support values, as well as all orders and higher clades listed in the data.xlsx file *(2 points)*

---

[back to top](#back-to-top)

### Running Analyses with Multiple Data Types

MrBayes makes it very easy to run analyses on matrices that contain multiple data types: the only thing you have to change are the names of the models.

In this section, you will run a Bayesian analysis on the combined nucleotide + protein datasset, and use it to answer the remaining questions.


1. Open `16s-enam-18s-coiProt-fused.nex` in your text editor

2. Generate a MrBayes block to perform the following functions: 

  - start and end a log file
  - set character partitions and partitioning scheme according to the `nucProtPartition.nex.best_scheme.nex` file generated during [Lab Three](https://github.com/ddecarle/eeb462-2021/blob/main/Lab3_MaximumLikelihood.md)
  - specify models for each partition 
      - for instructions on specifying amino acid models, see [Appendix B](#amino-acid-models).
  - specify settings for the MCMCMC simulation according to the [instructions above](#the-mcmc-simulation). This analysis should run for 150,000 generations.
  - begin the MCMC simulation
  - Generate summary statistics and a majority rule consensus tree


---

#### QUESTION 8

Paste the Bayes block from your `nucProt` analysis here *(5 points)*


#### QUESTION 9

Did the analysis converge? How do you know? Include the log and `.p` files with your submission.  *(4 points)*

#### QUESTION 10

Contrast this tree with the allNuc tree. Do you trust one of the trees over the other? Include both consensus trees as part of your submission. *(4 points)*

#### QUESTION 11

Consider all the trees you’ve generated in Labs Two through Four. Which – if any – is the best? Give a justification for your answer. *(3 points)*

---

#### BONUS QUESTION

Parsimony, maximum likelihood, or Bayesian inference: which optimality criterion is best?


## Appendix A: MCMC Simulation Parameters

- `ngen`

Indicates the number of generations that you want the simulation to complete (*i.e.* how long you want the analysis to run).

Your simulation should run for as long as it takes for the two (or more) runs to converge. Unfortunately, there’s no way of knowing *a priori* how long that will take: every simulation and every dataset are different. 

For more information on when to stop your analyses, see [Evaluating Convergence: Stopping Your Analysis](#evaluating-convergence-stopping-your-analysis).

Generally, I start by specifying 1,000,000 generations. We don’t have time for that in this lab. In the interest of time, we’ll specify a smaller number of generations for this analysis.

_NOTE_: ***If you’ve wildly miscalculated the value of*** `ngen`***, don’t worry!***

Once MrBayes finishes the specified number of generations, it will give you the option to continue the analysis. Alternatively, you can end the analysis at any time by typing `CTRL + C`.

- `nruns`

This specifies the number of simulations to be run simultaneously. Most of the time, this value is set to two. Running more than one simulation at a time is what makes our MCMC an MCMCMC (Metropolis-coupled Markov Chain Monte Carlo). The practical implications of this will become clearer in the section, [Evaluating Convergence: Stopping Your Analysis](#evaluating-convergence-stopping-your-analysis)

- `nchains`

Each simulation consists of a particular number of chains. These chains are commonly referred to as “robots searching tree space”. Normally, each run consists of four of these chains (or robots) and they move around tree space as new values are proposed for each parameter of our model. The number of new parameter values proposed each generation is therefore equal to (the number of chains * the number of runs). In this case, 8.

- `printfreq`

Every so often, MrBayes will print the state of the chains to the terminal. The `printfreq`
command indicates how frequently you want that to happen. The number you specify corresponds to a number of generations, so if `printfreq=100`, MrBayes will print the state of the chains every 100th generation. If `printfreq=1000`, the output will be printed every 1,000th generation, etc.

- `samplefreq`

For each new generation in your simulation, a new value for one of your model parameters is proposed, the likelihood of observing the data using this new parameter value is calculated, and this new parameter value is either accepted or not.

Just because a parameter value is accepted, however, does not mean it is automatically added to your posterior distribution. There are two main reasons for this. The first is that, since only one parameter is altered with each generation, trees from subsequent generations are likely to be very similar to one another. The second reason is that summarizing an overly large distribution would be computationally expensive.

The `samplefreq` option indicates how often you would like to add parameter values to your posterior distribution. Similar to the `printfreq` command, the specified value corresponds to a number of generations.

- `starttree`

As the name suggests, starttree specifies an initial tree from which your analysis will begin. Using random starting trees is preferable since, if each of your runs starts from a different, randomly chosen point in tree space, and both converge on the same answer, it is relatively likely that your analysis has not gotten stuck at a local optimum.

- `filename`

Specifies a prefix for all output files.

- `relburnin` and `burninfrac`

Since your simulations are starting from a random point in tree space, it stands to reason that the first trees added to your posterior distribution should not be particularly good. For this reason, it is common practice to discard trees sampled early in the simulation. These suboptimal trees are called “burn-in”. 

You can specify a **number of samples** to be discarded, or you can specify a **proportion of the entire distribution**. The `relburnin` option does the latter. 

If you use the `relburnin` command, you must also specify a proportion that indicates how large you want your burn-in to be. This is accomplished using the `burninfrac` option. Although 25% of the distribution seems like a large number, it is fairly standard in the literature. Remember that your distribution will still end up being quite large: the total number of samples = (number of generations/sample frequency).

- `savebrlens`

This one is pretty self-explanatory: it indicates that you want to save the branch lengths for each of the trees in your distribution.

[back to top](#table-of-contents)

## Appendix B: Specifying Alternative Models

### Amino Acid Models

Amino acid models can be specified using the `aamodelpr` option of the prset command. ***You do not need to include an `lset` command for amino-acid partitions***.

The syntax is as follows:

```
prset applyto=(#) aamodelpr=fixed(NAME);
```

- `#`: number of the partition to which the model should be applied
- `NAME`: the name of the particular model (*e.g.* dayhoff, wag, blosum...)

For a complete list of the amino acid models implemented in MrBayes, consult the [MrBayes Wiki](http://mrbayes.sourceforge.net/wiki/index.php/Manual_3.2), or use the MrBayes help command (`help prset;`).


**NOTE:** Unlike with the `allNuc` dataset, ***you cannot copy-and-paste the partitions straight from IQ-TREE's output file***. Because MrBayes accepts multiple data types in the same file, but IQ-TREE does not, the locations of each partition will change. Luckily, the fused NEXUS file contains a `SETS` block which tells you where each locus begins and ends. ***Remember*** that, when specifying your models of evolution, you may need to specify different partitions for each codon position in the protein-coding loci.  

See [IQ-TREE: Substitution Models](http://www.iqtree.org/doc/Substitution-Models) for more information on the models listed in your `.best_scheme.nex` file.

Like nucleotide models, amino acid models can incorporate a number of different types of rate
heterogeneity. These can be specified using the lset command as above.

### The Mk Model for Morphological Data

For morphological data, the Mk model can be specified as follows:

```
lset applyto=(#) coding=variable;
prset applyto=(#) symdirihyperpr=fixed(infinity) ratepr=variable;
```

- `#`: number of the partition to which the model should be applied


The `coding` option in the `lset` command indicates that only variable sites have the probability of being sampled. In other words, there are no invariable sites in your dataset.

The `prset` command specifes that the stationary frequencies for each character state in your dataset vary according to a symmetrical Dirichlet prior, and that each partition should be allowed to evolve at a different rate.

[back to top](#table-of-contents)

## Appendix C: Restarting Analyses

At some point, you may find you need to restart an MCMC simulation that has stopped (*e.g.* because your computer died, your simulation stopped before reaching stationarity, etc.).

Luckily, this is very easy:

1. Open your NEXUS file and add `append=yes` to your `mcmcp` command.

2. Examine the following files: `<output_file>.ckp`, `<output_file>.run1.t`, and `<output_file>.run2.t`

Ensure that the value of `generation` on the third line of the `.ckp` file is equal to the highest value for `tree gen.` at the end of both `.t` files. If there is a discrepancy, remove trees from the `.t` files (starting with the ones at the end of the file) until the values match, or change the `generation` field in the `.ckp` file. 

3. Execute your NEXUS file in MrBayes as before.

**NOTE** - You may see an error like this:

```
The specified number of generations (250000) was already finished in the previous run you are trying to append to.
Error in command "Mcmc"
The error occurred when reading char. 6 on line 80 in the file '16s-enam-18s-coi-fuseSimp.nex'
```

**SOLUTION:** Increase the value of `ngen` in your `mcmcp` command.

[back to top](#table-of-contents)
