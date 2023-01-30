#! /bin/env perl

use List::Util qw(max);

$VOLUME_ID = 1000;

sub notify_volume {
    $vol = get_volume();
    $icon = "";

    if($vol < 50) { $icon = "audio-volume-low-symbolic"; }
    elsif($vol >= 50 && $vol <= 75) { $icon = "audio-volume-medium-symbolic"; }
    elsif($vol > 75 && $vol <= 100) { $icon = "audio-volume-high-symbolic"; }
    else { $icon = "audio-volume-overamplified-symbolic" }

    system("dunstify -r $VOLUME_ID -a Volume -h int:value:$vol 'Volume [$vol%]' -i $icon -u low");
}

sub is_muted { return `pactl get-sink-mute \@DEFAULT_SINK@` =~ /yes\Z/; }

sub toggle_mute {
    system("pactl set-sink-mute \@DEFAULT_SINK@ toggle");
    if(is_muted()) { system("dunstify -a Volume -r $VOLUME_ID 'OFF' -i audio-volume-muted-symbolic -u low"); }
    else { notify_volume(); }
}

sub get_volume {
    my ($l, $r) = `pactl get-sink-volume \@DEFAULT_SINK@` =~ /\/\s*(\d+)%\s*\//g;
    my @volumes = (int($l), int($r));
    return max(@volumes);
}

sub set_volume {
    my $arg = shift;

    if(defined $arg) { 
        if(is_muted()) { toggle_mute(); }
        system("pactl set-sink-volume \@DEFAULT_SINK@ $arg");
        notify_volume();
    }
    else { die("set_volume: Invalid argument\n"); }
}

my $action = shift(@ARGV);

if(defined $action) {
    if($action eq "set-volume") { set_volume(shift(@ARGV)); }
    elsif($action eq "toggle-mute") { toggle_mute(); }
    else { die("Action '$action' is not valid\n"); }
}
else {
    die("Action Needed\n");
}
