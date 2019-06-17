


import com.stencyl.graphics.G;
import com.stencyl.graphics.BitmapWrapper;

import com.stencyl.behavior.Script;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.ActorScript;
import com.stencyl.behavior.SceneScript;
import com.stencyl.behavior.TimedTask;

import com.stencyl.models.Actor;
import com.stencyl.models.GameModel;
import com.stencyl.models.actor.Animation;
import com.stencyl.models.actor.ActorType;
import com.stencyl.models.actor.Collision;
import com.stencyl.models.actor.Group;
import com.stencyl.models.Scene;
import com.stencyl.models.Sound;
import com.stencyl.models.Region;
import com.stencyl.models.Font;
import com.stencyl.models.Joystick;

import com.stencyl.Engine;
import com.stencyl.Input;
import com.stencyl.Key;
import com.stencyl.utils.Utils;

import openfl.ui.Mouse;
import openfl.display.Graphics;
import openfl.display.BlendMode;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.events.TouchEvent;
import openfl.net.URLLoader;

import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2Fixture;
import box2D.dynamics.joints.B2Joint;

import motion.Actuate;
import motion.easing.Back;
import motion.easing.Cubic;
import motion.easing.Elastic;
import motion.easing.Expo;
import motion.easing.Linear;
import motion.easing.Quad;
import motion.easing.Quart;
import motion.easing.Quint;
import motion.easing.Sine;

/*"
	.paddingLeft   = _
	.paddingRight  = _
	.paddingTop	   = _
	.paddingBottom = _
	.setPadding(_)			// sets all paddings
	
	.setBorderColor('FFFFFF')
	
	.addChild(UIComponent)
	
	
"*/

class UIPanel extends UIComponent
{
	
	public var children			: Array<UIComponent>;
	public var childrenByName	: Map<String, UIComponent>;
	
	public var paddingLeft	 = 0;
	public var paddingRight	 = 0;
	public var paddingTop	 = 0;
	public var paddingBottom = 0;
	
	public var hasBorder = false;
	private var borderColor = -1;	// ONLY set it with setBorderColor("FFFFFF")
	
	public function setBorderColor(c : String){
		borderColor = U.getColor(c);
		hasBorder = true;
	}
	
	private function drawBorder(g : G){			// Used in constructor
		if(hasBorder && borderColor != -1){
			g.strokeSize = 3;
			g.strokeColor = borderColor;
			g.drawRect(x, y, getWidth(), getHeight());
		}
	}
	
	public function new(name){
		super(name);
		children = [];
		childrenByName = new Map<String, UIComponent>();
		U.onDraw(function(g:G){
			drawBorder(g);
		});
	}
	
	public function setPadding(x){
		paddingBottom = x;
		paddingLeft = x;
		paddingRight = x;
		paddingTop = x;
	}
	
	public function addChild(child : UIComponent){
		if(child == null) return;
		children.push(child);
		childrenByName[child.name] = child;
		child.parent = this;
	}
	
	private function getFrame(){
		var myFrame = new Rectangle(
			x + paddingLeft,
			y + paddingTop,
			getWidth() - paddingLeft - paddingRight,
			getHeight() - paddingTop - paddingBottom
		);
		return myFrame;
	}

	
	public override function draw(?frame){
		setupCoordinates(frame);
		var myFrame = getFrame();
		for(i in 0...children.length){
			children[i].draw(myFrame);
		}
	}
	
	
}



























