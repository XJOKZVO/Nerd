#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Long;
use File::Slurp;

sub extract_domain {
    my ($input) = @_;
    my @matches = $input =~ m/([a-z0-9][a-z0-9\-]{0,61}[a-z0-9]\.)+[a-z0-9][a-z0-9\-]*[a-z0-9]/g;
    return @matches;
}

sub help {
    print <<EOF;

   _   _                     _ 
  | \\ | |   ___   _ __    __| |
  |  \\| |  / _ \\ | '__|  / _` |
  | |\\  | |  __/ | |    | (_| |
  |_| \\_|  \\___| |_|     \\__,_|
                               

Usage: $0 [-i input_file] [-o output_file] [-p prefix] [-s suffix] [-h]
Options:
  -i, --input FILE   Read domains from FILE instead of stdin
  -o, --output FILE  Write output to FILE instead of stdout
  -p, --prefix STR   Add STR as prefix to each domain
  -s, --suffix STR   Add STR as suffix to each domain
  -h, --help         Display this help message

Examples:
  cat logs.txt | $0
  $0 -i logs.txt
  cat logs.txt | $0 -p "https://" -s "/api"
  $0 -i logs.txt -o output.txt
  $0 -h

EOF
    exit(0);
}

sub format_domain {
    my ($prefix, $domain, $suffix) = @_;
    $domain = $prefix . $domain if $prefix;
    $domain .= $suffix if $suffix;
    return $domain;
}

my %opts;
GetOptions(\%opts, "input=s", "output=s", "prefix=s", "suffix=s", "help|h");

if ($opts{help}) {
    help();
}

my %domains;
if ($opts{input}) {
    my $content = read_file($opts{input});
    my @lines = split /\n/, $content;
    foreach my $line (@lines) {
        $line =~ s/^\s+|\s+$//g; # trim leading and trailing spaces
        next if $line eq "";
        my @domains_list = extract_domain($line);
        next if !@domains_list;
        foreach my $domain (@domains_list) {
            $domains{$domain} = 1;
        }
    }
} else {
    while (my $line = <STDIN>) {
        $line =~ s/^\s+|\s+$//g; # trim leading and trailing spaces
        next if $line eq "";
        my @domains_list = extract_domain($line);
        next if !@domains_list;
        foreach my $domain (@domains_list) {
            $domains{$domain} = 1;
        }
    }
}

my $output_handle;
if ($opts{output}) {
    open($output_handle, '>', $opts{output}) or die "Cannot open output file: $!";
} else {
    $output_handle = \*STDOUT;
}

foreach my $domain (keys %domains) {
    $domain = format_domain($opts{prefix}, $domain, $opts{suffix});
    print $output_handle "$domain\n";
}

if ($opts{output}) {
    close($output_handle);
}
