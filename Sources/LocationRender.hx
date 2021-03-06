package;
import kha.Color;
import kha.graphics4.ConstantLocation;
import kha.graphics4.CullMode;
import kha.graphics4.Graphics;
import kha.math.Matrix4;
import kha.math.Vector3;
import kha.math.Vector4;
import kha.ScreenCanvas;

/**
 * ...
 * @author 0d
 */
class LocationRender
{

	var p:Matrix4;
	var v:Matrix4;
	var vp:Matrix4;
	
	var mvpID:ConstantLocation;
	var colorID:ConstantLocation;
	
	var cube:Cube;
	
	var isMouseDown = false;
	var mouseX = 0.0;
	var mouseY = 0.0;
	var mouseDeltaX = 0.0;
	var mouseDeltaY = 0.0;
	var accX = 0.0;
	var accY = 0.0;
	

	
	public function new() 
	{
		cube = new Cube();
		
		mvpID = cube.program.getConstantLocation("MVP");
		colorID = cube.program.getConstantLocation("uColor");
		
		var fovY = 90;
		var zn = 1;
		var zf = 10;
		var aspect = 1.0;
		
		p = Matrix4.perspectiveProjection(fovY, aspect, zn, zf);
		
		// Add mouse and keyboard listeners
		kha.input.Mouse.get().notify(onMouseDown, onMouseUp, onMouseMove, null);
	}
	
	function onMouseDown(button:Int, x:Int, y:Int) {
    	isMouseDown = true;
    }

    function onMouseUp(button:Int, x:Int, y:Int) {
    	isMouseDown = false;
    }

    function onMouseMove(x:Int, y:Int) {
    	mouseDeltaX = x - mouseX;
    	mouseDeltaY = y - mouseY;

    	mouseX = x;
    	mouseY = y;
    }
	
	public function traceVector4(vec: Vector4, name: String): Void
	{
		trace('$name:  ${vec.x}, ${vec.y}, ${vec.z}, ${vec.w}');
	}
	
	public function update(dt:Float)
	{
		var pos = new Vector3(4, 4, 4);
		v = Matrix4.lookAt( pos, // Position in World Space
						    new Vector3(0,0,0), // and looks at the origin
					        new Vector3(0, 1, 0) // Head is up
		);
		
		//trace( 'pos.x = ${pos.x}, pos.y = ${pos.y}, pos.z = ${pos.z} ');
		
		var w = ScreenCanvas.the.width;
		var h = ScreenCanvas.the.height;
		
		var nmx = (mouseX/w) * 2.0 - 1.0;
		var nmy = -(mouseY /h) * 2.0 + 1.0;
		
		var vec = new Vector4(2, -2, -5, 1);
		var persp_vec = p.multvec(vec);
		
		var clip_space_point: Vector4 = new Vector4(nmx, nmy, 1.0, 1);
		
		var pInv = p.inverse();
		
		var eye_space_point = pInv.multvec(clip_space_point);
		var norm_eye_space_point = eye_space_point.mult(1 / eye_space_point.w);
		
		var dir    = new Vector4( 0, -10, -10, 1);
		dir.normalize();
		
		vp = Matrix4.identity();
		vp = vp.multmat( p );
		vp = vp.multmat( v );

		
		var vInv = v.inverse();
		
		var eye_space_dir = new Vector4();
		eye_space_dir.x = norm_eye_space_point.x;
		eye_space_dir.y = norm_eye_space_point.y;
		eye_space_dir.z = norm_eye_space_point.z;
		eye_space_dir.w = 0;
		
		
		var world_space_dir = vInv.multvec(eye_space_dir);
		world_space_dir.normalize();
		
		var intersect_point = new Vector4();
		
		intersect_point.x = -(world_space_dir.x / world_space_dir.y) * pos.y + pos.x;
		intersect_point.y = 0;
		intersect_point.z = -(world_space_dir.z / world_space_dir.y) * pos.y + pos.z;
		intersect_point.w = 1;
		
		ix = intersect_point.x;
		iz = intersect_point.z;
	}
	
	var ix: Float;
	var iz: Float;
	
	public function render(g:Graphics)
	{
		//return;
		// Begin rendering
        g.begin();

        // Clear screen to black
        g.clear(Color.Pink);
		g.setProgram( cube.program );
		
		var model = Matrix4.identity();
		model = model.multmat( Matrix4.translation( 0.5 + ix, 0.5, 0.5 + iz));
		var mvp = vp.multmat( model );
		g.setMatrix( mvpID, mvp );
		g.setFloat4( colorID, 1.0, 0, 0, 1.0 );
		cube.render( g );
		
		
        g.end();
	}
	
}