package funkin.ui.story;

import funkin.data.story.StoryCharacterData;
import funkin.graphics.FunkinSprite;
import funkin.util.FileUtil;
import json2object.JsonParser;

/**
 * Just like the `Character` class, but for the story menu.
 */
class StoryCharacter extends FunkinSprite
{
	static var parser(default, null) = new JsonParser<StoryCharacterData>();

	public var id:String;
	public var meta:StoryCharacterData;

	public function load(id:String)
	{
		if (this.id == id)
			return;
		this.id = id;

		meta = null;

		final path:String = 'ui/story/characters/$id';
		final metaPath:String = Paths.json('$path/meta');

		// Metadata doesn't exist, so don't load it
		if (!Paths.exists(metaPath))
		{
			visible = false;
			active = false;
			return;
		}

		meta = parser.fromJson(FileUtil.getText(metaPath));
		visible = true;
		active = true;

		// Loads the sprite and animations
		// Story characters use gameplay character stuff
		loadSprite('$path/image', meta.scale, meta.frameWidth, meta.frameHeight);

		for (anim in meta.animations)
			addAnimation(anim.name, anim.frames, anim.framerate, anim.looped);

		flipX = meta.flipX;
		flipY = meta.flipY;

		bop(true);
	}

	public function bop(force:Bool = false)
	{
		// Don't bop if it's not the right time
		// Luckily, the bop can be forced
		if ((Conductor.instance.beat % meta?.bopEvery != 0 || getCurrentAnimation() != 'idle') && !force)
			return;

		playAnimation('idle', true);
	}
}
