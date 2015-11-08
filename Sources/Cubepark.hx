package;

import kha.Color;
import kha.Configuration;
import kha.Font;
import kha.FontStyle;
import kha.Framebuffer;
import kha.Game;
import kha.graphics4.ConstantLocation;
import kha.Image;
import kha.Loader;
import kha.LoadingScreen;
import kha.math.Matrix3;
import kha.math.Matrix4;
import kha.math.Vector3;
import kha.Scaler;
import kha.Scheduler;
import kha.Sys;

class Cubepark extends Game {
	
	var cube:Cube;
	
	
	var fps:FPSCounter;
	var font:Font;
	var lastTime:Float;
	
	var locationRender:LocationRender;
	
	public function new() {
		super("Empty", false);
		trace ("!!!");
		fps = new FPSCounter();
		
	}
	
	override public function init():Void 
	{
		super.init();
	
		Configuration.setScreen(new LoadingScreen());
		Loader.the.loadRoom("test", roomLoaded);	
	}
	
	function roomLoaded()
	{
		font = Loader.the.loadFont( "Arial", new FontStyle( false, false, false), 14 );
		Configuration.setScreen(this );
		
		locationRender = new LocationRender();
		
	}
	
	override public function update():Void 
	{
		
		var dt = Scheduler.time() - lastTime;
		lastTime = Scheduler.time();
		dt = Math.min(dt, 0.33);
		
		fps.update();
		locationRender.update(dt);
	}
	
	override public function render(frame:Framebuffer) {
        // A graphics object which lets us perform 3D operations
		
		var g = frame.g4;
		var g2 = frame.g2;
		
		locationRender.render( g );

		g2.begin(false);
		g2.color = Color.White;
		g2.opacity = 1;
		g2.font = font;
		g2.color = Color.White;
		g2.drawString("FPS = " + fps.fps, 300, 300);
		g2.end();
		
		fps.calcFrames();
		
		
    }
}
