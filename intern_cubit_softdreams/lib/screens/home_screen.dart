import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../model/product.dart';
import '../cubit/added_products_cubit.dart';
import 'added_products_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalog',
            style: TextStyle(fontSize: 27, fontWeight: FontWeight.w700)),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: SvgPicture.asset('assets/icons/cart.svg',
                    width: 24, height: 24, fit: BoxFit.fill),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddedProductsScreen(),
                    ),
                  );
                },
              ),
              BlocBuilder<AddedProductsCubit, AddedProductsState>(
                builder: (context, state) {
                  return Positioned(
                    top: 0,
                    right: 3,
                    child: Text(
                      '${state.addedProducts.length}',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ListView.builder(
            itemCount: listProductCart.length,
            itemBuilder: (context, index) {
              final product = listProductCart[index];
              return BlocBuilder<AddedProductsCubit, AddedProductsState>(
                builder: (context, state) {
                  final isAdded = state.addedProducts.contains(product);
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Image.asset(
                        product.image,
                        width: 40,
                        height: 40,
                      ),
                      title: Text(
                        product.title,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w500),
                      ),
                      trailing: SizedBox(
                        width: 70,
                        height: 30,
                        child: isAdded
                            ? const IconButton(
                          onPressed: null,
                          icon: Icon(
                            Icons.check,
                            color: Colors.black,
                          ),
                        )
                            : ElevatedButton(
                          onPressed: () {
                            context
                                .read<AddedProductsCubit>()
                                .addProduct(product);
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                          child: const Text('Add'),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
