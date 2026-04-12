package funkin.play.stage;

import funkin.data.stage.StageData.PropAnimData;
import funkin.graphics.FunkinSprite;

/**
 * A `FunkinSprite` used for the props of a `Stage`.
 */
class StageProp extends FunkinSprite
{
	final BOP_ANIMATION:String = 'idle';

	public var id:String;
	public var bopEvery:Int = 1;

	public function new(id:String)
	{
		super();

		this.id = id;
	}

	public function loadAnimations(animations:Array<PropAnimData>)
	{
		for (anim in animations)
			addAnimation(anim.name, anim.frames, anim.framerate, anim.looped);
	}

	public function bop(force:Bool = false)
	{
		if ((Conductor.instance.beat % bopEvery == 0) || force)
			playAnimation(BOP_ANIMATION, true);
	}

	override public function copy():StageProp
	{
		// This is so fucking stupid
		// Best I can do unfortunately

		var sprite:StageProp = new StageProp(id);

		sprite.loadGraphicFromSprite(this);
		sprite.setGraphicSize(width, height);
		sprite.updateHitbox();

		sprite.animation.copyFrom(animation);
		sprite.scrollFactor.copyFrom(scrollFactor);
		sprite.offset.copyFrom(offset);
		sprite.origin.copyFrom(origin);

		sprite.angle = angle;
		sprite.flipX = flipX;
		sprite.flipY = flipY;

		sprite.visible = visible;
		sprite.active = active;

		sprite.zIndex = zIndex;

		return sprite;
	}
}
