using StringTools;

import luxe.Component;
import luxe.Sprite;
import luxe.Vector;
import luxe.Rectangle;
import luxe.collision.Collision;
import luxe.collision.CollisionData;
import luxe.collision.shapes.Shape;
import luxe.collision.shapes.Circle;

class BulletComponent extends Component {

    var sprite : Sprite;
    var bulletSpeed : Float = 15.0;
    var bounds : Rectangle;
    var collider : Circle;
    var backgroundBoundsHaveBeenSet : Bool = false;

    public var alive : Bool = false;
    public var direction : Vector;


    override function init() {
        // called when initializing a component

        sprite = cast entity;
        direction = new Vector();
        collider = new Circle(pos.x, pos.y, 8);
        collider.name = "bulletCollider";

    } //init

    override function update( dt:Float ) {
        // called every frame for you

        if(Main.backgroundSize != null && !backgroundBoundsHaveBeenSet) {
            backgroundBoundsHaveBeenSet = true;
            bounds = new Rectangle(0, 0, Main.backgroundSize.x, Main.backgroundSize.y);
            // trace("BOUNDS MADE!");
        }

        if(alive) {
            var newx = sprite.pos.x + (direction.x * bulletSpeed);
            var newy = sprite.pos.y + (direction.y * bulletSpeed);

            sprite.pos = new Vector(newx, newy);
            collider.x = newx;
            collider.y = newy;

            //for each bullet (single component), roll through the pool of enemy colliders
            //if this shape hits one of those colliders, explosion, call enemy.resetEnemy()
            var results : Array<CollisionData> = Collision.testShapes(collider, Main.enemyColliderPool);
            if(results.length > 0) {
                for(collision in results) {
                    for(collider in Main.enemyColliderPool) {
                        if(collision.shape2.name == collider.name) {
                            var hitEnemy : Sprite = cast Luxe.scene.entities.get(collider.name.replace("Collider", ""));
                            var enemyComp : EnemyComponent = hitEnemy.get("enemy");
                            enemyComp.wasHit = true;
                            enemyComp.resetEnemy();
                            Luxe.camera.shake(8);
                        }
                    }
                }
            }

            if(!bounds.point_inside(sprite.pos)) {
                kill();
            }
        }
        
    } //update

    public function kill() {
        //if a bullet is off screen, 'destroy' it (non-visible, non moving, but still in the pool)
        alive = false;
        sprite.visible = false;

    }//kill


    override function onreset() {
        // called when the scene starts or restarts

    } //onreset

} //BulletComponent