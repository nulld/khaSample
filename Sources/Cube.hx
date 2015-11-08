package;
import kha.graphics4.Graphics;
import kha.graphics4.FragmentShader;
import kha.graphics4.IndexBuffer;
import kha.graphics4.Program;
import kha.graphics4.Usage;
import kha.graphics4.VertexBuffer;
import kha.graphics4.VertexData;
import kha.graphics4.VertexShader;
import kha.graphics4.VertexStructure;
import kha.Loader;

/**
 * ...
 * @author 0d
 */
class Cube
{

	var vertices = [
	  -0.5,-0.5,-0.5,  -0.5,-0.5, 0.5,  -0.5, 0.5, 0.5,
	   0.5, 0.5,-0.5,  -0.5,-0.5,-0.5,  -0.5, 0.5,-0.5,
	   0.5,-0.5, 0.5,  -0.5,-0.5,-0.5,   0.5,-0.5,-0.5,
	   0.5, 0.5,-0.5,   0.5,-0.5,-0.5,  -0.5,-0.5,-0.5,
	  -0.5,-0.5,-0.5,  -0.5, 0.5, 0.5,  -0.5, 0.5,-0.5,
	   0.5,-0.5, 0.5,  -0.5,-0.5, 0.5,  -0.5,-0.5,-0.5,
	  -0.5, 0.5, 0.5,  -0.5,-0.5, 0.5,   0.5,-0.5, 0.5,
	   0.5, 0.5, 0.5,   0.5,-0.5,-0.5,   0.5, 0.5,-0.5,
	   0.5,-0.5,-0.5,   0.5, 0.5, 0.5,   0.5,-0.5, 0.5,
	   0.5, 0.5, 0.5,   0.5, 0.5,-0.5,  -0.5, 0.5,-0.5,
	   0.5, 0.5, 0.5,  -0.5, 0.5,-0.5,  -0.5, 0.5, 0.5,
	   0.5, 0.5, 0.5,  -0.5, 0.5, 0.5,   0.5,-0.5, 0.5
	];
	
	var vertexBuffer:VertexBuffer;
	var indexBuffer:IndexBuffer;
	public var program:Program;
	
	public function new() 
	{
		
		var structure = new VertexStructure();
		structure.add("pos", VertexData.Float3);
		var structureLength = 3;
		
		var fragmentShader = new FragmentShader(Loader.the.getShader("cube.frag"));
		var vertexShader = new VertexShader(Loader.the.getShader("cube.vert"));

		// Link program with fragment and vertex shaders we loaded
		program = new Program();
		program.setFragmentShader(fragmentShader);
		program.setVertexShader(vertexShader);
		program.link(structure);
		
		vertexBuffer = new VertexBuffer(
			Std.int(vertices.length / 3), // Vertex count - 3 floats per vertex
			structure, // Vertex structure
			Usage.StaticUsage // Vertex data will stay the same
		);
		
		// Copy vertices to vertex buffer
		var vbData = vertexBuffer.lock();
		for (i in 0...vbData.length) {
		  vbData.set(i,vertices[i]);
		}
		vertexBuffer.unlock();
		
		var indices:Array<Int> = [];
		for (i in 0...Std.int(vertices.length / 3)) {
		  indices.push(i);
		}
		
		indexBuffer = new IndexBuffer(
			indices.length, // Number of indices for our cube
			Usage.StaticUsage // Index data will stay the same
		);

		// Copy indices to index buffer
		var iData = indexBuffer.lock();
		for (i in 0...iData.length) {
		  iData[i] = indices[i];
		}
		indexBuffer.unlock();
		
		
	}
	
	public function render(g:Graphics)
	{
		// Bind data we want to draw
		g.setVertexBuffer(vertexBuffer);
		g.setIndexBuffer(indexBuffer);

		// Draw!
		g.drawIndexedVertices();
	}
	
}