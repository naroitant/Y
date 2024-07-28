import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:y/domain/models/post_preview.dart';

class PostPreviewInfo extends StatelessWidget {
  final PostPreview postPreview;

  const PostPreviewInfo({
    required this.postPreview,
    super.key,
  });

  // Determine which ending the word 'like' should have.
  String determineEndingForLike(number, context) {
    if (number == 1) {
      return AppLocalizations
          .of(context)!
          .like;
    }

    if (number.remainder(10) == 1) {
      return AppLocalizations
          .of(context)!
          .likes_singular;
    }

    if ((number.remainder(10) > 1 && number.remainder(10) < 5) &&
        number.remainder(100) > 14) {
      return AppLocalizations
          .of(context)!
          .likes_dual;
    }

    return AppLocalizations
        .of(context)!
        .likes_plural;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.favorite_border),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Icon(Icons.mode_comment_outlined),
                  ),
                  Icon(Icons.send_rounded),
                ],
              ),
              Icon(Icons.bookmark_border),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '${postPreview.likes}'
                ' ${determineEndingForLike(postPreview.likes, context)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 6,
            left: 16,
            right: 16),
          child: Text.rich(
            TextSpan(
              text: '${postPreview
                  .owner
                  .firstName} ',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: postPreview.text,
                  style: const TextStyle(
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
