import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qscan/base/base_bloc.dart';
import 'package:qscan/base/tost_utils.dart';
import 'package:qscan/view_records/bloc/view_records_bloc.dart';
import 'package:qscan/view_records/bloc/view_records_state.dart';

import '../bloc/view_records_events.dart';

class ViewRecords extends StatefulWidget {
  const ViewRecords({super.key});

  @override
  State<ViewRecords> createState() => _ViewRecordsState();
}

class _ViewRecordsState extends State<ViewRecords> {
  bool isLoaderVisisble = false;

  List<String> snapshot = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<ViewRecordsBloc>(context).add(const InitViewRecords());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Un-Sync Data"),
        ),
        backgroundColor: Colors.pink.shade50,
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
              child: BlocListener<ViewRecordsBloc, BaseBlocState>(
                listener: (bloc, state) {
                  setState(() {
                    isLoaderVisisble = state is StateContentLoading;
                  });

                  if (state is ViewRecordsStateSuccess) {
                    setState(() {
                      snapshot = state.recordsList;
                    });
                  }
                  if (state is RecordsSyncStateSuccess) {
                    "Record Synced!".showAsToast();
                  }
                  if (state is RecordsSyncStateError) {
                    "Error getting on API!".showAsToast();
                  }
                },
                child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: snapshot.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                          title: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 30,
                                child: Text(
                                  "${index + 1}.",
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                                ),
                              ),
                              Text(snapshot[index])
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
                            child: Container(
                              height: 1,
                            ),
                          ),
                        ],
                      ));
                    }),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () async {
                  BlocProvider.of<ViewRecordsBloc>(context).add(SyncRecords(snapshot));
                },
                child: const Text('Sync'),
              ),
            ),
            if (isLoaderVisisble)
              const Center(
                child: CircularProgressIndicator(),
              )
          ],
        ));
  }
}
