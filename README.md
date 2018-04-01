# Hodgepodge

## Celular Automata from images

This script creates a series of images that can be assembled into an animation.

./hodge.pl <image> k_red k_green k_blue #frames

Image should be a jpeg file.

The k parameters should be integer values between 0 and 255 (negative values should work).

You shouldn't use more than 200 frames, as it will probably be just noise beyond that.

The images can be assembled into an animation with ffmpeg. I use these parameters for 1 frame per second:

```sh
 ffmpeg -r 1 -i lena%03d.jpg -vcodec libx264 lena.mp4
```
