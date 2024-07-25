package com.bilditplatform.rnflybuylivestatus

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.Promise

class RnFlybuyLivestatusModule internal constructor(context: ReactApplicationContext) :
  RnFlybuyLivestatusSpec(context) {

  override fun getName(): String {
    return NAME
  }

  companion object {
    const val NAME = "RnFlybuyLivestatus"
  }
}
