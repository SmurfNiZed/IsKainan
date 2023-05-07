import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/dimensions.dart';
import '../utils/shimmer.dart';
import 'fake_app_column.dart';

class ShimmerFoodList extends StatelessWidget {
  const ShimmerFoodList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 2,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20, bottom: Dimensions.height20),
                    child: Row(
                      children: [
                        // image section
                        Container(
                          width: Dimensions.listViewImgSize,
                          height: Dimensions.listViewImgSize,
                          child: shimmer(),
                        ),
                        Expanded(
                          child: Container(
                            height: Dimensions.listViewTextContSize,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(Dimensions.radius20),
                                  bottomRight: Radius.circular(Dimensions.radius20)
                              ),

                            ),
                            child:
                            Padding(padding: EdgeInsets.only(left: Dimensions.width10, right: Dimensions.width10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      shimmer(height: Dimensions.font20, width: Dimensions.width30*5,),
                                      SizedBox(height: Dimensions.height10/2,),
                                      shimmer(height:Dimensions.font16, width: Dimensions.width30*2,),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      shimmer(height: Dimensions.font16, width: Dimensions.width30*1.5,),
                                      SizedBox(height: Dimensions.height10/2,),
                                      shimmer(height: Dimensions.font20, width: Dimensions.width30*3,),
                                      SizedBox(height: Dimensions.height10/2,)
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                })
        ),
      ],
    );
  }
}
