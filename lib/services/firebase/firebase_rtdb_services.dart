import 'package:firebase_database/firebase_database.dart';
import 'package:health_connector/log/logger.dart';
import 'package:health_connector/main.dart';

class FirebaseRtdbServices {
  FirebaseRtdbServices._();
  static DatabaseReference getDatabaseReference(String nodeName) =>
      firebaseDatabase.reference().child(nodeName);

  static DatabaseReference getDatabaseReferenceRecursively(
      {required String rootNode, required List<String> nodes}) {
    var dbRef = getDatabaseReference(rootNode);

    for (var element in nodes) {
      dbRef = dbRef.child(element);
    }
    return dbRef;
  }

  static Future<Map> getDataAtNode(DatabaseReference dbRef) async =>
      await dbRef.once().then((value) {
        return value.snapshot.value as Map;
      });

  // then((DataSnapshot snapshot) {
  //   return snapshot.value;
  // });

  static iterateMap(Map map) => map.forEach((key, value) {
        if (value is Map) {
          iterateMap(value);
        } else {
          Logger.debug('key = $key || value = $value');
        }
      });
}
