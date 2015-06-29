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
import com.badlogic.gdx.Input.Buttons
import com.badlogic.gdx.Input.Keys
import com.badlogic.gdx.InputProcessor

struct InputProcFacade = {key}
augment InputProcFacade {
    function keyDown = |this, keycode| {
      return false
    }
    function keyUp = |this, keycode| {
      return false
    }
    function keyTyped = |this, character| {
      return false
    }
    function touchDown = |this, screenX, screenY, pointer, button| {
      return false
    }
    function touchUp = |this, screenX, screenY, pointer, button| {
      return false
    }
    function touchDragged = |this, screenX, screenY, pointer| {
      return false
    }
    function mouseMoved = |this, screenX, screenY| {
      return false
    }
    function scrolled = |this, amount| {
      return false
    }
}

struct AppListener = { batch, texture, sprite }
augment AppListener {
  function create = |this| {
    let inputProc = createInputProc(): newInstance()
    this: batch(SpriteBatch())
    this: texture(Texture(Gdx.files(): internal("data/player.png")))
    this: sprite(Sprite(this: texture()))
    let w = Gdx.graphics(): getWidth()
    let h = Gdx.graphics(): getHeight()
    this: sprite(): setPosition(w/2 - this: sprite(): getWidth()/2, h/2 - this: sprite(): getHeight()/2)
    Gdx.input(): setInputProcessor(inputProc)
  }

  function dispose = |this| {
    this: batch(): dispose()
    this: texture(): dispose()
  }

  function render = |this| {
    Gdx.gl(): glClearColor(1, 1, 1, 1)
    Gdx.gl(): glClear(GL30.GL_COLOR_BUFFER_BIT())

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

function createInputProc = {
  let delegate = InputProcFacade()
  return Adapter()
  : interfaces(["com.badlogic.gdx.InputProcessor"])
  : implements("keyDown", |this, keycode| { delegate: keyDown(keycode) })
  : implements("keyUp", |this, keycode| { delegate: keyUp(keycode) })
  : implements("keyTyped", |this, character| { delegate: keyTyped(character) })
  : implements("touchDown", |this, screenX, screenY, pointer, button| { delegate: touchDown(screenX, screenY, pointer, button) })
  : implements("touchUp", |this, screenX, screenY, pointer, button| { delegate: touchUp(screenX, screenY, pointer, button) })
  : implements("touchDragged", |this, screenX, screenY, pointer| { delegate: touchDragged(screenX, screenY, pointer) })
  : implements("mouseMoved", |this, screenX, screenY| { delegate: mouseMoved(screenX, screenY) })
  : implements("scrolled", |this, amount| { delegate: scrolled(amount) })
}
function createAppListener = {
    let delegate = AppListener()
    return Adapter()
    : interfaces(["com.badlogic.gdx.ApplicationListener"])
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
