import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizing/sizing.dart';
import 'package:squch_driver/features/chat_screen_features/presentation/widgets/chat_builder.dart';
import '../../../core/common/common_text_form_field.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_strings.dart';
import '../../../core/utils/fonts.dart';
import '../../../core/utils/image_utils.dart';
import '../../../core/utils/utils.dart';
import 'controller/chat_controller/chat_controller.dart';

class ChatScreen extends GetView<ChatController> {
  @override
  Widget build(BuildContext context) {
    print("abcd:${controller.messageList.length}");
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        controller.dashboardController.isNewMessageArrived.value = false;
      },
      child: Scaffold(
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(4.0),
            child: Container(
              color: Color(0xFFF4F4F4),
              height: 1.0,
            ),
          ),
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          leading: InkWell(
            onTap: () {
              Get.back();
              controller.dashboardController.isNewMessageArrived.value = false;
            },
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 14,
            ),
          ),
          title: Obx(
            () => Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.colorWhite,
                  maxRadius: 15,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: CachedNetworkImage(
                      imageUrl:
                          "${controller.dashboardController.currentTrip.value?.customer?.profileImage}",
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                  Colors.red, BlendMode.colorBurn)),
                        ),
                      ),
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ),
                Container(
                  width: 10.ss,
                ),
                Text(
                  "${controller.dashboardController.currentTrip.value?.customer?.firstName} ${controller.dashboardController.currentTrip.value?.customer?.lastName}",
                  style: CustomTextStyle(
                      fontSize: 16.ss, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          actions: [
            InkWell(
                onTap: () {
                  openDialPad(controller.dashboardController.currentTrip.value
                          ?.customer?.mobile ??
                      "");
                },
                child: Container(
                  height: 30.ss,
                  width: 30.ss,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: AppColors.callButtonBackground.withOpacity(0.2)),
                  child: Center(
                      child: Icon(
                    Icons.call_outlined,
                    size: 14,
                  )),
                )),
            Container(
              width: 20.ss,
            )
          ],
        ),
        body: Obx(
          () => controller.isLoadingAllMessages.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView(
                        controller: controller.scrollController,
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        children: [
                          Container(
                            height: 10.ss,
                          ),
                          Center(
                              child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15.ss, vertical: 2.ss),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: AppColors.borderRadiusColor)),
                            child: Text(
                              "TODAY",
                              style: CustomTextStyle(
                                  fontSize: 12.fss,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.chatDayTextColor),
                            ),
                          )),
                          Center(
                              child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 20.ss, vertical: 8.ss),
                            padding: EdgeInsets.symmetric(
                                horizontal: 30.ss, vertical: 8.ss),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: AppColors.borderRadiusColor)),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.lock,
                                  color: AppColors.colorBlack,
                                  size: 14,
                                ),
                                Container(
                                  width: 10.ss,
                                ),
                                Expanded(
                                  child: Text(
                                    "Messages and calls are secure & encrypted. Screenshots will be disabled during this chat.",
                                    style: CustomTextStyle(
                                        fontSize: 12.fss,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.chatDayTextColor),
                                  ),
                                ),
                              ],
                            ),
                          )),
                          ListView.builder(
                              physics: ClampingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: controller.messageList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ChatBuilder(
                                  message:
                                      controller.messageList[index].message,
                                  senderType:
                                      controller.messageList[index].senderType,
                                );
                              }),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0.ss, horizontal: 12.ss),
                      child: Row(children: [
                        Flexible(
                          child: CommonTextFormField(
                            maxLine: 3,
                            maxLength: 200,
                            padding: 0,
                            margin: 0,
                            onTap: () {
                              // controller.messageList
                            },
                            controller: controller.chatMessageController,
                            readOnly: false,
                            fillColor: AppColors.colorgrey.withOpacity(0.5),
                            decoration: InputDecoration(
                                counterText: "",
                                border: InputBorder.none,
                                filled: true,
                                fillColor: AppColors.colorlightgrey2,
                                hintText: AppStrings.anyPickupNotes.tr,
                                hintStyle: CustomTextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.fss)),
                          ),
                        ),
                        Container(
                          width: 10.ss,
                        ),
                        Obx(
                          () => controller.isLoading.value
                              ? const CircularProgressIndicator()
                              : InkWell(
                                  onTap: controller.chatSendOption.isFalse
                                      ? null
                                      : () {
                                          controller
                                              .dashboardController
                                              .isNewMessageArrived
                                              .value = false;
                                          controller.sendMessages();
                                          //controller.fetchMessages();
                                        },
                                  child: Container(
                                    height: 40.ss,
                                    width: 40.ss,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.ss)),
                                        color: AppColors.colorlightgrey2),
                                    child: Center(
                                        child: SvgPicture.asset(
                                      ImageUtils.sendStraight,
                                      color: controller.chatSendOption.isTrue
                                          ? AppColors.buttonColor
                                          : AppColors.callButtonBackground,
                                    )),
                                  ),
                                ),
                        ),
                      ]),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
