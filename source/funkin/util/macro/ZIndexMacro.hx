package funkin.util.macro;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;

using thx.Arrays;

/**
 * A macro class for implementing z-ordering features.
 */
class ZIndexMacro
{
	public static macro function buildFlxGroup():Array<Field>
	{
		if (Context.defined('display'))
			return [];

		var fields:Array<Field> = Context.getBuildFields();
		var pos:Position = Context.currentPos();

		if (fields.find(field -> return field.name == 'refresh') != null)
			return fields;

		fields.push({
			name: 'refresh',
			access: [APublic],
			kind: FieldType.FFun({
				args: [],
				expr: macro
				{sort(funkin.util.SortUtil.byZIndex);}
			}),
			pos: pos
		});

		return fields;
	}
}
#end
