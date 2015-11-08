package;
import kha.Color;
import kha.graphics4.ConstantLocation;
import kha.graphics4.CullMode;
import kha.graphics4.Graphics;
import kha.math.Matrix4;
import kha.math.Vector3;
import kha.math.Vector4;

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
		
		var fovY = 45;
		var zn = 0.1;
		var zf = 100;
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
	
	public function update(dt:Float)
	{
		var pos = new Vector3(0, 4, 4);
		v = Matrix4.lookAt( pos, // Position in World Space
						    new Vector3(0,0,0), // and looks at the origin
					        new Vector3(0, 1, 0) // Head is up
		);
		
		trace( 'pos.x = ${pos.x}, pos.y = ${pos.y}, pos.z = ${pos.z} ');
		
		var w = Sys.
		
		var nmx = (mouseX/640) * 2.0 - 1.0;
		var nmy = -(mouseY / 480) * 2.0 + 1.0;
		
		//trace( 'x: $nmx, y: $nmy' );
		
		
		var dir    = new Vector4( 0, -10, -10, 1);
		dir.normalize();
		
		vp = Matrix4.identity();
		vp = vp.multmat( p );
		vp = vp.multmat( v );

		var vpInv = vp.inverse();
		var pp = new Vector4( nmx, nmy, 0.0, 1.0 );
		pp = vpInv.multvec( pp );
		trace( 'x: ${pp.x}, y: ${pp.y}, z: ${pp.z}' );
		
	}
	
	
	
	public function render(g:Graphics)
	{
		// Begin rendering
        g.begin();

        // Clear screen to black
        g.clear(Color.Pink);
		g.setProgram( cube.program );
		
		var model = Matrix4.identity();
		model = model.multmat( Matrix4.translation( 0.5, 0.5, 0.5));
		var mvp = vp.multmat( model );
		g.setMatrix( mvpID, mvp );
		g.setFloat4( colorID, 1.0, 0, 0, 1.0 );
		cube.render( g );
		
		
        g.end();
	}
	
}