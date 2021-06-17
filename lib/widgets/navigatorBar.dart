import 'package:flutter/material.dart';
import 'package:pdf_reports_dark/providers/ui_provider.dart';
import 'package:provider/provider.dart';

class CustomNavigatorBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final uiProvider = Provider.of<UiProvider>(context);
    final currentIndex = uiProvider.selectedMenuOpt;

    return BottomNavigationBar(
        onTap: (int i) => uiProvider.selectedMenuOpt = i,
        currentIndex: currentIndex,
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.picture_as_pdf_sharp,
              color: Colors.grey.shade500,
            ),
            label: 'My reports',
            //backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.post_add,
              color: Colors.grey.shade500,
            ),
            label: 'New report',
            // backgroundColor: Colors.amber[800],
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
              color: Colors.grey.shade500,
            ),

            label: ('Settings'),
            // backgroundColor: Colors.amber[800],
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_add,
              color: Colors.grey.shade500,
            ),
            label: 'Costumer',
            // backgroundColor: Colors.amber[800],
          ),
        ]);
  }
}
