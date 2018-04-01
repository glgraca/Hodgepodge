#!/usr/bin/perl
use strict;
use warnings;
use GD;
use GD::Image;

if($#ARGV<4) {
  print "Usage: hodge.pl image.jpg k_red k_green k_blue #frames\n";
  exit;
}

GD::Image->trueColor(1);
my $lena=GD::Image->new($ARGV[0]);
my $width=$lena->width();
my $height=$lena->height();

my $k_red=$ARGV[1];
my $k_blue=$ARGV[2];
my $k_green=$ARGV[3];

my @reds=();
my @blues=();
my @greens=();

for my $x (0..$width-1) {
  for my $y (0..$height-1) {
    my @pixel=$lena->rgb($lena->getPixel($x,$y));
    my $index=$x+$y*$width;
    $reds[$index]=$pixel[0];
    $blues[$index]=$pixel[2];
    $greens[$index]=$pixel[1];
  }
}

my @reds2=@reds;
my @blues2=@blues;
my @greens2=@greens;

for my $i (0..($ARGV[4]-1)) {
  for my $x (0..$width-1) {
    for my $y (0..$height-1) {
      my $avg_red=0;
      my $avg_blue=0;
      my $avg_green=0;

      #Average
      for my $dx (0..2) {
        for my $dy (0..2) {
          if(!($dx==1 && $dy==1)) {
            my $xx=$x+$dx-1;
            my $yy=$y+$dy-1;

            $yy=0 if $yy>=$height;
            $yy=$height-1 if $yy<0;

            $xx=0 if $xx>=$width;
            $xx=$width-1 if $xx<0;

            my $index=$xx+$yy*$width;

            $avg_red+=$reds[$index];
            $avg_blue+=$blues[$index];
            $avg_green+=$greens[$index];
          }
        }
      }
      $avg_red/=8;
      $avg_green/=8;
      $avg_blue/=8;

      my $index=$x+$y*$width;

      my $new_red=$avg_red+$k_red;
      $new_red=0 if $new_red>255;
      $reds2[$index]=$new_red;

      my $new_blue=$avg_blue+$k_blue;
      $new_blue=0 if $new_blue>255;
      $blues2[$index]=$new_blue;

      my $new_green=$avg_green+$k_green;
      $new_green=0 if $new_green>255;
      $greens2[$index]=$new_green;

      $lena->setPixel($x, $y, $lena->colorResolve($new_red, $new_green, $new_blue));
    }
  } 
  open(IMAGE, sprintf(">lena%03d.jpg", $i));
  binmode IMAGE;
  print IMAGE $lena->jpeg(100);
  close IMAGE;
  @reds=@reds2;
  @blues=@blues2;
  @greens=@greens2;
}
