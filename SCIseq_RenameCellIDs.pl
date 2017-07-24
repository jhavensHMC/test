#!/usr/bin/perl

$die = "

ARGV0 = bam file
ARGV1 = Sample sheet (barcode (tab) newID)
ARGV2 = Run prefix (added to all read names)
ARGV3 = output prefix

";

if (!defined $ARGV[3]) {die $die}

$uniqID = 0;
open ID, "$ARGV[1]";
while ($l = <ID>) {
	chomp $l;
	($barc,$id) = split(/\t/, $l);
	$BARC_id{$barc} = $id;
	$BARC_uniqID{$barc} = $uniqID;
	$uniqID++;
	$BARC_num{$barc} = 0;
} close ID;

open OUT, "| samtools view -bS - 2>/dev/null > $ARGV[3].bam";
open IX, ">$ARGV[3].run_sample_sheet.txt";
open IN, "samtools view -h $ARGV[0] 2>/dev/null |";
while ($l = <IN>) {
	if ($l =~ /^\@/) {
		print OUT "$l";
	} else {
		chomp $l;
		@P = split(/\t/, $l);
		$barc = $P[0];
		$barc =~ s/:.*$//;
		if (!defined $BARC_id{$barc}) {
			print STDERR "No ID for barc: $barc in $ARGV[1], setting to na.\n";
			$BARC_id{$barc} = "na";
			$BARC_num{$barc} = 0;
		}
		$BARC_num{$barc}++;
		$P[0] = "$ARGV[2]\_$BARC_id{$barc}\_$BARC_uniqID{$barc}:$BARC_num{$barc}";
		$name = "$ARGV[2]\_$BARC_id{$barc}\_$BARC_uniqID{$barc}";
		if (!defined $IN_SHEET{$name}) {
			print IX "$name\t$BARC_id{$barc}\n";
			$IN_SHEET{$name} = 1;
		}
		$out = "$P[0]";
		for ($i = 1; $i < @P; $i++) {
			$out .= "\t$P[$i]";
		}
		print OUT "$out\n";
	}
} close IN;
close IN;
