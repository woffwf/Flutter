
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mob/cubit/saved_qr/saved_qr_cubit.dart';

class SavedQrScreen extends StatelessWidget {
  const SavedQrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SavedQrCubit()..loadQrCodes(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Збережені QR-коди'),
          backgroundColor: Colors.pink.shade200,
        ),
        body: BlocBuilder<SavedQrCubit, SavedQrState>(
          builder: (context, state) {
            if (state is SavedQrLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SavedQrLoaded) {
              final codes = state.codes;
              if (codes.isEmpty) {
                return const Center(child: Text('Немає збережених QR-кодів.'));
              }
              return ListView.builder(
                itemCount: codes.length,
                itemBuilder: (context, index) {
                  final code = codes[index];
                  return ListTile(
                    title: Text(code),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        context.read<SavedQrCubit>().deleteQrCode(code);
                      },
                    ),
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
