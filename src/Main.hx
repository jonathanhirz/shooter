import luxe.Input;
import luxe.AppConfig;
import luxe.Sprite;
import luxe.Color;
import luxe.Vector;
import luxe.collision.shapes.Shape;
import luxe.collision.shapes.Circle;
import phoenix.Texture;
import luxe.utils.Maths;

class Main extends luxe.Game {

    var playerTex : Texture;
    public var player : Sprite;
    var reticuleTex : Texture;
    var reticule : Sprite;
    var reticuleDist : Float = 25.0;
    var bulletTex : Texture;
    var bulletPool : Array<Sprite>;
    var bulletPoolSize : Int = 30;
    var moveSpeed : Float = 400.0;
    var mousePos : Vector;

    var enemyPool : Array<Sprite>;
    var enemyPoolSize : Int = 20;
    var enemyCollider : Circle;
    public static var enemyColliderPool : Array<Shape>;

    var isFiring : Bool = false;
    var nextFire : Float = 0.0;
    var fireRate : Float = 0.1;
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
            pos : Luxe.screen.mid,
            name : "player"
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

        } //bulletPool

        enemyPool = [];
        enemyColliderPool = [];
        for(i in 0...enemyPoolSize) {
            var enemy = new Sprite({
                name : "enemy",
                name_unique : true,
                visible : true,
                pos : new Vector(25*i, 0),
                size : new Vector(20, 20),
                color : new Color().rgb(0xb70028)
            }); //enemy

            enemyCollider = new Circle(enemy.pos.x, enemy.pos.y, 4);
            enemyCollider.name = enemy.name+"Collider";
            enemyColliderPool.push(enemyCollider);

            enemy.add(new EnemyComponent({name : "enemy" }));
            enemyPool.push(enemy);

        } //enemyPool


    } //ready

    override function update( dt:Float ) {
        if(Luxe.input.inputdown('up')) {
            if(player.pos.y > 0) {
                player.pos.y -= moveSpeed * dt;
            }
        }
        if(Luxe.input.inputdown('right')) {
            if(player.pos.x < Luxe.screen.w) {
                player.pos.x += moveSpeed * dt;
            }
        }
        if(Luxe.input.inputdown('down')) {
            if(player.pos.y < Luxe.screen.h) {
                player.pos.y += moveSpeed * dt; 
            }
        }
        if(Luxe.input.inputdown('left')) {
            if(player.pos.x > 0) {
                player.pos.x -= moveSpeed * dt;
            }
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
