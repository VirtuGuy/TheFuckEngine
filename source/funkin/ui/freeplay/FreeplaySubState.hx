package funkin.ui.freeplay;

import flixel.FlxCamera;
import flixel.util.FlxTimer;
import funkin.audio.FunkinSound;
import funkin.data.song.SongRegistry;
import funkin.graphics.FunkinSprite;
import funkin.graphics.FunkinText;
import funkin.graphics.shader.TextureSwap;
import funkin.play.PlayState;
import funkin.play.song.Song;
import funkin.save.Save;
import funkin.ui.freeplay.capsule.CapsuleGroup;
import funkin.ui.freeplay.capsule.CapsuleSprite;
import funkin.ui.freeplay.components.BackcardSprite;
import funkin.ui.freeplay.components.DJSprite;
import funkin.ui.freeplay.components.DifficultyText;
import funkin.ui.freeplay.components.SortText;
import funkin.ui.menu.MainMenuState;
import funkin.util.MathUtil;
import funkin.util.StringUtil;

/**
 * The engine's freeplay sub state.
 * This is the menu where the player can navigate through all the songs.
 */
class FreeplaySubState extends FunkinSubState
{
    static var selectedSong:Int = 1;
    static var selectedDiff:Int = 1;
    static var selectedSort:Int = 0;

    var skipIntro:Bool;
    var busy:Bool = false;

    var song(get, never):Song;
    var difficulty(get, never):String;
    
    var lerpScore:Float;
    var exitMovers:ExitMovers;

    var backcard:BackcardSprite;
    var backingImage:FunkinSprite;
    var dj:DJSprite;
    var capsules:CapsuleGroup;
    var scoreText:FunkinText;
    var diffText:DifficultyText;
    var sortText:SortText;

    public function new(skipIntro:Bool = false)
    {
        super();

        this.skipIntro = skipIntro;
    }

    override public function create()
    {
        super.create();

        FunkinSound.playMusic('ui/freeplay/music/random', 0);
        FunkinSound.music.fadeIn(0.75, 0, 0.6);

        _parentState.persistentDraw = false;

        conductor.reset(150);

        camera = new FlxCamera();
        camera.bgColor = 0x0;
        FlxG.cameras.add(camera, false);

        backcard = new BackcardSprite();
        add(backcard);

        backingImage = FunkinSprite.create(0, 0, 'ui/freeplay/card/right', 1.5);
        backingImage.shader = new TextureSwap('ui/freeplay/card/image');
        backingImage.active = false;
        backingImage.x = FlxG.width - backingImage.width;
        add(backingImage);

        dj = new DJSprite(30);
        dj.y = FlxG.height - dj.height + 30;
        add(dj);

        capsules = new CapsuleGroup(selectedSong);
        add(capsules);
        
        var blackbar:FunkinSprite = new FunkinSprite();
        blackbar.makeSolidColor(FlxG.width, 50, 0xFF000000);
        blackbar.zIndex = 1;
        add(blackbar);

        var freeplayText:FunkinText = new FunkinText(10, 0, 'freeplay');
        freeplayText.size = 24;
        freeplayText.y = (blackbar.height - freeplayText.height) / 2 + 0.5;
        freeplayText.zIndex = blackbar.zIndex;
        add(freeplayText);

        var ostText:FunkinText = new FunkinText(0, freeplayText.y, 'official ost');
        ostText.size = freeplayText.size;
        ostText.x = FlxG.width - ostText.width - freeplayText.x;
        ostText.zIndex = blackbar.zIndex;
        add(ostText);

        scoreText = new FunkinText(0, blackbar.height + 40);
        scoreText.alignment = RIGHT;
        add(scoreText);

        diffText = new DifficultyText(selectedDiff, SongRegistry.instance.getDifficulties());
        diffText.y = scoreText.y;
        diffText.onSelected.add(selectDifficulty);
        add(diffText);

        sortText = new SortText(selectedSort);
        sortText.screenCenter(X);
        sortText.y = blackbar.height + 30;
        sortText.onSelected.add(selectSort);
        add(sortText);

        exitMovers = new ExitMovers();
        exitMovers.add(backcard, -backcard.width);
        exitMovers.add(backingImage, FlxG.width);
        exitMovers.add(dj, -dj.width);
        exitMovers.add(blackbar, null, -blackbar.height);
        exitMovers.add(freeplayText, null, -freeplayText.height);
        exitMovers.add(ostText, null, -ostText.height);
        exitMovers.add(scoreText, null, -scoreText.height);
        exitMovers.add(diffText, null, -diffText.height);
        exitMovers.add(sortText, null, -sortText.height);

        selectDifficulty(selectedDiff);
        refresh();

        if (!skipIntro)
            intro();
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (FunkinSound.music?.playing)
        {
            conductor.time = FunkinSound.music.time;
            conductor.update();
        }

        if (controls.FAVORITE)
            favorite(capsules.capsule);
        if (controls.ACCEPT)
            confirm(capsules.capsule);
        if (controls.BACK)
            exit();

        capsules.busy = busy;
        diffText.busy = busy;
        sortText.busy = busy;

        // Doing it like this so that random is selected
        if (!busy)
            selectedSong = capsules.selected;

        lerpScore = MathUtil.lerp(lerpScore, Save.instance.getSongScore(song?.id, difficulty), 0.45);

        scoreText.text = StringUtil.leadingZeros(Math.round(lerpScore), 10);
        scoreText.x = FlxG.width - scoreText.width - 50;
    }

