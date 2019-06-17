
class Vector2
{
	public var x : Float;
	public var y : Float;

	public function new(?v : Vector2, ?_x : Float, ?_y : Float)
	{
		if(v != null){
			x = v.x;
			y = v.y;
		} else {
			x = _x;
			y = _y;
		}
	}

	public function add(v : Vector2){
		x += v.x;
		y += v.y;
	}

	public function toString(){
		return x + ", " + y;
	}

	
}