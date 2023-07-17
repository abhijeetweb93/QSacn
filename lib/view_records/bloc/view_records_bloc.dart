import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qscan/base/base_bloc.dart';
import 'package:qscan/view_records/bloc/view_records_events.dart';
import 'package:qscan/view_records/bloc/view_records_state.dart';


import 'package:path_provider/path_provider.dart';
import 'dart:io';

import '../../base/util/shared_preferences_utils.dart';

class ViewRecordsBloc extends BaseBloc{
  ViewRecordsBloc(super.initialState){
    on<InitViewRecords>(_fetchTransaction);
    on<SyncRecords>(_postTransaction);
  }


  void _fetchTransaction(InitViewRecords event, Emitter<BaseBlocState> emit) async{
    emit(StateContentLoading());
    final response = await SharedPreferencesUtils.getListOfMobileNo();
    await Future.delayed(Duration(seconds: 2));
    return emit(ViewRecordsStateSuccess(response!));

  }

  void _postTransaction(SyncRecords event, Emitter<BaseBlocState> emit) async {
    emit(StateContentLoading());
    final uri = Uri.parse('https://example.com/api.asmx/addData');
    final headers = {'Content-Type': 'text/plain'};
    // Map<String, dynamic> body = {'id': 21, 'name': 'bob'};
    // jsonEncode(dataList)
    String jsonBody = jsonEncode(event.dataList).toString();
    //String jsonBody = json.encode(jsonEncode(dataList));
    final encoding = Encoding.getByName('utf-8');
    var response = await http.post(
      uri,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    );

    if (response.statusCode == 200) {
      print(response.body.toString());
      return emit(const RecordsSyncStateSuccess("Sync Success"));
    } else {
      //throw Exception('Request Failed.');
      return emit(const RecordsSyncStateSuccess("Request Failed."));
    }
  }


  void _writeToTextFile(){

  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<File> writeCounter(String counter) async {
    final file = await _localFile;
    return file.writeAsString('$counter');
  }

  void writeToTextFile(String text) async {
    final directory = await getExternalStorageDirectory();
    final file = File('${directory?.path}/qrdata.txt');

    // Write to the file
    await file.writeAsString(text);

    print('File written successfully');
  }


}