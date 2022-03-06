# MetaBooster / HiFiBooster

## Description
Microbial communities are usually highly diverse, and often involve multiple strains from the participating species due to the rapid evolution of microorganisms. In such a complex microecosystem, different strains may show different biological functions. While reconstruction of individual genomes at the strain level is vital for accurately deciphering the composition of microbial communities, the problem has largely remained unresolved so far. Next generation sequencing has been routinely used in metagenome assembly, but struggles to generate strain-specific genome sequences due to the short read length. This explains why long-read sequencing technologies have recently provided unprecedented opportunities to carry out haplotype- or strain-resolved genome assembly.
Here, we propose MetaBooster and HiFiBooster, as two pipelines for strain aware metagenome assembly from PacBio CLR and Oxford Nanopore long-read sequencing data.
Benchmarking experiments on both simulated and real sequencing data demonstrate that either the MetaBooster or the HiFiBooster pipeline drastically outperform the state of the art de novo metagenome assemblers, in terms of all relevant metagenome assembly criteria, involving genome fraction, contig length and error rates.

## Installation and dependencies
MetaBooster / HiFiBooster relies on the following dependencies:
- [VeChat](https://github.com/HaploKit/vechat)
- [Canu](https://github.com/marbl/canu)

After installing VeChat and Canu, add `vechat` and `canu` to your PATH, and make sure `vechat -h` and `canu -h` can run correctly. Subsequently, pull down the scripts and run `sh run.sh -h` for details.

## Running and options
The format of input read file should be FASTA or FASTQ (or gzip file). The `-i` and `-g ` parameters are required. Other parameters are optional.
Please run `sh run.sh -h` to get details of parameters setting.
```
Usage: sh run.sh [options] -i rawReads -g genomesize -o out -p sequencingPlatform -m pipeline

Input:
  rawReads:                         input long reads
  genomesize:                       estimated genome size
  out:                              directory where to output the results
  sequencingPlatform:               long read sequencing platform: PacBio CLR (-p pb) or Oxford Nanopore (-p ont)
  pipeline:                         which pipeline to run: MetaBooster (-m MetaBooster) or HiFiBooster (-m HiFiBooster)

Options:
  --threads INT, -t INT:            Number of processes to run in parallel (default: 8).
  --help, -h:                       Print this help message.
```


## Examples

One can test the `run.sh` program using the small PacBio CLR reads file `example/reads.fa`. Please use the absolute path of `strainline.sh` when running the program.
- PacBio CLR reads
```
cd example
/abspath/Strainline/src/strainline.sh -i reads.fa -o out -p pb -k 20 -t 32
```

- ONT reads
```
/abspath/Strainline/src/strainline.sh -i reads.fa -o out -p ont -t 32
```

One could run the code on the simulated data of low complexity. Here is the raw reads: https://drive.google.com/file/d/14RGy8yhUtW5GJeY053RCirXIM2njrIQR/view?usp=sharing 

Here is the corresponding reference genomes: https://drive.google.com/file/d/1bOUrBVsRN-QqkmatomD4hZAEI7H28iB5/view?usp=sharing

All benchmarking datasets used in the manuscript can be seen here: https://zenodo.org/record/5830706#.YiRAWxNBzUK

## Citation


