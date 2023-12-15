import 'package:flutter/material.dart';
import 'package:y/domain/models/post_preview.dart';
import 'package:y/features/home/widgets/post_preview_info.dart';
import 'package:y/features/home/widgets/user_preview_header.dart';
import 'package:y/ui/components/cached_network_image_component.dart';

class PostPreviewCard extends StatelessWidget {
  final PostPreview postPreview;

  const PostPreviewCard({
    required this.postPreview,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;

    return Column(
      children: [
        UserPreviewHeader(userPreview: postPreview.owner),
        CachedNetworkImageComponent(
          url: postPreview.image,
          fit: BoxFit.cover,
          width: size,
          height: size,
        ),
        PostPreviewInfo(postPreview: postPreview),
      ],
    );
  }
}
