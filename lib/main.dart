import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  // Widget build(BuildContext context) {
  //   return MultiBlocProvider(
  //     providers: [
  //       BlocProvider<ActivityCubit>(
  //         create: (context) => ActivityCubit(),
  //       )
  //     ],
  //   );
  // }

  MyAppState createState() {
    return MyAppState();
  }
}

class ActivityModel {
  String id;
  String nama;
  ActivityModel({required this.id, required this.nama}); //constructor
}

class ActivityCubit extends Cubit<ActivityModel> {
  //ActivityCubit() : super("http://178.128.17.76:8000/jenis_pinjaman/1");
  String url = "http://178.128.17.76:8000/jenis_pinjaman/1";
  ActivityCubit() : super(ActivityModel(id: "", nama: ""));

  //map dari json ke atribut
  void setFromJson(Map<String, dynamic> json) {
    String id = json['id'];
    String nama = json['nama'];

//emit state baru, ini berbeda dgn provider!
    emit(ActivityModel(id: id, nama: nama));
  }

  void fetchData() async {
    final response =
        await http.get(Uri.parse("http://178.128.17.76:8000/jenis_pinjaman/1"));
    if (response.statusCode == 200) {
      //sukses
      setFromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal load');
    }
  }
}

class MyAppState extends State<MyApp> {
  final textEditController = TextEditingController();
  String pilihanPinjaman = "pilih pinjaman";
  String pilihanJenis = "";

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    textEditController.dispose();
    super.dispose();
  }

  // Text("Deva Farah 2000793");

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<String>> pinjam = [];
    var itm0 = const DropdownMenuItem<String>(
      value: "pilih pinjaman",
      child: Text("Pilih jenis pinjaman"),
    );
    var itm1 = const DropdownMenuItem<String>(
      value: "pi1",
      child: Text("Jenis pinjaman 1"),
    );
    var itm2 = const DropdownMenuItem<String>(
      value: "pinjaman 2",
      child: Text("Jenis pinjaman 2"),
    );
    var itm3 = const DropdownMenuItem<String>(
      value: "pinjaman 3",
      child: Text("Jenis pinjaman 3"),
    );
    pinjam.add(itm0);
    pinjam.add(itm1);
    pinjam.add(itm2);
    pinjam.add(itm3);

    return MaterialApp(
      title: 'Hello App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('My App P2P'),
        ),

        body: FutureBuilder(
          //  future: fetchData(), // fungsi untuk mengambil data dari API
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Menampilkan indikator loading jika future masih dalam proses
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              // Menampilkan pesan error jika terjadi kesalahan dalam mengambil data
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              // Data berhasil diterima
              return Column(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.all(16),
                    child: Text(
                      '2000793, Deva Shofa Al Fathin; 2001286, Farah Dwi Ameliani; Saya berjanji tidak akan berbuat curang data atau membuat orang lain berbuat curang',
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: DropdownButton(
                      value: pilihanPinjaman,
                      items: pinjam,
                      onChanged: (String? newValue) {
                        setState(() {
                          if (newValue != null) {
                            pilihanPinjaman = newValue;
                            // Aktifkan pengambilan data menggunakan ActivityCubit
                            context.read<ActivityCubit>().fetchData();
                          }
                        });
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
//column center
      ), //Scaffold
    ); //Material APP
  }
}
