import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';

class ImageUtils{

  //Icons
  static const String appIcon ="assets/icons/app_icon.png";
  static const String splashIcon ="assets/icons/SQUCH.svg";
  static const String loginTopLogo ="assets/icons/login_top_logo.svg";
  static const String homeOutline ="assets/icons/home_outline.svg";
  static const String homeFilled ="assets/icons/home_outline.svg";
  static const String activityOutline ="assets/icons/activity_outline.svg";
  static const String activityFilled ="assets/icons/activity_outline.svg";
  static const String inboxOutline ="assets/icons/inbox_outline.svg";
  static const String inboxFilled ="assets/icons/inbox_outline.svg";
  static const String walletOutline ="assets/icons/wallet_outline.svg";
  static const String walletFilled ="assets/icons/wallet_outline.svg";
  static const String profileOutline ="assets/icons/profile_outline.svg";
  static const String profileFilled ="assets/icons/profile_outline.svg";
  static const String closeCircle ="assets/icons/close-circle.png";

  static const String notificationOutline ="assets/icons/notification.svg";
  static const String microphone ="assets/icons/microphone.svg";

  static const String topup ="assets/icons/topup.svg";
  static const String request ="assets/icons/request_arrow.svg";
  static const String pay ="assets/icons/pay_arrow.svg";
  static const String rewards ="assets/icons/rewards.svg";
  static const String more ="assets/icons/more.svg";
  static const String loudSpeaker ="assets/icons/loud_speaker.svg";
  static const String rightArrow ="assets/icons/right_arrow.svg";
  static const String heartOutline ="assets/icons/heart.svg";
  static const String star ="assets/icons/star.svg";
  static const String sourceLocationIcon ="assets/icons/source_location_circle.svg";
  static const String destinationLocationIcon ="assets/icons/pin 1.svg";
  static const String clock ="assets/icons/clock.svg";
  static const String recaptcha ="assets/icons/recaptcha.png";
  static const String howToUse ="assets/icons/how_to_use.svg";
  static const String cancelBy ="assets/icons/credit_by_driver.svg";
  static const String close ="assets/icons/close 1.png";
  static const String add ="assets/icons/add.svg";
  static const String cash ="assets/icons/cash.png";
  static const String carWaitingTime ="assets/icons/car_waiting_time.png";
  static const String startPoint ="assets/icons/start_point.svg";
  static const String endPoint ="assets/icons/end_point.svg";
  static const String verticalLine ="assets/icons/verticalLine.png";
  static const String dollar ="assets/icons/dollar-circle.svg";
  static const String confirmRide ="assets/icons/confirm_ride_tick.svg";
  static const String silent ="assets/icons/call-slash.svg";
  static const String driver_not_at_pickup ="assets/icons/profile-delete.svg";
  static const String driver_ask_me_cancel ="assets/icons/profile-circle.svg";
  static const String driver_wrong_side ="assets/icons/two-arrow 1.svg";
  static const String driver_early ="assets/icons/car.svg";
  static const String other_reason ="assets/icons/other.svg";
  static const String locationMarkerIcon ="assets/icons/location_marker_icon.png";
  static const String downArrow ="assets/icons/Backward.svg";

  static const String selfie ="assets/icons/selfie.svg";
  static const String camera ="assets/icons/camera.svg";
  static const String idProof ="assets/icons/id_proof.svg";
  static const String personal_details ="assets/icons/personal_details.svg";
  static const String carDetails ="assets/icons/car_small_icon.svg";
  static const String insuranceDetails ="assets/icons/note.svg";
  static const String bankDetails ="assets/icons/bank.svg";

  static const String verified ="assets/icons/verified.svg";
  static const String pending ="assets/icons/pending.svg";

  static const String call ="assets/icons/call.svg";
  static const String msgText ="assets/icons/message-text.svg";
  static const String phone ="assets/icons/phone-receiver.svg";
  static const String apple ="assets/icons/apple.svg";
  static const String facebook ="assets/icons/facebook.svg";
  static const String google ="assets/icons/google.svg";
  static const String source ="assets/icons/source_marker.svg";
  static const String destination ="assets/icons/destination_marker.svg";
  static const String resetPasswordSentLock ="assets/icons/reset_password_sent_lock.png";
  static const String visa ="assets/icons/Payment method icon.png";
  static const String wallet ="assets/icons/Payment method icon-2.png";
  static const String card ="assets/icons/Payment method icon-3.png";
  static const String starOutline ="assets/icons/Mask.png";
  static const String starFilled ="assets/icons/Mask-2.png";

