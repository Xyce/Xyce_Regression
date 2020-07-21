#!/usr/bin/env perl

open(INPUT,"abmpow3.cir.prn");
open(OUTPUT,">abmpow3.cir.prn.gs");

while ($line = <INPUT>)
{
  # Handle first and last lines:
  if ($line =~ m/^[IE]/) 
  { 
    print OUTPUT "$line"; 
    next; 
  }
  @s = split(" ",$line);

  $a[0] = $s[0];
  $a[1] = $s[1];
  # Note:  The Xyce expression library does NOT implement raising negative
  # numbers to fractional powers correctly.  It deliberately does
  # sign(x)*(abs(x)**power) to avoid having behavioral sources throw
  # NaNs during the Newton iterations.  This test prints {V(1)**2.1} and
  # (-V(1))**3.1 with V(1) going between -2.5 and 2.5.  It is incorrect to
  # have perl just compute these, because half of them are NaN.
  # Since this is a Xyce regression test and not a test of the power operator,
  # it is necessary that this generation script emit what we expect from Xyce,
  # not what we expect from math.
  # This highlights the dangers of ABM:  if one constructs a netlist that
  # has expressions that are ill-formed over the entire range of values
  # that newton iteration might throw at it, one gets an unstable model.
  # The expression library tries (for good or ill) to desensitize Xyce from
  # that sort of problem, but at the expense of the power operator doing the
  # wrong thing when there's a domain error.
  $a[2] = (( $a[1])**(2.1)) if ($a[1]>=0);
  $a[2] = -((-$a[1])**(2.1)) if ($a[1]<0);
  $a[3] = -(($a[1])**(3.1)) if ($a[1]>=0); 
  $a[3] = ((-$a[1])**(3.1)) if ($a[1]<0);

  $end=3;
  printf OUTPUT "%2g  ",$s[0];
  printf OUTPUT "    %14.8e",$a[1];
  printf OUTPUT "    %14.8e",$a[2];
  printf OUTPUT "  %14.8e  \n",$a[3];
}
close(INPUT);
close(OUTPUT);
