


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
	
	--- ALL UI CLASSES REQUIRE:
			U.hx
			Style.hx
			Rectangle.hx
			eachother
			
	API:
		.left   = _
		.right  = _
		.top    = _
		.bottom = _
		.setWidth(_)		// In pixels
		.setHeight(_)		// In pixels
	
	So, this is how the ui will be done:
	1. Create the hierarchy of components, with their own data and stuff
	2. root.draw() draws the whole view again

"*/

class UIComponent
{
	
	public var parent : UIPanel;
	public var name = "";
	public var x : Float = 0;	// Actual x on screen          these are not used when building the UI
	public var y : Float = 0;	// Actual y on screen          these are not used when building the UI
	
	public var left		= 0;                        // but these are used
	public var right	= 0;                        // but these are used
	public var top		= 0;                        // but these are used
	public var bottom	= 0;                        // but these are used
	private var width  : Float = 0;                  // ONLY use getters and setters for these
	private var height : Float = 0;                  // ONLY use getters and setters for these
	public var inheritsWidth  = true;	// The w of the parent will be used instead of its own
	public var inheritsHeight = true;	// The h of the parent will be used instead of its own
	public var isShown = true;
	
	public function new(n, ?_parent){
		name = n;
		parent = _parent;
	}
	
	public function hide(){
		if(isShown) isShown = false;
	}
	public function show(){
		if(!isShown) isShown = true;
	}
	
	public function setWidth(w){
		width = w;
		inheritsWidth = false;
	}
	
	public function setHeight(h){
		height = h;
		inheritsHeight = false;
	}
	
	public function getWidth() : Float{
		if(inheritsWidth){
			if(parent == null)
				return getScreenWidth();
			else {
				return parent.getWidth() - parent.paddingLeft - parent.paddingRight;
			}
		} else {
			return width;
		}
	}
	public function getHeight() : Float{
		if(inheritsHeight){
			if(parent == null)
				return getScreenHeight();
			else {
				return parent.getHeight() - parent.paddingTop - parent.paddingBottom;
			}
		} else {
			return height;
		}
	}
	
	public function setupCoordinates(?frame){
		if(frame == null || parent == null) frame = new Rectangle(0, 0, getScreenWidth(), getScreenHeight());
		if(bottom == 0){
			y = frame.y + top;
		} else {
			y = frame.y + frame.height - getHeight() - bottom;
		}
		if(right == 0){
			x = frame.x + left;
		} else {
			x = frame.x + frame.width - getWidth() - right;
		}
	
		trace("Setup coordinates for " + name);
		trace(x + ", " + y);
	}

	public function draw(?frame){
		setupCoordinates(frame);
	}
	
	
}



























