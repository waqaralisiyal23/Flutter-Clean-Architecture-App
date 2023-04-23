import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import '../../domain/models/article.dart';

class ArticleWidget extends StatelessWidget {
  final Article article;
  final bool isRemovable;
  final void Function(Article article)? onRemove;
  final void Function(Article article)? onArticlePressed;
  const ArticleWidget({
    super.key,
    required this.article,
    this.isRemovable = false,
    this.onRemove,
    this.onArticlePressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _onTap,
      child: Container(
        padding: const EdgeInsetsDirectional.only(
            start: 14, end: 14, bottom: 7, top: 7),
        height: MediaQuery.of(context).size.width / 2.2,
        child: Row(
          children: [
            _buildImage(context),
            _buildTitleAndDescription(),
            _buildRemovableArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 14),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Container(
          width: MediaQuery.of(context).size.width / 3,
          height: double.maxFinite,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.08),
          ),
          child: Image.network(
            article.urlToImage ?? '',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) {
              return Center(
                child: Text(
                  article.urlToImage == null
                      ? '404\nNOT FOUND'
                      : 'Failed to load image',
                  textAlign: TextAlign.center,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTitleAndDescription() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              article.title ?? '',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Butler',
                fontWeight: FontWeight.w900,
                fontSize: 18,
                color: Colors.black87,
              ),
            ),

            // Description
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  article.description ?? '',
                  maxLines: 2,
                ),
              ),
            ),

            // Datetime
            Row(
              children: [
                const Icon(Ionicons.time_outline, size: 16),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    article.publishedAt ?? '',
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRemovableArea() {
    if (isRemovable) {
      return GestureDetector(
        onTap: _onRemove,
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Icon(Ionicons.trash_outline, color: Colors.red),
        ),
      );
    }
    return Container();
  }

  void _onTap() {
    if (onArticlePressed != null) {
      onArticlePressed?.call(article);
    }
  }

  void _onRemove() {
    if (onRemove != null) {
      onRemove?.call(article);
    }
  }
}
