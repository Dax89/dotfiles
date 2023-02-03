#! /bin/env perl

use utf8;
use JSON::PP;

binmode(STDOUT, ":utf8");

my $category = shift(@ARGV) or die("Invalid category");
my $device = shift(@ARGV) or die("Invalid device");
my $sensor = shift(@ARGV) or die("Invalid sensor");

my $output = `sensors -j`;
my $sensors = decode_json($output);
my $value = int($sensors->{$category}->{$device}->{$sensor});

print("$value°C");
