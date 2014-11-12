import luxe.Component;
import luxe.Sprite;
import luxe.Vector;

class BulletComponent extends Component {

    var sprite : Sprite;
    var bulletSpeed : Float = 10.0;

    public var alive : Bool = false;
    public var direction : Vector;


    override function init() {
        // called when initializing a component

        sprite = cast entity;

        direction = new Vector();

    } //init

    override function update( dt:Float ) {
        // called every frame for you

        if(alive) {
            var newx = sprite.pos.x + (direction.x * bulletSpeed);
            var newy = sprite.pos.y + (direction.y * bulletSpeed);

            sprite.pos = new Vector(newx, newy);
        }
        


    } //update

    override function onreset() {
        // called when the scene starts or restarts

    } //onreset

} //BulletComponent