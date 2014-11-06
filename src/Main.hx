import luxe.Input;
import luxe.AppConfig;
import luxe.Sprite;
import luxe.Color;
import luxe.Vector;

class Main extends luxe.Game {

    var player : Sprite;

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
        player = new Sprite({
            color : new Color().rgb(0xffffff),
            pos : Luxe.screen.mid,
            size : new Vector(50, 50)
        }); //player

        connect_input();

    } //ready

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

    override function update( dt:Float ) {

    } //update


} //Main
