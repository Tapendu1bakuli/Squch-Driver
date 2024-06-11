import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizing/sizing.dart';
import 'package:squch_driver/common/widget/time_line.dart';
import 'package:squch_driver/core/utils/app_colors.dart';
import 'package:squch_driver/core/utils/app_strings.dart';
import '../../../core/utils/fonts.dart';
import '../../../core/widgets/horizontal_gap.dart';
import '../../map_page_feature/data/models/address_model.dart';

const kTileHeight = 60.0;

class ShareRideRouteWidget extends StatelessWidget {
  Address? source;
  Address? destination;
  List<Address>? multiStop;
  bool? enableDone;
  bool? isLoading;
  Function(int index)? onDone;
  EdgeInsets? padding;

  ShareRideRouteWidget(
      {super.key,
      required this.source,
      required this.destination,
      required this.multiStop,
      this.enableDone = false,
      this.isLoading = false,
      this.padding = const EdgeInsets.symmetric(horizontal: 0.0),
      this.onDone});

  @override
  Widget build(BuildContext context) {
    List<Address> allStops = <Address>[];
    allStops.add(source ?? Address());
    allStops.addAll(multiStop ?? <Address>[]);
    allStops.add(destination ?? Address());
    return Center(
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: Timeline.tileBuilder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemExtent: 60,
          theme: TimelineThemeData(
            nodePosition: 0,
            connectorTheme: ConnectorThemeData(
              thickness: 1.0,
            ),
            indicatorTheme: IndicatorThemeData(
              size: 20.0.ss,
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 0),
          builder: TimelineTileBuilder.connected(
            contentsBuilder: (_, index) {
              if (index == 0) {
                return Container(
                  margin: EdgeInsets.only(left: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(allStops[index].getDescription,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: CustomTextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12.fss,
                            color: AppColors.textBlack)),
                    subtitle: Text(AppStrings.pickUp.tr),
                    trailing: Text(allStops[index].reachedAtHour ?? "",style: CustomTextStyle(
                        color: AppColors.textBlack.withOpacity(.4),
                        fontSize: 12.fss,
                        fontWeight: FontWeight.w500)),
                  ),
                );
              }
              if (index == allStops.length - 1) {
                return Container(
                  margin: EdgeInsets.only(left: 10.0),
                  //height: 10.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2.0),
                    //color: Color(0xffe6e7e9),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(allStops[index].getDescription,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: CustomTextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12.fss,
                            color: AppColors.textBlack)),
                    subtitle: Text(AppStrings.destination.tr),
                    trailing: Text(allStops[index].reachedAtHour ?? "",style: CustomTextStyle(
                        color: AppColors.textBlack.withOpacity(.4),
                        fontSize: 12.fss,
                        fontWeight: FontWeight.w500)),
                  ),
                );
              }
              return Container(
                margin: EdgeInsets.only(left: 10.0.ss),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2.0),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(allStops[index].getDescription,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: CustomTextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12.fss,
                          color: AppColors.textBlack)),
                  subtitle: allStops[index].progressStatus ==
                          TripTimelineStatus.inProgress
                      ? Row(
                          children: [
                            Text(AppStrings.arrived.tr),
                            HorizontalGap(10.ss),
                            (enableDone ?? false)
                                ? (isLoading ?? false)
                                    ? Container(
                                        height: 30,
                                        width: 30,
                                        padding: EdgeInsets.all(5.ss),
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      )
                                    : InkWell(
                                        child: Container(
                                          padding: EdgeInsets.all(5.ss),
                                          decoration: BoxDecoration(
                                              color: AppColors.buttonColor,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(6.ss))),
                                          child: Row(
                                            children: [
                                              HorizontalGap(10.ss),
                                              Icon(Icons.done,
                                                  color: AppColors.colorWhite,
                                                  size: 12.ss),
                                              HorizontalGap(5.ss),
                                              Text(AppStrings.done.tr,
                                                  style: CustomTextStyle(
                                                      color:
                                                          AppColors.colorWhite,
                                                      fontSize: 10.fss,
                                                      fontWeight:
                                                          FontWeight.w700)),
                                              HorizontalGap(10.ss),
                                            ],
                                          ),
                                        ),
                                        onTap: () {
                                          onDone == null
                                              ? null
                                              : onDone!(index - 1);
                                        },
                                      )
                                : Offstage(),
                          ],
                        )
                      : Text(AppStrings.nextStop.tr),
                  trailing: Text(allStops[index].reachedAtHour ?? "",
                      style: CustomTextStyle(
                          color: AppColors.textBlack.withOpacity(.4),
                          fontSize: 12.fss,
                          fontWeight: FontWeight.w500)),
                ),
              );
            },
            connectorBuilder: (_, index, __) {
              return DashedLineConnector(
                thickness: 1.0,
                dash: 4.ss,
                gap: 2.ss,
                space: 1.ss,
                color: AppColors.titleColor.withOpacity(.5),
              );
            },
            indicatorBuilder: (_, index) {
              switch (allStops[index].progressStatus) {
                case TripTimelineStatus.done:
                  return DotIndicator(
                    color: AppColors.switcherOnlineColor,
                    child: Icon(
                      Icons.check_circle,
                      color: AppColors.switcherOnlineColor,
                      size: 20.0.ss,
                    ),
                  );
                case TripTimelineStatus.inProgress:
                  return DotIndicator(
                    child: Icon(
                      Icons.location_on_rounded,
                      color: AppColors.tipInProgress,
                      size: 20.0.ss,
                    ),
                  );
                case TripTimelineStatus.next:
                default:
                  return DotIndicator(
                    child: Icon(
                      Icons.location_on_rounded,
                      color: AppColors.tipNext,
                      size: 20.0.ss,
                    ),
                  );
              }
            },
            itemExtentBuilder: (_, __) => kTileHeight,
            itemCount: allStops.length,
          ),
        ),
      ),
    );
  }
}
