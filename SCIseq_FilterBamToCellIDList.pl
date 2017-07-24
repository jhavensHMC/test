#!/usr/bin/perl

$die = "

ARGV0 = bam file
ARGV1 = cellID list
ARGV2 = output bam

";

if (!defined $ARGV[2]) {die $die};

open IN, "$ARGV[1]";
while ($l = <IN>) {
	chomp $l;
	$KEEP{$l} = 1;
} close IN;

open IN, "samtools view -h $ARGV[0] |";
open OUT, "| samtools view -bS - 2>/dev/null > $ARGV[2]";
while ($l = <IN>) {
	chomp $l;
	if ($l =~ /^\@/) {print OUT "$l\n"}
	else {
		@P = split(/\t/, $l);
		$P[0] =~ s/:.+$//;
		if (defined $KEEP{$P[0]}) {print OUT "$l\n"}
	}
} close IN; close OUT;