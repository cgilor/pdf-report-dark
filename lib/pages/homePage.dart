import 'package:flutter/material.dart';
import 'package:pdf_reports_dark/pages/costumerPage.dart';
import 'package:pdf_reports_dark/pages/historiPage.dart';
import 'package:pdf_reports_dark/pages/settingsPage.dart';
import 'package:pdf_reports_dark/providers/ui_provider.dart';
import 'package:pdf_reports_dark/widgets/navigatorBar.dart';
import 'package:provider/provider.dart';

import 'newReportPage.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _HomePageBody(),
      bottomNavigationBar: CustomNavigatorBar(),
      //floatingActionButton: NewReportButton(),
      //floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class _HomePageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Obtener el selected menu opt
    final uiProvider = Provider.of<UiProvider>(context);

    // Cambiar para mostrar la pagina respectiva
    final currentIndex = uiProvider.selectedMenuOpt;

    // Usar el ScanListProvider
    // final scanListProvider = Provider.of<ScanListProvider>(context, listen: false);

    switch (currentIndex) {
      case 0:
        // scanListProvider.cargarScanPorTipo('geo');
        return HistoryPage();

      case 1:
        //  scanListProvider.cargarScanPorTipo('http');
        return NewReportPage();

      case 2:
        //  scanListProvider.cargarScanPorTipo('http');
        return SettingsPage();
      case 3:
        return CostumerPage();

      default:
        return NewReportPage();
    }
  }
}
