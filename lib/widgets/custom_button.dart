import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.pink.shade300, // фон кнопки
        foregroundColor: Colors.white, // колір тексту
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14), // відступи
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // круглі кути
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16, // розмір шрифту
          fontWeight: FontWeight.bold, // жирний текст
        ),
      ),
    );
  }
}
