import 'package:flutter/material.dart';
import 'package:proyectoformativo/sqlhelper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Raleway',
          colorScheme: const ColorScheme.light()),
      debugShowCheckedModeBanner: false,
      home: const MyStatefulWidget(title: 'Flutter Demo Home Page'),
    );
  }
}

enum SinginCharacter { femenino, masculino }

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key, required this.title});
  final String title;

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidget();
}

class _MyStatefulWidget extends State<MyStatefulWidget> {
  List<Map<String, dynamic>> users = [];
  bool isLoading = false;
  void refreshUsers() async {
    final allBooks = await SQLHelper.getBooks();
    setState(() {
      users = allBooks;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    refreshUsers();
  }

  // Controllers
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController productoController = TextEditingController();
  final TextEditingController cantidadController = TextEditingController();
  final TextEditingController barrioController = TextEditingController();
  final TextEditingController direccionController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(top: 40, left: 30, right: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(users.isNotEmpty ? users[0]['nombre'] : "No hay users"),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: const Text(
                'Pedido',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text('Ingresa los datos para tu pedido.'),
            ),
            Form(
                child: Column(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: TextFormField(
                        decoration: InputDecoration(
                            hintText: 'Nombre',
                            hintStyle:
                                const TextStyle(fontWeight: FontWeight.w600),
                            fillColor: Colors.grey.shade200,
                            focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 0, style: BorderStyle.none),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 0, style: BorderStyle.none),
                            ),
                            filled: true))),
                Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: TextFormField(
                      decoration: InputDecoration(
                          hintText: 'Producto',
                          hintStyle:
                              const TextStyle(fontWeight: FontWeight.w600),
                          fillColor: Colors.grey.shade200,
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0, style: BorderStyle.none),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0, style: BorderStyle.none),
                          ),
                          filled: true),
                    )),
                Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: TextFormField(
                      decoration: InputDecoration(
                          hintText: 'Cantidad',
                          hintStyle:
                              const TextStyle(fontWeight: FontWeight.w600),
                          fillColor: Colors.grey.shade200,
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0, style: BorderStyle.none),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0, style: BorderStyle.none),
                          ),
                          filled: true),
                    )),
                Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: TextFormField(
                      decoration: InputDecoration(
                          hintText: 'Barrio',
                          hintStyle:
                              const TextStyle(fontWeight: FontWeight.w600),
                          fillColor: Colors.grey.shade200,
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0, style: BorderStyle.none),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0, style: BorderStyle.none),
                          ),
                          filled: true),
                    )),
                Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: TextFormField(
                      decoration: InputDecoration(
                          hintText: 'Dirección',
                          hintStyle:
                              const TextStyle(fontWeight: FontWeight.w600),
                          fillColor: Colors.grey.shade200,
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0, style: BorderStyle.none),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0, style: BorderStyle.none),
                          ),
                          filled: true),
                    )),
                Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: TextFormField(
                      decoration: InputDecoration(
                          hintText: 'Teléfono',
                          hintStyle:
                              const TextStyle(fontWeight: FontWeight.w600),
                          fillColor: Colors.grey.shade200,
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0, style: BorderStyle.none),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0, style: BorderStyle.none),
                          ),
                          filled: true),
                    )),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.black, // background (button) color
                            foregroundColor:
                                Colors.white, // foreground (text) color
                          ),
                          child: const Text('Hacer pedido')),
                    )),
              ],
            ))
          ],
        ),
      ),
    ));
  }
}
