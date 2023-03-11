import 'package:flutter/material.dart';
import 'package:mouvement_de_palier/responsive_builder.dart';
import 'package:mouvement_de_palier/step.dart';
import 'package:mouvement_de_palier/views/components/sidemenu.dart';

typedef Widget BuildChild(BuildContext context);
class CommonScaffold extends StatelessWidget {
  BuildChild buildChild;
  Function? onPressedMenu;

  CommonScaffold(this.buildChild, {this.onPressedMenu, Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  // astuce de la key : dans le child, mettre un onPressed, ce onPressed fera :
  // () => _key.currentState!.openDrawer()
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(title: Text("Mouvement de palier"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String result) {
              switch (result) {
                case 'alimentaire':
                  CurrentStep().changeStep("assets/step1.json");
                  break;
                case 'hygiene':
                  CurrentStep().changeStep("assets/step2.json");
                  break;
                case 'seconde_vie':
                  CurrentStep().changeStep("assets/step3.json");
                  break;
                default:
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'alimentaire',
                child: Text('Déchets Alimentaires'),
              ),
              const PopupMenuItem<String>(
                value: 'hygiene',
                child: Text('Hygiène et ménager'),
              ),
              const PopupMenuItem<String>(
                value: 'seconde_vie',
                child: Text('Seconde vie'),
              ),
            ],
          )
        ],),
      drawer: ResponsiveBuilder.isDesktop(context) ? null : Drawer(child: SideMenu(),),
      body: SafeArea(child: ResponsiveBuilder(
        mobileBuilder: (context, constraints){
          return SingleChildScrollView(child: buildChild(context),);
        },
        tabletBuilder: (context, constraints){
          return Row(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // todo : pas sûr que la row soit nécessaire ??
              Flexible(
                  flex: constraints.maxWidth > 800 ? 8 : 7,
                  child: SingleChildScrollView(child: buildChild(context)))],);
        },
        desktopBuilder: (context, constraints){
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                  flex: constraints.maxWidth > 1350 ? 3 : 4,
                  child: SideMenu()), // child sidebar
              Flexible(flex: constraints.maxWidth > 1350 ? 10 : 9, child: SingleChildScrollView(child: buildChild(context),),)
            ],);
        },
      ),),
    );
  }
}
