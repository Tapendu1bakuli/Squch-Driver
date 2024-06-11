import 'package:flutter/material.dart';
import 'package:sizing/sizing.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';
import '../utils/fonts.dart';

class CommonIntroPage extends StatelessWidget {
  AssetImage? backgroundImage;
  Image? logo;
  String ? heading;
  String ? summary;
  double ? height;

  CommonIntroPage({this.backgroundImage,this.logo,this.heading,this.summary,this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child:
      Column(
        children: [
          Container(
            height: (height!*3.0)/4,
            child: Stack(

              children: [

                Container(
                  height: (height!*3.0)/4,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      image:
                      DecorationImage(
                        // alignment: Alignment(0,-10),
                        image: backgroundImage??AssetImage("assets/images/backgrounds/back2.png",),
                        fit: BoxFit.fitWidth,
                      )
                  ),
                ),
              /*  Align(
                  alignment: AlignmentDirectional.bottomCenter,
                  child: Container(
                    color: Colors.white.withOpacity(0.2),
                    height: 100,),

                ),*/


              ],
            ),
          ),
          Container(
            height:  (height!*1.0)/4,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:[
                  Text(heading??"",style: CustomTextStyle(fontSize: 18.fss,fontWeight: FontWeight.w700),overflow: TextOverflow.clip,textAlign: TextAlign.center,),
                  Text(summary??"",style: CustomTextStyle(fontSize: 12),overflow: TextOverflow.clip,textAlign: TextAlign.center,),
                ]

            ),
          ),
        ],
      )

      /*Stack(
        fit: StackFit.expand,
        children: [


          Positioned(
            top: 30,

            child: Container(child: logo??Image.asset("assets/images/backgrounds/three.png",height: MediaQuery.of(context).size.height,width: 100,),
          ),),

        ],
      ),*/
    );
  }
}
