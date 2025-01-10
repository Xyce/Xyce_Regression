#!/usr/bin/env perl

open(INPUT,"lead_pmos1.cir.prn");
open(OUTPUT,">lead_pmos1.cir.prn.gs");
while ($line = <INPUT>)
{
  # Handle first and last lines:
  if ($line =~ m/^[IE]/) 
  { 
    print OUTPUT "$line"; 
    next; 
  }
  @s = split(" ",$line);
  $a = 0;
  printf OUTPUT "%3d   %14.8e   %14.8e   %14.8e   %14.8e   %14.8e  %14.8e  %14.8e  %14.8e  %14.8e  \n",$s[0],$s[1],$s[2],$s[3],$s[4],$s[5],$a,$a,$a,$a;
}
close(INPUT);
close(OUTPUT);
