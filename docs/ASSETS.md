# Assets

This is a nice little guide on good asset creation.

## Images

One thing you probably don't want the engine to have is images that could be smaller in size. The art folder includes a bat file that can optimize every png in the assets folder. You need [oxipng](https://github.com/oxipng/oxipng) in order to run the file.

## Sounds and Music

Sound files take up a LOT of space. Something you can do is use [Audacity](https://www.audacityteam.org) to re-export sound files, as that can bring the file size down by a couple megabytes.

Because the engine uses OGG files for audio, you can re-export sound files with an OGG quality of zero. From my testing, exporting with quality set to zero does nothing to the actual quality of the audio.

[OptiVorbis](https://optivorbis.github.io/OptiVorbis/) can be used to further reduce the size of sound files by optimizing them. If you are familiar with video games, you should know that optimization is good.

## Format

For consistency, the assets folder should have its files in a lower kebab case format (ex. `my-super-cool-song`).