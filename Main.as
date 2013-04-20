﻿package {	import flash.display.MovieClip;	import EuclideanVector;	import Sprite;	import bomb;	import flash.geom.Point;	import flash.events.Event;	import flash.events.KeyboardEvent;	import flash.events.MouseEvent;	import flash.display.StageScaleMode;	public class Main extends MovieClip {		var square:player = new player(new Point(0,200));		var tbomb1:bomb = new bomb(new Point(0,300));		var gravity:EuclideanVector = new EuclideanVector(new Point(0,1));		var isjumping:Boolean = false;		var isLeftdown:Boolean = false;		var isRightdown:Boolean = false;		var lastKeyCode:Number = 0;		var Velocity:Number = 2;		var MaxVel:Number = 15;		var world:Array = new Array();		public function Main() {			// constructor code			square.position = new EuclideanVector(new Point(0,200));			addChild(square);			world.push(square);			stage.addEventListener(KeyboardEvent.KEY_DOWN, moveSquare);			stage.addEventListener(KeyboardEvent.KEY_UP, moveSquare2);			stage.addEventListener(MouseEvent.MOUSE_DOWN, thowBomb);			addEventListener(Event.ENTER_FRAME,updateWorld);			stage.scaleMode = StageScaleMode.NO_BORDER;			addChild(tbomb1);			tbomb1.visible = false;		}		private function moveSquare(e:KeyboardEvent) {			switch (e.keyCode) {				case 37 :					if (!isLeftdown) {						square.gotoAndPlay("running");						square.scaleX = Math.abs(square.scaleX)* -1;					}					isLeftdown = true;					lastKeyCode = e.keyCode;										break;				case 38 :					if (!isjumping) {						square.gotoAndPlay("jump");						isjumping = true;						square.velocity.sum(new EuclideanVector(new Point(0,-10)));					}					break;				case 39 :					if (!isRightdown) {						square.gotoAndPlay("running");						square.scaleX = Math.abs(square.scaleX);					}					isRightdown = true;					lastKeyCode = e.keyCode;										break;				case 16 :					Velocity = 5;					MaxVel = 25;					break;			}		}		private function moveSquare2(e:KeyboardEvent) {			switch (e.keyCode) {				case 37 :					isLeftdown = false;					square.gotoAndPlay("normal");					if (! isjumping) {						square.velocity.position.x = 0;					}					break;				case 39 :					isRightdown = false;					square.gotoAndPlay("normal");					if (! isjumping) {						square.velocity.position.x = 0;					}					break;				case 16 :					Velocity = 2;					MaxVel = 15;					break;			}		}				private function thowBomb(e:MouseEvent) {			tbomb1.visible = true;			tbomb1.position = new EuclideanVector(new Point(square.position.position.x, square.position.position.y ));									var test:EuclideanVector = new EuclideanVector(new Point(  e.stageX , e.stageY ));			var offset:EuclideanVector = test.subtract(square.position);						offset.normalize();						offset.multiply(50);						tbomb1.velocity = offset;						trace(tbomb1.position.position.x + "-" + tbomb1.position.position.y);		}				private function updateWorld(e:Event):void {			var didTouch:Boolean = false;			if (square.hitTestObject(rock)) {				if (lastKeyCode == 39 				&& (square.y + square.height/2) > (rock.y - rock.height/2) ) {					square.velocity.position.x = Math.abs(square.velocity.position.x) * -1.2;					didTouch = true;				} else if (lastKeyCode == 37 				   &&  (square.y + square.height/2) >  (rock.y - rock.height/2) ) {					square.velocity.position.x = Math.abs(square.velocity.position.x) * 1.2;					didTouch = true;				}				if ((square.y + square.height/2) <=  (rock.y - rock.height/2) ) {					square.velocity.position.y = 0;					isjumping = false;				}			}			if (isLeftdown) {				if (square.velocity.position.x >=  -  MaxVel) {					square.velocity.sum(new EuclideanVector(new Point(-Velocity,0)));				}			}			if (isRightdown) {				if (square.velocity.position.x <= MaxVel) {					square.velocity.sum(new EuclideanVector(new Point(Velocity,0)));				}			}						if (square.velocity.position.x < 1 && square.velocity.position.x > -1 ) {				square.gotoAndPlay("normal");			}						if (square.hitTestObject(floor)) {				if (isjumping) {					square.gotoAndPlay("running");				}				isjumping = false;			}						for (var i:Number = 0; i < world.length; i++) {				if (world[i].hitTestObject(floor)) {					gravity = new EuclideanVector(new Point(0,0));					world[i].velocity.position.x = world[i].velocity.position.x * 0.9;					world[i].velocity.position.y = 0;															world[i].velocity.sum(gravity);				} else {					gravity = new EuclideanVector(new Point(0,1));					world[i].velocity.sum(gravity);				}			}			var posX:Number = square.x;			posX = stage.stageWidth / 2 - posX;			if (posX>0) {				posX = 0;			}			if (posX<-1000) {				posX = -1000;			}			trees.x = posX * 0.7;			clouds.x = posX * 0.5;			sky.x = posX * 0.2;			x = posX;		}	}}