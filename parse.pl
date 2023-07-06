#/usr/bin/perl
use strict;
use warnings;

use open qw( :std :encoding(UTF-8) );
use lib qw(..);
use JSON qw( );
use File::Slurp qw(read_dir);

# retrieves the file content of a json file
sub read_content {

  my ($file_path)=@_;
  print $file_path,"\n";

  # open a json file
  my $json_text = do {
   open(my $json_fh, "<:encoding(UTF-8)", $file_path)
      or die("Can't open \"$file_path\": $!\n");
   local $/;
   <$json_fh>
  };

  #parse and decode the json file
  my $json = JSON->new;
  my $data = $json->decode($json_text);
  
  for my $object (@$data){
    if ($object->{user}){
      print $object->{"text"};
    }
  }
}

my $root = '.';
# read the root directory where all the directories are stored
my @dh = grep {-d "$root/$_" } read_dir($root);

# traverse for each channel directory
foreach my $channel (@dh){
  my $date_dir = "$root/$channel";
  my @dates = read_dir($date_dir);
  # find each json file for all the dates of the channel
  foreach my $date (@dates){
    my $file_path ="$date_dir/$date";
    # read content of the json of a particular date of a channel
    read_content($file_path)

  }
}