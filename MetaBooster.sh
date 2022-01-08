
raw_read=$1
genomesize=$2
platform=pb #ont
threads=48

# Run VeChat for error correction
vechat $raw_read  -t $threads  --platform $platform -o reads.vechat_corrected.fa

# Run Canu for error correction
rm -rf out
canu -p out -d out  useGrid=false rawErrorRate=0.2 genomeSize=$genomesize  -pacbio-raw $read
zcat out/out.trimmedReads.fasta.gz >xx
cat reads.vechat_corrected.fa xx >reads.merged.fa
rm xx

# Run Canu's assembly module
combined_read=reads.merged.fa
rm -rf out
canu -p out -d out  useGrid=false genomeSize=$genomesize -corrected  -pacbio  $combined_read
cp out/out.contigs.fasta assembly.fa

