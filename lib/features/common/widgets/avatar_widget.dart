import 'package:flutter/material.dart';

class AvatarWidget extends StatelessWidget {
  final String? imageUrl;
  final double radius;
  final bool showEdit;
  final VoidCallback? onEdit;

  const AvatarWidget({
    Key? key,
    this.imageUrl,
    this.radius = 20,
    this.showEdit = false,
    this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: radius,
          backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
          backgroundColor: Colors.grey[200],
          child: imageUrl == null 
            ? Icon(Icons.person, size: radius, color: Colors.grey[600])
            : null,
        ),
        if (showEdit)
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: onEdit,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFD4FF3F),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  Icons.edit,
                  color: Colors.black,
                  size: 16,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

