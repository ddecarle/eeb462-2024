## Setting up your workspace 

1. All necessary files for this lab are stored in the "student" folder on the EEB teaching laptop, so you will not need to follow the first few steps listed in the main tutorial.  

2. Open an instance of Windows PowerShell from the start menu.

3. Navigate to the `LabOne` folder within the `EEB462` folder:

```
cd C:\Users\student\EEB462\LabOne
```

4. create a new folder called `Fasta`:

```
mkdir Fasta
```

5. move all `.fasta` files into this new folder 

```
mv *fasta Fasta
```

6. Navigate into the `Fasta` folder using `cd` and use the list directory contents command (`ls`) to examine the contents of the folder.

Use this  information to answer QUESTION 1. 

7. use the following command to examine the first few lines of the file `16s.fasta`:
`Get-Content 16s.fasta -Head 10`

## Downloading sequences

These sequences are already downloaded for you, so you will not need to download them again. They are stored in the file `18s-2.fasta`

## Quality control

1.  In the Powershell, use `cd` to navigate to the `Fasta` folder if you are not already there. Then, use the following command to cound the number of sequences in the `18s.fasta` file. 

```
(get-content 18s-2.fasta | select-string -pattern ">").length
```

2. Follow steps 2-5 from the main tutorial.

## Formatting your data

1. Because students are not allowed to run scripts on the teaching laptops, you can skip this step. The sequences are already correctly named for you. 

2-3. Follow steps 2-3 from the main tutorial

4. Use the following command to append the contents of `extraMammals.fasta` to `18s-2.fasta`:

```
get-content 18s-2.fasta, extraMammals.fasta | set-content 18s.fasta
```

5. Ensure that `18s.fasta` now contains all 21 sequences for 18S:

```
(get-content 18s.fasta | select-string -pattern ">").length
```

6. Once you have confirmed that this is the case, delete `extraMammals.fasta` and `18s-2.fasta` using the following commands:

```
del extraMammals.fasta
del 18s-2.fasta
```

## Translating sequences

 Follow steps 1-5 in the main tutorial. 

 6. Open `coi-protein.fasta` in your text editor (*e.g.* Notepad++) and remove '_2' from the end of each sequence name. 

 ## Alignment

 To use MUSCLE in PowerShell, you will use the following command: 

 ```
 muscle-win64.v5.3.exe -align <input file> -output <output file>

```

To align our 16s sequences, for example, we would use the following command:

 ```
 muscle-win64.v5.3.exe -align Fasta/16s.fasta -output Fasta/16s.fasta.align

```

1. Navigate to the `LabOne` folder using the `cd` command. Then, align all `.fasta` files in your `Fasta` folder.

2. Once you have all your alignments, create a new folder for them, and move them all to their new home: 


```
mkdir Alignments
mv Fasta/*align Alignments 
```

## Concatenating sequences 

Follow steps 1-24 in the main tutorial.

## Tidying up

1. Use the command line to create a new folder within `C:\Users\student\EEB462\LabOne` called `NEXUS`.

Within the “NEXUS” folder, create sub-folders called “Main”, “ML” and “MrBayes”.
Move all “MAIN” files to “Main”.

2. Move “16s-enam-18s-coi-fuseSimp.nex” and “16s-enam-18s-coiProt-fuse.nex” to “MrBayes”.

3. Move the remaining NEXUS files (“coi-protein.nex”, “16s-enam-18s-fuse.nex”, and “16s-enam-18s-coi-fuse.nex”) to “ML”.




