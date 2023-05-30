#! /bin/env perl

use utf8;
use JSON::PP;

binmode(STDOUT, ":utf8");

my @INTEL_CPU = ["coretemp-isa-0000", "Package id 0", "temp1_input"];
my @AMD_CPU = ["k10temp-pci-00c3", "Tctl", "temp1_input"];
my @CATEGORIES = (@INTEL_CPU, @AMD_CPU);

my $output = `sensors -j`;
my $sensors = decode_json($output);
my $value = "???";

for my $category (@CATEGORIES) {
    my $obj = $sensors;
    my $lastprop;

    for my $cpuprop (@$category) {
        if(exists $obj->{$cpuprop}) {
            $obj = $obj->{$cpuprop};
        }
        else {
           $obj = undef;
           break;
        }
    }

    if(defined $obj) {
        $value = int($obj);
        break;
    }
}

print("$value°C");
