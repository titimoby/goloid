module goloid.keys

import com.badlogic.gdx.Input.Buttons
import com.badlogic.gdx.Input$Keys
import com.badlogic.gdx.InputProcessor
import gololang.Adapters

struct InputProcFacade = {left, right, up}
augment InputProcFacade {
    function keyDown = |this, keycode| {
      var job = false
      if (keycode == UP()) {
        job = true
        this: up(true)
      }
      if (keycode == LEFT()) {
        job = true
        this: left(true)
      }
      if (keycode == RIGHT()) {
        job = true
        this: right(true)
      }
      return job
    }

    function keyUp = |this, keycode| {
      var job = false
      if (keycode == UP()) {
        job = true
        this: up(false)
      }
      if (keycode == LEFT()) {
        job = true
        this: left(false)
      }
      if (keycode == RIGHT()) {
        job = true
        this: right(false)
      }
      return job
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

function createInputProc = |delegate| {
  return Adapter()
  : interfaces(["com.badlogic.gdx.InputProcessor"])
  : implements("keyDown", |this, keycode| { return delegate: keyDown(keycode) })
  : implements("keyUp", |this, keycode| { return delegate: keyUp(keycode) })
  : implements("keyTyped", |this, character| { return delegate: keyTyped(character) })
  : implements("touchDown", |this, screenX, screenY, pointer, button| { return delegate: touchDown(screenX, screenY, pointer, button) })
  : implements("touchUp", |this, screenX, screenY, pointer, button| { return delegate: touchUp(screenX, screenY, pointer, button) })
  : implements("touchDragged", |this, screenX, screenY, pointer| { return delegate: touchDragged(screenX, screenY, pointer) })
  : implements("mouseMoved", |this, screenX, screenY| { return delegate: mouseMoved(screenX, screenY) })
  : implements("scrolled", |this, amount| { return delegate: scrolled(amount) })
}
