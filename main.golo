module goloid

import gololang.Adapters

import goloid.keys
import  goloid.application

import com.badlogic.gdx.backends.lwjgl.LwjglApplication
import com.badlogic.gdx.backends.lwjgl.LwjglApplicationConfiguration

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
