import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import "package:meta/meta.dart";
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

part 'database_event.dart';
part 'database_state.dart';

class DatabaseBloc extends Bloc<DatabaseEvent, DatabaseState> {
  DatabaseBloc() : super(DatabaseInitial()) {
    on<DatabaseEvent>((event, emit) async {
      if (event is DatabaseQueryEvent) {
        emit(DatabaseQueryingState(query: event.query));
        var databasesPath = await getDatabasesPath();
        var path = join(databasesPath, "russian.db");

// Check if the database exists
        var exists = await databaseExists(path);

        if (!exists) {
          // Should happen only the first time you launch your application
          print("Creating new copy from asset");

          // Make sure the parent directory exists
          try {
            await Directory(dirname(path)).create(recursive: true);
          } catch (_) {}

          // Copy from asset
          ByteData data =
              await rootBundle.load(url.join("assets", "russian.db"));
          List<int> bytes =
              data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

          // Write and flush the bytes written
          await File(path).writeAsBytes(bytes, flush: true);
        } else {
          print("Opening existing database");
        }

// open the database
        var db = await openDatabase(path, readOnly: true);

        final result = await db.rawQuery(event.query);

        emit(DatabaseQueryCompleteState(queryResult: result));
      }
    });
  }
}
