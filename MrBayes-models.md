# MrBayes Models of Evolution

## Model Families

* [GTR](#GTR)
* [SYM](#SYM)
* [HKY](#HKY)
* [K2P](#K2P)
* [F81](#F81)
* [JC](#JC)
* [MK](#MK-Model-for-Morphology)


## GTR

**GTR** 

	lset applyto=() nst=6;

**GTR+I**

	lset applyto=() nst=6 rates=propinv;

**GTR+G**

	lset applyto=() nst=6 rates=gamma;

**GTR+I+G**

	lset applyto=() nst=6 rates=invgamma;


## SYM

**SYM**

	lset applyto=() nst=6;
	prset applyto=() statefreqpr=fixed(equal);

**SYM+I**

	lset applyto=() nst=6 rates=propinv;
	prset applyto=() statefreqpr=fixed(equal);

**SYM+G**

	lset applyto=() nst=6 rates=gamma;
	prset applyto=() statefreqpr=fixed(equal);

**SYM+I+G**

	lset applyto=() nst=6 rates=invgamma;
	prset applyto=() statefreqpr=fixed(equal);

## HKY
**HKY**

	lset applyto=() nst=2;


**HKY+I**

	lset applyto=() nst=2 rates=propinv;


**HKY+G**

	lset applyto=() nst=2 rates=gamma;


**HKY+I+G**

	lset applyto=() nst=2 rates=invgamma;


## K2P

**K2P**

    lset applyto=() nst=2;
    prset applyto=() statefreqpr=fixed(equal);
  
**K2P+I**    

    lset applyto=() nst=2 rates=propinv;
    prset applyto=() statefreqpr=fixed(equal);

**K2P+G**

    lset applyto=() nst=2 rates=gamma;
    prset applyto=() statefreqpr=fixed(equal);

**K2P+I+G**

    lset applyto=() nst=2 rates=invgamma;
    prset applyto=() statefreqpr=fixed(equal);


## F81

**F81**

    lset applyto=() nst=1;

**F81+I**

    lset applyto=() nst=1 rates=propinv;

**F81+G**

    lset applyto=() nst=1 rates=gamma;

**F81+I+G**

    lset applyto=() nst=1 rates=invgamma;

## Jukes Cantor  

**JC**

    lset applyto=() nst=1;
    prset applyto=() statefreqpr=fixed(equal);

**JC+I**

    lset applyto=() nst=1 rates=propinv;
    prset applyto=() statefreqpr=fixed(equal);

**JC+G**

    lset applyto=() nst=1 rates=gamma;
    prset applyto=() statefreqpr=fixed(equal);

**JC+I+G**

    lset applyto=() nst=1 rates=incgamma;
    prset applyto=() statefreqpr=fixed(equal);
    
## MK Model for Morphology

	lset applyto=() coding=variable;
	prset applyto=() symdirihyperpr=fixed(infinity) ratepr=variable;

* `coding`: indicates that only variable sites have the probability of being sampled. In other words, there are no invariable sites in your dataset.

* `prset` command used here specifies that the stationary frequencies for each character state in your dataset vary according to a symmetrical Dirichlet prior, and that each partition should be allowed to evolve at a different rate.
