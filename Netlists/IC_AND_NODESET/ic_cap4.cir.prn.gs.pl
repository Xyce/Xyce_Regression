#!/usr/bin/env perl

open(INPUT,"ic_cap4.cir.prn");
open(OUTPUT,">ic_cap4.cir.prn.gs");
while ($line = <INPUT>)
{
  # Handle first and last lines:
  if ($line =~ m/^[IE]/) 
  { 
    print OUTPUT "$line"; 
    next; 
  }
  @s = split(" ",$line);
  $a = exp(-$s[1]/0.001);
  printf OUTPUT "%3d   %14.8e   %14.8e   \n",$s[0],$s[1],$a;
}
close(INPUT);
close(OUTPUT);
