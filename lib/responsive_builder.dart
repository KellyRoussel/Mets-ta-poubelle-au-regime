import 'package:flutter/material.dart';


typedef Widget DeviceBuilder(BuildContext context, BoxConstraints constraints);

class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({
    required this.mobileBuilder,
    required this.tabletBuilder,
    required this.desktopBuilder,
    Key? key}) : super(key: key);

   final DeviceBuilder mobileBuilder;
   final DeviceBuilder tabletBuilder;
   final DeviceBuilder desktopBuilder;

   static bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < 600;

   static bool isTablet(BuildContext context) => MediaQuery.of(context).size.width < 1100 && MediaQuery.of(context).size.width >= 600;

  static bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= 1100;


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints){
      if(constraints.maxWidth >= 1100){
        return desktopBuilder(context, constraints);
      }else if(constraints.maxWidth >= 600){
        return tabletBuilder(context, constraints);
      }else{
        return mobileBuilder(context, constraints);
      }
    });
  }
}
