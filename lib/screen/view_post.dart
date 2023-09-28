import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:fitness_social_app/models/generic_post_model.dart';
import 'package:flutter/material.dart';

class ViewPost extends StatelessWidget {
  const ViewPost({Key? key, required this.post}) : super(key: key);
  final GenericPost post;

  @override
  Widget build(BuildContext context) {
    final imageProvier = MultiImageProvider([Image.network(post.image).image]);
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  title: Text(
                    post.postName,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  backgroundColor: Theme.of(context).colorScheme.background,
                  // snap: true,
                  floating: true,
                )
              ],
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      showImageViewerPager(context, imageProvier);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Container(
                        height: 350,
                        width: double.infinity,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              post.image,
                              fit: BoxFit.cover,
                            )),
                      ),
                    ),
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.favorite_outline),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.comment_outlined),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.share_outlined),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }
}
