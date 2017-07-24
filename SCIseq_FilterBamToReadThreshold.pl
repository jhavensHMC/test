#!/usr/bin/perl

$die = "

ARGV0 = bam (bbrd, q10)
ARGV1 = min read count
ARGV2 = output bam

Excludes chr Y, M, and L containing

";

if (!defined $ARGV[2]) {die $die}

open IN, "samtools view $ARGV[0] 2>/dev/null |";
while ($l = <IN>) {
	chomp $l;
	@P = split(/\t/, $l);
	if ($P[2] !~ /(Y|M|L)/) {
		$tag = $P[0];
		$tag =~ s/:.*$//;
		if (!defined $CT{$tag}) {
			$CT{$tag} = 1;
		} else {
			$CT{$tag}++;
		}
	}
} close IN;

open IN, "samtools view -h $ARGV[0] 2>/dev/null |";
open OUT, "| samtools view -bS - 2>/dev/null > $ARGV[2]";
while ($l = <IN>) {
	if ($l =~ /^\@/) {
		print OUT "$l";
	} else {
		chomp $l;
		@P = split(/\t/, $l);
		$tag = $P[0];
		$tag =~ s/:.*$//;
		if ($CT{$tag}>=$ARGV[1]) {
			print OUT "$l\n";
		}
	}
} close IN;
close OUT;
