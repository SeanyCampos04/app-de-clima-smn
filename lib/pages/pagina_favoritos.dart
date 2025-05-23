import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smn/models/modelo_municipio.dart';
import 'package:smn/providers/provider_municipio.dart';
import 'package:smn/utils/favoritos.dart';

class PaginaFavoritos extends StatefulWidget {
  const PaginaFavoritos({super.key});

  @override
  State<PaginaFavoritos> createState() => _PaginaFavoritosState();
}

class _PaginaFavoritosState extends State<PaginaFavoritos> {
  List<ModeloMunicipio> favoritos = [];

  @override
  void initState() {
    super.initState();
    _cargarFavoritos();
  }

  Future<void> _cargarFavoritos() async {
    final lista = await Favoritos.obtenerFavoritos();
    setState(() {
      favoritos = lista;
    });
  }

  Future<void> _eliminarFavorito(ModeloMunicipio municipio) async {
    await Favoritos.eliminarDeFavoritos(municipio.idEdo, municipio.idMpo);
    _cargarFavoritos();
  }

  Future<void> _seleccionarMunicipio(ModeloMunicipio municipio) async {
    final providerMunicipio =
        Provider.of<ProviderMunicipio>(context, listen: false);

    await providerMunicipio.cargarMunicipioDesdeFavoritos(
      context,
      municipio.idEdo,
      municipio.idMpo,
      municipio.label,
    );

    Navigator.pop(context); // Cierra la pantalla de favoritos
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Favoritos'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 7, 197, 255),
        foregroundColor: Colors.black,
      ),
      body: favoritos.isEmpty
          ? const Center(child: Text('No hay municipios favoritos'))
          : ListView.builder(
              itemCount: favoritos.length,
              padding: const EdgeInsets.all(8.0),
              itemBuilder: (context, index) {
                final municipio = favoritos[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 6.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    title: Text(
                      municipio.label,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Color.fromARGB(255, 255, 255, 255)),
                      onPressed: () => _eliminarFavorito(municipio),
                    ),
                    onTap: () => _seleccionarMunicipio(municipio),
                  ),
                );
              },
            ),
    );
  }
}
