import luxe.Input;
import luxe.AppConfig;
import luxe.Sprite;
import luxe.Color;
import luxe.Vector;
import phoenix.Texture;

class Main extends luxe.Game {

    var playerTex : Texture;
    var player : Sprite;
    var moveSpeed : Float = 200.0;

    override function config( config:AppConfig ) {

        config.window.title = config.runtime.window.title;

        if(config.runtime.window != null) {
            if(config.runtime.window.width != null) {
                config.window.width = Std.int(config.runtime.window.width);
            }
            if(config.runtime.window.height != null) {
                config.window.height = Std.int(config.runtime.window.height);
            }
        }
        return config;

    } //config

    override function ready() {
        playerTex = Luxe.loadTexture("assets/player.png");
        player = new Sprite({
            // color : new Color().rgb(0xffffff),
            texture : playerTex,
            pos : Luxe.screen.mid,
            size : new Vector(50, 50)
        }); //player

        connect_input();

    } //ready

    override function update( dt:Float ) {
        if(Luxe.input.inputdown('up')) {
            player.pos.y -= moveSpeed * dt;
        }
        if(Luxe.input.inputdown('right')) {
            player.pos.x += moveSpeed * dt;
        }
        if(Luxe.input.inputdown('down')) {
            player.pos.y += moveSpeed * dt;
        }
        if(Luxe.input.inputdown('left')) {
            player.pos.x -= moveSpeed * dt;
        }


    } //update

    function connect_input() {
        // add WASD and arrow keys to input
        Luxe.input.add('up', Key.up);
        Luxe.input.add('up', Key.key_w);
        Luxe.input.add('right', Key.right);
        Luxe.input.add('right', Key.key_d);
        Luxe.input.add('down', Key.down);
        Luxe.input.add('down', Key.key_s);
        Luxe.input.add('left', Key.left);
        Luxe.input.add('left', Key.key_a);

    } //connect_input

    override function onkeyup( e:KeyEvent ) {
        if(e.keycode == Key.escape) {
            Luxe.shutdown();
        }

    } //onkeyup

} //Main
