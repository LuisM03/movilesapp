import 'dart:core';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    // var tablas = {
      
   
    // };

    await database.execute("""create table users(
      id integer primary key autoincrement not null,
      nombre text not null,
      apellidos text not null,
      sexo text not null,
      correo text not null,
      password text not null
    );""");
    await database.execute("""
        create table pedidos(
        id integer primary key autoincrement not null,
        nombre text not null,
        producto text not null,
        cantidad text not null,
        barrio text not null,
        direccion text not null,
        telefono text not null,
        id_user integer not null
      );""");

    // for (String tabla in tablas){
    //   await database.execute(tabla);
    // }

  }

  static Future<sql.Database> db() async {
    String data = await getDatabasesPath();
    return sql.openDatabase('soffmandis.db', version: 4,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }


   static Future<List<Map<String, dynamic>>> getSales() async {
    final db = await SQLHelper.db();
    return db.query('pedidos', orderBy: 'id');
  }



  static Future<List<Map<String, dynamic>>> getBookById(int id) async {
    final db = await SQLHelper.db();
    return db.query('users', where: 'id = ?', whereArgs: [id], limit: 1);
  }

    static Future<List<Map<String, dynamic>>> getSaleById(int id) async {
    final db = await SQLHelper.db();
    return db.query('pedidos', where: 'id = ?', whereArgs: [id], limit: 1);
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

  static Future<Map<String, dynamic>> createSale(
      String nombre,
      String producto,
      String cantidad,
      String barrio,
      String direccion,
      String telefono,
      int idUser) async {
    final db = await SQLHelper.db();
    final pedido = {
      'nombre': nombre,
      'producto': producto,
      'cantidad': cantidad,
      'barrio': barrio,
      'direccion': direccion,
      'telefono' : telefono,
      'id_user': idUser
    };
    await db.insert('pedidos', pedido,
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

    static Future<Map<String, dynamic>> updateSale(String nombre,
      String producto,
      String cantidad,
      String barrio,
      String direccion,
      String telefono, int id) async {
    final db = await SQLHelper.db();

    final pedido = {
      'nombre': nombre,
      'producto': producto,
      'cantidad': cantidad,
      'barrio': barrio,
      'direccion': direccion,
      'telefono' : telefono
    };



    await db.update('pedidos', pedido, where: 'id = ?', whereArgs: [id]);

    return {"message": "Update pedido successfully"};
  }



  static Future<void> deleteBook(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete('users', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      debugPrint("Error deleting: $e");
    }
  }

    static Future<void> deleteSale(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete('pedidos', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      debugPrint("Error deleting: $e");
    }
  }
}


