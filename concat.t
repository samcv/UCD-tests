#!/usr/bin/env perl6
use Test;
plan 5 * 2;
# The script examples in the .txt of this project are taken from wikipedia.org and
# are licensed under the CC 3.0 Share Alike license
# https://creativecommons.org/licenses/by-sa/3.0/

# See Retreived.txt for dates and URL's they were retreived from

test-script("Hangul.txt".IO.slurp);
test-script("Arabic.txt".IO.slurp);
sub test-script (Str $string) {
    my $script = $string.uniprop('Script');
    # Just in case somebody's git is set to alter line endings on checked out files
    # Make sure both strings have the correct lineendings before proceeding
    my $crnl-string = S:g/ \n | \r\n /\r\n/ given $string;
    my $nl-string   = S:g/ \r\n | \n /\n/ given $string;
    my @ords = $crnl-string.ords;

    is-deeply $crnl-string.chars, $nl-string.chars, "\\r\\n newline has same number of .chars as \\n in $script";

    is-deeply $crnl-string.NFD.NFC.Str, $crnl-string, "$script text \\r\\n newlines roundtrips NFD to NFC";
    is-deeply $nl-string.NFD.NFC.Str, $nl-string, "$script text \\n newlines roundtrips NFD to NFC";
    my $eq-ok = 0;
    my $chars-ok = 0;
    for 1..@ords.elems {
      my @o = @ords;
      my @n = @o.shift xx $_;
      my $concatted = @n.chrs ~ @o.chrs;
      $eq-ok++ if $concatted eq $crnl-string;
      $chars-ok++ if $concatted.chars == $crnl-string.chars;
    }
    is-deeply $eq-ok, (1..@ords.elems).elems, "$script concat equal";
    is-deeply $chars-ok, (1..@ords.elems).elems, "$script concat charcount equal";
}