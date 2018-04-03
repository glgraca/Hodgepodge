# Hodgepodge

## Cellular Automata from Images

This script creates a series of images that can be assembled into an animation.

./hodge.pl image k_red k_green k_blue #frames

The image should be a jpeg file.

If you want to use an indexed-colour image (GIFs or 8 bit PNGs), use the hodge_indexed.pl script.

The k parameters should be integer values between 0 and 255 (negative values should also work).

You shouldn't use more than 200 frames, as it will probably be just noise beyond that.

The images can be assembled into an animation with ffmpeg. I use these parameters for 1 frame per second:

```sh
 ffmpeg -r 1 -i hodge%03d.jpg -vcodec libx264 hodge.mp4
```
The algorithm works as follows:

1. Each pixel is a cell;
1. Calculate the average value of its neighbours and add k;
1. The new pixel is the new value modulo 256 (do this for each colour component in 24-bit colour images);
1. Write the image to file and repeat.
