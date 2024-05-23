import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mysql_flask_crud/model/student_model.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:5000';

  // kenapa List<Student>? karena object Student yang akan di kembalikan ketika function ini di panggil
  Future<List<Student>> getStudents() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      // menguraikan hasil dari response menjadi sebuah list dengan method json.decode
      List jsonResponse = json.decode(response.body);
      // hasil dari response tersebut akan di masukan ke dalam object dart menggunakan function student.fromjson() lalu diubah ke dalam bentuk list dengan function .tolist()
      return jsonResponse
          .map((students) => Student.fromJson(students))
          .toList();
    } else {
      throw Exception('Failed to load students');
    }
  }

  Future<void> addStudents(Student student) async {
    final response = await http.post(Uri.parse('$baseUrl/add'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        // jsonEncode mengubah dari dart object menjadi sebuah format json untuk input data, karena data yang di input harus berupa json
        body: jsonEncode(student.toJson()));
    if (response.statusCode != 201) {
      throw Exception('Failed to add student');
    }
  }
}

/**  
 * Kesimpulan Perbedaan
Tipe Data Pengembalian:

Future<List<Student>>: Mengembalikan daftar objek Student.
Future<void>: Tidak mengembalikan data, hanya mengindikasikan penyelesaian operasi.

Kapan Digunakan:

Future<List<Student>>: Digunakan ketika operasi menghasilkan data yang perlu digunakan setelah operasi selesai.
Future<void>: Digunakan ketika operasi tidak memerlukan data yang dikembalikan, hanya perlu diketahui kapan operasi selesai. 
*/
