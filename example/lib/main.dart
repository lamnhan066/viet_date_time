import 'package:flutter/material.dart';
import 'package:viet_date_time/viet_date_time.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _vietDateTime = VietDateTime.fromSolar(DateTime.now());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Lịch Việt Hôm Nay'),
        ),
        body: Center(
          child: Text(
            'Ngày ${_vietDateTime.day} tháng ${_vietDateTime.month} năm ${_vietDateTime.year} \n'
            '${_vietDateTime.isLeapMonth ? '(Nhuần)' : ''}',
          ),
        ),
      ),
    );
  }
}
