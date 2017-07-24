#!/usr/bin/perl

$die = "

ARGV0 = bam file
ARGV1 = output for barcode-based rmdupped bam file
        also q10 filters & plots distribution
ARGV2 = full path to plotting r script (if blank will not plot)
        Note: plotting required ggplot2 and for Rscript
              to be command-line callable

Will exclude chrY,M, and 'L' chroms
Requires samtools to be command-line callable

";

if (!defined $ARGV[1]) {die $die}

if ($ARGV[1] !~ /\.bam$/) {
	$PFX = $ARGV[1];
} else {
	$PFX = $ARGV[1];
	$PFX =~ s/\.bam$//;
}

open OUT, "| samtools view -bS - > $PFX.bam 2>/dev/null";

open H, "samtools view -H $ARGV[0] 2>/dev/null |";
while ($l = <H>) {print OUT $l};
close H;

open IN, "samtools view -q 10 $ARGV[0] 2>/dev/null |";
while ($l = <IN>) {
	chomp $l;
	@P = split(/\t/, $l);
	($barc,$null) = split(/:/, $P[0]);
	if (defined $KEEP{$P[0]}) {
		print OUT "$l\n";
		$BARC_total{$barc}++;
		$BARC_kept{$barc}++;
	} elsif ($P[1] & 4) {} else {
		if ($P[2] !~ /(M|Y|L)/) {
			$BARC_total{$barc}++;
			if (!defined $BARC_POS_ISIZE{$barc}{"$P[2]:$P[3]"} && !defined $OBSERVED{$P[0]}) {
				$BARC_POS_ISIZE{$barc}{"$P[2]:$P[3]"} = 1;
				$KEEP{$P[0]} = 1;
				print OUT "$l\n";
				$BARC_kept{$barc}++;
			}
			$OBSERVED{$P[0]} = 1;
		}
	}
} close IN; close OUT;


open OUT, ">$PFX.complexity.txt";
$rank = 1;
foreach $barc (sort {$BARC_kept{$b}<=>$BARC_kept{$a}} keys %BARC_kept) {
	$pct = sprintf("%.2f", ($BARC_kept{$barc}/$BARC_total{$barc})*100);
	print OUT "$rank\t$barc\t$BARC_total{$barc}\t$BARC_kept{$barc}\t$pct\n";
	$rank++;
} close OUT;

if (defined $ARGV[2]) {
	system("Rscript $ARGV[2] $PFX.complexity.txt $PFX");
}


