package macohi.util;

import lime.utils.Assets as KoyaAssets; // import macohi.funkin.koya.backend.KoyaAssets;

using StringTools;

class StringUtil
{
	/**
	 * Checks if a string is `null` or blank (contains only whitespaces).
	 * 
	 * Yoinked from an FNF pr heheheehehehee
	 * https://github.com/FunkinCrew/Funkin/pull/6910
	 *
	 * @param value The string to check.
	 * @return True... or False...
	 */
	public static function isBlank(value:String):Bool
	{
		return value == null || value.trim().length == 0;
	}

	public static function splitStringByNewlines(str:String):Array<String>
	{
		if (str == null)
			return [];

		var strA:Array<String> = [];

		for (entry in str.split('\n'))
			strA.push(entry.trim());

		return strA;
	}

	public static function splitTextAssetByNewlines(txt:String)
	{
		if (!KoyaAssets.exists(txt))
		{
			WindowUtil.alert('Missing Path: $txt', '$txt is a missing path\nand thus cannot be split by newlines');
			return [];
		}

		return splitStringByNewlines(KoyaAssets.getText(txt));
	}
}
