# Lab Three: Model Testing & Maximum Likelihood


For the most part, PowerShell users will be able to complete this tutorial using the same commands as in the [main tutorial](https://github.com/ddecarle/eeb462-2024/blob/main/Lab3_MaximumLikelihood.md). 

**If you are using one of the EEB teaching laptops**, there are two important things to remember for this lab. 

First, you will be using IQ-TREE version 2 instead of version 3. As a result, you should type `iqtree2` instead of `iqtree3` as indicated in the main tutorial. 

Second, remember that you will not be able to use FigTree to view your trees. Instead, you can use the Interactive Tree of Life tree viewer following the directions below: 

1. Navigate to [itol.embl.de](itol.embl.de)
2. Click on **Upload** at the top of the screen
3. Click **Choose File**, select the correct tree, then click the **Upload** button
4. You should now see yoiur tree displayed on the screen. For instructions to reroot your tree and display bootstrap values, see [Appendix A of the Lab 2 for PowerShell tutorial](https://github.com/ddecarle/eeb462-2024/blob/main/LAB2_for_PowerShell.md#appendix-a-itol)


## Tutorial
To begin, download and unzip [all files for Lab Three](https://github.com/ddecarle/eeb462-2024/blob/main/LabThree.zip). 

1. Move the `LabThree` folder into your `EEB462` folder. 
2. Locate the `NEXUS\ML` folder you created as part of [Lab One](https://github.com/ddecarle/eeb462-2024/blob/main/LAB1_characterMatrices.md)
3. Copy `16s-enam-18s-coi-fuse.nex` into the `LabThree\allNuc` folder
4. Copy `16s-enam-18s-fuse.nex` and `coi-protein.nex` into `LabThree\nucProt`
5. Move the IQ-TREE executable (`iqtree2.exe`) and `libiomp5md.dll` into the `LabThree` folder.

### Partitioning your dataset

Follow all steps in the [main tutorial](https://github.com/ddecarle/eeb462-2024/blob/main/Lab3_MaximumLikelihood.md#partitioning-your-dataset)

### Model Testing, Tree Inference, and Bootstrapping

1. Open an instance of PowerShell and navigate to the `LabThree\allNuc` folder.

Follow the remaining steps in the [main tutorial](https://github.com/ddecarle/eeb462-2024/blob/main/Lab3_MaximumLikelihood.md#model-testing-tree-inference-and-bootstrapping)

### Combining Multiple Data Types 

Follow all steps in the [main tutorial](https://github.com/ddecarle/eeb462-2024/blob/main/Lab3_MaximumLikelihood.md#combining-multiple-data-types)

**NOTE**: You may see an error at the end of this tree search. As long as the `nucProtPartition.nex.contree` file is present in your `nucProt` folder, you can safely ignore it.

### Topology Tests: Comparing Trees (Statistically)

Follow all steps in the [main tutorial](https://github.com/ddecarle/eeb462-2024/blob/main/Lab3_MaximumLikelihood.md#topology-tests-comparing-trees-statistically)

**If you are using one of the EEB teaching laptops**, you may encounter an error at this part of the analysis. If so, you can find the output file (`nucPartition.nex.best_scheme.nex.iqtree`) on the [Lab Three Discussion board](https://q.utoronto.ca/courses/399317/discussion_topics/3215610) on quercus. 


