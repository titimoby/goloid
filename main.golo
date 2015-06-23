module goloid

import gololang.Adapters
import com.badlogic.gdx.backends.lwjgl.LwjglApplication
import com.badlogic.gdx.backends.lwjgl.LwjglApplicationConfiguration
import com.badlogic.gdx.ApplicationListener
import com.badlogic.gdx.Gdx
import com.badlogic.gdx.graphics.Color
import com.badlogic.gdx.graphics.GL30
import com.badlogic.gdx.graphics.g2d.BitmapFont
import com.badlogic.gdx.graphics.g2d.SpriteBatch



struct AppListener = { batch, font }
augment AppListener {
  function create = |this| {
    this: batch(SpriteBatch())
    this: font(BitmapFont())
    this: font(): setColor(Color.RED())
  }

  function dispose = |this| {
    this: batch(): dispose()
    this: font(): dispose()
  }

  function render = |this| {
    Gdx.gl(): glClearColor(1, 1, 1, 1)
    Gdx.gl(): glClear(GL30.GL_COLOR_BUFFER_BIT())

    this: batch(): begin()
    this: font(): draw(this: batch(), "Hello World", 200, 200)
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
  cfg: width(480)
  cfg: height(320)

  let lwjglApp = LwjglApplication(helloworld, cfg)
}
