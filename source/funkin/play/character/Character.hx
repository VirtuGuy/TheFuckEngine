package funkin.play.character;

import funkin.data.character.CharacterData;
import funkin.data.character.CharacterRegistry;
import funkin.modding.IScriptedClass.IPlayStateScriptedClass;
import funkin.modding.event.ScriptEvent;
import funkin.play.note.NoteDirection;
import funkin.play.stage.StageProp;

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

	public function buildSprite()
	{
		if (meta == null)
			return;

		// Loads the image
		loadSprite(getPath('image'), meta.scale, meta.width, meta.height);
		loadAnimations(meta.animations);

		bopEvery = meta.bopEvery;
		singDuration = meta.singDuration;

		flipX = meta.flipX != (type == PLAYER);
		flipY = meta.flipY;

		offset.set(-meta.globalOffset[0] ?? 0, -meta.globalOffset[1] ?? 0);

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

	override function playAnimation(name:String, force:Bool = false)
	{
		if (!hasAnimation(name))
			return;

		super.playAnimation(name, force);

		if (!isBopping)
			singTimer = 0;
	}

	//
	// DEATH
	//

	public function buildDeathCharacter():Character
	{
		var death:Character = CharacterRegistry.instance.fetchCharacter(getDeathCharacter());

		if (death == null)
			return null;

		death.scrollFactor.copyFrom(scrollFactor);
		death.setPosition(x, y);
		death.playAnimation('start');

		return death;
	}

	public function getDeathCharacter():String
	{
		return '$id-death';
	}

	public function getDeathMusic():String
	{
		return getDeathSFX('music');
	}

	public function getDeathSFX(id:String):String
	{
		return getPath(id, getDeathCharacter());
	}

	public function getPauseMusic():String
	{
		return getPath('pause');
	}

	public function getPath(id:String, ?character:String)
	{
		character ??= this.id;

		return '${CharacterRegistry.instance.path}/$character/$id';
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
}
