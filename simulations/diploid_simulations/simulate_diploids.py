import msprime
import tskit
import numpy as np
import sys

demography = msprime.Demography()
demography.add_population(name="A", initial_size=1)
demography.add_population(name="B", initial_size=1)
demography.add_population(name="C", initial_size=1)
demography.add_population_split(time=1, derived=["A", "B"], ancestral="C")

ts = msprime.sim_ancestry(samples=[
        msprime.SampleSet(1,population="A",ploidy=1),
        msprime.SampleSet(1,population="B",ploidy=1)
        ], 
    demography=demography,
    recombination_rate=0.0,
    sequence_length=99_906_537,
    ploidy=2,
    random_seed=1234)

mts = msprime.sim_mutations(ts,
                            rate=0.1,
                            model="JC69",
                            random_seed=1234)

with open("./test.vcf", "w") as file:
    mts.write_vcf(file)