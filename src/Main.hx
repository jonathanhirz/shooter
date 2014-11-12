import luxe.Input;
import luxe.AppConfig;
import luxe.Sprite;
import luxe.Color;
import luxe.Vector;
import phoenix.Texture;
import luxe.utils.Maths;

class Main extends luxe.Game {

    var playerTex : Texture;
    var player : Sprite;
    var reticuleTex : Texture;
    var reticule : Sprite;
    var reticuleDist : Float = 25.0;
    var bulletTex : Texture;
    var bulletPool : Array<Sprite>;
    var bulletPoolSize : Int = 20;
    var moveSpeed : Float = 300.0;
    var mousePos : Vector;

    var isFiring : Bool = false;
    var nextFire : Float = 0.0;
    var fireRate : Float = 0.5;
    var currentBullet : Int = 0;


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

        // Luxe.screen.cursor.visible = false;
        connect_input();
        mousePos = new Vector();

        playerTex = Luxe.loadTexture("assets/player.png");
        player = new Sprite({
            texture : playerTex,
            pos : Luxe.screen.mid
        }); //player

        reticuleTex = Luxe.loadTexture("assets/reticule.png");
        reticule = new Sprite({
            texture : reticuleTex,
            pos : player.pos
        }); //reticule

        bulletPool = [];
        bulletTex = Luxe.loadTexture("assets/bullet.png");
        for(i in 0...bulletPoolSize) {
            var bullet = new Sprite({
                name : "bullet",
                name_unique : true,
                texture : bulletTex,
                visible : false

            }); //bullet

            bullet.add(new BulletComponent({name : "bullet" }));

            bulletPool.push(bullet);
        }

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

        var diffX : Float = player.pos.x - mousePos.x;
        var diffY : Float = player.pos.y - mousePos.y;
        var angle : Float = Math.atan2(diffY, diffX);
        reticule.rotation_z = angle * (180 / Math.PI) - 90;
        reticule.pos = new Vector(player.pos.x - reticuleDist * Math.cos(angle), player.pos.y - reticuleDist * Math.sin(angle));

        if(isFiring) {
            if(Luxe.time > nextFire) {
                fire();
                nextFire = Luxe.time + fireRate;
            }
        }

    } //update

    function fire() {
        currentBullet++;
        if(currentBullet > bulletPoolSize - 1) {
            currentBullet = 0;
        } // reset to the beginning of the pool

        var bullet = bulletPool[currentBullet];
        bullet.pos = reticule.pos;
        bullet.rotation_z = reticule.rotation_z;
        bullet.visible = true;

        var component : BulletComponent = bullet.get("bullet");
        component.alive = true;
        component.direction.x = Math.cos(Maths.radians(bullet.rotation_z - 90) * 1);
        component.direction.y = Math.sin(Maths.radians(bullet.rotation_z - 90) * 1);

    } //fire

    override function onmousemove( e:MouseEvent ) {
        mousePos = e.pos;

    } //onmousemove

    override function onmousedown( e:MouseEvent) {
        isFiring = true;

    } //onmousedown

    override function onmouseup( e:MouseEvent ) {
        isFiring = false;

    } //onmouseup

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
