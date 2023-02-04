#! /bin/env perl

use strict;
use warnings;
use JSON::PP qw(decode_json encode_json);
use feature qw(say);

sub print_entries {
    my ($entries, $selentry, $icon, $type, $i) = @_;
    my $idx = -1;

    foreach (@$entries) {
        my %info = (
            type => $type,
            name => $_->{name},
            description => $_->{description},
            icon => $icon,
        );

        print("$_->{description}\0icon\x1f$icon\x1finfo\x1f${\encode_json(\%info)}");

        if($_->{name} eq $selentry) { 
            $idx = $$i;
            print("\x1fnonselectable\x1ftrue");
        }

        print("\n");
        $$i++;
    }

    return $idx;
}

sub show_audio {
    my ($sinks, $sources) = (
        decode_json(`pactl -f json list sinks`),
        decode_json(`pactl -f json list sources`),
    );

    my ($selsink, $selsource) = (
        `pactl get-default-sink`,
        `pactl get-default-source`,
    );

    chomp($selsink);
    chomp($selsource);

    my ($sinkidx, $sourceidx, $i) = (-1, -1, 0);
    $sinkidx = print_entries($sinks, $selsink, "audio-volume-high-symbolic", "sink", \$i);
    $sourceidx = print_entries($sources, $selsource, "microphone-sensitivity-high-symbolic", "source", \$i);
    say("\0active\x1f$sinkidx,$sourceidx");
}

my $choice = ($ENV{ROFI_RETV});

if($choice == "1") {
    my $info = decode_json($ENV{ROFI_INFO});
    system("pactl set-default-$info->{type} $info->{name}");
 
    if($info->{type} eq "sink") { system("dunstify Output '$info->{description}' -i $info->{icon} -r 2000 -u low"); }
    else { system("dunstify Input '$info->{description}' -i $info->{icon} -u low -r 2000 "); }
}

show_audio();

