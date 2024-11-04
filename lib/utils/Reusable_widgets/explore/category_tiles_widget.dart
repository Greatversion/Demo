import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mambo/routes/app.nameRoutes.dart';
import 'package:mambo/utils/app.constants.dart';
import 'package:mambo/utils/app.styles.dart';
import 'package:mambo/view%20models/category_view_model.dart';
import 'package:provider/provider.dart';

class CategoryTilesWidget extends StatelessWidget {
  final int index;
  const CategoryTilesWidget({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    AppConst appconst = AppConst();

    return Consumer<CategoryProvider>(builder: (BuildContext context,
        CategoryProvider categoryProvider, Widget? child) {
      return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, RoutesName.categoryScreen, arguments: {
            "categoryName": categoryProvider.categories[index].name!,
            "index": index,
            "categoryID": categoryProvider.categories[index].id,
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(11),
                topRight: Radius.circular(11),
              ),
              color: appconst.categoryColors[index],
            ),
            child: Stack(
              children: [
                AppConst.isDeviceAPhone()
                    ? Positioned(
                        bottom: 0.1,
                        right: 0.5,
                        left: 0.5,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Container(
                            width: double.infinity,
                            height: 100, // Set a fixed height
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                              image: DecorationImage(
                                image:
                                    categoryProvider.categories[index].image !=
                                            null
                                        ? CachedNetworkImageProvider(
                                            categoryProvider
                                                .categories[index].image!.src!,
                                          )
                                        : const CachedNetworkImageProvider(
                                            'https://placehold.co/600x400/png'),
                                fit: BoxFit
                                    .cover, // Ensure the image covers the container
                              ),
                            ),
                          ),
                        ),
                      )
                    : Positioned(
                        bottom: 0.1,
                        right: 0.5,
                        left: 0.5,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Container(
                            width: double.infinity,
                            height: 100, // Set a fixed height
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                              image: DecorationImage(
                                image:
                                    categoryProvider.categories[index].image !=
                                            null
                                        ? CachedNetworkImageProvider(
                                            categoryProvider
                                                .categories[index].image!.src!)
                                        : const CachedNetworkImageProvider(
                                            'https://placehold.co/600x400/png'),
                                fit: BoxFit
                                    .cover, // Ensure the image covers the container
                              ),
                            ),
                          ),
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 8, top: 5, bottom: 2),
                  child: Text(
                    categoryProvider.categories[index].name!,
                    style: AppStyles.semiBoldText.copyWith(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
