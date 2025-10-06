
import 'package:flutter/material.dart';
import '../models/product.dart';

class CartScreen extends StatefulWidget {
  final List<CartItem> cart;
  const CartScreen({super.key, required this.cart});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  double get total => widget.cart.fold(0.0, (sum, item) => sum + item.lineTotal);

  void _inc(CartItem item) {
    setState(() => item.quantity += 1);
  }

  void _dec(CartItem item) {
    setState(() {
      item.quantity -= 1;
      if (item.quantity <= 0) widget.cart.remove(item);
    });
  }

  Future<void> _editNotes(CartItem item) async {
    final ctrl = TextEditingController(text: item.notes);
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Editar ${item.product.name}'),
        content: TextField(
          controller: ctrl,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Notas / Cambios (ej. extra shot, sin azúcar)',
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, ctrl.text.trim()), child: const Text('Guardar')),
        ],
      ),
    );
    if (result != null) {
      setState(() => item.notes = result);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pedido actualizado')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tu pedido')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: widget.cart.isEmpty
                  ? const Center(child: Text('Tu carrito está vacío'))
                  : ListView.separated(
                      itemCount: widget.cart.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, i) {
                        final item = widget.cart[i];
                        return ListTile(
                          leading: Image.asset(item.product.image, width: 42, height: 42),
                          title: Text(item.product.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Notas: ${item.notes.isEmpty ? '—' : item.notes}'),
                              const SizedBox(height: 4),
                              Text('Precio: \$${item.product.price.toStringAsFixed(2)}'),
                            ],
                          ),
                          trailing: SizedBox(
                            width: 200,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  tooltip: 'Quitar',
                                  onPressed: () => _dec(item),
                                  icon: const Icon(Icons.remove_circle_outline),
                                ),
                                Text(item.quantity.toString(),
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                IconButton(
                                  tooltip: 'Añadir más',
                                  onPressed: () => _inc(item),
                                  icon: const Icon(Icons.add_circle_outline),
                                ),
                                IconButton(
                                  tooltip: 'Editar pedido',
                                  onPressed: () => _editNotes(item),
                                  icon: const Icon(Icons.edit_note),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('\\${total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: widget.cart.isEmpty
                  ? null
                  : () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Pago realizado'),
                          content: const Text('¡Gracias! Tu pedido en BeanRush está en camino ☕🍰'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK')),
                          ],
                        ),
                      );
                    },
              icon: const Icon(Icons.credit_card),
              label: const Text('Pagar'),
            ),
          ],
        ),
      ),
    );
  }
}
