#!/usr/bin/perl
use strict;
use warnings;
use 5.010;

#begin main

  foreach (@ARGV) {
    traverse_clean($_,$_) if -d $_;
    if ( $_ =~ /.*\.v/) {
      clean_verilog($_); 
    }
  }

#end main

sub traverse_clean {
  my $full_path = $_[0];
  my $file = $_[1];
   
  if ( $file =~ /.*\.v/) {
    clean_verilog($full_path);
  }
  return if not -d $file;
  opendir my $dh, $file or die;
  while (my $sub = readdir $dh) {
    next if $sub eq '.' or $sub eq '..';
    traverse_clean("$full_path/$sub","$sub");
  }
  close $dh;
  return;
}

sub clean_verilog {
  
  my $filename = $_[0];
  my $can_write = 1;
  my $LINE;
  
  open(my $fh_read, '<', $filename) or die "Could not open file '$filename' $!";
  my @LINES = <$fh_read>;
  close($fh_read);
  
  open(my $fh_write, '>', $filename) or die "Could not open file '$filename' $!";
  
  foreach $LINE ( @LINES ) {
    if ($LINE =~ /^`ifdef.*/) {
      $can_write = 0;
    }
    if ($LINE =~ /^`include.*/) {
      next;
    }
    if ($can_write == 1) {
      print $fh_write $LINE;
    }
    if ($LINE =~ /^`endif.*/) {
      $can_write = 1;
    }
  }
  $can_write = 1;
  close ($fh_write); 
}
