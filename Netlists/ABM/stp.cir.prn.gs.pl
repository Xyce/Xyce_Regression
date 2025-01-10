#!/usr/bin/env perl

open(INPUT,"stp.cir.prn");
open(OUTPUT,">stp.cir.prn.gs");

while ($line = <INPUT>)
{
  # Handle first and last lines:
  if ($line =~ m/^[IE]/) 
  { 
    print OUTPUT "$line"; 
    next; 
  }
  @s = split(" ",$line);
  $a = 0.0;
  if ($s[1] > 0.5)
  {
    $a = 5.0;
  }

  printf OUTPUT "%3d   %14.8e   ",$s[0],$s[1];
  printf OUTPUT "%14.8e\n", $a;
}
close(INPUT);
close(OUTPUT);

