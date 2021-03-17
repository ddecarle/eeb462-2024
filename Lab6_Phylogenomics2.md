# Lab 6: Phylogenomics II

*Tutorial by Viviana Astudillo-Clavijo*

### Background

During Lab 5 we processed and assembled raw NGS reads to generate fasta format sequences for our taxa of interest (*i.e.* target loci). Today we will focus on **further processing these fasta files in order to prepare the data for phylogenetic analyses**. 

The first step will be **assessing our assembled target loci** in more detail. Specifically, we want to make sure that what we assembled is of good enough quality for robust phylogenetic analyses (remember: garbage in ➤ garbage out). Poor quality loci include those with large amounts of **missing data**, as these contain few phylogenetically informative sites and can thus present challenges to or mislead phylogenetic analyses. 

After removing poor quality loci, an important next step is ensuring that loci are orthologous. **Orthologous sequences are those with shared ancestry and whose split from one another was the result of a speciation event**. Another non-speciation event that can lead to similar but non-orthologous sequences is gene duplication. Sequences with a shared ancestry whose split was the result of a gene duplication even are known as **paralogous sequences**. Phylogenies based on orthologous sequences give us the history of species relationship. In contrast, phylogenies based on paralogous sequences give us the history of gene duplication events, which may not be the same as the history of speciation events. Therefore, if we are interested in resolving species relationships (which we often are), then it is imperative that we base our analyses almost exclusively on orthologous sequences.

Unfortunately, it is not always easy to determine whether the loci you are using represent orthologous copies across your taxa. In response, several approaches for identifying orthologs have been developed:

 - **Preselection of Orthologs:** Some researchers take care of the issue of orthology *prior to sequencing*. One way to do this is to scan a set of existing annotated genomes and identify loci that are present in only a single copy across taxa. Then probes are designed to capture only these single-copy loci during DNA sequencing. 

 - **Identification of Orthologs After Sequencing:** Many other approaches also exist for identifying orthologs once you have your assembled sequences. The algorithms on which these are based, and their relative advantages and disadvantages are several, but we won’t discuss them in detail here.

