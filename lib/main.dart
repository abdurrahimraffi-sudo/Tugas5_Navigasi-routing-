import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

// ===================== MODEL =====================
class Food {
  final String image;
  final String name;
  final int price; // harga bertipe int
  final String description;

  const Food({
    required this.image,
    required this.name,
    required this.price,
    required this.description,
  });
}

// ===================== DATA =====================
// Ganti URL gambar dengan foto pilihanmu kalau ada yang tidak tampil.
const List<Food> foods = [
  Food(
    image: 'https://www.themealdb.com/images/media/meals/ustsqw1468250014.jpg',
    name: 'Penne Arrabiata',
    price: 35000,
    description:
        'Pasta penne dengan saus tomat pedas, bawang putih, dan cabai kering. '
        'Gurih, segar, dan cocok untuk pencinta pedas.',
  ),
  Food(
    image: 'https://www.themealdb.com/images/media/meals/wxywrq1468235067.jpg',
    name: 'Apple Frangipan Tart',
    price: 28000,
    description:
        'Tart renyah berisi krim almond dan irisan apel manis yang dipanggang '
        'hingga keemasan. Pas untuk teman minum teh.',
  ),
  Food(
    image: 'https://www.themealdb.com/images/media/meals/wyxwsp1486979827.jpg',
    name: 'Chicken Handi',
    price: 42000,
    description:
        'Ayam dimasak dalam kuah rempah kental bergaya India dengan tomat, '
        'yoghurt, dan bumbu garam masala.',
  ),
  Food(
    image: 'https://www.themealdb.com/images/media/meals/wvpsxx1468256321.jpg',
    name: 'Teriyaki Chicken',
    price: 38000,
    description:
        'Ayam panggang dengan saus teriyaki manis gurih, disajikan bersama '
        'nasi hangat dan sayuran segar.',
  ),
  Food(
    image: 'https://www.themealdb.com/images/media/meals/1529444830.jpg',
    name: 'Beef Lo Mein',
    price: 40000,
    description:
        'Mie telur tumis dengan irisan daging sapi empuk, sayuran, dan saus '
        'kecap khas Tiongkok.',
  ),
  Food(
    image: 'https://www.themealdb.com/images/media/meals/58oia61564916529.jpg',
    name: 'Corba',
    price: 25000,
    description:
        'Sup lentil hangat ala Turki dengan rasa lembut dan sedikit asam '
        'dari perasan lemon.',
  ),
];

// ===================== HELPER =====================
String rupiah(int value) {
  final s = value.toString().replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+$)'),
        (m) => '${m[1]}.',
      );
  return 'Rp $s';
}

Widget foodImage(String url, {double? height, BoxFit fit = BoxFit.cover}) {
  return Image.network(
    url,
    height: height,
    width: double.infinity,
    fit: fit,
    loadingBuilder: (context, child, progress) {
      if (progress == null) return child;
      return Container(
        height: height,
        color: Colors.orange.shade50,
        child: const Center(child: CircularProgressIndicator()),
      );
    },
    errorBuilder: (_, __, ___) => Container(
      height: height,
      color: Colors.orange.shade100,
      child: const Center(
        child: Icon(Icons.restaurant, size: 48, color: Colors.deepOrange),
      ),
    ),
  );
}

// ===================== APP + ROUTING =====================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String homeRoute = '/';
  static const String detailRoute = '/detail';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Warung Makan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFFFF8F3),
        useMaterial3: true,
      ),
      initialRoute: homeRoute,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case homeRoute:
            return MaterialPageRoute(builder: (_) => const HomePage());
          case detailRoute:
            final food = settings.arguments as Food;
            return PageRouteBuilder(
              settings: settings,
              transitionDuration: const Duration(milliseconds: 400),
              pageBuilder: (_, __, ___) => DetailPage(food: food),
              transitionsBuilder: (_, animation, __, child) =>
                  FadeTransition(opacity: animation, child: child),
            );
          default:
            return MaterialPageRoute(builder: (_) => const HomePage());
        }
      },
    );
  }
}

// ===================== HALAMAN LIST =====================
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 150,
            backgroundColor: scheme.primary,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              title: const Text(
                'Warung Makan',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.deepOrange.shade700, Colors.orange],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.only(top: 60, right: 20),
                    child: Icon(Icons.ramen_dining,
                        size: 70, color: Colors.white24),
                  ),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: Text(
                'Menu Favorit',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList.separated(
              itemCount: foods.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) => FoodCard(food: foods[index]),
            ),
          ),
        ],
      ),
    );
  }
}

class FoodCard extends StatelessWidget {
  final Food food;
  const FoodCard({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.white,
      elevation: 3,
      shadowColor: Colors.black26,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () async {
          // Navigasi ke detail, kirim data lewat arguments
          final qty = await Navigator.pushNamed(
            context,
            MyApp.detailRoute,
            arguments: food,
          );
          // Terima data balik dari halaman detail
          if (qty != null && context.mounted) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Text('$qty x ${food.name} ditambahkan ke keranjang'),
                ),
              );
          }
        },
        child: Row(
          children: [
            Hero(
              tag: food.name,
              child: SizedBox(
                width: 120,
                height: 120,
                child: foodImage(food.image, height: 120),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      food.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 13, color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: scheme.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        rupiah(food.price),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: scheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===================== HALAMAN DETAIL =====================
class DetailPage extends StatefulWidget {
  final Food food;
  const DetailPage({super.key, required this.food});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int _qty = 1;

  @override
  Widget build(BuildContext context) {
    final food = widget.food;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 320,
            backgroundColor: scheme.primary,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: food.name,
                child: foodImage(food.image, height: 320),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              transform: Matrix4.translationValues(0, -20, 0),
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              decoration: const BoxDecoration(
                color: Color(0xFFFFF8F3),
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.name,
                    style: const TextStyle(
                        fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    rupiah(food.price),
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: scheme.primary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Deskripsi',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    food.description,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Text(
                        'Jumlah',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const Spacer(),
                      IconButton.filledTonal(
                        onPressed:
                            _qty > 1 ? () => setState(() => _qty--) : null,
                        icon: const Icon(Icons.remove),
                      ),
                      SizedBox(
                        width: 44,
                        child: Text(
                          '$_qty',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton.filled(
                        onPressed: () => setState(() => _qty++),
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: FilledButton.icon(
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(54),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
            onPressed: () => Navigator.pop(context, _qty),
            icon: const Icon(Icons.shopping_cart_outlined),
            label: Text(
              'Tambah ke Keranjang  •  ${rupiah(food.price * _qty)}',
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}