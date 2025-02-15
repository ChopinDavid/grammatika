import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:uchu/services/navigation_service.dart';
import 'package:uchu/utilities/url_helper.dart';

class UchuDrawer extends StatelessWidget {
  const UchuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView.builder(
        itemBuilder: (context, index) {
          switch (index) {
            case 0:
              return const DrawerHeader(child: Text('Menu'));
            case 1:
              return ListTile(
                title: const Text('Settings'),
                onTap: () => GetIt.instance
                    .get<NavigationService>()
                    .pushSettingsPage(context),
              );
            case 2:
              return ListTile(
                title: const Text('Statistics'),
                onTap: () => GetIt.instance
                    .get<NavigationService>()
                    .pushStatisticsPage(context),
              );
            case 3:
              return ListTile(
                title: const Text('Bug Report/Feature Request'),
                onTap: () => GetIt.instance
                    .get<UrlHelper>()
                    .launchUrl('https://github.com/ChopinDavid/uchu/issues'),
              );
          }
        },
      ),
    );
  }
}