  static const String carOnMap ="assets/icons/car_on_map.png";
  static const String pin ="assets/icons/pin.png";
  static const String mapPin ="assets/icons/map_pin.png";
  static const String pinBig ="assets/icons/pin_big.png";
  static const String upload ="assets/icons/upload 1.svg";

  static const String driverImg ="assets/icons/driver_img.svg";
  static const String sourceLocation ="assets/icons/source_location.svg";
  static const String destinationLocation ="assets/icons/destination_icon.svg";
  static const String line ="assets/icons/Line 400.svg";

  static const String msg ="assets/icons/message.svg";
  static const String passenger ="assets/icons/passenger.svg";


  //Background Images
  static const String landing ="assets/backgrounds/6.png";
  static const String introScreenOne ="assets/backgrounds/1.png";
  static const String introScreenTwo ="assets/backgrounds/2.png";
  static const String introScreenThree ="assets/backgrounds/3.png";
  static const String introScreenFour ="assets/backgrounds/4.png";
  static const String introScreenFive ="assets/backgrounds/5.png";
  static const String send ="assets/icons/send.svg";
  static const String sendStraight ="assets/icons/send_straight.svg";


  static const String buyAndSell ="assets/backgrounds/buy_and_sell.png";
  static const String events ="assets/backgrounds/events.png";
  static const String foods ="assets/backgrounds/foods.png";
  static const String grocery ="assets/backgrounds/grocery.png";
  static const String stay ="assets/backgrounds/stay.png";
  static const String ride ="assets/backgrounds/ride.png";
  static const String recomentedResturent ="assets/backgrounds/Rectangle 164774.png";
  static const String loginBackTop ="assets/backgrounds/login_top.png";



  //Images
  static const String shopDailyDealsItem ="assets/images/image 17.png";
  static const String shopDailyDealsLogo ="assets/images/image 18.png";
  static const String topDestination ="assets/images/top_destination_item.png";
  static const String dealsOnGroceryItem ="assets/images/deals_on_grocery_item.png";
  static const String car ="assets/images/car.png";
  static const String eventItem ="assets/images/event_item.png";
  static const String cancelByDriverImage ="assets/images/Rectangle 45.png";
  static const String confirmBookinhBottomsheetIcon ="assets/images/wepik-export-20231018081538JKRK 2.png";


  //Type selection page card images
  static const String typeSelectionTopCardIcon ="assets/icons/type_selection_disabled_image.svg";
  static const String typeSelectionBottomCardIcon ="assets/icons/type_selection_enabled_image.svg";
  static const String typeSelectionIsSelectedIcon ="assets/icons/tick_mark_icon.svg";
  static const String driverOnline ="assets/icons/driver_online.svg";
  static const String driverOffline ="assets/icons/driver_offline.svg";

  static const String driverLoader ="assets/icons/driver_loader.svg";
  static const String shareIcon ="assets/icons/share.svg";
  static const String shieldIcon ="assets/icons/shield.svg";
  static const String logoutIcon ="assets/icons/logout.svg";
  static const String cancelIcon ="assets/icons/cancel.svg";
  static const String thumbsUp ="assets/icons/thumbs_up.svg";
  static const String loadingImage ="assets/icons/loader_image.gif";
  static const String appbarTopLogo ="assets/icons/squch_login_top_logo.svg";
  static const String carImage4xAtBiddingCard ="assets/icons/car_image_4x.png";
  static const String splashBackgroundImage ="assets/backgrounds/splash_background.png";
  static const String splashBackgroundTextImage ="assets/backgrounds/squch_splash_text_logo.svg";
  static const String stoppageMarker ="assets/icons/stoppage_marker.png";




}
Future<Uint8List> getBytesFromAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
}