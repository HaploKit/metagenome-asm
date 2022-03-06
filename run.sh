#!/usr/bin/env bash

set -e

#Prints a help message
function print_help() {
  echo "Usage: $0 [options] -i rawReads -g genomesize -o out -p sequencingPlatform -m pipeline"
  echo ""
  echo "Enhancing long read based strain-aware metagenome assembly"
  echo ""
  echo "Author: Xiao Luo"
  echo "Date:   Mar 2022"
  echo ""
  echo "	Input:"
  echo "  rawReads:                         input long reads"
  echo "  genomesize:                       estimated genome size"
  echo "	out:                              directory where to output the results"
  echo "  sequencingPlatform:               long read sequencing platform: PacBio (-p pb) or Oxford Nanopore (-p ont)"
  echo "  pipeline:                         which pipeline to run: MetaBooster (-m MetaBooster) or HiFiBooster (-m HiFiBooster)"
  echo ""
  echo "	Options:"
  echo "	--threads INT, -t INT:            Number of processes to run in parallel (default: 8)."
  echo "	--help, -h:                       Print this help message."
  exit 1
}

#Set options to default values
raw_reads=""
genomesize=""
threads=8
outdir="out"

platform="pb"
pipeline="MetaBooster"
#Print help if no argument specified
if [[ "$1" == "" ]]; then
  print_help
fi

#Options handling
while [[ "$1" != "" ]]; do
  case "$1" in
  "--help" | "-h")
    print_help
    ;;
  "-i")
    case "$2" in
    "")
      echo "Error: $1 expects an argument"
      exit 1
      ;;
    *)
      raw_reads="$2"
      shift 2
      ;;
    esac
    ;;
  "-g")
    case "$2" in
    "")
      echo "Error: $1 expects an argument"
      exit 1
      ;;
    *)
      genomesize="$2"
      shift 2
      ;;
    esac
    ;;
  "-o")
    case "$2" in
    "")
      echo "Error: $1 expects an argument"
      exit 1
      ;;
    *)
      outdir="$2"
      shift 2
      ;;
    esac
    ;;
  "-p")
    case "$2" in
    "")
      echo "Error: $1 expects an argument"
      exit 1
      ;;
    *) if [[ "$2" == "pb" ]]; then
      platform="pb"
      shift 2
    elif [[ "$2" == "ont" ]]; then
      platform="ont"
      shift 2
    else
      echo "Error: $1 must be either pb or ont"
      exit 1
    fi ;;
    esac
    ;;
  "-m")
    case "$2" in
    "")
      echo "Error: $1 expects an argument"
      exit 1
      ;;
    *) if [[ "$2" == "MetaBooster" ]]; then
      pipeline="MetaBooster"
      shift 2
    elif [[ "$2" == "HiFiBooster" ]]; then
      pipeline="HiFiBooster"
      shift 2
    else
      echo "Error: $1 must be either MetaBooster or HiFiBooster"
      exit 1
    fi ;;
    esac
    ;;
  "--threads" | "-t")
    case "$2" in
    "")
      echo "Error: $1 expects an argument"
      exit 1
      ;;
    *)
      threads="$2"
      shift 2
      ;;
    esac
    ;;
#
  --)
    shift
    break
    ;;
  *)
    echo "Error: invalid option \"$1\""
    exit 1
    ;;
  esac
done

#Exit if no input or no output files have been specified
if [[ $raw_reads == "" ]]; then
  echo "Error: -i must be specified"
  exit 1
fi
if [[ $genomesize == "" ]]; then
  echo "Error: -g must be specified"
  exit 1
fi
basepath=$(dirname $0)

if [ ! -d $outdir ]; then
 mkdir $outdir
else
 echo Directory \'$outdir\' 'already exists, please use a new one, exiting...'
 exit
fi

# if [[ $pipeline == "MetaBooster" ]];then
if [[ $platform == "pb" ]];then
  # Run VeChat for error correction
  vechat $raw_read  -t $threads  --platform $platform -o $outdir/reads.vechat_corrected.fa

  # Run Canu for error correction
  rm -rf $outdir/canu
  canu -p out -d $outdir/canu  useGrid=false rawErrorRate=0.2 genomeSize=$genomesize  -pacbio $raw_read
  zcat $outdir/canu/out.trimmedReads.fasta.gz >$outdir/xx
  cat $outdir/reads.vechat_corrected.fa $outdir/xx >$outdir/reads.merged.fa
  rm $outdir/xx

  # Run (Hi)Canu's assembly module
  combined_read=$outdir/reads.merged.fa
  rm -rf $outdir/combined

  if [[ $pipeline == "MetaBooster" ]];then
    canu -p out -d $outdir/combined  useGrid=false genomeSize=$genomesize -corrected  -pacbio  $combined_read
  else #HiFiBooster
    canu -p out -d $outdir/combined  useGrid=false genomeSize=$genomesize -corrected  -pacbio-hifi  $combined_read
  fi
  
else #ONT
  # Run VeChat for error correction
  vechat $raw_read  -t $threads  --platform $platform -o $outdir/reads.vechat_corrected.fa

  # Run Canu for error correction
  rm -rf $outdir/canu
  canu -p out -d $outdir/canu  useGrid=false rawErrorRate=0.2 genomeSize=$genomesize  -nanopore $raw_read
  zcat $outdir/canu/out.trimmedReads.fasta.gz >$outdir/xx
  cat $outdir/reads.vechat_corrected.fa $outdir/xx >$outdir/reads.merged.fa
  rm $outdir/xx

  # Run (Hi)Canu's assembly module
  combined_read=$outdir/reads.merged.fa
  rm -rf $outdir/combined

  if [[ $pipeline == "MetaBooster" ]];then
    canu -p out -d $outdir/combined  useGrid=false genomeSize=$genomesize -corrected  -nanopore  $combined_read
  else #HiFiBooster
    canu -p out -d $outdir/combined  useGrid=false genomeSize=$genomesize -corrected  -pacbio-hifi  $combined_read
  fi
fi

cp $outdir/combined/out.contigs.fasta $outdir/assembly.fa
echo 'Program finished. Please see this file for output contigs: '$outdir"/assembly.fa"
