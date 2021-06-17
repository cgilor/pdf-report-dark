import 'package:path/path.dart';
import 'package:pdf_reports_dark/models/costumer.dart';
import 'package:pdf_reports_dark/models/imgaPdf.dart';
import 'package:pdf_reports_dark/models/pdfInfo.dart';
import 'package:pdf_reports_dark/models/settings.dart';

import 'package:sqflite/sqflite.dart';

class PdfDatabase {
  static final PdfDatabase instance = PdfDatabase._init();

  static Database? _database;

  PdfDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('pdfreport.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    print(path);

    return await openDatabase(path, version: 6, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT';

    await db.execute('''
CREATE TABLE $tableImages ( 
  ${ImageFields.id} $idType, 
  ${ImageFields.path} $textType,
  ${ImageFields.description} $textType

  )
''');
    await db.execute('''
          CREATE TABLE pdfreport ( 
          id INTEGER PRIMARY KEY,
          path TEXT,
          name TEXT,
          time TEXT
          )
          ''');
    await db.execute('''
          CREATE TABLE settings (
           id INTEGER PRIMARY KEY,
           name TEXT,
           address TEXT,
		       phone TEXT,
           email TEXT,
		      image TEXT
          )
          
        ''');
    await db.execute('''
          CREATE TABLE costumer (
           id INTEGER PRIMARY KEY,
           name TEXT,
           address TEXT,
		       phone TEXT,
           email TEXT
          )
          
        ''');
  }

  Future<ImagePdf> create(ImagePdf image) async {
    final db = await instance.database;

    final id = await db.insert(tableImages, image.toJson());
    return image.copy(id: id);
  }

  Future<PdfInfo> createPdf(PdfInfo pdfReport) async {
    final db = await instance.database;

    final id = await db.insert('pdfreport', pdfReport.toJson());
    return pdfReport.copy(id: id);
  }

  Future<SettingsModel> createSett(SettingsModel settings) async {
    final db = await instance.database;

    final id = await db.insert('settings', settings.toJson());
    return settings.copy(id: id);
  }

  Future<CostumerModel> createCostumer(CostumerModel costumer) async {
    final db = await instance.database;

    final id = await db.insert('costumer', costumer.toJson());
    return costumer.copy(id: id);
  }

  Future<ImagePdf> readImage(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableImages,
      columns: ImageFields.values,
      where: '${ImageFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return ImagePdf.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<ImagePdf>> readAllImages() async {
    final db = await instance.database;

    // final result =
    //     await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');

    final result = await db.query(tableImages);

    return result.map((json) => ImagePdf.fromJson(json)).toList();
  }

  Future<List<PdfInfo>> readAllReports() async {
    final db = await instance.database;

    final result = await db.query('pdfreport');

    return result.map((json) => PdfInfo.fromJson(json)).toList();
  }

  Future<List<SettingsModel>> readAllSett() async {
    final db = await instance.database;

    final result = await db.query('settings');

    return result.map((json) => SettingsModel.fromJson(json)).toList();
  }

  Future<List<CostumerModel>> readAllCostumer() async {
    final db = await instance.database;

    final result = await db.query('costumer');

    return result.map((json) => CostumerModel.fromJson(json)).toList();
  }

  Future<int> update(ImagePdf image) async {
    final db = await instance.database;

    return db.update(
      tableImages,
      image.toJson(),
      where: '${ImageFields.id} = ?',
      whereArgs: [image.id],
    );
  }

  Future<int> updateSett(SettingsModel settings) async {
    final db = await instance.database;
    final res = await db.update('settings', settings.toJson(),
        where: 'id = ?', whereArgs: [settings.id]);
    return res;
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableImages,
      where: '${ImageFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteReport(int id) async {
    final db = await instance.database;

    return await db.delete(
      'pdfreport',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAllScans() async {
    final db = await instance.database;
    final res = await db.delete(tableImages);
    return res;
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
