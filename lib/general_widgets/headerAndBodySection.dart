import 'package:flutter/material.dart';

class HeaderAndBodySection extends StatelessWidget {
  const HeaderAndBodySection({
    super.key,
    required this.sectionHeader,
    required this.body
  });

  final String sectionHeader;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          sectionHeader,
          style: Theme.of(context).textTheme.titleLarge,
        ),

        const SizedBox(height: 20,),

        Align(
          alignment: body.isEmpty ? Alignment.center : Alignment.centerLeft,
          child: Text(
            body.isEmpty ? "This section is empty" : body,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}