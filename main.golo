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

function main = |args| {
  println("start")

  let conf = Adapter()
  conf: interfaces(["com.badlogic.gdx.ApplicationListener"])
  : implements("create", |this| {
      #var batch = SpriteBatch()
      #var font = BitmapFont()
      #font: setColor(Color.RED())
  })
  : implements("dispose", |this| {
      #batch: dispose()
      #font: dispose()
    }
  )
  : implements("render", |this| {
      #horrorrrrrr
      var batch = SpriteBatch()
      var font = BitmapFont()
      font: setColor(Color.RED())
      #back to normal
      Gdx.gl(): glClearColor(1, 1, 1, 1)
      Gdx.gl(): glClear(GL30.GL_COLOR_BUFFER_BIT())

      batch: begin()
      font: draw(batch, "Hello World", 200, 200)
      batch: end()
    }
  )
  : implements("resize", |this, width, height| {
      println("resize to implement")
    }
  )
  : implements("pause", |this| {
      println("pause to implement")
    }
  )
  : implements("resume", |this| {
      println("resume to implement")
    }
  )

  let helloworld = conf: newInstance()

  let cfg = LwjglApplicationConfiguration()
  cfg: title("hello-world")
  cfg: useGL30(false)
  cfg: width(480)
  cfg: height(320)

  let lwjglApp = LwjglApplication(helloworld, cfg)
}
