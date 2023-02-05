#! /bin/perl

sub execute_if {
    my $cmd = shift or die("Invalid command");

    if(system("command -v $cmd > /dev/null") == 0) {
        my $args = shift;
        system("$cmd $args");
    }
}

execute_if("numlockx");
system("xset r rate 250 50");
system("i3");
