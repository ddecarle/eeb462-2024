# Lab Two: Parsimony 

### Introduction

#### Assumptions of Parsimony

Maximum parsimony derives from Occam's Razor: a principle which states that "entities should not be multiplied without necessity". For our purposes, "entities" refer to evolutionary events, or character changes.

Following from that, parsimony has three main assumptions:

- In the absence of evidence to the contrary, assume homology
- All characters are equally informative 
- all character state changes are equally likely

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


### Lab Assignment Two

Questions: *(XXX points total)*

Bonus Questions: []()

## Table of Contents
- [Software](#software)
- [NEXUS files](#NEXUS-files)
- [Tutorial](#tutorial)
  - [Setting up your workspace](#setting-up-your-workspace) 

## Software

For this lab, we will be using the following software: 

- [PAUP*](https://paup.phylosolutions.com/)
- [FigTree](http://tree.bio.ed.ac.uk/software/figtree/)
- A plain text editor of your choice 

## NEXUS files 

The key to mastering PAUP* - and several other phylogenetic inference programs - is the NEXUS file format. NEXUS files are modular, with information stored in various blocks. The modular nature of these files makes it easy to store all the information necessary to conduct analyses with a variety of software. 

Basic block structure: 

```
begin <block-name>;

  <your-commands-here>;

end;
```

#### Important Tips:

- All NEXUS files begin with `#NEXUS`
- All commands in a NEXUS file must end with a semicolon (`;`)
- You can comment your NEXUS files using square brackets: for the most part, any text between square brackets will be ignored by PAUP* and other software
- Your best resources for working with NEXUS files are the [Quick-Start Guide](http://paup.phylosolutions.com/tutorials/quick-start/) and the [PAUP* manual](http://phylosolutions.com/paup-documentation/paupmanual.pdf)


## Tutorial

### Setting up your workspace

For this lab, we'll be working with some of the files we generated for [Lab One](https://github.com/ddecarle/eeb462-2021/blob/main/LAB1_characterMatrices.md):

Create new folder - LabTwo
 - subfolders: allNuc nucConstrain nucProt
copy correct NEXUS files into subfolders
make sure PAUP is in EEB462 folder (same location as MUSCLE)

navigate to .../LabTwo/allNuc


start PAUP
start logging
(mention help pages)

```
./../../<paup>
log start file = allNuc.txt;
```

import NEXUS file

```
exec 16s-enam-18s-coi-fuse.nex;
```

set  outgroup & double check status
```
outgroup <taxon>;
tstatus;
```

set optimality criterion & double check status
```
set criterion = parsimony;
cstatus;
```

(potential question: what percentage of characters are parsimony informative? will these characters inform our analyses at all?)

define heuristic search
conduct search and save MPTs

```
hsearch start=stepwise addseq=random nreps=1000 swap=TBR hold=70 nchuck = 5 nbest=all;
savetree file=allNucMPTs.tre brlen=yes;
contree /strict=yes;
cleartrees;
```
after clearing trees, begin bootstrapping

```
bootstrap nreps=100 treefile=boot.tre search=heuristic /start=stepwise addseq=random nreps=50 swap=TBR;
```
