import 'package:flutter/material.dart';
import 'models/pokemon.dart';
import 'services/pokemon_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PokéApp',
      home: PokemonScreen(),
    );
  }
}

class PokemonScreen extends StatefulWidget {
  @override
  _PokemonScreenState createState() => _PokemonScreenState();
}

class _PokemonScreenState extends State<PokemonScreen> {
  final _controller = TextEditingController();
  final _service = PokemonService();

  Pokemon? _pokemon;
  String? _error;

  void _search() async {
    setState(() {
      _error = null;
      _pokemon = null;
    });

    try {
      final pokemon = await _service.fetchPokemon(_controller.text.toLowerCase());
      setState(() {
        _pokemon = pokemon;
      });
    } catch (e) {
      setState(() {
        _error = 'No se encontró el Pokémon';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Buscar Pokémon')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Nombre del Pokémon',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _search,
                ),
              ),
            ),
            SizedBox(height: 20),
            if (_error != null)
              Text(_error!, style: TextStyle(color: Colors.red)),
            if (_pokemon != null)
              Column(
                children: [
                  Image.network(_pokemon!.imageUrl),
                  Text(
                    _pokemon!.name.toUpperCase(),
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
