# Lab Two: Parsimony
## Windows PowerShell Version
*Tutorial by Danielle de Carle*

To begin, download and unzip [all files for Lab Two](https://github.com/ddecarle/eeb462-2021/blob/main/LabTwo.zip). Move the `Lab2-TNT` folder into your existing `EEB462` folder that you created during Lab One. 

More detailed information about all these steps is available in the [main tutorial](https://github.com/ddecarle/eeb462-2024/blob/main/LAB2_Parsimony.md). The lab assignment questions can be found there as well. 

### Parsimony Analysis 101

1. Follow steps 1-5 from the [main tutorial](https://github.com/ddecarle/eeb462-2024/blob/main/LAB2_Parsimony.md#parsimony-analysis-101).

2. Open an instance of PowerShell and use the `cd` command to navigate to the `Lab2-TNT` folder. If you are using one of the EEB computers, the path should be `C:\Users\student\EEB462\Lab2-TNT`.
3. Follow steps 7-9 from the [main tutorial](https://github.com/ddecarle/eeb462-2024/blob/main/LAB2_Parsimony.md#parsimony-analysis-101).
4. **If you are not using one of the EEB laptops**: Download `tnt_tree_clean.ps1` [from the course GitHub repository](https://github.com/ddecarle/eeb462-2024/blob/main/tnt_tree_clean.ps1). Move it to your `Lab2-TNT` folder and use the following command to convert your TNT trees to `.tre` format: `.\..\tnt_tree_clean.ps1`  
    
    **If you are using one of the EEB laptops**: You will not be able to run the script necessary to convert the TNT output  (*i.e.* `consensus_bootstraps.tnttre` and `mpts.tnttre`) to a format that is readable by most tree viewing software. Instead, you can view the results of this analysis on the Interactive Tree of Life website by following this link: [allNuc\_consensus\_bootstraps.tnttre.tre](https://itol.embl.de/tree/142150219144141561758741537). 

### Examining Trees

**If you are not using one of the EEB laptops**, follow steps 11-13 from the [main tutorial](https://github.com/ddecarle/eeb462-2024/blob/main/LAB2_Parsimony.md#examining-trees). 

**If you are using one of the EEB laptops**, follow the instructions in [Appendix A: iTOL](#appendix-a-itol) to re-root your tree and display the bootstrap values. 

### Combining multiple data types

Follow steps 1-18 in the [main tutorial](https://github.com/ddecarle/eeb462-2024/blob/main/LAB2_Parsimony.md#combining-multiple-data-types).

**If you are not using one of the EEB laptops**, use the following command to convert your TNT trees to `.tre` format: `.\..\tnt_tree_clean.ps1`. 

Then, follow step 20 in the main tutorial.

**If you are using one of the EEB laptops**, follow this link to view the output of the analysis on iTOL: [nucProt\_consensus\_bootstraps.tnttre.tre](https://itol.embl.de/tree/142150219144141661758741538).

Then, follow the instructions in [Appendix A: iTOL](#appendix-a-itol) to re-root your tree and display the bootstrap values. 

### Constrained Analyses

Follow steps 21-26 in the [main tutorial](https://github.com/ddecarle/eeb462-2024/blob/main/LAB2_Parsimony.md#constrained-analyses).

**If you are not using one of the EEB laptops**, use the following command to convert your TNT trees to `.tre` format: `.\..\tnt_tree_clean.ps1`. 

**If you are using one of the EEB laptops**, follow this link to view the output of the analysis on iTOL: [nucConstrain\_consensus\_bootstraps.tnttre.tre](https://itol.embl.de/tree/142150219144141621758741537).

Then, follow the instructions in [Appendix A: iTOL](#appendix-a-itol) to re-root your tree and display the bootstrap values. 

## Appendix A: iTOL
The [Interactive Tree of Life](https://itol.embl.de/) provides an online platform for viewing and annotating phylogenetic trees. 

Here, we will go over how to re-root trees and visualize support values on this platform.

### Re-rooting trees
1. To re-root a tree, first identify the taxon you would like to serve as the root. 
2. Click on the name of the taxon, then select **Tree structure** > **Re-root the tree here**.

### Displaying Bootstrap values
1. Click the **Advanced** tab in the Control Panel
2. Under the heading **Branch metadata display**, you will see an option for **Bootstraps/metadata**. Click the **Display** button to the left of this.
3. You will now see blue circles around each of the nodes. The size of the circle corresponds to the bootstrap value with larger circles indicating higher support. To view this informaiton as numeric values instead, click the **Text** button under the **Bootstraps/metadata** button you clicked in the previous step. This will show the boostrap values along each branch. Each value corresponds to the node directly to the right of it.   












