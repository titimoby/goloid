module goloid.application

import gololang.Adapters

import goloid.keys

import java.lang.Math
import java.util.ArrayList

import com.badlogic.gdx.ApplicationListener
import com.badlogic.gdx.Gdx
import com.badlogic.gdx.graphics.Color
import com.badlogic.gdx.graphics.GL20
import com.badlogic.gdx.graphics.g2d.SpriteBatch
import com.badlogic.gdx.graphics.Texture
import com.badlogic.gdx.graphics.g2d.Sprite
import com.badlogic.gdx.graphics.OrthographicCamera
import com.badlogic.gdx.math.Vector2
import com.badlogic.gdx.physics.box2d
import com.badlogic.gdx.graphics.glutils.ImmediateModeRenderer20
import com.badlogic.gdx.graphics.glutils
import com.badlogic.gdx.graphics.glutils.ShapeRenderer$ShapeType

struct propStruct = {debug, powerInc, maxVelocity, turnSpeed}
struct starField = {starsCoord, timer}

struct AppListener = { game_width, game_height, pixels_meters, batch, texture, sprite, world, body, camera, inputFacade, prop, stars }
augment AppListener {
  function create = |this| {
    # set the power increment
    this: prop(propStruct(0, 0.1_F, 10_F, 0.02_F))
    this: stars(starField(createStarsCoord(100, this: game_width(), this: game_height()), 0))
    # create input management object
    this: inputFacade(InputProcFacade(false, false, false))
    let inputProc = createInputProc(this: inputFacade()): newInstance()
    # set the input management
    Gdx.input(): setInputProcessor(inputProc)

    # create player sprite
    this: batch(SpriteBatch())
    this: texture(Texture(Gdx.files(): internal("data/player64x48.png")))
    this: sprite(Sprite(this: texture()))
    let width = Gdx.graphics(): getWidth()
    let height = Gdx.graphics(): getHeight()
    this: sprite(): setPosition(width/2 - this: sprite(): getWidth()/2, height/2 - this: sprite(): getHeight()/2)

    # Create a physics world, the heart of the simulation.
    # The Vector passed in is gravity (here, deep space ;))
    this: world( World(Vector2(0_F, 0_F), true) )

    let bodyDef = BodyDef()
    bodyDef: type( BodyDef$BodyType.DynamicBody() )
    bodyDef: position(): set(
      (this: sprite(): getX() + this: sprite(): getWidth()/2) / this: pixels_meters(),
      (this: sprite(): getY() + this: sprite(): getHeight()/2) / this: pixels_meters())
    this: body(this: world(): createBody(bodyDef))

    let shape = PolygonShape()
    shape: setAsBox(this: sprite(): getWidth()/2 / this: pixels_meters(),
      this: sprite(): getHeight()/2 / this: pixels_meters())

    let fixtureDef = FixtureDef()
    fixtureDef: shape(shape)
    fixtureDef: density( 0.1_F)

    this: body(): createFixture(fixtureDef)
    shape: dispose()

    this: camera( OrthographicCamera(1_F*width, 1_F*height ))
  }

  function dispose = |this| {
    this: batch(): dispose()
    this: texture(): dispose()
  }

  function render = |this| {
    # Step the physics simulation forward at a rate of 60hz
    this: world(): step(1_F/60_F, 6, 2)

    if (this: inputFacade(): left() == true) {
      this: body(): setTransform(this: body(): getPosition(), this: body(): getAngle()+this: prop(): turnSpeed())
    }
    if (this: inputFacade(): right() == true) {
        this: body(): setTransform(this: body(): getPosition(), this: body(): getAngle()-this: prop(): turnSpeed())
    }
    if (this: inputFacade(): up() == true) {
    #  let push = this: prop(): power() + this: prop(): powerInc()
      let desiredVx = floatValue(-1*this: prop(): powerInc()*sin(doubleValue(this: body(): getAngle())))
      let desiredVy = floatValue(this: prop(): powerInc()*cos(doubleValue(this: body(): getAngle())))

      let velocity =  this: body(): getLinearVelocity()
      let desiredVelocity = Vector2(velocity: x()+desiredVx, velocity: y()+desiredVy)
      #println("velocity "+velocity: x() + " "+ velocity: y())
      #println("desiredVelocity "+desiredVelocity: x() + " "+ desiredVelocity: y())

      desiredVelocity: limit(this: prop(): maxVelocity())
      let computedVelocity = (desiredVelocity: x()*desiredVelocity: x() + desiredVelocity: y()*desiredVelocity: y())
      let maxV = this: prop(): maxVelocity()

      if (computedVelocity <= maxV)  {
        this: body(): setLinearVelocity(desiredVelocity)
      }
    }
    this: camera(): update()

    Gdx.gl(): glClearColor(0, 0, 0, 1)
    Gdx.gl(): glClear(GL30.GL_COLOR_BUFFER_BIT())

    if (this: stars(): timer() < 60*3) {
      this: stars(): timer(this: stars(): timer()+1)
    } else {
      this: stars(): timer(0)
    }
    drawStarfield(this)
    # Set the sprite's position from the updated physics body location
    var bodyX = (this: body(): getPosition(): x()* this: pixels_meters()) - this: sprite(): getWidth()/2
    var bodyY = (this: body(): getPosition(): y()* this: pixels_meters()) - this: sprite(): getHeight()/2

    if (intValue(bodyX) > Gdx.graphics(): getWidth()) {
      bodyX = this: sprite(): getWidth()/2
      this: body(): setTransform(bodyX/this: pixels_meters(), this: body(): getPosition(): y(), this: body(): getAngle())
    } else if (bodyX < -1_F) {
      this: body(): setTransform(Gdx.graphics(): getWidth()/this: pixels_meters(), this: body(): getPosition(): y(), this: body(): getAngle())
      bodyX = Gdx.graphics(): getWidth()
    }
    if (intValue(bodyY) > Gdx.graphics(): getHeight()) {
      bodyY = this: sprite(): getHeight()/2
      this: body(): setTransform(this: body(): getPosition(): x(), bodyY/this: pixels_meters(), this: body(): getAngle())
    } else if (bodyY < -1_F) {
      this: body(): setTransform(this: body(): getPosition(): x(), Gdx.graphics(): getHeight()/this: pixels_meters(), this: body(): getAngle())
      bodyY = Gdx.graphics(): getHeight()
    }
    bodyX = (this: body(): getPosition(): x()* this: pixels_meters()) - this: sprite(): getWidth()/2
    bodyY = (this: body(): getPosition(): y()* this: pixels_meters()) - this: sprite(): getHeight()/2
    this: sprite(): setPosition(bodyX, bodyY)

    this: sprite(): setRotation(floatValue(toDegrees(doubleValue(this: body(): getAngle()))) )

    this: batch(): begin()
    this: sprite(): draw(this: batch())
    this: batch(): end()
  }

  function createStarsCoord = |nbStars, game_width, game_height| {
    let starsCoord = ArrayList()
    for (var i = 0, i < nbStars, i = i + 1) {
      starsCoord: add(Vector2(floatValue(random())*game_width, floatValue(random())*game_height))
    }
    return starsCoord
  }

  function drawStarfield = |this| {
    let renderer = ShapeRenderer()

    renderer: begin(Line())
    renderer: setColor(WHITE())
    foreach star in this: stars(): starsCoord() {
      renderer: line(star: x(), star: y(), star: x(), star: y()+1)
    }

    renderer: end()
  }

  function resize = |this, width, height| {
    println("resize to implement")
  }
  function pause = |this| {
    println("pause to implement")
  }
  function resume = |this| {
    println("resume to implement")
  }
}

function createAppListener = |game_width, game_height, pixels_meters| {
    let delegate = AppListener(game_width, game_height, pixels_meters, 0, 0, 0, 0, 0, 0, 0, 0, 0)
    return Adapter()
    : interfaces(["com.badlogic.gdx.ApplicationListener"])
    : implements("create", |this| { return delegate: create() })
    : implements("dispose", |this| { return delegate: dispose() })
    : implements("render", |this| { return delegate: render() })
    : implements("resize", |this, width, height| { return delegate: resize(width, height) })
    : implements("pause", |this| { return delegate: pause() })
    : implements("resume", |this| { return delegate: resume() })
}
