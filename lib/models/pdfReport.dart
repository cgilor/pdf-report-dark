import 'package:pdf_reports_dark/models/costumer.dart';
import 'package:pdf_reports_dark/models/imgaPdf.dart';
import 'package:pdf_reports_dark/models/pdfInfo.dart';
import 'package:pdf_reports_dark/models/settings.dart';

class PdfReport {
  final PdfInfo? pdfinfo;
  // final SettingsModel settings;
  //final Customer customer;
  final ImagePdf? imageReport;
  final SettingsModel? settingsModel;
  final CostumerModel? costumerModel;

  const PdfReport(
      {this.pdfinfo, this.imageReport, this.settingsModel, this.costumerModel});
}
