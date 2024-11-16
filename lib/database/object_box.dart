/*
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../models/object_box/olocation.dart';
import '../models/object_box/objectbox.g.dart';

class ObjectBox {
  static final ObjectBox _instance = ObjectBox._internal();

  factory ObjectBox() => _instance;
  static Box<OLocation>? _database;

  ObjectBox._internal();

  Future<Box<OLocation>> get database async {
    if (_database != null) return _database!;
    _database = await create();
    return _database!;
  }

  Future<Box<OLocation>> create() async {
    final directory =
        p.join((await getApplicationDocumentsDirectory()).path, "obx-location");
    final store = await openStore(
        directory: directory, macosApplicationGroup: "objectbox.location");
    return Box(store);
  }

  Future<List<OLocation>> getUnSyncedLocations() async {
    final builder =
        (await database).query(OLocation_.synced.equals("N")).build();

    return builder.find();
  }

  Future<void> addLocation(OLocation location) async =>
      (await database).putAsync(location);

  Future<void> removeLocation(int id) async => (await database).removeAsync(id);
}
*/
