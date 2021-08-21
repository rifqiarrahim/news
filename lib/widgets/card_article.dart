import 'package:flutter/material.dart';
import 'package:news/data/model/article.dart';
import 'package:news/provider/database_provider.dart';
import 'package:news/ui/detail_page.dart';
import 'package:provider/provider.dart';

import '../navigation.dart';
import '../styles.dart';

class CardArticle extends StatelessWidget {
  final Article article;

  const CardArticle({required this.article});

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, provider, child) {
        return FutureBuilder<bool>(
          future: provider.isBookmarked(article.url),
          builder: (context, snapshot) {
            var isBookmarked = snapshot.data ?? false;
            return Material(
              color: primaryColor,
              child: ListTile(
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                leading: Hero(
                  tag: article.urlToImage!,
                  child: Image.network(
                    article.urlToImage!,
                    width: 100,
                  ),
                ),
                title: Text(
                  article.title,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                subtitle: Text(
                  article.author!,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                onTap: () => Navigation.intentWithData(ArticleDetailPage.routeName, article),
                trailing: isBookmarked
                    ? IconButton(
                        icon: Icon(Icons.bookmark),
                        color: Theme.of(context).accentColor,
                        onPressed: () => provider.removeBookmark(article.url),
                      )
                    : IconButton(
                        icon: Icon(Icons.bookmark_border),
                        color: Theme.of(context).accentColor,
                        onPressed: () => provider.addBookmark(article),
                      ),
              ),
            );
          },
        );
      },
    );
  }
}