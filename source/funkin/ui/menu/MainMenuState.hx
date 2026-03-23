package funkin.ui.menu;

import funkin.graphics.FunkinSprite;
import funkin.ui.freeplay.FreeplaySubState;

/**
 * The engine's main menu state.
 * This is the menu where the player can access the story and freeplay menu.
 */
class MainMenuState extends FunkinState
{
    override public function create()
    {
        super.create();

        var bg:FunkinSprite = FunkinSprite.create(0, 0, 'ui/menu/bg', 1.5);
        bg.color = 0xFF363636;
        bg.active = false;
        add(bg);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (controls.ACCEPT)
            openSubState(new FreeplaySubState());
    }
}