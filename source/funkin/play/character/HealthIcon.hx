package funkin.play.character;

import funkin.data.character.CharacterData.CharacterIconData;
import funkin.data.character.CharacterRegistry;
import funkin.graphics.FunkinSprite;
import funkin.util.MathUtil;

/**
 * A `FunkinSprite` that helps indicate whoever is winning or losing.
 */
class HealthIcon extends FunkinSprite
{
	static final LERP_SPEED:Float = 0.165;
	static final BOP_SCALE:Float = 1.265;

	public final id:String;
	public final meta:CharacterIconData;
	public final isPlayer:Bool;

	public var state(default, set):HealthIconState = IDLE;

	var _scale:Float;

	public function new(id:String, meta:CharacterIconData, isPlayer:Bool = false)
	{
		super();

		this.id = id;
		this.meta = meta;
		this.isPlayer = isPlayer;

		final image:String = meta.id ?? id;
		final path:String = '${CharacterRegistry.instance.path}/$image/icon';

		// The sprite needs to be loaded in order to get the size
		loadSprite(path);
		loadSprite(path, meta.scale, graphic?.height, graphic?.height);

		addAnimation('icon', [0, 1, 2], 0);
		playAnimation('icon');

		flipX = meta.flipX != isPlayer;
		flipY = meta.flipY;

		_scale = scale.x;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		// Cool ass lerping >:D
		scale.x = scale.y = MathUtil.lerp(scale.x, _scale, LERP_SPEED);
		angle = MathUtil.lerp(angle, 0, LERP_SPEED);
	}

	public function bop()
	{
		// Don't bop the icon if it's not the right beat
		if (Conductor.instance.beat % meta.bopEvery != 0)
			return;

		scale.x = scale.y = _scale * BOP_SCALE;

		if (meta.bopAngle != null)
			angle = meta.bopAngle;
	}

	@:noCompletion
	function set_state(value:HealthIconState):HealthIconState
	{
		if (state == value)
			return state;

		state = value;

		animation.frameIndex = switch (state)
		{
			case LOSING:
				1;
			case WINNING:
				2;
			default:
				0;
		}

		return state;
	}
}
