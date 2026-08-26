package funkin.play.character;

import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxTileFrames;
import flixel.math.FlxPoint;
import funkin.data.character.CharacterData;
import funkin.data.character.CharacterRegistry;
import funkin.modding.IScriptedClass.IPlayStateScriptedClass;
import funkin.modding.event.ScriptEvent;
import funkin.play.note.NoteDirection;
import funkin.play.stage.StageProp;
import funkin.util.MathUtil;

/**
 * A `StageProp` that sings and bops and all that.
 */
class Character extends StageProp implements IPlayStateScriptedClass
{
	static final MAX_SING_TIME:Float = 1;

	public var meta:CharacterData;
	public var type:CharacterType;

	public var singDuration:Float;
	public var singTimer:Float;

	public var isBopping(get, never):Bool;
	public var isSinging(get, never):Bool;
	public var isMissing(get, never):Bool;

	var charPath(get, never):String;

	public function buildSprite()
	{
		if (meta == null)
			return;

		loadSprite('$charPath/image', meta.scale, meta.width, meta.height);
		buildAnimations(meta.animations);

		offset.set(-meta.globalOffset[0] ?? 0, -meta.globalOffset[1] ?? 0);

		flipX = meta.flipX != (type == PLAYER);
		flipY = meta.flipY;

		bopEvery = meta.bopEvery;

		singDuration = meta.singDuration;
		singTimer = MAX_SING_TIME;

		bop();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		final singSeconds:Float = MAX_SING_TIME / (Conductor.instance.quaver / Constants.MS_PER_SEC * singDuration);

		singTimer = Math.min(MAX_SING_TIME, singTimer + elapsed * singSeconds);
	}

	override function bop(force:Bool = false)
	{
		if (singTimer < MAX_SING_TIME && !force)
			return;

		// Recreates that cool ass sing hold thing that the player can do
		if (type == PLAYER && NoteDirection.anyPressed() && isSinging)
			return;

		super.bop(force);
	}

	public function sing(direction:NoteDirection, suffix:String = '')
	{
		if (flipX && direction.horizontal)
			direction = direction.inverse;
		playAnimation('${direction.name}$suffix', true);
	}

	public function miss(direction:NoteDirection, suffix:String = '')
	{
		if (flipX && direction.horizontal)
			direction = direction.inverse;
		playAnimation('${direction.name}-miss$suffix', true);
	}

	public function buildHealthIcon():HealthIcon
	{
		// Return null if icon data is lacking
		// The god damn errors this would give >:(
		if (meta.icon == null)
			return null;
		return new HealthIcon(id, meta.icon, type == PLAYER);
	}

	function buildAnimations(animations:Array<CharacterAnimData>)
	{
		if (frames == null)
			return;

		final images:Array<String> = [];

		for (anim in animations)
		{
			if (anim == null)
				continue;

			final image:Null<String> = anim.image;
			final path:String = Paths.image('$charPath/images/$image');

			// Loads the images for the animations
			if (Paths.exists(path) && !images.contains(image))
			{
				images.push(image);

				final size:FlxPoint = FlxPoint.get(anim.width ?? frameWidth, anim.height ?? frameHeight);

				for (frame in FlxTileFrames.fromGraphic(FlxGraphic.fromAssetKey(path), size).frames)
				{
					frame.name = image;
					frames.pushFrame(frame, true);
				}

				size.put();
			}

			// Adds the actual animations
			// This also applies offsets to them as well :D
			final offset:FlxPoint = MathUtil.arrayToPoint(anim.offset);
			final index:Int = Std.int(Math.max(0, frames.getIndexByName(anim.image)));

			final animFrames:Array<Int> = [];

			for (frame in anim.frames)
			{
				frame += index;
				frames.getByIndex(frame)?.offset?.set(offset.x, offset.y);
				animFrames.push(frame);
			}

			offset.put();

			addAnimation(anim.name, animFrames, anim.framerate, anim.looped);
		}
	}

	override function playAnimation(name:String, force:Bool = false)
	{
		if (!hasAnimation(name))
			return;

		super.playAnimation(name, force);

		if (!isBopping)
			singTimer = 0;
	}

	override function onNoteHit(event:NoteScriptEvent)
	{
		super.onNoteHit(event);

		if (event.cancelled || !event.playAnimation || type == PLAYER != event.note.isPlayer || type == OTHER)
			return;

		sing(event.note.direction, event.suffix);
	}

	override function onNoteMiss(event:NoteScriptEvent)
	{
		super.onNoteMiss(event);

		if (event.cancelled || !event.playAnimation || type != PLAYER)
			return;

		miss(event.note.direction, event.suffix);
	}

	override function onHoldNoteHold(event:HoldNoteScriptEvent)
	{
		super.onHoldNoteHold(event);

		if (event.cancelled || !event.playAnimation || type == PLAYER != event.holdNote.isPlayer || type == OTHER)
			return;

		if (!isBopping)
			singTimer = 0;
	}

	override function onHoldNoteDrop(event:HoldNoteScriptEvent)
	{
		super.onHoldNoteDrop(event);

		if (event.cancelled || !event.playAnimation || type != PLAYER)
			return;

		miss(event.holdNote.direction, event.suffix);
	}

	override function onGhostMiss(event:GhostMissScriptEvent)
	{
		super.onGhostMiss(event);

		if (event.cancelled || !event.playAnimation || type != PLAYER)
			return;

		miss(event.direction, event.suffix);
	}

	override function onSongRetry(event:ScriptEvent)
	{
		super.onSongRetry(event);

		singTimer = MAX_SING_TIME;

		// Force the bopping animation
		// This is honestly better than staying in a singing animation
		bop(true);
	}

	@:noCompletion
	inline function get_isBopping():Bool
	{
		return getCurrentAnimation() == 'idle';
	}

	@:noCompletion
	inline function get_isSinging():Bool
	{
		final name:String = getCurrentAnimation();

		return (name.startsWith(NoteDirection.LEFT.name)
			|| name.startsWith(NoteDirection.DOWN.name)
			|| name.startsWith(NoteDirection.UP.name)
			|| name.startsWith(NoteDirection.RIGHT.name))
			&& !name.endsWith('-miss');
	}

	@:noCompletion
	inline function get_isMissing():Bool
	{
		return getCurrentAnimation().endsWith('-miss');
	}

	@:noCompletion
	inline function get_charPath():String
	{
		return '${CharacterRegistry.instance.path}/$id';
	}
}
