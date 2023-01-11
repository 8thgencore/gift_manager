import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class GiftPageArgs extends Equatable {
  const GiftPageArgs(this.giftName);

  final String giftName;

  @override
  List<Object?> get props =>[giftName];

}

class GiftPage extends StatelessWidget {
  const GiftPage({ required this.args, super.key});

  final GiftPageArgs args;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text(
          args.giftName,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
