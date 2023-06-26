import 'dart:core';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
      create table users(
        id integer primary key autoincrement not null,
        nombre varchar(60) not null,
        apellidos varchar(60) not null,
        sexo varchar(60) not null,
        correo text not null,
        password varchar(60) not null
      );
      create table pedidos(
        id integer primary key autoincrement not null,
        nombre varchar(60) not null,
        producto varchar(60) not null,
        cantidad integer not null,
        barrio text not null,
        direccion text not null
        telefono varchar(60) not null
      );
      """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase('soff_database.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }



  static Future<List<Map<String, dynamic>>> getBooks() async {
    final db = await SQLHelper.db();
    return db.query('users', orderBy: 'id');
  }

  static Future<List<Map<String, dynamic>>> getBookById(int id) async {
    final db = await SQLHelper.db();
    return db.query('users', where: 'id = ?', whereArgs: [id], limit: 1);
  }

  static Future<Map<String, dynamic>?> loginUser(String correo, String password) async{
    final db = await SQLHelper.db();
    final List<Map<String, dynamic>> users  = await db.query('users', where: 'correo = ? AND password = ?', whereArgs: [correo, password]);
    if (users.isNotEmpty) {
      return users.first;
    }
    return null;
  }

  static Future<Map<String, dynamic>> createBook(
      String nombre,
      String apellidos,
      String sexo,
      String correo,
      String password) async {
    final db = await SQLHelper.db();
    final user = {
      'nombre': nombre,
      'apellidos': apellidos,
      'sexo': sexo,
      'correo': correo,
      'password': password
    };
    await db.insert('users', user,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return {"message": "Create user successfully"};
  }

  // static Future<Map<String, dynamic>> createPedido(
  //   String
  // ){
  // }

  static Future<Map<String, dynamic>> updateBook(String nombre,
      String apellidos,
      String sexo,
      String correo,
      String password, int id) async {
    final db = await SQLHelper.db();

    final user = {
      'nombre': nombre,
      'apellidos': apellidos,
      'sexo': sexo,
      'correo': correo,
      'password': password
    };

    await db.update('users', user, where: 'id = ?', whereArgs: [id]);

    return {"message": "Update user successfully"};
  }



  static Future<void> deleteBook(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete('users', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      debugPrint("Error deleting: $e");
    }
  }
}
