package com.bilditplatform.rnflybuycore

import android.os.Build
import androidx.annotation.RequiresApi
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.bridge.ReadableMapKeySetIterator
import com.facebook.react.bridge.ReadableType
import com.radiusnetworks.flybuy.sdk.data.customer.CustomerInfo
import com.radiusnetworks.flybuy.sdk.data.location.CircularRegion
import com.radiusnetworks.flybuy.sdk.data.room.domain.PickupWindow
import java.time.Instant


fun decodeData(data: ReadableMap): Map<String, String> {
  var dataMap = mapOf<String, String>()
  val iterator: ReadableMapKeySetIterator = data.keySetIterator()
  while (iterator.hasNextKey()) {
    val key = iterator.nextKey()
    val type: ReadableType = data.getType(key)
    when (type) {
      ReadableType.String -> dataMap += Pair(key, data.getString(key)!!)
      else -> throw IllegalArgumentException("Could not convert object with key: $key.")
    }
  }
  return dataMap
}


fun decodeCustomerInfo(customer: ReadableMap): CustomerInfo {
  var name = ""
  var carType = ""
  var carColor = ""
  var licensePlate = ""
  var phone = ""


  if (customer.hasKey("name")) {
    name = customer.getString("name")!!
  }
  if (customer.hasKey("carType")) {
    carType = customer.getString("carType")!!
  }
  if (customer.hasKey("carColor")) {
    carColor = customer.getString("carColor")!!
  }
  if (customer.hasKey("phone")) {
    phone = customer.getString("phone")!!
  }
  if (customer.hasKey("licensePlate")) {
    licensePlate = customer.getString("licensePlate")!!
  }

  return CustomerInfo(
    name = name,
    carType = carType,
    carColor = carColor,
    licensePlate = licensePlate,
    phone = phone
  )
}

fun decodeRegion(region: ReadableMap): CircularRegion {
  var latitude = region.getDouble("latitude")!!
  var longitude = region.getDouble("longitude")!!
  var radius = region.getInt("radius").toFloat()

  return CircularRegion(
    latitude = latitude,
    longitude = longitude,
    radius = radius
  )
}


@RequiresApi(Build.VERSION_CODES.O)
fun decodePickupWindow(pickupWindow: ReadableMap): PickupWindow {
  val instantStart = Instant.parse(pickupWindow.getString("start")!!)
  val instantEnd = Instant.parse(pickupWindow.getString("end")!!)
  return PickupWindow(
    start = instantStart,
    end = instantEnd
  )
}