    override function beatHit(beat:Int)
    {
        super.beatHit(beat);

        // Make the DJ bop
        // Without this line, freeplay would be shit
        dj.dance();
    }

    function selectDifficulty(selected:Int)
    {
        busy = true;
        selectedDiff = selected;

        var songs:Array<String> = SongRegistry.instance.listWithDifficulty(difficulty);

        // Only view favorited songs if selectedSort is 1
        if (selectedSort == 1)
            songs = songs.filter(song -> return Save.instance.isSongFavorited(song));

        capsules.load(songs, difficulty);
        capsules.forEachAlive(capsule -> exitMovers.add(capsule, FlxG.width + capsule.x));

        diffText.x = (440 - diffText.width) / 2;

        FlxTimer.wait(0.1, () -> busy = false);
    }

    function selectSort(selected:Int)
    {
        selectedSort = selected;
        sortText.screenCenter(X);

        selectDifficulty(selectedDiff);
    }

    function confirm(capsule:CapsuleSprite)
    {
        if (busy) return;

        // The capsule's song is null, meaning that it's Random
        if (capsule.song == null)
        {
            var list:Array<CapsuleSprite> = capsules.members.filter(capsule -> capsule.alive && capsule.song != null);
            var random:CapsuleSprite = list[FlxG.random.int(0, list.length - 1)];

            capsule = random;

            // Can't select a capsule that's null
            if (capsule == null)
            {
                FunkinSound.playOnce('ui/sounds/cancel');
                return;
            }

            capsules.selected = capsule.ID;
        }

        busy = true;

        capsule.flicker();
        dj.confirm();

        FunkinSound.playOnce('ui/sounds/confirm');

        FlxTimer.wait(1, () -> {
            camera.fade(0xFF000000, 0.25, false, () -> {
                PlayState.song = capsule.song;
                PlayState.difficulty = difficulty;

                FlxG.switchState(() -> new PlayState());
            });
        });
    }

    function favorite(capsule:CapsuleSprite)
    {
        if (busy) return;
        busy = true;

        var capsule:CapsuleSprite = capsules.capsule;
        var song:Song = capsule.song;

        if (song != null)
            capsule.favorited = !Save.instance.isSongFavorited(song.id);

        FlxTimer.wait(0.1, () -> busy = false);
    }

    function intro()
    {
        _parentState.persistentDraw = true;

        busy = true;
        capsules.lerp = false;

        backcard.hide();
        exitMovers.intro();

        exitMovers.onIntroDone = () -> {
            _parentState.persistentDraw = false;

            busy = false;
            capsules.lerp = true;

            backcard.show();
        }
    }

    function exit()
    {
        if (busy) return;
        busy = true;

        _parentState.persistentDraw = true;

        capsules.lerp = false;

        backcard.hide();
        exitMovers.outro();
        exitMovers.onOutroDone = () -> close();

        FunkinSound.playOnce('ui/sounds/cancel');
        FunkinSound.music.stop();
    }

    override public function destroy()
    {
        super.destroy();

        FunkinSound.music?.stop();
    }

    inline function get_song():Song
        return capsules.song;

    inline function get_difficulty():String
        return diffText.difficulty;

    public static function build(skipIntro:Bool = true):FunkinState
    {
        var menu:MainMenuState = new MainMenuState();
        menu.openSubState(new FreeplaySubState(skipIntro));
        return menu;
    }
}