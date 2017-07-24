SCI-seq data processing readme:

Contact: Andrew Adey (adey@ohsu.edu)

The scripts here are for processing Single cell Combinatorial
Indexing and Sequencing (SCI-seq) raw read data. The typical
workflow is as follows & requires samtools to be command line
callable:

1) After sequencing using SCI-seq chemistry (same as CPT-seq),
   perform the standard bcl2fastq v2 script as standard for
   NextSeq sequencing runs but be sure to include the
   following options: --with-failed-reads and
                      --create-fastq-for-index-reads

2) In the folder witht he Undetermined... fastq files, run
   SCIseq_NextSeqFastq_to_SCIseqFastq.pl with the first
   arguement as the directory (just "." if current), the
   second arguement as the index file int he format:
    IndexID (tab) Index Number (1-4) (tab) Index Sequence
   The file:
    SCIseq.TSase8nt_i5A_i7A.PCR10nt_i5ABCDEF_i7ABCDEF.index.txt
   is provided, and the third arguement as an output prefix.

   The output of this script will be forward and reverse reads
   for those matching the idexes and rejected reads. The read
   names will be int he format used for processing where the
   name is the barcode (cell identifier) and a unique number.

3) If the entire run is for one sample, then no further split
   is necessary. Otherwise samples can be split out at this
   stage using SCIseq_SplitRunFastq.pl with the passing
   fastq files as the first two arguements, the output prefix
   for non-sample reads as the third arguement, and then a set
   of sample arguements with the sample prefix followed by an
   index file as in the index file used for the initial split.
   
   Note: This should only be carried out if the samples are for
   different projects, or require different alignment processes
   since it is possible to split after alignment when in bam
   file format which is typically easier since all samples can
   be aligned at the same time.
   
4) Next, align the reads using your preferred aligner to
   produce an aligned bam file. Do not perform duplicate
   removal, since standard duplicate removal does not account
   for the cell identifier.
   
5) Remove duplicates using SCIseq_RemoveDuplicates.pl with
   the aligned and sorted bam file as the first arguement and
   the output bam file as the second. If the path to the
   plotting R script (SCIseq_RemoveDuplicatesPlot.r) is provided
   as a third arguement, it will plot some compelxity figures.
   This R script requires ggplot2.

Additional Processing:   

Splitting Bam files:
   Duplicate removed bam files can then be split into respective
   samples using: SCIseq_FilterBamToCellIDList.pl, where the
   first arguement is the input bam, the second is a list of
   barcodes to include, and the third is the output bam. A list
   of cell IDs can be generated using: SCIseq_MakeCellIDList.pl

Filtering to a read count threshold:
   SCI-seq bam files can also be filtered to only include cells
   that have a minimum read count threshold using:
   SCIseq_FilterBamToReadThreshold.pl
   
Add standard RG header lines to bam:
   Use: SCIseq_AddRGtoBam.pl