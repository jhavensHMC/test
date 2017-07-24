#!/usr/bin/perl

$die = "

ARGV0 = index file

ARGV1 = Nextera Plate Indexes
	e.g. A:1-2,A:5-12,B:1-2,B:12 OR ALL
ARGV2-N = PCR Plate Indexes
	e.g. AE=A:1-12,B:1-12,C:1,C:4-6 OR ##=ALL

STDOUT = list of indexes

";

if (!defined $ARGV[2]) {die $die};

$all = "A:1-12,B:1-12,C:1-12,D:1-12,E:1-12,F:1-12,G:1-12,H:1-12";

%NEX_I5 = ("A" => "AGGCTATA", "B" => "GCCTCTAT", "C" => "AGGATAGG", "D" => "TCAGAGCC",
           "E" => "CTTCGCCT", "F" => "TAAGATTA", "G" => "ACGTCCTG", "H" => "GTCAGTAC");

@NEX_I7 = ("NULL", "ATTACTCG", "TCCGGAGA", "CGCTCATT", "GAGATTCC", "ATTCAGAA", "GAATTCGT",
                   "CTGAAGCT", "TAATGCGC", "CGGCTATG", "TCCGCGAA", "TCTCGCGC", "AGCGATAG");

@I5_LETTERS = ("A", "B", "C", "D", "E", "F", "G", "H");


#i5-T169-NEX1cpt-B       4       GCCAAGGCAA

open IN, "$ARGV[0]";
while ($l = <IN>) {
	chomp $l;
	($ID,$pos,$seq) = split(/\t/, $l);
	if ($pos == 2) {
		($null,$num,$cpt,$let) = split(/-/, $ID);
		$num =~ s/^T//;
		$I7_LET_NUM{$let}{$num} = $seq;
	} elsif ($pos == 4) {
		($null,$num,$cpt,$let) = split(/-/, $ID); #print STDERR "$null,$num,$cpt,$let\n";
		$num =~ s/^T//;
		$I5_LET_NUM{$let}{$num} = $seq;
	}
} close IN;

foreach $let (keys %I7_LET_NUM) {
	$col = 1;
	foreach $num (sort {$a<=>$b} keys %{$I7_LET_NUM{$let}}) {
		$LET_COL_seq{$let}{$col} = $I7_LET_NUM{$let}{$num}; #print STDERR "I7 PCR LET $let COL $col = $I7_LET_NUM{$let}{$num}\n";
		$col++;
	}
}

foreach $let (keys %I5_LET_NUM) {
	$row = 0;
	foreach $num (sort {$a<=>$b} keys %{$I5_LET_NUM{$let}}) {
		$LET_ROW_seq{$let}{$I5_LETTERS[$row]} = $I5_LET_NUM{$let}{$num}; #print STDERR "I5 PCR LET $let ROW $row ($I5_LETTERS[$row]) = $I5_LET_NUM{$let}{$num}\n";
		$row++;
	}
}

if ($ARGV[1] =~ /ALL/i) {$ARGV[1] = $all};
@NEX_SET = split(/,/, $ARGV[1]);
foreach $nex (@NEX_SET) {
	($row,$cols) = split(/:/, $nex);
	if ($cols =~ /-/) {
		($start,$end) = split(/-/, $cols);
		for ($i = $start; $i <= $end; $i++) {
			$nexWell = "$row,$i";
			$NEX_WELLS{$nexWell} = 1;
		}
	} else {
		$nexWell = "$row,$cols";
		$NEX_WELLS{$nexWell} = 1;
	}
}

for ($j = 2; $j < @ARGV; $j++) {
	($lets,$set) = split(/=/, $ARGV[$j]); #print STDERR "$lets,$set\n";
	($i5let,$i7let) = split(//, $lets); #print STDERR "\t$i5let,$i7let\n";
	if ($set =~ /ALL/i) {$set = $all};
	@PCR_SET = split(/,/, $set);
	foreach $pcr (@PCR_SET) {
		($row,$cols) = split(/:/, $pcr); #print STDERR "\t\t$row,$cols\n";
		if ($cols =~ /-/) {
			($start,$end) = split(/-/, $cols);
			for ($i = $start; $i <= $end; $i++) {
				$pcrLetWell = "$i5let,$i7let,$row,$i";
				$PCR_WELLS{$pcrLetWell} = 1;
			}
		} else {
			$pcrLetWell = "$i5let,$i7let,$row,$cols";
			$PCR_WELLS{$pcrLetWell} = 1;
		}
	}
}

foreach $i5let (keys %LET_ROW_seq) {
	foreach $i7let (keys %LET_COL_seq) {
		foreach $nexRow (keys %NEX_I5) {
			for ($nexCol = 1; $nexCol <= 12; $nexCol++) {
				foreach $pcrRow (keys %NEX_I5) {
					for ($pcrCol = 1; $pcrCol <= 12; $pcrCol++) {
					
						$nexWell = "$nexRow,$nexCol";
						$pcrLetWell = "$i5let,$i7let,$pcrRow,$pcrCol";
						
						if (defined $NEX_WELLS{$nexWell} && defined $PCR_WELLS{$pcrLetWell}) {
							$i7nex = $NEX_I7[$nexCol];
							$i7pcr = $LET_COL_seq{$i7let}{$pcrCol};
							$i5nex = $NEX_I5{$nexRow};
							$i5pcr = $LET_ROW_seq{$i5let}{$pcrRow};
							print $i7nex.$i7pcr.$i5nex.$i5pcr."\n";
						}
					}
 				}
			}
		}
	}
}










