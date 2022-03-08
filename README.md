# MetaBooster / HiFiBooster

## Description
Microbial communities are usually highly diverse, and often involve multiple strains from the participating species due to the rapid evolution of microorganisms. In such a complex microecosystem, different strains may show different biological functions. While reconstruction of individual genomes at the strain level is vital for accurately deciphering the composition of microbial communities, the problem has largely remained unresolved so far. Next generation sequencing has been routinely used in metagenome assembly, but struggles to generate strain-specific genome sequences due to the short read length. This explains why long-read sequencing technologies have recently provided unprecedented opportunities to carry out haplotype- or strain-resolved genome assembly.
Here, we propose MetaBooster and HiFiBooster, as two pipelines for strain aware metagenome assembly from PacBio CLR and Oxford Nanopore long-read sequencing data.
Benchmarking experiments on both simulated and real sequencing data demonstrate that either the MetaBooster or the HiFiBooster pipeline drastically outperform the state of the art de novo metagenome assemblers, in terms of all relevant metagenome assembly criteria, involving genome fraction, contig length and error rates.

## Installation and dependencies
MetaBooster / HiFiBooster relies on the following dependencies:
- [VeChat >= v1.1.0](https://github.com/HaploKit/vechat)
- [Canu >= v2.1](https://github.com/marbl/canu)

After installing VeChat and Canu, add `vechat` and `canu` to your PATH, and make sure `vechat -h` and `canu -h` can run correctly. Subsequently, pull down the scripts and run `./metagenome-asm -h` for details.

## Running and options
The format of input read file should be FASTA or FASTQ (or gzip file). The `-i` and `-g` parameters are required. Other parameters are optional.
Please run `./metagenome-asm -h` to get details of parameters setting.
```
Usage: metagenome-asm [options] -i rawReads -g genomesize -o out -p sequencingPlatform -m pipeline

Input:
  rawReads:                         input long reads
  genomesize:                       estimated genome size
  out:                              directory where to output the results
  sequencingPlatform:               long read sequencing platform: PacBio CLR (-p pb) or Oxford Nanopore (-p ont)
  pipeline:                         which pipeline to run: MetaBooster (-m MetaBooster) or HiFiBooster (-m HiFiBooster)

Options for setting VeChat:
  --split  BOOL             split target sequences into chunks (default: False)
  --split-size INT          split target sequences into chunks of desired size in lines, only valid when using --split (default: 1000000)
  --scrub BOOL              scrub chimeric reads (default: False)
  --base BOOL               perform base level alignment when computing read overlaps in the first cycle of VeChat (default: False)
  --min-identity-cns FLOAT  minimum sequence identity between read overlaps in the consensus round (default: 0.99)
  --threads INT, -t INT:    number of processes to run in parallel (default: 8).
  --help, -h:               print this help message.
```


## Examples

One can test the `metagenome-asm` program using the small PacBio CLR reads file `example/reads.fa.gz`. 
- PacBio CLR reads
```
./metagenome-asm -i example/reads.fa.gz -g 49k -o out -p pb -m MetaBooster
```

- ONT reads
```
./metagenome-asm -i example/reads.fa.gz -g 49k -o out -p ont 
```

In addition, one could run the code on the simulated data of low complexity. Here is the raw reads: https://drive.google.com/file/d/14RGy8yhUtW5GJeY053RCirXIM2njrIQR/view?usp=sharing 

Here is the corresponding reference genomes: https://drive.google.com/file/d/1bOUrBVsRN-QqkmatomD4hZAEI7H28iB5/view?usp=sharing

All benchmarking datasets used in the manuscript can be seen here: https://zenodo.org/record/5830706#.YiRAWxNBzUK

## Citation


