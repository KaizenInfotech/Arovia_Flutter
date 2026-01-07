import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

Widget profilePhotoWidget(String? imageUrl) {
  final bool isValidUrl = imageUrl != null && imageUrl.trim().isNotEmpty;

  return CircleAvatar(
    radius: 35,
    backgroundColor: const Color(0xFFD9D9D9),

    child: isValidUrl
        ? ClipOval(
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: 74,
        height: 74,
        fit: BoxFit.cover,

        placeholder: (context, url) => const Icon(
          Icons.person,
          size: 50,
          color: Colors.black54,
        ),

        errorWidget: (context, url, error) => const Icon(
          Icons.person,
          size: 50,
          color: Colors.black,
        ),
      ),
    )
        : const Icon(
      Icons.person,
      size: 50,
      color: Colors.black,
    ),
  );
}
