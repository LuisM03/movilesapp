import 'package:flutter/material.dart';
import 'sqlhelper.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        // Remove the debug banner
        debugShowCheckedModeBanner: false,
        title: 'MANDISA',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, }) : super(key: key);
 

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // All journals
  List<Map<String, dynamic>> _journals = [];
  
  bool _isLoading = true;
  

  // This function is used to fetch all data from the database
  void _refreshJournals() async {
    final pedido = await SQLHelper.getSales();
    setState(() {
      _journals = pedido;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshJournals(); 
    
  }

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _productoController = TextEditingController();
  final TextEditingController _cantidadController = TextEditingController();
  final TextEditingController _barrioController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();

  

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(int? id) async {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingJournal =
          _journals.firstWhere((element) => element['id'] == id);
      _nombreController.text = existingJournal['nombre'];
      _productoController.text = existingJournal['producto'];
      _cantidadController.text = existingJournal['cantidad'];
      _barrioController.text = existingJournal['barrio'];
      _direccionController.text = existingJournal['direccion'];
      _telefonoController.text = existingJournal['telefono'];
    }

    showModalBottomSheet(
        context: context,
        elevation: 6,
        isScrollControlled: true,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                top: 15,
                left: 15,
                right: 15,
                // this will prevent the soft keyboard from covering the text fields
                bottom: MediaQuery.of(context).viewInsets.bottom + 120,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: _nombreController,
                    decoration: const InputDecoration(hintText: 'Nombre'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _productoController,
                    decoration: const InputDecoration(hintText: 'Producto'),
                  ),
                  TextField(
                    controller: _cantidadController,
                    decoration: const InputDecoration(hintText: 'Cantidad'),
                  ),
                  TextField(
                    controller: _barrioController,
                    decoration: const InputDecoration(hintText: 'Barrio'),
                  ),
                  TextField(
                    controller: _direccionController,
                    decoration: const InputDecoration(hintText: 'Direccion'),
                  ),
                  TextField(
                    controller: _telefonoController,
                    decoration: const InputDecoration(hintText: 'Celular'),
                  ),
                  TextField(
                    controller: _correoController,
                    decoration: const InputDecoration(hintText: 'Correo'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      Mailer(_correoController.text, _productoController.text, _cantidadController.text);
                      // Save new journal
                      if (id == null) {
                        await _addItem();
                      }

                      if (id != null) {
                        await _updateItem(id);
                      }

                      // Clear the text fields
                      _nombreController.text = '';
                      _productoController.text = '';
                      _cantidadController.text='';
                      _barrioController.text='';
                      _direccionController.text='';
                      _telefonoController.text='';
                      _correoController.text='';

                      // Close the bottom sheet
                      Navigator.of(context).pop();
                    },
                    child: Text(id == null ? 'Nuevo' : 'Actualizar',),
                    style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.black, // background (button) color
                                foregroundColor:
                                    Colors.white, // foreground (text) color
                              )
                    
                  )
                ],
              ),
            ));
  }

// Insert a new journal to the database
  Future<void> _addItem() async {
     await SQLHelper.createSale(
        _nombreController.text, _productoController.text,_cantidadController.text,_barrioController.text,_direccionController.text, _telefonoController.text, 1);
    _refreshJournals();
  }

  // Update an existing journal
  Future<void> _updateItem(int id) async {
    await SQLHelper.updateSale(
        _nombreController.text, _productoController.text,_cantidadController.text,_barrioController.text,_direccionController.text, _telefonoController.text, id);
    _refreshJournals();
  }

  // Delete an item
  void _deleteItem(int id) async {
    await SQLHelper.deleteSale(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Registro eliminado con exito!'),
    ));
    _refreshJournals();
  }

  @override
  Widget build(BuildContext context) {
    final correo = ModalRoute.of(context)!.settings.arguments;
    // _correoController.text = correo!["correo"];
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pedidos Mandisa"),
        backgroundColor: Colors.grey.shade900,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _journals.length,
              itemBuilder: (context, index) => Card(
                color: Color.fromARGB(255, 187, 188, 210),
                margin: const EdgeInsets.all(15),
                child: ListTile(
                    title: Text(_journals[index]['nombre']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Text(_journals[index]['producto']),
                     Text(_journals[index]['cantidad']),
                     Text(_journals[index]['barrio']),
                     Text(_journals[index]['direccion']),
                     Text(_journals[index]['telefono']),
                    ],),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit,
                            color: Colors.black,
                            size: 36,),
                            onPressed: () => _showForm(_journals[index]['id']),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete,
                            color: Colors.black,
                            size: 32,),
                            onPressed: () =>
                                _deleteItem(_journals[index]['id']),
                          ),
                        ],
                      ),
                    )),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add,
        color: Colors.white,
        size:32),
        backgroundColor: Colors.black,
        onPressed: () => _showForm(null),
      ),
    );
  }
}

class User {
  final int id;
  final String nombre;
  final String apellidos;
  final String sexo;
  final String correo;
  final String password;


  User(this.nombre, this.id, this.apellidos, this.sexo, this.correo, this.password);
}

  Mailer(String correo, String producto, String cantidad) async {
    String username = 'eymontoya496@misena.edu.co';
    String password = 'rimftbkemrpnzstl';

    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username, 'Confirmación de compra a Mandisa')
      ..recipients.add(correo)
      ..ccRecipients.addAll([correo, correo])
      ..bccRecipients.add(Address(correo))
      ..subject = 'Usted se ha realizado una compra ${DateTime.now()}'
      ..text = 'COMPRO: ${cantidad} ${producto}'
      ..html = "COMPRO: ${cantidad} ${producto}";

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }

    var connection = PersistentConnection(smtpServer);

    // Send the first message
    await connection.send(message);

    // send the equivalent message

    // close the connection
    await connection.close();
  }