The cichlid loci used for this course are **single-copy exons**. That is, target loci were selected based on their presence as only a single copy across a few cichlid genomes, and thus are very likely to represent only orthologous sequences ([Ilves et al. 2014](https://www.researchgate.net/publication/259697052_A_targeted_next-generation_sequencing_toolkit_for_exon-based_cichlid_phylogenomics)). As a result, **we will not be implementing orthology-identification analyses in this lab**. 

### Lab Assignment 6

Questions: *(10 points total)*

 - [1](#question-1), [2](#question-2), [3](#question-3), [4](#question-4), [5](#question-5), [6](#question-6)

## Table of Contents

- [Tutorial](#tutorial)
  - [Assessing and Filtering Assembled Loci](#assessing-and-filtering-assembled-loci) 
  - [Multiple Sequence Alignment](#multiple-sequence-alignment-muscle)
  - [Inspection and Editing of Alignments](#inspect-and-manually-edit-alignments-mesquite)


## Software

For this lab, we'll be using the following software:

- [MUSCLE](https://www.drive5.com/muscle/downloads.htm): ([MUSCLE Manual](http://www.drive5.com/muscle/muscle.html))
- [Mesquite](http://www.mesquiteproject.org/Installation.html)
- a plain text editor of your choice

Don't forget to ***consult the [Command Line Basics](https://github.com/ddecarle/eeb462-2021/blob/main/CommandLineBasics.md) tutorial*** for more in-depth explanations of scripting and for loops.

## Tutorial


| Main Objective for This Lab: |
| ---- |
| In this week’s lab we will be looking at our assembled target loci in more detail and identifying those that remain useful for phylogenetic analyses. The remaining high-quality orthologous loci will then be aligned to each other. Finally, these multiple sequence alignments will be reviewed and manually edited where necessary. At the end of the lab we should have edited sequence alignments for our target loci that are ready for tree building in next lab. | 


<p align="center">
  <img src="https://github.com/ddecarle/eeb462-2021/blob/main/images/L6-Picture1.jpg">
</p>

### Assessing and Filtering Assembled Loci

1. Log into SciNet and navigate into the `eeb462share` directory. Use the same username and password you used for the previous lab: sign in info can be found [here](https://docs.google.com/spreadsheets/d/17IvhbKuhfztwHabd2wutmKfHzgghxrFleCcJrwidcw8/edit#gid=0). 

	```
	ssh -Y <username>@teach.scinet.utoronto.ca
	cd $SCRATCH/eeb462share
	```
At the end of last lab we generated complete target loci for our ingroup taxa. The `*.fasta` files that we generated have multiple lines of nucleotides per locus (you can confirm using `head -20 Gym_balzanii/Gym_balzanii.fasta`). Sequence data is much easier to work with if there is only a single line of nucleotides per locus. 

2. Use this for loop to update our `*.fasta` files so that each locus consists of only a single line of text with the entire sequence.

	```
	for species in A_cacatuoides  B_cupido  C_minuano  Geo_abalios  Geo_dicrozoster  Gym_balzanii  Gym_rhabdotus  Mik_altispinosus  Mik_ramirezi
	do
	cat $species/${species}.fasta | sed '/^>/ s/^/ /' | sed '/^ >/ s/$/ /' | tr -d '\n' | tr ' ' '\n' | sed '/^$/d' > $species/${species}2.fasta
	mv -f $species/${species}2.fasta $species/${species}.fasta
	done
	```

3. Confirm that this worked. This command should print the first two sequences in the `.fasta` file to your terminal: you should see two lines for each sequence - one with the locus identifier, and a second with the sequence.
	
	`head -4 Gym_balzanii/Gym_balzanii.fasta`

Now we will further process our assembled reads to prepare them for multiple sequence alignment.

If you look at the sequences for any one species (*i.e.* the `*.fasta` file), you will note that some loci have some or many Ns. **Loci with large amounts of missing data have few phylogenetically informative sites and are therefore not particularly useful for inferring relationships**, and can actually mislead estimates in some cases. Filtering out poor quality loci is a common next step in phylogenetics. 

Choosing which loci to filter out is usually arbitrary, but nonetheless informed by the data. For example, you may choose to filter out any target sequence that is less than 50% of the reference length. Filtering of loci can be done either with the command line or GUI sequence editing software, like [Geneious](https://www.geneious.com/) or [Mesquite](http://www.mesquiteproject.org/Installation.html). Here we will filter out all target sequences < 500 basepairs (bp) in length using the command line. 

4. Run the following script. **Read the embedded comments** to get a better idea of what the script is doing.

	```
	for species in A_cacatuoides  B_cupido  C_minuano  Geo_abalios  Geo_dicrozoster  Gym_balzanii  Gym_rhabdotus  Mik_altispinosus  Mik_ramirezi 
	do
	# Compute the length of all target sequences (excluding Ns) for all ingroup taxa and store this as a variable called TargetLength
	# Create two more variables containing the name of target exons (Exons) and species (Sp).
	TargetLength=`cat $species/${species}.fasta | tr -d -c '[ACTG]\n' | awk '!(NR % 2) {print length($0)}'` 
	Exons=`grep ">" $species/${species}.fasta`
	Sp=`yes "$species" | head -n 20`
	
	# Combine the three variables into one table. Now you have a table with sequence lengths for all target loci across ingroup taxa 
	paste -d ' ' <(echo "$Sp") <(echo "$Exons") <(echo "$TargetLength") >> TargLengths.txt
	
	done
	
	# Make another table (TargLengths_min500.txt) containing only those sequences > 500 bp in length
	cat TargLengths.txt | awk '$3>500' > TargLengths_min500.txt
	
	# Finally, use the sequence information in the TargLengths_min500.txt table to find (i.e. using grep) and extract only those sequences that meet our 500bp threshold from the *.fa files that we generated in last lab (i.e. from the complete set of target exons)
	
	for species in A_cacatuoides  B_cupido  C_minuano  Geo_abalios  Geo_dicrozoster  Gym_balzanii  Gym_rhabdotus  Mik_altispinosus  Mik_ramirezi 
	do
	ExonKeep=`grep "$species" TargLengths_min500.txt | cut -d' ' -f2`
	grep -A1 "$ExonKeep" $species/${species}.fasta > $species/${species}_500bp.fasta
	sed -i '/^-/d' $species/${species}_500bp.fasta 
	done
	
	```

---
#### QUESTION 1 

Reveal the contents of the `TargLengths_min500.txt` file for the first two taxa using the following command: `head -30 TargLengths_min500.txt`. Copy and paste the resulting table. *(1 point)*

---

[back to top](#table-of-contents)

### Multiple Sequence Alignment (MUSCLE)

Now that we have established a set of good quality target loci, we are ready to align our sequences. 

5. To keep things neat, make a directory to hold your alignments: `mkdir Aligns`. This directory should have been created within the `eeb462share` directory. Confirm using this command: `ls $SCSRATCH/eeb462share`  

Right now the target sequences only include the loci names. We need to **append the species name to each locus**, otherwise we won’t be able to identify to which species loci belong to once they are aligned. (The references are already appended with “`O_niloticus`".) We also need to **separate all sequences into their own files** because we will have to concatenate them by locus, rather than by species like they are now, for MUSCLE to align them. 

6. Run the code below to do these two things:  

	```
	for species in A_cacatuoides B_cupido  C_minuano  Geo_abalios  Geo_dicrozoster  Gym_balzanii  Gym_rhabdotus  Mik_altispinosus  Mik_ramirezi
	do
	
	# Append species name. To do this, sed finds lines starting with > (i.e. lines containing the sequence name) and adds “_${species}” to the end of those lines
	sed -i "/^>/ s/$/_${species}/" $species/${species}_500bp.fasta
	
	# Split all 20 sequences into their own file
	split -l 2 -d $species/${species}_500bp.fasta $species/${species}_
	
		# Rename files to “locus_taxa.fa” format
		for file in $species/${species}_[0-2][0-9]
		do
		read line < "$file"
		mv "$file" "${line#?}.fasta"
		done
	
	done
	
	# Move the separate files into the Aligns directory
	mv *.fasta Aligns
	```
	
7. Look at the contents of the `Aligns` directory. You should see many files named `locus_taxa.fasta`. **Look inside one of these files to confirm** that it contains a single sequence for one species:

	```
	ls Aligns
	cat Aligns/ENSONIE00000005149_A_cacatuoides.fasta
	```

Right now the Aligns directory only contains target sequences. 

8. Put a copy of the *O. niloticus* loci in there as well, as this will be our outgroup taxon in phylogenetic analyses: `cp O_niloticus_References/*.fasta Aligns`.

Now let’s concatenate and align our loci!

First, we will concatenate the `*.fasta` files by locus to generate 20 "`${exon}_Concat.fasta`" files. That is, we are **generating a single file containing all taxa for each of our 20 loci**. Then we will use MUSCLE to align the loci within each of these 20 files. Locus names were extracted from the `exonNames.txt` file generated at the beginning of last lab (using `cat exonNames.txt`) and pasted into this for-loop for you. 

9. Use the for loop to generate a single file for each locus and align those sequences:

	```
	for exon in ENSONIE00000005149 ENSONIE00000015639 ENSONIE00000021168 ENSONIE00000023461 ENSONIE00000029595 ENSONIE00000033868 ENSONIE00000034582 ENSONIE00000042474 ENSONIE00000044242 ENSONIE00000048423 ENSONIE00000061707 ENSONIE00000064342 ENSONIE00000075454 ENSONIE00000110949 ENSONIE00000130663 ENSONIE00000141538 ENSONIE00000265157 ENSONIE00000265161 ENSONIE00000265364 ENSONIE00000265379_GPR85 
	do
	
	# Concatenate by locus
	cat Aligns/${exon}* > Aligns/${exon}_Concat.fasta
	
	# Align (using MUSCLE)
	./muscle -in Aligns/${exon}_Concat.fasta -out Aligns/${exon}_MUSCLEaligned.fasta
	
	done
	
	```

10. Delete concatenated files: we won’t be needing them again: `rm -I Aligns/*_Concat.fasta`. 
	
	- You will be asked to confirm that you want to delete these files, simply enter `y` when prompted.

11. Confirm that you have created `*_MUSCLEaligned.fasta` files for each locus: `ls Aligns/*_MUSCLEaligned.fasta`.

[back to top](#table-of-contents)

### Inspect and Manually Edit Alignments (Mesquite)

The first thing we will do is **check whether alignments have enough taxa to be worth including** in phylogenetic analyses. Recall that we got rid of sequences < 500bp in length. This means that **some alignments will contain fewer than our initial 10 taxa**. 

While some amount of missing taxonomic data is ok (*i.e.* can still give us good phylogenetic resolution), alignments with too many missing taxa are not particularly useful for resolving relationships amongst our focal taxa. Like with our 500bp cutoff, deciding on how many taxa are enough can be an arbitrary decision. Here we will **retain only alignments that contain at least half of the taxa** (*i.e.* at least 5 taxa). 

We can determine which alignments don’t meet this cutoff fairly easily with the command line. 

11. Move into your local Aligns directory and run the following for-loop.

	```
	cd Aligns
	for exon in ENSONIE00000005149 ENSONIE00000015639 ENSONIE00000021168 ENSONIE00000023461 ENSONIE00000029595 ENSONIE00000033868 ENSONIE00000034582 ENSONIE00000042474 ENSONIE00000044242 ENSONIE00000048423 ENSONIE00000061707 ENSONIE00000064342 ENSONIE00000075454 ENSONIE00000110949 ENSONIE00000130663 ENSONIE00000141538 ENSONIE00000265157 ENSONIE00000265161 ENSONIE00000265364 ENSONIE00000265379_GPR85
	
	do
	
	# Count the number of sequences in the alignment by counting the number of times that the > character is present
	nTaxa=`cat ${exon}_MUSCLEaligned.fasta | grep '>' | wc -l`
	printf "%-30s %-30s \n" "$exon" "$nTaxa "
	
	done
	```
The output should be a table printed to the terminal with the first column containing locus name and the second showing the number of taxa in that alignment.

---
#### QUESTION 2
 
Copy and paste the resulting table. *(1 point)*

#### QUESTION 3

 Did any alignments contain fewer than 5 taxa? If so, which? How many loci are left in our dataset? *(2 points)*

---

12. If any alignments contain sequences for fewer than 5 taxa, delete them from your dataset: they do not contain enough information to be phyogenetically useful. Use the following command, replacing `<exon_names>` with the names of any exons to be deleted:

	```
	for exon in <exon_names>
	do
	rm -I ${exon}_MUSCLEaligned.fasta                             
	done
	```
	
13. Confirm that you deleted them: `ls *MUSCLEaligned.fasta | wc -l`. 

The above command will print the number of files in the current directory that end with `MUSCLEaligned.fasta`. The number displayed should be equal to (`20 - n`) where `n` is the number of loci you deleted. 

**Now let's *manually inspect and edit alignments*.**

We are going to look through each of the remaining alignments and make some decisions about which loci to keep, and whether the alignments we have are good enough for phylogenetic analysis. 

This is usually done in a GUI editing program – like Geneious or Mesquite – where potential misalignment could be easily identified and edited. GUI sequence editing software colour codes bases, missing data and gaps. Therefore, it is easy to pick out columns (*i.e.* sites), stretches of columns (*i.e.* sections of the locus/alignment) or taxa that are problematic. 

Some of the potential problems may include the addition of gaps in an alignment where they should not be present, one or more taxa that is/are not aligned well with the rest, etc. 

**Download alignments from SciNet to the Aligns folder that you created on your computer last week.** 

14. **Open a new terminal window that is not signed into SciNet** and move into your local Aligns directory (*i.e.* the Aligns folder that you created on your computer last week). Confirm that you are in the right place using `pwd`. We will be working in this directory, off of SciNet, for the remainder of the lab, so make sure that you are in the right place.

15. When you are in the right directory, use `scp` ("secure copy") to download all `*_MUSCLEaligned.fasta` files from the `Aligns` directory in Scinet to your *local* `Aligns` directory. The period (`.`) at the end of this command specifies that the downloaded files should be placed in the current working directory (which again, is your local Aligns directory). Replace `<directory>` with your desired directory. Also replace `<username>` with your Scinet username. Enter your password when prompted. 

```
scp <username>@teach.scinet.utoronto.ca:/scratch/t/teacheeb462/<username>/eeb462share/Aligns/\*MUSCLEaligned.fasta .

```

**NOTE:** the back-slash (`\`) before the wildcard character (`*`) in the above command is known as an "escape character". We use escape characters to indicate that we want to use the literal meaning for the following character, rather than any other significance that character might have. Although we do not need to use an escape character when navigating through directories on SciNet, it is an essential part of the `scp` command. 

16. Open the `Aligns` folder on your local computer to confirm that you have downloaded the alignments. 

We will now review the alignments in Mesquite. 

For a small dataset like outs, this may be a fairly quick process. For larger datasets (*e.g.* hundreds of loci), editing alignments can easily take many days or weeks. 

While time-consuming, it is important to manually review and edit your alignments. Automated alignment software (such as MUSCLE) can – and occasionally does – make mistakes. It is up to the researcher, who knows the system they are working with, to vet the resulting alignments that will serve as input data for phylogenetic inference. (Again, garbage in ➤ garbage out).

**NOTE:** : Keep track of your editing steps for the following three sequences, as the next assignment questions are based on them (See [Q4](#question-4) & [Q5](#question-5) before editing these loci):


| `ENSONIE00000023461` |	`ENSONIE00000110949` |	`ENSONIE000000265157` |
| ----- | ----- | ----- |

17. Import each alignment into Mesquite, and **review each one using the following steps** to ensure that the best alignment has been achieved. Although MUSCLE usually produces very good alignments, sequences that are more divergent or have many sites with missing data can result in alignment errors. 

- open the alignment in Mesquite
- Review and edit the alignment – if necessary – to ensure that the best alignment has been achieved. Here are some general tips for editing sequences:
  - If many target taxa have gaps or Ns at the 3’ and/or 5’ end, trim these ends. They provide little to no phylogenetically informative data.
  - Recall that the loci that we are working with are exons. Therefore, there should be no gaps with a length that ≠ a multiple of 3 within sequences, as these would affect the reading frame. Edit sequences to remove internal gaps. ***Make sure that the parts of the sequence that are left remain correctly aligned*** across taxa.
  - If one or a few taxon look as though they are misaligned with the rest (*i.e.* they have many sites that are not consistent with the colour code of most others), then these may represent misalignments. This can happen during the automated aliment process (*i.e.* with MUSCLE), but can also be the result of your own editing (*e.g.* if you delete some upstream gaps that cause the whole sequences to shift). For these taxa, you may have to shift the entire sequence to the left or right to improve its alignment with the other taxa. 
- Export each of the edited sequences from Mesquite in Fasta format, and **save it in your `Aligns_edited` directory.**
  - **File** > **Export…** > select **FASTA (DNA/RNA)** > **OK** > Check **include gaps** > **Export** > Delete the `.fas` extension at the end of the file name (it should just be `.fasta`) > **Save** 

18. Review the edited sequences in a text editor. Notice that Mesquite exports `.fasta` files as a multi-line sequence for each taxon. As before, we will have to use the command line to convert these back to a single-line-per-taxon format. 

19. In a terminal window whose working directory is set to the location of your edited alignments run the following for-loop (*i.e.* your local `Aligns` folder). Replace `<exon_names>` with the name of the edited loci that you exported from Mesquite.

	```
	for exon in <exon_names>
	do
	cat ${exon}_MUSCLEaligned.fasta | sed '/^>/ s/^/ /' | sed '/^ >/ s/$/ /' | tr -d '\n' | tr ' ' '\n' | sed '/^$/d' > ${exon}_MUSCLEaligned2.fasta
	mv -f ${exon}_MUSCLEaligned2.fasta ${exon}_MUSCLEaligned.fasta 
	done
	
	```

---
The next two questions deal with the three alignments that you were asked to keep track of (*i.e.* `ENSONIE00000023461`, `ENSONIE00000110949`, `ENSONIE000000265157`). 

#### QUESTION 4
 
Which alignment(s) had 3’ and/or 5’ ends with large amounts of missing data or gaps? Briefly summarize the steps you took to edit this/these alignments . *(3 points)*

#### QUESTION 5

Which alignment(s) had internal gaps? Briefly summarize the steps you took to edit this/these alignments *(1 point)*

#### QUESTION 6

Reviewing and manually editing alignments can be very time consuming for phylogenomic datasets. Nonetheless, many researchers would not proceed with tree-building without looking over their alignments, one-by-one. Why it is so important to inspect and manually edit each alignment before tree building? *(2 points)*

---

Let's end by putting our edited alignments back onto SciNet. 

20. In a terminal window that is logged into your SciNet account, create a new directory within the `eeb462share` folder to hold edited alignments: `mkdir Aligns_edited`.

21. From your other terminal window (*i.e.* the one that isn't logged in to SciNet), navigate to your `Aligns_edited` folder, and use the following `scp` command to transfer the files back to SciNet. As always, remember to replace `<username>` with the correct user ID. 

[back to top](#table-of-contents)

**You now have good alignments!** 

**We are finally ready for tree building!** …next week
