
import 'package:flutter/material.dart';
import '../models/product.dart';
import 'cart_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  final bool showAssetsMessage;
  const HomeScreen({super.key, this.showAssetsMessage = false});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Product> products = [
    // Cafés
    Product('Café Espresso', 45.0, 'assets/icons/coffee.png',
        description: 'Shot intenso de café 100% arábica.',
        preparation: 'Molienda fina, extracción 25-30 seg.'),
    Product('Capuccino', 50.0, 'assets/icons/cappuccino.png',
        description: 'Espresso con leche vaporizada y espuma.',
        preparation: '1/3 espresso, 1/3 leche, 1/3 espuma.'),
    Product('Latte', 48.0, 'assets/icons/latte.png',
        description: 'Espresso suave con abundante leche.',
        preparation: 'Espresso + leche vaporizada, poca espuma.'),
    Product('Americano', 42.0, 'assets/icons/americano.png',
        description: 'Espresso diluido con agua caliente.',
        preparation: '1 espresso + 100-150 ml de agua.'),
    Product('Mocha', 55.0, 'assets/icons/mocha.png',
        description: 'Café con chocolate y leche cremosa.',
        preparation: 'Espresso + sirope chocolate + leche.'),
    Product('Frappé', 58.0, 'assets/icons/frappe.png',
        description: 'Bebida fría batida con hielo.',
        preparation: 'Base fría + espresso + hielo licuado.'),
    // Comida
    Product('Sandwich', 55.0, 'assets/icons/sandwich.png',
        description: 'Pan artesanal con jamón y queso.',
        preparation: 'Tostado al momento, mantequilla ligera.'),
    Product('Croissant', 40.0, 'assets/icons/croissant.png',
        description: 'Hojaldre francés crujiente.',
        preparation: 'Horneado diario, mantequilla premium.'),
    Product('Bagel', 38.0, 'assets/icons/bagel.png',
        description: 'Pan en aro esponjoso, sellado al horno.',
        preparation: 'Tostado + queso crema opcional.'),
    Product('Brownie', 32.0, 'assets/icons/brownie.png',
        description: 'Chocolate intenso con textura fudgy.',
        preparation: 'Horneado con cacao y nueces.'),
  ];

  final List<CartItem> cart = [];

  void addToCart(Product p, {String notes = ''}) {
    final idx = cart.indexWhere((c) => c.product.name == p.name && c.notes == notes);
    setState(() {
      if (idx >= 0) {
        cart[idx].quantity += 1;
      } else {
        cart.add(CartItem(product: p, quantity: 1, notes: notes));
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${p.name} añadido al carrito')),
    );
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  void _openDetail(Product p) {
    final notesCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      // ignore: deprecated_member_use
      backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.98),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Image.asset(p.image, width: 120, height: 120)),
              const SizedBox(height: 8),
              Text(p.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(p.description),
              const SizedBox(height: 6),
              Text('Preparación: ${p.preparation}', style: const TextStyle(fontStyle: FontStyle.italic)),
              const SizedBox(height: 12),
              TextField(
                controller: notesCtrl,
                decoration: const InputDecoration(
                  labelText: 'Personaliza tu pedido (ej. leche de almendra, sin azúcar)',
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('\$${p.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ElevatedButton.icon(
                    onPressed: () {
                      addToCart(p, notes: notesCtrl.text.trim());
                      Navigator.pop(ctx);
                    },
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text('Agregar'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.showAssetsMessage) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Bienvenido! Íconos coloridos listos 🎨')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemsCount = cart.fold<int>(0, (s, c) => s + c.quantity);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú BeanRush'),
        leading: IconButton(
          tooltip: 'Cerrar sesión',
          icon: const Icon(Icons.logout),
          onPressed: _logout,
        ),
        actions: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                icon: Image.asset('assets/icons/cart.png', width: 24, height: 24),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartScreen(cart: cart),
                  ),
                ),
              ),
              if (itemsCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      itemsCount.toString(),
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: .95,
        ),
        itemBuilder: (context, i) {
          final p = products[i];
          return Card(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.35),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: InkWell(
              onTap: () => _openDetail(p),
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: Image.asset(p.image)),
                    const SizedBox(height: 8),
                    Text(p.name, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('\$${p.price.toStringAsFixed(2)}'),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () => _openDetail(p),
                      icon: const Icon(Icons.info_outline, size: 16),
                      label: const Text('Detalles'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
