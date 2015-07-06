module goloid.application

import gololang.Adapters

import goloid.keys

import java.lang.Math
import com.badlogic.gdx.ApplicationListener
import com.badlogic.gdx.Gdx
import com.badlogic.gdx.graphics.Color
import com.badlogic.gdx.graphics.GL30
import com.badlogic.gdx.graphics.g2d.SpriteBatch
import com.badlogic.gdx.graphics.Texture
import com.badlogic.gdx.graphics.g2d.Sprite
import com.badlogic.gdx.graphics.OrthographicCamera
import com.badlogic.gdx.math.Vector2
import com.badlogic.gdx.physics.box2d

let PIXELS_TO_METERS = 100_F

struct AppListener = { batch, texture, sprite, world, body, camera }
augment AppListener {
  function create = |this| {
    # create player sprite
    this: batch(SpriteBatch())
    this: texture(Texture(Gdx.files(): internal("data/player.png")))
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
      (this: sprite(): getX() + this: sprite(): getWidth()/2) / PIXELS_TO_METERS,
      (this: sprite(): getY() + this: sprite(): getHeight()/2) / PIXELS_TO_METERS)
    this: body(this: world(): createBody(bodyDef))

    let shape = PolygonShape()
    shape: setAsBox(this: sprite(): getWidth()/2 / PIXELS_TO_METERS,
      this: sprite(): getHeight()/2 / PIXELS_TO_METERS)

    let fixtureDef = FixtureDef()
    fixtureDef: shape(shape)
    fixtureDef: density( 0.1_F)

    this: body(): createFixture(fixtureDef)
    shape: dispose()

    # create input management object
    let inputProc = createInputProc(this: body()): newInstance()
    # set the input management
    Gdx.input(): setInputProcessor(inputProc)

    this: camera( OrthographicCamera(1_F*width, 1_F*height ))
  }

  function dispose = |this| {
    this: batch(): dispose()
    this: texture(): dispose()
  }

  function render = |this| {
    this: camera(): update()
    # Step the physics simulation forward at a rate of 60hz
    this: world(): step(1_F/60_F, 6, 2)

    Gdx.gl(): glClearColor(1, 1, 1, 1)
    Gdx.gl(): glClear(GL30.GL_COLOR_BUFFER_BIT())

    # Set the sprite's position from the updated physics body location
    this: sprite(): setPosition(
      (this: body(): getPosition(): x() * PIXELS_TO_METERS)
          - this: sprite(): getWidth()/2 ,
      (this: body(): getPosition(): y() * PIXELS_TO_METERS)
          - this: sprite(): getHeight()/2 )

    # Ditto for rotation
    this: sprite(): setRotation(floatValue(toDegrees(doubleValue(this: body(): getAngle()))) )

    this: batch(): begin()
    this: sprite(): draw(this: batch())
    this: batch(): end()
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

function createAppListener = {
    let delegate = AppListener()
    return Adapter()
    : interfaces(["com.badlogic.gdx.ApplicationListener"])
    : implements("create", |this| { return delegate: create() })
    : implements("dispose", |this| { return delegate: dispose() })
    : implements("render", |this| { return delegate: render() })
    : implements("resize", |this, width, height| { return delegate: resize(width, height) })
    : implements("pause", |this| { return delegate: pause() })
    : implements("resume", |this| { return delegate: resume() })
}
