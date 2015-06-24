module goloid

import gololang.Adapters
import com.badlogic.gdx.backends.lwjgl.LwjglApplication
import com.badlogic.gdx.backends.lwjgl.LwjglApplicationConfiguration
import com.badlogic.gdx.ApplicationListener
import com.badlogic.gdx.Gdx
import com.badlogic.gdx.graphics.Color
import com.badlogic.gdx.graphics.GL30
import com.badlogic.gdx.graphics.g2d.SpriteBatch
import com.badlogic.gdx.graphics.Texture
import com.badlogic.gdx.graphics.g2d.Sprite
import com.badlogic.gdx.Input
import com.badlogic.gdx.Input.Keys

struct AppListener = { batch, texture, sprite }
augment AppListener {
  function create = |this| {
    this: batch(SpriteBatch())
    this: texture(Texture(Gdx.files(): internal("data/player.png")))
    this: sprite(Sprite(this: texture()))
    let w = Gdx.graphics(): getWidth()
    let h = Gdx.graphics(): getHeight()
    this: sprite(): setPosition(w/2 - this: sprite(): getWidth()/2, h/2 - this: sprite(): getHeight()/2)
  }

  function dispose = |this| {
    this: batch(): dispose()
    this: texture(): dispose()
  }

  function render = |this| {
    Gdx.gl(): glClearColor(1, 1, 1, 1)
    Gdx.gl(): glClear(GL30.GL_COLOR_BUFFER_BIT())

    let leftKey =  com.badlogic.gdx.Input.Keys.LEFT()

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
    return Adapter(): interfaces(["com.badlogic.gdx.ApplicationListener"])
    : implements("create", |this| { delegate: create() })
    : implements("dispose", |this| { delegate: dispose() })
    : implements("render", |this| { delegate: render() })
    : implements("resize", |this, width, height| { delegate: resize(width, height) })
    : implements("pause", |this| { delegate: pause() })
    : implements("resume", |this| { delegate: resume() })
}

function main = |args| {
  println("start")

  let helloworld = createAppListener(): newInstance()

  let cfg = LwjglApplicationConfiguration()
  cfg: title("hello-world")
  cfg: useGL30(false)
  cfg: width(800)
  cfg: height(600)

  let lwjglApp = LwjglApplication(helloworld, cfg)
}
