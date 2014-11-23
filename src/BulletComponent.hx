import luxe.Component;
import luxe.Sprite;
import luxe.Vector;
import luxe.Rectangle;

class BulletComponent extends Component {

    var sprite : Sprite;
    var bulletSpeed : Float = 15.0;
    var bounds : Rectangle;

    public var alive : Bool = false;
    public var direction : Vector;


    override function init() {
        // called when initializing a component

        sprite = cast entity;
        direction = new Vector();
        bounds = new Rectangle(0, 0, Luxe.screen.w, Luxe.screen.h);

    } //init

    override function update( dt:Float ) {
        // called every frame for you

        if(alive) {
            var newx = sprite.pos.x + (direction.x * bulletSpeed);
            var newy = sprite.pos.y + (direction.y * bulletSpeed);

            sprite.pos = new Vector(newx, newy);

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