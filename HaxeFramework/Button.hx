


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

class Button
{
	
	
	public var actor : Actor;
	public var isDisabled = false;
	public var isHidden = false;
	public var data = 0;
	public static var buttonActor : ActorType = null;
	
	public function markAsGrayed(){
		isDisabled = true;
		actor.setFilter([createSaturationFilter(0)]);
	}
	
	public function unmarkAsGrayed(){
		isDisabled = false;
		actor.clearFilters();
	}
	
	public function new(actorType : ActorType, layer : String){
		actor = createRecycledActorOnLayer(actorType, 0, 0, 1, layer);
		actor.anchorToScreen();
	}
	
	public inline function disable(){
		isDisabled = true;
	}
	
	public inline function enable(){
		isDisabled = false;
	}
	
	public inline function setX(x : Float){
		actor.setX(x);
	}
	public inline function setY(y : Float){
		actor.setY(y);
	}
	
	public inline function setTop(amount : Float){
		actor.setY(amount);
	}
	
	public inline function setBottom(amount : Float){
		actor.setY(getScreenHeight() - amount);
	}
	
	public inline function setLeft(amount : Float){
		actor.setX(amount);
	}
	
	public inline function setRight(amount : Float){
		actor.setX(getScreenWidth() - amount);
	}

	public inline function setXScreen(x : Float){
		setX(getScreenX() + x);
	}

	public inline function setYScreen(y : Float){
		setY(getScreenY() + y);
	}
	
	public function getX(){
		return actor.getX();
	}
	
	public function getY(){
		return actor.getY();
	}
	
	public function setAnimation(s : String){
		actor.setAnimation(s);
	}
	
	public function addOnClickListener(doThis : Void -> Void){
		UserInterface.ui.addMouseOverActorListener(actor, function(mouseState:Int, list:Array<Dynamic>):Void{
			if(isDisabled || isHidden) return;
			if(3 == mouseState){doThis();}});
	}
	
	public function show(){
		isHidden = false;
		actor.enableActorDrawing();
	}
	
	public function hide(){
		isHidden = true;
		actor.disableActorDrawing();
	}
	
	public function moveTo(x : Float, y : Float, seconds : Float){
		actor.moveTo(x, y, seconds, Linear.easeNone);
	}
	
	public static function createSpellButton(spellName : String){
		var a = new Button(ActorTypes.spellButton(), "Spell Buttons");
		a.setAnimation(spellName);
		return a;
	}
	
	public static function createUIElement(animationName : String){
		if(buttonActor == null){
			buttonActor = getActorTypeByName("UIElement");
		}
		var an = "";
		if(animationName == null){
			an = "Animation 0";
		} else {
			an = animationName;
		}
		var a = new Button(buttonActor, "UI");
		a.setAnimation(animationName);
		return a;
	}
	
}



























