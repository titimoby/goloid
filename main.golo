module goloid

import gololang.Adapters

import goloid.keys
import  goloid.application

import com.badlogic.gdx.backends.lwjgl.LwjglApplication
import com.badlogic.gdx.backends.lwjgl.LwjglApplicationConfiguration

function main = |args| {
  let GAME_WIDTH = 1024
  let GAME_HEIGHT = 768
  let PIXELS_TO_METERS = 100_F

  let goloidApp = createAppListener(PIXELS_TO_METERS): newInstance()

  let cfg = LwjglApplicationConfiguration()
  cfg: title("Goloid")
  cfg: useGL30(false)
  cfg: width(GAME_WIDTH)
  cfg: height(GAME_HEIGHT)

  let lwjglApp = LwjglApplication(goloidApp, cfg)
}
