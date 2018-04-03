#!/usr/bin/perl
use strict;
use warnings;
use GD;
use GD::Image;

if($#ARGV<2) {
  print "Usage: hodge.pl image.png k #frames\n";
  exit;
}

my $hodge=GD::Image->new($ARGV[0]);
my $width=$hodge->width();
my $height=$hodge->height();

my $k=$ARGV[1];

my @pixels=();

for my $x (0..$width-1) {
  for my $y (0..$height-1) {
    my $pixel=$hodge->getPixel($x,$y);
    my $index=$x+$y*$width;
    $pixels[$index]=$pixel;
  }
}

my @pixels2=@pixels;

for my $i (0..($ARGV[2]-1)) {
  for my $x (0..$width-1) {
    for my $y (0..$height-1) {
      my $avg=0;

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

            $avg+=$pixels[$index];
          }
        }
      }
      $avg/=8;

      my $index=$x+$y*$width;

      my $new=int($avg+$k);
      $new=$new%256;
      $pixels2[$index]=$new;

      $hodge->setPixel($x, $y, $new);
    }
  } 
  open(IMAGE, sprintf(">hodge%03d.png", $i));
  binmode IMAGE;
  print IMAGE $hodge->png;
  close IMAGE;
  @pixels=@pixels2;
}
