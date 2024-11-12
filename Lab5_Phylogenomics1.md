# Lab Five: Phylogenomics I

*Tutorial by Viviana Astudillo-Clavijo*

### Background

DNA sequencing technologies have undergone major advances in the last decade. Next Generation Sequencing (NGS) makes it possible to obtain much larger amounts of DNA data (*i.e.* **phylogenomic data**) faster and at a fraction of the cost of Sanger Sequencing. Furthermore, NGS is giving researchers access to DNA in samples that were previously difficult - if not impossible - to obtain, such as those with trace amounts of DNA. The result is a recent surge in the availability of DNA data for phylogenetic analyses. This is an exciting time, as more DNA data provides more opportunities for exploring and scrutinizing phylogenetic relationships at all taxonomic levels (*e.g*. population, species, etc.). 

However, new challenges for processing and analyzing this wealth of data have also emerged. First, most NGS platforms return thousands to millions of small sequence fragments (known as **sequencing reads**). Reads are fragments of whole sequences and must thus evaluated and assembled in order to obtain complete target sequences (*i.e.* the loci of interest). Second, with hundreds, and in some cases thousands, of samples, it is no longer feasible to process sequences independently. It is much more reasonable and practical to automate some or most of the process, which means that computer programming is quickly becoming an essential skill for phylogeneticists. Large computational demands also means that it is common to run analyses on external servers (*e.g*. SciNet) that have more computational power rather than locally. Third, software that was traditionally used to analyze multi-locus data (*e.g.* PartionFinder, IQ-TREE, RAxML, MrBayes) is incapable of handle phylogenomic-scale datasets, and therefore new implementations of these methods geared specifically towards phylogenomic-data analyses (*e.g.* ExaBayes) are being developed. Finally, phylogenomic-scale datasets are revealing details about the evolutionary process that are causing us to reassess the assumptions made by traditional phylogenetic methods. This last challenge has pushed the field towards developing new phylogenetic methods for analyzing species relationships, known as species tree methods (see Lab 7), that are more deeply rooted in population genetics and are inherently dependent on large datasets. **Fig. 1** highlights the main steps in phylogenomic data analysis and provides a comparison of NGS and Sanger Sequencing data processing.

**NOTE:** Although big data and species tree methods have become commonplace, it is important to remember that bigger and newer are not always better. A number of studies have shown that traditional multi-locus datasets and concatenation approaches can be just as good or better than NGS and species tree approaches in some cases. As with research in any field, it is important to become familiar with your study system before deciding on the most appropriate data to collect and methods to analyze it with. 

<p align="center">
  <img src="https://github.com/ddecarle/eeb462-2021/blob/main/images/L5-Picture1.png">
</p>

| Figure 1. A comparison of data processing for NGS and Sanger Sequencing Data. Both NGS and Sanger Sequencing start with genomic DNA.  |
| ------------- |
| Library preparation and sequencing are usually done externally for NGS, while many molecular labs are equipped to perform Sanger Sequencing in-house. <br> The lab protocol in NGS that allows for the rapid processing of a large number of sequences necessarily produces reads rather than complete loci sequences. As a result, a number of additional processing steps must be taken in order to assemble raw sequencing reads into high quality loci. In comparison, Sanger Sequencing provides complete loci sequences. <br> In both cases, complete loci sequences can then be used to obtain multiple sequence alignments (MSA) for phylogenetic/phylogenomic analyses. |

### Lab Assignment Five

