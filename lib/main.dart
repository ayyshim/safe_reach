import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_reach/src/bloc/bloc_watcher.dart';
import 'package:safe_reach/src/main.dart';

void main() {
  BlocSupervisor.delegate = BlocWatcher();
  runApp(MyApp());
}
