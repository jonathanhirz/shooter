import luxe.Component;
import luxe.Sprite;
import luxe.Color;
import luxe.Vector;

class EnemyComponent extends Component {

    var sprite : Sprite;
    var player : Sprite;
    var speed : Float = 100.0 * Math.random();

    override function init() {
        // called when initializing a component

        sprite = cast entity;
        player = cast Luxe.scene.entities.get("player");

        var randomSide = Std.random(4);
        if(randomSide == 0) {
            sprite.pos = new Vector(Std.random(Std.int(Luxe.screen.w)), -20);
        }
        if(randomSide == 1) {
            sprite.pos = new Vector(Luxe.screen.w + 20, Std.random(Std.int(Luxe.screen.h)));
        }
        if(randomSide == 2) {
            sprite.pos = new Vector(Std.random(Std.int(Luxe.screen.w)), Luxe.screen.h + 20);
        }
        if(randomSide == 3) {
            sprite.pos = new Vector(-20, Std.random(Std.int(Luxe.screen.h)));
        }


        // init at a random place around the outside of the game view on a random side

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

    } //update

    override function onreset() {
        // called when the scene starts or restarts

    } //onreset

} //EnemyComponent