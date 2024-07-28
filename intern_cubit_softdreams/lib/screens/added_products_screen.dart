import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/added_products_cubit.dart';

class AddedProductsScreen extends StatelessWidget {
  const AddedProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Added Products'),
      ),
      body: BlocBuilder<AddedProductsCubit, AddedProductsState>(
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: state.addedProducts.length,
                  itemBuilder: (context, index) {
                    final product = state.addedProducts[index];
                    return ListTile(
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
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_forever_outlined,
                            color: Colors.black),
                        onPressed: () {
                          context
                              .read<AddedProductsCubit>()
                              .removeProduct(product);
                        },
                      ),
                    );
                  },
                ),
              ),
              Container(
                alignment: Alignment.center,
                height: 100,
                width: double.infinity,
                color: Colors.grey,
                child: Text(
                  'Total: ${state.totalPrice}\$',
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w800,
                    fontSize: 24,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
