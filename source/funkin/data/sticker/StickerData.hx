package funkin.data.sticker;

/**
 * A structure object used for stickerpack data.
 */
typedef StickerData =
{
	var name:String;
	var artist:String;
	@:default([])
	var images:Array<String>;
}
