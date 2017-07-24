#!/usr/bin/perl

$die = "

ARGV0 = directory with Undetermined fastq files
ARGV1 = index file
ARGV2 = output prefix

Will split with a hamming distance of 2

";

if (!defined $ARGV[2]) {die $die}

open IN, "$ARGV[1]";
while ($l = <IN>) {
	chomp $l;
	($id,$pos,$seq) = split(/\t/, $l);
	$POS_SEQ_seq{$pos}{$seq} = $seq;
	$POS_length{$pos} = length($seq);
} close IN;

# make all-1-away hash
foreach $pos (keys %POS_SEQ_seq) {
	foreach $seq (keys %{$POS_SEQ_seq{$pos}}) {
		@TRUE = split(//, $seq);
		for ($i = 0; $i < @TRUE; $i++) {
			if ($TRUE[$i] =~ /A/i) {
				@NEW = @TRUE; $NEW[$i] = "C"; $new = join("", @NEW); $POS_SEQ_seq{$pos}{$new} = $seq;
				@NEW = @TRUE; $NEW[$i] = "G"; $new = join("", @NEW); $POS_SEQ_seq{$pos}{$new} = $seq;
				@NEW = @TRUE; $NEW[$i] = "T"; $new = join("", @NEW); $POS_SEQ_seq{$pos}{$new} = $seq;
				@NEW = @TRUE; $NEW[$i] = "N"; $new = join("", @NEW); $POS_SEQ_seq{$pos}{$new} = $seq;
			} elsif ($TRUE[$i] =~ /C/i) {
				@NEW = @TRUE; $NEW[$i] = "A"; $new = join("", @NEW); $POS_SEQ_seq{$pos}{$new} = $seq;
				@NEW = @TRUE; $NEW[$i] = "G"; $new = join("", @NEW); $POS_SEQ_seq{$pos}{$new} = $seq;
				@NEW = @TRUE; $NEW[$i] = "T"; $new = join("", @NEW); $POS_SEQ_seq{$pos}{$new} = $seq;
				@NEW = @TRUE; $NEW[$i] = "N"; $new = join("", @NEW); $POS_SEQ_seq{$pos}{$new} = $seq;
			} elsif ($TRUE[$i] =~ /G/i) {
				@NEW = @TRUE; $NEW[$i] = "C"; $new = join("", @NEW); $POS_SEQ_seq{$pos}{$new} = $seq;
				@NEW = @TRUE; $NEW[$i] = "A"; $new = join("", @NEW); $POS_SEQ_seq{$pos}{$new} = $seq;
				@NEW = @TRUE; $NEW[$i] = "T"; $new = join("", @NEW); $POS_SEQ_seq{$pos}{$new} = $seq;
				@NEW = @TRUE; $NEW[$i] = "N"; $new = join("", @NEW); $POS_SEQ_seq{$pos}{$new} = $seq;
			} elsif ($TRUE[$i] =~ /T/i) {
				@NEW = @TRUE; $NEW[$i] = "C"; $new = join("", @NEW); $POS_SEQ_seq{$pos}{$new} = $seq;
				@NEW = @TRUE; $NEW[$i] = "G"; $new = join("", @NEW); $POS_SEQ_seq{$pos}{$new} = $seq;
				@NEW = @TRUE; $NEW[$i] = "A"; $new = join("", @NEW); $POS_SEQ_seq{$pos}{$new} = $seq;
				@NEW = @TRUE; $NEW[$i] = "N"; $new = join("", @NEW); $POS_SEQ_seq{$pos}{$new} = $seq;
			}
		}
	}
}

# make all-2-away hash
foreach $pos (keys %POS_SEQ_seq) {
	foreach $id_seq (keys %{$POS_SEQ_seq{$pos}}) {
		$seq = $POS_SEQ_seq{$pos}{$id_seq};
		@TRUE = split(//, $seq);
		for ($i = 0; $i < @TRUE; $i++) {
			if ($TRUE[$i] =~ /A/i) {
				@NEW = @TRUE; $NEW[$i] = "C"; $new = join("", @NEW); if (!defined $POS_SEQ_seq{$pos}{$new}) {$POS_SEQ_seq{$pos}{$new} = $seq};
				@NEW = @TRUE; $NEW[$i] = "G"; $new = join("", @NEW); if (!defined $POS_SEQ_seq{$pos}{$new}) {$POS_SEQ_seq{$pos}{$new} = $seq};
				@NEW = @TRUE; $NEW[$i] = "T"; $new = join("", @NEW); if (!defined $POS_SEQ_seq{$pos}{$new}) {$POS_SEQ_seq{$pos}{$new} = $seq};
				@NEW = @TRUE; $NEW[$i] = "N"; $new = join("", @NEW); if (!defined $POS_SEQ_seq{$pos}{$new}) {$POS_SEQ_seq{$pos}{$new} = $seq};
			} elsif ($TRUE[$i] =~ /C/i) {
				@NEW = @TRUE; $NEW[$i] = "A"; $new = join("", @NEW); if (!defined $POS_SEQ_seq{$pos}{$new}) {$POS_SEQ_seq{$pos}{$new} = $seq};
				@NEW = @TRUE; $NEW[$i] = "G"; $new = join("", @NEW); if (!defined $POS_SEQ_seq{$pos}{$new}) {$POS_SEQ_seq{$pos}{$new} = $seq};
				@NEW = @TRUE; $NEW[$i] = "T"; $new = join("", @NEW); if (!defined $POS_SEQ_seq{$pos}{$new}) {$POS_SEQ_seq{$pos}{$new} = $seq};
				@NEW = @TRUE; $NEW[$i] = "N"; $new = join("", @NEW); if (!defined $POS_SEQ_seq{$pos}{$new}) {$POS_SEQ_seq{$pos}{$new} = $seq};
			} elsif ($TRUE[$i] =~ /G/i) {
				@NEW = @TRUE; $NEW[$i] = "C"; $new = join("", @NEW); if (!defined $POS_SEQ_seq{$pos}{$new}) {$POS_SEQ_seq{$pos}{$new} = $seq};
				@NEW = @TRUE; $NEW[$i] = "A"; $new = join("", @NEW); if (!defined $POS_SEQ_seq{$pos}{$new}) {$POS_SEQ_seq{$pos}{$new} = $seq};
				@NEW = @TRUE; $NEW[$i] = "T"; $new = join("", @NEW); if (!defined $POS_SEQ_seq{$pos}{$new}) {$POS_SEQ_seq{$pos}{$new} = $seq};
				@NEW = @TRUE; $NEW[$i] = "N"; $new = join("", @NEW); if (!defined $POS_SEQ_seq{$pos}{$new}) {$POS_SEQ_seq{$pos}{$new} = $seq};
			} elsif ($TRUE[$i] =~ /T/i) {
				@NEW = @TRUE; $NEW[$i] = "C"; $new = join("", @NEW); if (!defined $POS_SEQ_seq{$pos}{$new}) {$POS_SEQ_seq{$pos}{$new} = $seq};
				@NEW = @TRUE; $NEW[$i] = "G"; $new = join("", @NEW); if (!defined $POS_SEQ_seq{$pos}{$new}) {$POS_SEQ_seq{$pos}{$new} = $seq};
				@NEW = @TRUE; $NEW[$i] = "A"; $new = join("", @NEW); if (!defined $POS_SEQ_seq{$pos}{$new}) {$POS_SEQ_seq{$pos}{$new} = $seq};
				@NEW = @TRUE; $NEW[$i] = "N"; $new = join("", @NEW); if (!defined $POS_SEQ_seq{$pos}{$new}) {$POS_SEQ_seq{$pos}{$new} = $seq};
			}
		}
	}
}




$ARGV[0] =~ s/\/$//;

@R1 = ("$ARGV[0]/Undetermined_S0_L001_R1_001.fastq.gz","$ARGV[0]/Undetermined_S0_L002_R1_001.fastq.gz","$ARGV[0]/Undetermined_S0_L003_R1_001.fastq.gz","$ARGV[0]/Undetermined_S0_L004_R1_001.fastq.gz");
@R2 = ("$ARGV[0]/Undetermined_S0_L001_R2_001.fastq.gz","$ARGV[0]/Undetermined_S0_L002_R2_001.fastq.gz","$ARGV[0]/Undetermined_S0_L003_R2_001.fastq.gz","$ARGV[0]/Undetermined_S0_L004_R2_001.fastq.gz");
@I1 = ("$ARGV[0]/Undetermined_S0_L001_I1_001.fastq.gz","$ARGV[0]/Undetermined_S0_L002_I1_001.fastq.gz","$ARGV[0]/Undetermined_S0_L003_I1_001.fastq.gz","$ARGV[0]/Undetermined_S0_L004_I1_001.fastq.gz");
@I2 = ("$ARGV[0]/Undetermined_S0_L001_I2_001.fastq.gz","$ARGV[0]/Undetermined_S0_L002_I2_001.fastq.gz","$ARGV[0]/Undetermined_S0_L003_I2_001.fastq.gz","$ARGV[0]/Undetermined_S0_L004_I2_001.fastq.gz");

open R1OUT, "| gzip > $ARGV[2].1.fq.gz";
open R2OUT, "| gzip > $ARGV[2].2.fq.gz";
open R1FAIL, "| gzip > $ARGV[2].fail.1.fq.gz";
open R2FAIL, "| gzip > $ARGV[2].fail.2.fq.gz";

$totalCT = 0; $failCT = 0;

for ($i = 0; $i < @R1; $i++) {
	open R1, "zcat $R1[$i] |";
	open R2, "zcat $R2[$i] |";
	open I1, "zcat $I1[$i] |";
	open I2, "zcat $I2[$i] |";
	
	while ($i1tag = <I1>) {
		
		chomp $i1tag; $i2tag = <I2>; chomp $i2tag;
		$i1seq = <I1>; chomp $i1seq; $i2seq = <I2>; chomp $i2seq;
		
		$null = <R1>; $null = <R2>;
		$r1seq = <R1>; $r2seq = <R2>; chomp $r1seq; chomp $r2seq;
		$null = <R1>; $null = <R2>;
		$r1qual = <R1>; $r2qual = <R2>; chomp $r1qual; chomp $r2qual;
		$null = <I1>; $null = <I1>;
		$null = <I2>; $null = <I2>;
		
		$ix1 = substr($i1seq,0,$POS_length{'1'});
		$ix2 = substr($i1seq,$POS_length{'1'},$POS_length{'2'});
		$ix3 = substr($i2seq,0,$POS_length{'3'});
		$ix4 = substr($i2seq,$POS_length{'3'},$POS_length{'4'});

		$totalCT++;
		
		if (defined $POS_SEQ_seq{'1'}{$ix1} &&
			defined $POS_SEQ_seq{'2'}{$ix2} &&
			defined $POS_SEQ_seq{'3'}{$ix3} &&
			defined $POS_SEQ_seq{'4'}{$ix4}) {
			
			$barc = $POS_SEQ_seq{'1'}{$ix1}.$POS_SEQ_seq{'2'}{$ix2}.$POS_SEQ_seq{'3'}{$ix3}.$POS_SEQ_seq{'4'}{$ix4};
			
			$passCT++;
			
			print R1OUT "\@$barc:$totalCT#0/1\n$r1seq\n\+\n$r1qual\n";
			print R2OUT "\@$barc:$totalCT#0/2\n$r2seq\n\+\n$r2qual\n";
			
		} else {
		
			$barc = $ix1.$ix2.$ix3.$ix4;
			
			print R1FAIL "\@$barc:F_$failCT#0/1\n$r1seq\n\+\n$r1qual\n";
			print R2FAIL "\@$barc:F_$failCT#0/1\n$r2seq\n\+\n$r2qual\n";
			
			$failCT++;
		}
		
	}
	
	close R1; close R2; close I1; close I2;
}

open STATS, ">$ARGV[2].split_stats.txt";
$passPCT = sprintf("%.2f", ($passCT/$totalCT)*100);

print STATS "TOTAL = $totalCT
PASS = $passCT ($passPCT\%)
FAIL = $failCT\n";

close STATS;
