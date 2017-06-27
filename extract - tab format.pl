use strict;
#print $ARGV[0];
#@files = <*.pdf.txt>;
#foreach $file (@files)
#{
#	print $file . "\n";
#}

my $output_file = "output.txt";

my $base_path = $ARGV[0];
my $regex_file = $ARGV[1];
my $regex_string = '';

read_in_regex();
process_files ($base_path);

sub read_in_regex
{
	open(my $fh, '<', $regex_file)
		or die "Could not open file '$regex_file' $!";

	while (my $row = <$fh>)
	{
		chomp $row;
		$regex_string = "$regex_string|$row";
	}
	$regex_string =~ s/^.//;
#	print $regex_string;
}


# Accepts one argument: the full path to a directory.
# Returns: nothing.
sub process_files
{
	my $path = shift;

	# Open the directory.
	opendir (DIR, $path)
		or die "Unable to open $path: $!";
	
	# Read in the files.
	# You will not generally want to process the '.' and '..' files,
	# so we will use grep() to take them out.
	# See any basic Unix filesystem tutorial for an explanation of the +m.
#	my @files = grep { !/^\.{1,2}$/ } readdir (DIR);
	my @files = grep { /.pdf.txt/ } readdir (DIR);
	
	# Close the directory.
	closedir (DIR);
	
	# At this point you will have a list of filenames
	#  without full paths ('filename' rather than
	#  '/home/count0/filename', for example)
	# You will probably have a much easier time if you make
	#  sure all of these files include the full path,
	#  so here we will use map() to tack it on.
	#  (note that this could also be chained with the grep
	#   mentioned above, during the readdir() ).
	@files = map { $path . '/' . $_ } @files;

#	print $ARGV[1];

	#loop through each file
	foreach my $file (@files)
	{
		#open the file for reading
		open (my $txtfile, $file) or die "error opening $file\n";
		
		#Loop through all lines in each file
		while (my $line=<$txtfile>)
		{
			#my @extraction = $line=~/$ARGV[1]/g;
			#if ($line=~/sick leave.{1,50}\d+|\d+.{1,50}sick leave|sick day.{1,50}\d+|\d+.{1,50}sick day/g)
			$line=~ s/\f|\R//g;
			if (my @extraction = ($line =~ m/$regex_string/gi))
#			if ($line=~/$ARGV[1]/g)
			{
				#print $line;
				#(my $no_line_feed = $line) =~ s/\R//;
				print $file . "\t$line";

				foreach my $s (@extraction)
				{
					print "\t$s";
					my $start = 0;
#					my $match = $s;
					if (index($line, $s)-50 > 0)
					{
						$start = index($line, $s)-50;
					}
					my $extras = substr($line, $start, length($s) + 100);
					my $value;
					if ($s =~ /(\d+)/)
					{
#						print "\tweird:\t" . $1 . "\n";
						$value = $1;
					}

					#$value =~ m/\d+/;
#					print $file . "\t" . $line . "\t" . $extras . "\t" . index($line, $s) . "\t" . length($s) . "\n";
#					$extras =~ s/\R//g;
					print "\t$extras\t$value";
				}
				#print $file . "\t" . $line . "\n";
				#print $file . "\t" . $4 . "\n";
				#my $captured = $line=~/$ARGV[1]/g;
				#print $file . "\t" . $capture . "\n";
				print "\n";
			}
				
		}
		#close the file
		close $file
	}

}