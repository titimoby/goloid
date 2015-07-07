module goloid.keys

import com.badlogic.gdx.Input.Buttons
import com.badlogic.gdx.Input$Keys
import com.badlogic.gdx.InputProcessor
import gololang.Adapters

struct InputProcFacade = {left, right, up}
augment InputProcFacade {
    function keyDown = |this, keycode| {
      case {
        when (keycode == UP()) {
          this: up(true)
        }
        when (keycode == LEFT()) {
          this: left(true)
        }
        when (keycode == RIGHT()) {
          this: right(true)
        }
        otherwise {
          return false
        }
      }
      return true
    }
    function keyUp = |this, keycode| {
      case {
        when (keycode == UP()) {
          this: up(false)
        }
        when (keycode == LEFT()) {
          this: left(false)
        }
        when (keycode == RIGHT()) {
          this: right(false)
        }
        otherwise {
          return false
        }
      }
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
