import luxe.Input;
import luxe.AppConfig;
import luxe.Sprite;
import luxe.Color;
import luxe.Vector;
import luxe.collision.shapes.Shape;
import luxe.collision.shapes.Circle;
import phoenix.Texture;
import luxe.utils.Maths;
import luxe.Rectangle;
import luxe.Text;
import luxe.States;



class GameOverState extends State {

    var value : Int;

    public function new ( _name:String, _value:Int ) {
        super({ name:_name });
        value = _value;
    }

    override function onenabled<T>( _data:T ) {
        var gameOverText = new Text({
            text : "GAME OVER",
            align : center,
            pos : new Vector(Luxe.screen.w/2, Luxe.screen.h/2 - 15)
        });
        var finalScoreText = new Text({
            text : "Score: " + value,
            align : center,
            pos : new Vector(Luxe.screen.w/2, Luxe.screen.h/2 + 15)
        });
    }
}

class Main extends luxe.Game {

    var backgroundTex : Texture;
    var background : Sprite;
    public static var backgroundSize : Vector;
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
    public static var score : Int = 0;
    var scoreText : Text;

    var enemyPool : Array<Sprite>;
    var enemyPoolSize : Int = 10;
    var enemyCollider : Circle;
    public static var enemyColliderPool : Array<Shape>;

    var isFiring : Bool = false;
    var nextFire : Float = 0.0;
    var fireRate : Float = 0.1;
    var currentBullet : Int = 0;

    var cameraPosMid : Vector;
    var cameraXBuffer : Int = 100;
    var cameraYBuffer : Int = 100;

    var machine : States;


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
        cameraPosMid = new Vector();

        machine = new States({ name:"stateMachine" });

        // backgroundTex = Luxe.loadTexture("assets/tilemap.png");
        // background = new Sprite({
        //     texture : backgroundTex,
        //     origin : new Vector(0, 0),
        //     pos : new Vector(0, 0),
        //     name : "background",
        //     depth : 0,
        //     color : new Color(1, 1, 1, 0.5)
        // });

        // backgroundTex.onload = checkSize;

        // Luxe.camera.bounds = new Rectangle(0, 0, background.size.x, background.size.y);

        playerTex = Luxe.loadTexture("assets/player.png");
        player = new Sprite({
            texture : playerTex,
            pos : Luxe.screen.mid,
            name : "player",
            depth : 1
        }); //player

        reticuleTex = Luxe.loadTexture("assets/reticule.png");
        reticule = new Sprite({
            texture : reticuleTex,
            pos : player.pos,
            depth : 1
        }); //reticule

        bulletPool = [];
        bulletTex = Luxe.loadTexture("assets/bullet.png");
        for(i in 0...bulletPoolSize) {
            var bullet = new Sprite({
                name : "bullet",
                name_unique : true,
                texture : bulletTex,
                visible : false,
                depth : 1

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
                color : new Color().rgb(0xb70028),
                depth : 1
            }); //enemy

            enemyCollider = new Circle(enemy.pos.x, enemy.pos.y, 6);
            enemyCollider.name = enemy.name+"Collider";
            enemyColliderPool.push(enemyCollider);

            enemy.add(new EnemyComponent({name : "enemy" }));
            enemyPool.push(enemy);

        } //enemyPool

        scoreText = new Text({
            text : "Score: " + score,
            pos : new Vector(Luxe.screen.w/2, 30),
            align : center
        });


    } //ready

    public function checkSize(_) {
        backgroundSize = new Vector(background.size.x, background.size.y);
    }

    override function update( dt:Float ) {
        if(Luxe.input.inputdown('up')) {
                player.pos.y -= moveSpeed * dt;
            if(player.pos.y < 0) {
                player.pos.y = 0;
            }
        }
        if(Luxe.input.inputdown('right')) {
                player.pos.x += moveSpeed * dt;
            if(player.pos.x > Luxe.screen.w) {
                player.pos.x = Luxe.screen.w;
            }
        }
        if(Luxe.input.inputdown('down')) {
                player.pos.y += moveSpeed * dt; 
            if(player.pos.y > Luxe.screen.h) {
                player.pos.y = Luxe.screen.h;
            }
        }
        if(Luxe.input.inputdown('left')) {
                player.pos.x -= moveSpeed * dt;
            if(player.pos.x < 0) {
                player.pos.x = 0;
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

        scoreText.text = "Score: " + score;
        
        // cameraPosMid.x = Luxe.camera.pos.x + Luxe.camera.viewport.w / 2;
        // cameraPosMid.y = Luxe.camera.pos.y + Luxe.camera.viewport.h / 2;

        // if(player.pos.x > cameraPosMid.x + cameraXBuffer) {
        //     Luxe.camera.pos.x += 300 * dt;
        //     // Luxe.camera.pos.x = Maths.lerp(Luxe.camera.pos.x, Luxe.camera.pos.x +10, 1.0);
        // }
        // if(player.pos.x < cameraPosMid.x - cameraXBuffer) {
        //     Luxe.camera.pos.x -= 300 * dt;
        // }
        // if(player.pos.y > cameraPosMid.y + cameraYBuffer) {
        //     Luxe.camera.pos.y += 300 * dt;
        // }
        // if(player.pos.y < cameraPosMid.y - cameraYBuffer) {
        //     Luxe.camera.pos.y -= 300 * dt;
        // }

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
        mousePos = Luxe.camera.screen_point_to_world(mousePos);

    } //onmousemove

    override function onmousedown( e:MouseEvent) {
        isFiring = true;

    } //onmousedown

    override function onmouseup( e:MouseEvent ) {
        isFiring = false;

    } //onmouseup

    function connect_input() {
        // add WASD and arrow keys to input
        Luxe.input.bind_key('up', Key.up);
        Luxe.input.bind_key('up', Key.key_w);
        Luxe.input.bind_key('right', Key.right);
        Luxe.input.bind_key('right', Key.key_d);
        Luxe.input.bind_key('down', Key.down);
        Luxe.input.bind_key('down', Key.key_s);
        Luxe.input.bind_key('left', Key.left);
        Luxe.input.bind_key('left', Key.key_a);

    } //connect_input

    override function onkeyup( e:KeyEvent ) {
        if(e.keycode == Key.escape) {
            Luxe.shutdown();
        }

        if(e.keycode == Key.space) {
            machine.add(new GameOverState('gameOverState', 20 ));
            machine.enable('gameOverState');
        }

    } //onkeyup

} //Main
