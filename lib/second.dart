// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'dart:async';

// class username dan password dari page login
class SecondScreen extends StatefulWidget {
  final String username;
  final String password;

  SecondScreen({super.key, required this.username, required this.password});

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

// tampilan utama
class _SecondScreenState extends State<SecondScreen> {
  List<String> items = List<String>.generate(5, (i) => "Item ${i + 1}");
  bool showWelcomeMessage = true;
  bool isSelectMode = false;
  Set<int> selectedItems = Set<int>();

  // timer
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 4), () {
      setState(() {
        showWelcomeMessage = false;
      });
    });
  }

  // toggle tampilan saat select mode untuk cancel icon
  void _cancelIconSelectMode() {
    setState(() {
      isSelectMode = !isSelectMode;
      selectedItems.clear();
    });
  }

  // toggle saat menahan tap
  void _onItemLongPress(int index) {
    setState(() {
      isSelectMode = true;
      selectedItems.add(index);
    });
  }

  // aksi untuk item yang terpilih
  void _onItemTap(int index) {
    if (isSelectMode) {
      setState(() {
        if (selectedItems.contains(index)) {
          selectedItems.remove(index);
        } else {
          selectedItems.add(index);
        }
      });
    } else {
      _navigateToDetailPage(index);
    }
  }

  // masuk ke halaman detail saat di tap
  void _navigateToDetailPage(int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPage(
          item: items[index],
          items: items,
          index: index,
        ),
      ),
    );

    //
    // if (result != null) {
    //   setState(() {
    //     items = result;
    //   });
    // }
  }

  // logika buat penghapusan banyak item yang terpilih
  void _deleteIconSelectMode() {
    setState(() {
      items.removeWhere((item) => selectedItems.contains(items.indexOf(item)));
      selectedItems.clear();
      isSelectMode = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Item dihapus!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isCorrectCredentials =
        widget.username == 'Matin' && widget.password == '123';

    String backgroundImageUrl;

    if (isCorrectCredentials) {
      backgroundImageUrl =
          'https://pbs.twimg.com/media/FV-ey3VUEAIKmVf.jpg:large';
    } else {
      backgroundImageUrl =
          'https://webapps-cdn.esri.com/CDN/support-site/technical-articles-images/000029012/00N39000003LL24-0EM5x000004NgKj.png';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('List View'),
        actions: isSelectMode
            ? [
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: _deleteIconSelectMode,
                ),
                IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: _cancelIconSelectMode,
                ),
              ]
            : [],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: NetworkImage(backgroundImageUrl),
              width: 500,
              height: 400,
              fit: BoxFit.fitWidth,
              alignment: Alignment.center,
            ),
            if (isCorrectCredentials && showWelcomeMessage)
              Text(
                'Selamat Datang ${widget.username}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
              )
            else if (!isCorrectCredentials)
              Text(
                'Username dan password tidak sesuai.',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
              ),
            if (isCorrectCredentials)
              Expanded(
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: _showAddItemDialog,
                      child: Text('Tambah Item'),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final isSelected = selectedItems.contains(index);
                          return GestureDetector(
                            onLongPress: () => _onItemLongPress(index),
                            onTap: () => _onItemTap(index),
                            child: Container(
                              color: isSelected
                                  ? const Color.fromARGB(255, 0, 251, 255)
                                      .withOpacity(0.5)
                                  : Colors.transparent,
                              child: ListTile(
                                title: Text(items[index]),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  // elevated button buat tambah item
  void _showAddItemDialog() {
    TextEditingController itemController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tambah Item Baru'),
          content: TextField(
            controller: itemController,
            decoration: InputDecoration(hintText: 'Nama Item'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Tambah'),
              onPressed: () {
                setState(() {
                  items.add(itemController.text);
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Item ditambahkan!')),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class DetailPage extends StatefulWidget {
  final String item;
  final List<String> items;
  final int index;

  DetailPage({required this.item, required this.items, required this.index});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late TextEditingController _controller;
  late List<String> items;
  late int index;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.item);
    items = widget.items;
    index = widget.index;
  }

  void _updateItem() {
    setState(() {
      items[index] = _controller.text;
    });
    Navigator.pop(context, items);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Item diupdate!')),
    );
  }

  void _deleteItem() {
    setState(() {
      items.removeAt(index);
    });
    Navigator.pop(context, items);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Item dihapus!')),
    );
  }

  // void _addItem() {
  //   setState(() {
  //     items.add(_controller.text);
  //   });
  //   Navigator.pop(context, items);
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text('Item ditambahkan!')),
  //   );
  // }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Page'),
        backgroundColor: const Color.fromARGB(255, 0, 251, 255),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Item'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _updateItem,
              child: Text('Update Item'),
            ),
            // SizedBox(height: 8),
            // ElevatedButton(
            //   onPressed: _addItem,
            //   child: Text('Add Item'),
            // ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: _deleteItem,
              child: Text('Delete Item'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