Questions: *(22 points total)*

 - [1](#question-1), [2](#question-2), [3](#question-3), [4](#question-4), [5](#question-5), [6](#question-6), [7](#question-7)


 ## Table of Contents
 
 - [Software](#software)
 - [Resources](#resources)
 - [Tutorial](#tutorial)
   - [Introduction](#introduction)
     - The Study System 
     - Library Preparation and Next-Generation Sequencing
     - Running Analyses on a Super Computer
   - [Preparing Your Files](#Preparing--Getting-Familiar-with-Your-Files)
   - [Filtering and Trimming Reads](#filter-and-trim-reads-prinseq)
   - [Assessing Read Quality](#assess-read-quality-prinseq)
   - [Assembling Raw Reads](#assemble-raw-reads-bowtie2-samtools)

## Software

For this lab, we'll be using the following software: 

- [PRINSEQ](http://prinseq.sourceforge.net/manual.html): Quality control and pre-processing of metagenomic datasets
- [Bowtie2](http://bowtie-bio.sourceforge.net/bowtie2/manual.shtml): Read alignment software
- [SAMtools](http://www.htslib.org/doc/samtools-1.2.html): Sequence/Alignment Mapping and associated tools

All analyses for today's lab will be conducted on [SciNet's Teach Cluster](https://www.scinethpc.ca/). If you run into any trouble using the server, [SciNet has a very helpful wiki](https://docs.scinet.utoronto.ca/index.php/Main_Page).

Don't forget to ***consult the [Command Line Basics](https://github.com/ddecarle/eeb462-2021/blob/main/CommandLineBasics.md) tutorial*** for more in-depth information about scripting and for loops.


## Tutorial

### Introduction

#### The Study System: Geophagini Cichlid Fishes

Neotropical (South and Central American) rivers harbor some of the largest concentrations of biodiversity on the planet, and here cichlid fishes are amongst the most diverse. Neotropical cichlids belong to the monophyletic subfamily Cichlinae, which is sister to the African subfamily, Pseudocrenilabrinae. The largest Cichlinae tribe is Geophagini with at least 250 described species that exhibit diverse morphologies and ecological adaptations. Geophagini is thought to have experienced a continent-wide riverine adaptive radiation. Their species richness, ubiquity in Neotropical communities, tremendous ecomorphological diversity, and apparent continental-scale adaptive radiation is quickly making Geophagini a useful system for investigating the historical macroevolutionary processes that gave rise to modern Neotropical fish diversity. 

A robust phylogeny is imperative for reconstructing macroevolutionary patterns. The internal relationships of Geophagini have been studied using morphological and multi-locus data in some detail, and now researchers are also applying phylogenomic data to further scrutinize earlier findings and resolve several challenging nodes. 

Over the next three weeks we will be working with 20 exons sequences for 10 Cichlid species (originally sequenced by [Ilves and López-Fernández 2017 - *Molecular Phylogenetics and Evolution*](https://www.researchgate.net/publication/320369477_Exon-based_phylogenomics_strengthens_the_phylogeny_of_Neotropical_cichlids_and_identifies_remaining_conflicting_clades_Cichliformes_Cichlidae_Cichlinae)) to investigate relationships amongst representatives of Geophagini cichlid tribe. Both traditional concatenation and species tree approaches will be applied in order to assess the topological outcomes resulting from the application of different methodological and biological assumptions.  

**NOTE:** The number of loci used in phylogenomic studies is usually much larger (hundreds to thousands of sequences), but in the interest of time and computational power, we will limit our exercises to 20 exon sequences.

<div align="center">

  | Species | Code |
  | ------- | ---- |
  | *Apistogramma cacatuoides* | A_cacatuoides |
  | *Biotodoma cupido* | B_cupido |
  | *Crenicichla minuano* | C_minuano |
  | *Geophagus abalios* | Geo_abalios |
  | *Geophagus dicrozoster* | Geo_dicrozoster |
  | *Gymnogeophagus balzanii* | Gym_balzanii |
  | *Gymnogeophagus rhabdotus* | Gym_rhabdotus |
  | *Mikrogeophagus altispinosus* | Mik_altispinosus |
  | *Mikrogeophagus ramirezi* | Mik_ramierzi |
  | *Oreochromis niloticus* | O_niloticus |
  
</div>

| Table 1 |
| ------- |
|The first 9 taxa belong to the Geophagini tribe and constitute the focal group. The last taxon, *Oreochromis niloticus*, belongs to the African subfamily Pseudocrenilabrinae and will serve as the reference for exon assembly and outgroup for phylogenetic analyses. |

#### A Note on Library Preparation and NGS

The 20 target exons were captured for geophagine species using probes designed based on an annotated Tilapia (*Oreochromis niloticus*) genome (Ilves & López-Fernández 2014, 2017). The target exons were sequenced with Illumina paired-end NGS, which sequences the targets from both the 5’ and 3’ ends in order facilitate read assembly later on. The result is a set of forward and reverse reads for the 20 target exons, which we will be processing.    

#### Running Analyses on a Super Computer

Phylogenomics software is largely open source and is therefore unix-based. Unfortunately, Unix-based software is not easy to install or use with Windows (Most NGS software is easily applied on Macs). Therefore, we will be running analyses for the remaining labs on SciNet’s super computer. SciNet is a Canadian institution with high-power computers that are made accessible to registered Canadian institutions and researchers. Students in this class have been registered with a temporary account for the duration of the course.

You will need to sign in (from any computer) with these temporary credentials any time you want to use SciNet. Two main things to know about SciNet is that (1) you can run smaller jobs directly on its `$SCRATCH` node (see [below](#Preparing--Getting-Familiar-with-Your-Files)) or (2) submit larger jobs via scripts that will require more computational power and thus run as resources are available. 

**You can obtain a username and password using [this sign-up sheet](https://docs.google.com/spreadsheets/d/17IvhbKuhfztwHabd2wutmKfHzgghxrFleCcJrwidcw8/edit#gid=0)**: simply add your name next to one of the user IDs. You'll be using this same login information for the remainder of the labs. 

[back to top](#table-of-contents)

### Today's Lab

| Main Objective for This Lab: |
| ---- |
| This week we will be focusing on processing the reads returned from NGS. By the end of the lab you should have gone from raw NGS reads to complete exon sequences for each species.  | 

<p align="center">
  <img src="https://github.com/ddecarle/eeb462-2021/blob/main/images/L5-Picture2.jpg">
</p>


### Preparing & Getting Familiar with Your Files

Before starting this section of the labs, lets prepare a local directory (*i.e.* on your computer) that will hold the files that we generate from SciNet. 

1. Create a "LabFive" folder inside your "EEB462" folder.
2. Open a new terminal window and navigate to this directory.
3. Create new directories by running the following commands:

```
mkdir prinseqGraphs
mkdir Aligns
mkdir Aligns_edited
mkdir TREES
mkdir TREES/Concat
mkdir TREES/Astral
```
These directories will hold your alignments, edited alignments and trees. We will keep returning to them throughout the next three labs.

Now let’s get onto Scinet, where we will be doing most of our work. SciNet is unix-based, and so all of the commands that you learned in the first lab and would use locally on a Mac work here. 

4. To access SciNet from any computer, open a new terminal window and log in using the `ssh` command. Replace `<username>` with your username and enter the password when prompted. 

   ```
   ssh –Y <username>@teach.scinet.utoronto.ca 
   ```
Now you are logged into SciNet’s super computer system. There are two main login nodes: `$HOME` and `$SCRATCH`. This is where you develop, prepare and submit jobs. 

When you log in, you are automatically taken to the `$HOME` node (you can confirm using `pwd`). This is a read-only node, used mainly for moving files from your computer into SciNet. We will be running all analyses on the `$SCRATCH` node.

A folder containing all material for the remaining labs has been created in the `$HOME` node: `home/l/lcl_uoteeb462/eeb462starter`

5. Move into this folder and explore its contents:

  ```
  cd ../eeb462starter
  ls
  ```

All of the files for the phylogenomics labs are here:

- The `O_niloticus_Reference` folder contains the 20 target exons for Tilapia; these will be our outgroup sequences.
- The 9 geophagine species folders contain reads for the focal taxa (use `ls Geo_abalios` to see the contents of one of these). The `sorted` part of the filenames specifies that reads are sorted by sequence identifier. A separate folder is used for each species because a number of other files will be created during processing. 
- The `Refseq_923.fna` file contains the *O. niloticus* references that will be used to guide the assembly of the target exons for the 9 geophagine taxa. The remaining files are software executables that are needed for running analyses (*e.g.* muscle and astral). 

6. Inspect the first few lines of `A_cacatuoides_sorted.fastq` using the `head` command below. This will display the first 8 lines of the `A_cacatuoides_sorted.fastq` file.  

  ```
  head -8 A_cacatuoides/A_cacatuoides_sorted.fastq
  ```

`fastq` is the standard output format for NGS reads, as it stores both sequence and quality information in the same file. Each file contains the whole collection of reads for all target exons of a given species, and each read is associated with 4 lines of text:

<p align="center">
  <img src="https://github.com/ddecarle/eeb462-2021/blob/main/images/L5-Picture3.jpg">
</p>

**Quality scores** are used by read-processing software (*e.g.* PRINSEQ) further down the pipeline to determine which bases/reads to trim according to user-defined quality thresholds. Quality scores are related to the probability of an incorrect base call (*i.e.* sequencing error rate). Low quality bases have high error rates, and should thus be trimmed. Bases with quality scores ≥ 20 are usually considered of good quality. 
These are all of the characters in order of quality (from 0-93).

<p align="center">
  <img src="https://github.com/ddecarle/eeb462-2021/blob/main/images/L5-Picture4.jpg">
</p>

---

#### QUESTION 1

Paste the output from the `head -8` command above (*i.e.* the first 2 reads and their associated information) below. If a minimum threshold quality of 20 was used, would you say that this set of reads is of generally high or low quality? Explain BRIEFLY. *(2 points)*

---

7. Use the `ls`, `tr` and `sed` commands to make `speciesNames.txt` and `exonNames.txt` files. These files will contain space-delimited species and exon names, respectively, which will be useful for automating scripts across specific species or exons with for-loops later.

  ```
  ls -d */ | tr '/\n' ' ' > $SCRATCH/speciesNames.txt
  sed -i 's/astralEx//' $SCRATCH/speciesNames.txt
  ls O_niloticus_References | sed 's/_REFERENCE.fasta//g' | tr '\n' ' ' > $SCRATCH/exonNames.txt
  ```
  
Now whenever you need to automate a script for all folders, simply print the contents of the species or exon file to the console with `cat` and copy and paste what you need into a for-loop (see next section). 

  ```
  cat speciesNames.txt
  cat exonNames.txt
  ```
  
Lastly, SciNet has installed the software that we need as modules. The necessary modules need to be loaded, along with any dependencies (*e.g.* gcc), in order for the software to be available in your SciNet session. 

8. Move into your `scratch`node, then load the modules.

  ```
  cd $SCRATCH
  module load gcc
  module load tbb
  module load prinseq
  module load bowtie2
  module load samtools
  module load bcftools
  ```
If you encounter an error, try replacing the `module load gcc` command with the following command instead: `module load gcc/7.3.0`
  
9. Confirm that your modules were loaded using the command `module list`, and checking to see that all the relevant modules are displayed in the terminal. 

[back to top](#table-of-contents)

### Filter and Trim Reads (*PRINSEQ*)

We will be using the PRINSEQ software to process reads. PRINSEQ has an online GUI version, but automation is best achieved through the command line. A for-loop will be used to automate read processing for geophagine species.  

There are a lot of reads, so processing them can take a long time (~30+ minutes/species, depending on computational power). To speed things up, we are only going to process 1 taxon (*A. cacatuoides*) for this section of the lab. All other have been done for you. 

1. Print the contents of the `speciesNames.txt` file (generated in section 1) using `cat`. 
2. Copy the first name (*i.e.* *A. cacatuoides*) in the resulting list and replace it for `<species_names>` in the first line of the following script. 

  ```
for species in <species_names>
do

#make a folder to contain your results
mkdir $species
  
#Run prinseq on sorted read files
prinseq-lite.pl -fastq $species/${species}_sorted.fastq -out_format 3 -out_good $species/${species}_processed1 -out_bad null -no_qual_header -min_qual_mean 20 -ns_max_p 1 -derep 12345 -trim_tail_left 5 -trim_tail_right 5 -trim_qual_left 20 -trim_qual_right 20 -trim_qual_type mean -trim_qual_rule lt -trim_qual_window 5 -trim_qual_step 1 -min_len 60 -graph_stats ld,qd,da -graph_data 
    
done
  ```

4. Run the entire for-loop. Comments (*i.e.* lines of text in the script starting with `#`) are ignored by the shell (*i.e.* not interpreted as commands) and are included primarily to help explain what the script is doing.

**NOTE:** a for-loop is not actually necessary here since we are processing only 1 file, but we will use one anyway so that you know how to do it if you want to process multiple species in the future. 

This PRINSEQ script filters and trims reads based on a series of specified parameters. Here is a more detailed explanation of the parameters that we specified. See the [prinseq manual](#software) for additional options and explanations: 

  -	`-fastq` specifies the input fastq file containing the full set of reads
  -	`-out_format` specifies the output format (3 = fastq). 
  -	`-out_good` specifies the file name for the processed reads
  -	`-out_bad null` prevents the generation of data for reads that fail filters. 
  -	`-min_qual_mean 20` filters out reads with a mean quality score below 20.
  -	`-ns_max_p 1` filters out reads with more than 1% N’s (N = ambiguous data).
  -	`-derep 12345` filters out all types of read duplicates.
  -	`-trim_tail_left 5` and `-trim_tail_right 5` trim poly-A tails with a minimum length of 5 from the 3’ and 5’ ends of reads.
  -	`-trim_qual_type mean` specifies that the type of quality score that should be assessed is the mean score across a length of 5 bases, as specified by `-trim_qual_window 5`. If the average quality across sets 5 bases is below the threshold (*i.e.* 20), then those bases will be trimmed from the read. 
  -	`-trim_qual_window 5` specifies a window of 5 bases for assessing quality scores. Larger or smaller window sizes can be used, but 5 is reasonable.
  -	`-trim_qual_step 1` specifies that the step size for moving the sliding window of bases is 1. That is, after assessing a set of 5 bases, move onto the next 5, without skipping any bases. If step size was 2, then the next 5 bases to be assessed would start 2-bases over from the initial 5-base window.
  -	`-trim_qual_rule` lt specifies that bases with a mean quality score less than the indicated threshold should be trimmed from reads. 
  -	`-trim_qual_left 20` and `-trim_qual_right 20` specifies a quality threshold of 20 for trimming bases from 3’ and 5’ end of reads.
  -	`-min_len 60` filters reads shorter than 60 bases in length, as these will be hard to assemble back into target exons (very short reads can be misaligned to the reference).
  -	`-graph_data` creates a file with stats needed to generate summary graphs with prinseq.
  -	`–graph_stats ld,qd,da` specifies that only stats for length distribution, base quality distribution, and read duplicates need to be calculated and saved. There are several other stats that can be calculated, but for this lab, we will focus only on these 3.  
 
---

#### QUESTION 2

Fill out the table below to summarize the types of reads that get filtered and bases that get trimmed according to the parameters in our script. One example for each is provided in order to get you started. *(3 points)*

| Filtered reads: | Trim: |
| --------------- | ----- |
| Reads with a mean quality score < 20 | Poly-A tails longer than 5 bases in length |
| <br>     | <br>    |
| <br>     | <br>    |
| <br>     | <br>    |

---

5. Calculate the same graphing stats for the processed reads:

  ```
  for species in A_cacatuoides
  do

  #Generate stats for Processed data
  prinseq-lite.pl -fastq $species/${species}_processed1.fastq -out_good $species/${species}_Processed1_GraphGeneration_Delete -out_bad null -no_qual_header -graph_data $species/${species}_Processed1_Graphs.gd –graph_stats ld,qd,da

  rm $species/${species}_Processed1_GraphGeneration_Delete.fastq

  done
  ```

  when promoted, enter `y` to confirm that you want to delete the .fastq file as specified in the above command

[back to top](#table-of-contents)

### Assess Read Quality (PRINSEQ)

We will be using PRINSEQ’s online software to generate .png graphs to visualize a summary of our unprocessed and processed reads for *A. cacatuoides*.

1. Download the graph file for *A. cacatuoides* from SciNet to the "prinseqGraphs" directory that you created locally. In a new terminal window that is ***not signed into SciNet*** navigate to the "prinseqGraphs" directory.   
  
  confirm that you are in the right directory using `pwd`

2. From here use the following command to access SciNet and download the specified file. Replace `<username>` in both locations with your username and enter your password when prompted. 
  
  ```
  scp <username>@teach.scinet.utoronto.ca:/scratch/l/lcl_uoteeb462/<username>/eeb462share/A_cacatuoides/A_cacatuoides_Unprocessed_graphs.gd .
  ```
  
3. The prinseq graphs should now be inside your prinseqGraphs folder. Confirm using `ls`.

4. In a web browser, go to [http://edwards.sdsu.edu/cgi-bin/prinseq/prinseq.cgi](http://edwards.sdsu.edu/cgi-bin/prinseq/prinseq.cgi)

5. select **Get Report** > click on **Select a graph data file to upload** > upload the `A_cacatuoides_Unprocessed_graphs.gd` file > click **Continue** > Download the .zip file and unpack it. 
 
This folder contains the collection of graphs generated for the unprocessed reads for this species.   

6. Repeat steps 1 - 5 for the processed reads: `A_cacatuoides_Processed1_Graphs.gd`

7. Look in the unpacked folders. Note that many graphs have been produced. Feel free to look these over if you want a better understanding of the types of stats that prinseq calculates. For this lab, we will focus only on the distribution of quality scores and duplicates across reads. 

---

#### QUESTION 3

Paste the quality and duplicate distribution graphs for *A. cacatuoides*’s unprocessed reads below. The file extensions for these graphs are: `_qd.png`, `_qd3.png`, and `_df.png`. Give each graph a figure legend with an informative title. Refer to these when answering questions 5 a-c. *(6 points)*

  - a) Is there a part along the length of reads that appears to be particularly prone to sequencing errors? 
  - b)	Would you say that across their length reads are mostly of low (mean quality score < 20) or high (mean quality score > 20) quality? 
  - c)	Is there evidence of duplicates in this dataset? If so, what type of duplicate is most common? Do most reads with duplicates have only a few or many copies? 

#### QUESTION 4

Paste these same 3 graphs for the processed reads and give them figure legends, and use them to answer the following questions. *(3 points)*

  - a) Has the quality of the reads improved?
  - b) Were duplicates successfully eliminated? If any remain, describe the type and amount remaining. Are any remaining duplicates likely to be problematic?

---
  
You can use the post-process graphs to inform the continued to processing of reads (*i.e.* repeat [filtering and trimming of reads] (#filter-and-trim-reads-prinseq) with updated parameters) until you are happy with the quality of your reads. For this lab our processing produced pretty good results, so we will be content with 1 round and move on to assembling our high quality reads. 

[back to top](#table-of-contents)

### Assemble Raw Reads (Bowtie2, SAMtools)

Now that the reads have been processed, we will assemble them into complete target exons using the the *O. niloticus* exons as a guide. These steps are not as computational intensive as the previous section, so we will be using for loops to process *ALL* reads.  

1. Go back to the ***terminal window that is signed into SciNet*** and whose working directory is set to `eeb462share` (you can confirm with `pwd`).

2. Create an index of the reference sequences using the `Refseq_923.fna` file, which contains all of the target exons for *O. niloticus*. 

  ```
  bowtie2-build Refseq_923.fna Refseq923
  ```

3. Print the species names to the console: `cat speciesNames.txt`

4. Copy all names **except for *O_niloticus***, and use that to replace `<species_names>` in the first line of the following code. Run the following for-loop for ALL target taxa (*i.e.* all taxa except *O. niloticus*). This will assemble reads using the indexed *O. niloticus* reference as a guide. The final result will be consensus sequences with a minimum read depth > 10. As the code below runs (it will take a few minutes) read through the comments above each command and the corresponding more detailed description below for details of the process. Each line of code is numbered so that you can match it with the description below. 

  ```
  for species in <species_names>
  do
  
    # 1. Assemble target sequences using the reads that were processed with PRINSEQ by aligning them to the indexed reference sequences. 
    bowtie2 --very-sensitive-local -x Refseq_923 -U $species/${species}_processed1.fastq -S $species/${species}.sam

    # 2. Sort reads in sam format
    samtools sort $species/${species}.sam > $species/${species}.sorted.sam

    # 3. Convert sorted sam to sorted bam
    samtools view -b $species/${species}.sorted.sam > $species/${species}.sorted.bam

    # 4. Convert .bam to .vcf while filtering out reads with quality scores < 20. Pipe the filtered reads to bcftools call for variant calling.  
    bcftools mpileup  -f Refseq_923.fna -q20 -Q20 $species/${species}.sorted.bam | bcftools call -c -Ov -o $species/${species}.sorted.vcf

    # 5. Filter out reads with a read depth less than 10. This outputs a fastq file 
    vcfutils.pl vcf2fq -d10 $species/${species}.sorted.vcf > $species/${species}.fq

    # 6. Convert fastq to fasta, converting all poor quality bases to Ns
    sed '/^+/,/^\@/{/^+/!{/^\@/!d}}' $species/${species}.fq | sed 's/@/>/g' | sed '/+/d' | sed 's/[a-z]/N/g' > $species/${species}.fasta

  done
  ```

**NOTE:** You may get an error when executing this for loop. If that is the case, try manually re-typing the line of code beneath comment #1. Then, re-run the command from step 2, and execute the for loop again.

<p align="center">
  <img src="https://github.com/ddecarle/eeb462-2021/blob/main/images/L5-Picture5.png">
</p>

| Figure 2. Schematic showing how we go from raw reads (2.1) to assembled loci (2.3) using guided assembly with a reference (2.2). |
| ---- |
| **2.1** Shows raw reads for two target loci (1 (red) , 2 (green)), for each of three species (A,B,C). <br> **2.2** Shows the complete sequences for loci 1 and 2 for our reference taxon. <br> **2.3** Shows the process of guided assembly. <br> Raw reads are aligned back to their corresponding reference locus. A consensus sequence (*i.e.* assembled target) is extracted from the aligned reads. Now we have complete target sequences for our three species. `*` and `**` highlight two bp sites in locus 1 for species C. `* `shows a site that is represented in only one read and thus is said to have a read depth of 1. `**` shows a site that has coverage across 4 sites, and thus has a read depth of 4. | 

PRINSEQ command explained:

  - **Line 1:** First, the PRINSEQ-processed reads for the target exons are aligned to the indexed *O. niloticus* references with Bowtie2. This is referred to as guided assembly since the assembly of target sequences from raw reads is guided by alignment of those reads to a reference sequence (**Fig.2**). <br>
Bowtie2 allows you to set assembly parameters (*e.g.* maximum number of mismatches allowed, number of times to re-seed, etc.) manually, which affects how easily reads are able to align back to their corresponding reference sequences. Choosing parameters that maximize the rate of read alignment while minimize alignment error can be tricky. Alternatively, you can use one of Bowtie2’s presets, which sets all of these alignment parameters for you according to how sensitive the preset is. Since our reference is relatively closely related to our targets (they are all cichlids), we will be using `--very-sensitive-local` preset. The outputted files are in SAM format (1 per species).
  - **Line 2:** The SAM files are sorted by exon to match the indexed reference. Sorting is important for generating and storing read statistics that are used in the generation of consensus target sequences down the line. 
  - **Line 3:** Sorted SAM files are converted to sorted BAM files, as the latter are better for storing and working with large amounts of data.  
  - **Line 4:** Sorted BAM files are filtered (with `bcftools mpileup`) to retain only aligned reads with a minimum quality score of 20. From the resulting high quality sites only those that differ from the reference (*i.e.* variable sites) are retained using variant calling (with `bcftools call`). 
  - **Line 5:** Finally, of the high quality variant sites, sites are further filtered (with `vcfutils.pl`) to retain only those with a minimum read depth of 10. <br> 
Read depth (also known as depth of coverage) refers to the number of independent reads that a base site is represented in. For example, a site with a read depth of 100 is represented in 100 reads. Read depth provides a measure of confidence in sequencing. The higher the number of reads that support a site, the more confident you can be that that site was correctly sequenced. If a site is represented in only a few reads, then it is difficult to know whether the correct base was called for that site or whether you are dealing with a sequencing error. See **Fig. 2.3** for a graphical explanation of read depth.
  - **Line 6:** The files outputted by `vcfutils.pl` are in `.fastq` format. This simple series of sed commands converts them to fasta formatted files. Low quality bases, coded as lowercase bases in the fastq file, are also converted to Ns

5. Use the following to assess a final fasta file: `cat Gym_balzanii/Gym_balzanii.fasta`

If this command does not print a fasta file to your terminal, re-run the code from step 4.

---

#### QUESTION 5

It is important to find the correct level of sensitivity when assembling reads with a reference (here *O. niloticus*) as a guide. We used the `--very-sensitive-local` preset. What are the risks associated with choosing parameters that are too stringent? How about too lenient? *(3 points)*

#### QUESTION 6

Can you think of a scenario in which you would opt for very stringent mapping parameters? How about more lenient parameters? *(2 points)*

#### QUESTION 7

Use the following two lines of code to look at the first four assembled loci for *A. cacuatoides* and *G. balzanii*.

  ```
  head -100 A_cacatuoides/A_cacatuoides.fasta
  head -100 Gym_balzanii/Gym_balzanii.fasta
  ```
Which species has more missing data? What effects might missing data for this species have on phylogenetic analyses? *(3 points)*

---

<div align="center">

***You now have 20 fully assembled loci for 9 ingroup and an outgroup cichlid.*** 

| Congratulations! |
| ---------------- |

</dir>

Next week we review these exons in more detail and align sequence. 

[back to top](#table-of-contents)
