# Lab Four: Bayesian Analysis

## Windows PowerShell Version
*Tutorial by Danielle de Carle*


To begin, prepare your workspace for this lab following the instructions in step 1 of the [main tutorial](https://github.com/ddecarle/eeb462-2024/blob/main/Lab4_BayesianInference.md#tutorial).

**If you are using one of the EEB teaching laptops**, this step has already been completed for you.

### The Bayes Block

Create a Bayes Block for the `allNuc` analysis following steps 2-5 in the [main tutorial](https://github.com/ddecarle/eeb462-2024/blob/main/Lab4_BayesianInference.md#the-bayes-block).

### Paritioning Data

Follow steps 6-8 in the [main tutorial](https://github.com/ddecarle/eeb462-2024/blob/main/Lab4_BayesianInference.md#partitioning-data) to define partitions in your dataset according to the results of the model testing we conducted using IQ-TREE in Lab Three. 

### Specifying Models in MrBayes

Specify the models to use in your analysis following steps 9-11 in the [main tutorial](https://github.com/ddecarle/eeb462-2024/blob/main/Lab4_BayesianInference.md#specifying-models-in-mrbayes).

### The MCMC Simulation

Parameterize the MCMC simulation in your Bayes Block following step 12 in the [main tutorial](https://github.com/ddecarle/eeb462-2024/blob/main/Lab4_BayesianInference.md#the-mcmc-simulation).

### The End of the Bayes Block
Finally, complete your Bayes Block followin steps 13-15 in the [main tutorial](https://github.com/ddecarle/eeb462-2024/blob/main/Lab4_BayesianInference.md#the-end-of-the-bayes-block).

### Running the Analysis

* Open an instance of PowerShell and navigate to your `LabFour\allNuc` folder using the `cd` command. 

* Launch MrBayes using the following command: `./../<MrBayes>`. Be sure to replace `<MrBayes>` with the name of your executable file. **If you are using one of the EEB teaching laptops**, the file name will be `mb.3.2.7-win64.exe`.

One MrBayes is running, begin your analysis according to step 17 in the [main tutorial](https://github.com/ddecarle/eeb462-2024/blob/main/Lab4_BayesianInference.md#running-the-analysis).

### Evaluating Convergence: Stopping Your Analysis

Follow steps 18-20 in the [main tutorial](https://github.com/ddecarle/eeb462-2024/blob/main/Lab4_BayesianInference.md#evaluating-convergence-stopping-your-analysis) to monitor the results of your analysis. 

**If you are using one of the EEB teaching laptops**, you will not be able to use Tracer to examine your output files. You will be able to gain much of the same informaiton by examining the log files for your analyses. Visually examining your trace files will be much more important when you are running more thorough analyses (*e.g.* for your term project). You should be able to do this easily on your personal computer. 

### After the Simulation

Follow steps 21-23 in the [main tutorial](https://github.com/ddecarle/eeb462-2024/blob/main/Lab4_BayesianInference.md#after-the-simulation) to evaluate the results of your Bayesian analysis. 

### Running Analyses with Multiple Data Types

Follow steps 24-25 in the [main tutorial](https://github.com/ddecarle/eeb462-2024/blob/main/Lab4_BayesianInference.md#running-analyses-with-multiple-data-types) to conduct a tree search using the `nucProt` dataset.











