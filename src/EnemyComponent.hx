import luxe.Component;
import luxe.Sprite;
import luxe.Color;
import luxe.Vector;
import luxe.collision.Collision;
import luxe.collision.CollisionData;
import luxe.collision.shapes.Shape;
import luxe.collision.shapes.Circle;

class EnemyComponent extends Component {

    var sprite : Sprite;
    var player : Sprite;
    var speed : Float = 100.0 * Math.random();
    public var wasHit : Bool = false;

    override function init() {
        // called when initializing a component

        sprite = cast entity;
        player = cast Luxe.scene.entities.get("player");

        resetEnemy();

    } //init

    override function update( dt:Float ) {
        // called every frame for you

        if(sprite.pos.x < player.pos.x) {
            sprite.pos.x += speed * dt;
        }
        if(sprite.pos.x > player.pos.x) {
            sprite.pos.x -= speed * dt;
        }
        if(sprite.pos.y < player.pos.y) {
            sprite.pos.y += speed * dt;
        }
        if(sprite.pos.y > player.pos.y) {
            sprite.pos.y -= speed * dt;
        }
        for(c in Main.enemyColliderPool) {
            if(c.name == sprite.name+"Collider") {
                c.x = sprite.pos.x;
                c.y = sprite.pos.y;
            }
        }

    } //update

    public function resetEnemy() {
        var randomSide = Std.random(4);
        //top
        if(randomSide == 0) { 
            sprite.pos = new Vector(Luxe.camera.pos.x + Std.random(Std.int(Luxe.camera.viewport.w)), Luxe.camera.pos.y -20 - Std.random(10));
            trace("top");
        }
        //right
        if(randomSide == 1) {
            sprite.pos = new Vector(Luxe.camera.pos.x + Luxe.camera.viewport.w + 20 + Std.random(10), Luxe.camera.pos.y + Std.random(Std.int(Luxe.camera.viewport.h)));
            trace("right");
        }
        //bottom
        if(randomSide == 2) {
            sprite.pos = new Vector(Luxe.camera.pos.x + Std.random(Std.int(Luxe.camera.viewport.w)), Luxe.camera.pos.y + Luxe.camera.viewport.h + 20 + Std.random(10));
            trace("bottom");
        }
        //left
        if(randomSide == 3) {
            sprite.pos = new Vector(Luxe.camera.pos.x -20 - Std.random(10), Luxe.camera.pos.y + Std.random(Std.int(Luxe.camera.viewport.h)));
            trace("left");
        }
        if(wasHit) {
            // sprite.color = Color.random();
            wasHit = false;
            speed = 100.0 * Math.random();
        }

    } //resetEnemy

    override function onreset() {
        // called when the scene starts or restarts

    } //onreset

} //EnemyComponent