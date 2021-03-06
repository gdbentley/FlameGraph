#!/usr/bin/perl -w
#
# files.pl	Print file sizes in folded format, for a flame graph.
#
# This helps you understand storage consumed by a file system, by creating
# a flame graph visualization of space consumed. This is basically a Perl
# version of the "find" command, which emits in folded format for piping
# into flamegraph.pl.
#
# Copyright (c) 2017 Brendan Gregg.
# Licensed under the Apache License, Version 2.0 (the "License")
#
# 03-Feb-2017   Brendan Gregg   Created this.

use strict;
use File::Find;

sub usage {
	print STDERR "USAGE: $0 directory\n";
	print STDERR "   eg, $0 /Users\n";
	print STDERR "Intended to be piped to flamegraph.pl. Full example:\n";
	print STDERR "   $0 /Users | flamegraph.pl " .
	    "--hash --countname=bytes > files.svg\n";
	exit 1;
}

usage() if @ARGV == 0 or $ARGV[0] eq "--help" or $ARGV[0] eq "-h";

my $dir = $ARGV[0];

find(\&wanted, $dir);

sub wanted {
	my ($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size) = stat($_);
	return unless defined $size;
	my $path = $File::Find::name;
	$path =~ tr/\//;/;		# delimiter
	$path =~ tr/;.a-zA-Z0-9-/_/c;	# ditch whitespace and other chars
	$path =~ s/^;//;
	print "$path $size\n";
}
