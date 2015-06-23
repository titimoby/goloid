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

struct tipStruct = {
  value
}

function appListener = |adapter| {
  let batch = tipStruct(1)
  let font = tipStruct(1)
  adapter: interfaces(["com.badlogic.gdx.ApplicationListener"])
  : implements("create", |this| {
      batch: value(SpriteBatch())
      font: value(BitmapFont())
      font: value(): setColor(Color.RED())
  })
  : implements("dispose", |this| {
      batch: value(): dispose()
      font: value(): dispose()
    }
  )
  : implements("render", |this| {
      Gdx.gl(): glClearColor(1, 1, 1, 1)
      Gdx.gl(): glClear(GL30.GL_COLOR_BUFFER_BIT())

      batch: value(): begin()
      font: value(): draw(batch: value(), "Hello World", 200, 200)
      batch: value(): end()
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
  return adapter
}

function main = |args| {
  println("start")

  let helloworld = appListener(Adapter()): newInstance()

  let cfg = LwjglApplicationConfiguration()
  cfg: title("hello-world")
  cfg: useGL30(false)
  cfg: width(480)
  cfg: height(320)

  let lwjglApp = LwjglApplication(helloworld, cfg)
}
