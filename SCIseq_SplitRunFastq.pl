#!/usr/bin/perl

$die = "

ARGV0 = Read1.split.fq.gz
ARGV1 = Read2.split.fq.gz
ARGV2 = Non-matching prefix
ARGV3-N = SamplePrefix,barcode_file.txt

STDOUT = split stats

";

if (!defined $ARGV[2]) {die $die};

for ($i = 3; $i < @ARGV; $i++) {
	($PFX,$barc_file) = split(/,/, $ARGV[$i]);
	open IN, "$barc_file";
	while ($l = <IN>) {
		chomp $l;
		($id,$pos,$seq) = split(/\t/, $l);
		$BARC_SETS{$PFX}{$pos}{$seq} = 1;
	} close IN;
	foreach $seq1 (keys %{$BARC_SETS{$PFX}{"1"}}) {
		foreach $seq2 (keys %{$BARC_SETS{$PFX}{"2"}}) {
			foreach $seq3 (keys %{$BARC_SETS{$PFX}{"3"}}) {
				foreach $seq4 (keys %{$BARC_SETS{$PFX}{"4"}}) {
					$full = $seq1.$seq2.$seq3.$seq4;
					if (defined $PREV_USED{$full}) {
						$NOMATCH{$full} = 1;
						print STDERR "WARNING: $full barcode in multiple outputs! Sending to fail split set!\n";
					}
#					print STDERR "DEBUG: $full\n";
					$PREV_USED{$full} = 1;
					$BARC2PFX{$full} = $PFX;
				}
			}
		}
	}
	$O1 = $PFX."1"; $O2 = $PFX."2";
	open $O1, "| gzip > $PFX.1.fq.gz";
	open $O2, "| gzip > $PFX.2.fq.gz";
	$MATCH_CT{$PFX} = 0;
}

if ($ARGV[0] =~ /\.gz$/) {
	open IN1, "zcat $ARGV[0] |";
} else {
	open IN1, "$ARGV[0]";
}

if ($ARGV[1] =~ /\.gz$/) {
	open IN2, "zcat $ARGV[1] |";
} else {
	open IN2, "$ARGV[1]";
}

open NO1, "| gzip > $ARGV[2].1.fq.gz";
open NO2, "| gzip > $ARGV[2].2.fq.gz";
$NOMATCH_CT = 0;
$TOTAL_CT = 0;

while ($tag1 = <IN1>) {
	$tag2 = <IN2>; chomp $tag1; chomp $tag2;
	$seq1 = <IN1>; $seq2 = <IN2>; chomp $seq1; chomp $seq2;
	$null = <IN1>; $null = <IN2>;
	$qual1 = <IN1>; $qual2 = <IN2>; chomp $qual1; chomp $qual2;
	$tag = $tag1; $tag =~ s/^\@//;
	$tag =~ s/:.*$//;
#	print STDERR "DEBIUG: $tag\n";
	if (defined $NOMATCH{$tag}) {
		print NO1 "$tag1\n$seq1\n\+\n$qual1\n";
		print NO2 "$tag2\n$seq2\n\+\n$qual2\n";
		$NOMATCH_CT++;
	} elsif (defined $BARC2PFX{$tag}) {
		$O1 = $BARC2PFX{$tag}."1";
		$O2 = $BARC2PFX{$tag}."2";
		print $O1 "$tag1\n$seq1\n\+\n$qual1\n";
		print $O2 "$tag2\n$seq2\n\+\n$qual2\n";
		$MATCH_CT{$BARC2PFX{$tag}}++;
	} else {
		print NO1 "$tag1\n$seq1\n\+\n$qual1\n";
		print NO2 "$tag2\n$seq2\n\+\n$qual2\n";
		$NOMATCH_CT++;
	}
	$TOTAL_CT++;
} close IN1; close IN2; close NO1; close NO2;

$pct = sprintf("%.2f", ($NOMATCH_CT/$TOTAL_CT)*100);
print "TOTAL READS: $TOTAL_CT
NON MATCHING: $NOMATCH_CT ($pct %)\n";

foreach $PFX (keys %BARC_SETS) {
	close "$PFX.1";
	close "$PFX.2";
	$pct = sprintf("%.2f", ($MATCH_CT{$PFX}/$TOTAL_CT)*100);
	print "MATCHING $PFX: $MATCH_CT{$PFX} ($pct %)\n";
}













