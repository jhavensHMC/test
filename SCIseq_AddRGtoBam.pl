#!/usr/bin/perl

$die = "

ARGV0 = bam file
ARGV1 = output bam file with RG lines

";

if (!defined $ARGV[1]) {die $die}

open IN, "samtools view -h $ARGV[0] |";
while ($l = <IN>) {
	chomp $l;
	if ($l =~ /^\@/) {
		$header .= "$l\n";
	} else {
		@P = split(/\t/, $l);
		$tag = $P[0];
		$tag =~ s/:.*$//;
		$TAGS{$tag} = 1;
	}
} close IN;

foreach $tag (keys %TAGS) {
	$header .= "\@RG\tID:$tag\tSM:$tag\tLB:$tag\tPL:Illumina\n";
}

open IN, "samtools view $ARGV[0] |";
open OUT, "| samtools view -bS - > $ARGV[1]";
print OUT "$header";
while ($l = <IN>) {
	chomp $l;
	@P = split(/\t/, $l);
	$tag = $P[0];
	$tag =~ s/:.*$//;
	print OUT "$l\tRG:Z:$tag\n";
} close IN;