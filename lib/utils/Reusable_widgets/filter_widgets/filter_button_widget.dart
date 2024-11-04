import 'package:flutter/material.dart';
import 'package:mambo/utils/app.styles.dart';
import 'package:mambo/view%20models/product_filter_view_model.dart';
import 'package:provider/provider.dart';
import 'package:mambo/models/Network%20models/search_model.dart';
import 'package:mambo/utils/Reusable_widgets/filter_widgets/brand_list_widget.dart';
import 'package:mambo/utils/Reusable_widgets/filter_widgets/category_list_widget.dart';
import 'package:mambo/utils/Reusable_widgets/filter_widgets/pricerange_textField_widget.dart';
import 'package:mambo/view%20models/category_view_model.dart';

class FilterButtonWidget extends StatefulWidget {
  final String buttonTag;
  final Function(SearchModel)? onApplyFilters; // Add this

  const FilterButtonWidget({
    super.key,
    required this.buttonTag,
    this.onApplyFilters, // Add this
  });

  @override
  State<FilterButtonWidget> createState() => _FilterButtonWidgetState();
}

class _FilterButtonWidgetState extends State<FilterButtonWidget> {
  List<String> selectedBrands = [];
  List<String> selectedCategories = [];
  String minPrice = '';
  String maxPrice = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: InkWell(
        onTap: () {
          setState(() {
            selectFilteringFunction(widget.buttonTag, context);
          });
        },
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black87),
              borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(7.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.buttonTag,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Icon(Icons.keyboard_arrow_down,
                    color: Colors.grey[600]), //Modified)
              ],
            ),
          ),
        ),
      ),
    );
  }

  void selectFilteringFunction(String buttonTag, BuildContext context) {
    switch (buttonTag) {
      case "Brands":
        _showBrandsDialogBox(context);
        break;

      case "Category":
        _showCategoryDialogBox(context);
        break;
      case "Price":
        _showPriceDialogBox(context);
        break;
      default:
    }
  }

  void _showBrandsDialogBox(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return ChangeNotifierProvider(
          create: (_) => BrandsViewModel(context),
          child: _BrandsDialog(
            selectedBrands: selectedBrands,
            minPrice: minPrice,
            maxPrice: maxPrice,
            selectedCategories: selectedCategories,
            onApplyFilters: (searchModel) {
              setState(() {
                selectedBrands = searchModel.brands ?? [];
              });
              applyFilters();
            },
          ),
        );
      },
    );
  }

  void _showPriceDialogBox(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return PriceDialog(
          minPrice: minPrice,
          maxPrice: maxPrice,
          selectedBrands: selectedBrands,
          selectedCategories: selectedCategories,
          onApplyFilters: (searchModel) {
            setState(() {
              minPrice = searchModel.price!.min;
              maxPrice = searchModel.price!.max;
            });
            applyFilters();
          },
        );
      },
    );
  }

  void _showCategoryDialogBox(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return ChangeNotifierProvider(
          create: (_) => CategoriesViewModel(context),
          child: _CategoryDialog(
            selectedCategories: selectedCategories,
            minPrice: minPrice,
            maxPrice: maxPrice,
            selectedBrands: selectedBrands,
            onApplyFilters: (searchModel) {
              setState(() {
                selectedCategories = searchModel.categories ?? [];
              });
              applyFilters();
            },
          ),
        );
      },
    );
  }

  void applyFilters() {
    final searchModel = SearchModel(
      brands: selectedBrands,
      categories: selectedCategories,
      price: Price(min: minPrice, max: maxPrice),
    );

    if (widget.onApplyFilters != null) {
      widget.onApplyFilters!(searchModel);
    }
  }
}

class _BrandsDialog extends StatefulWidget {
  final List<String> selectedBrands;
  final List<String> selectedCategories;
  final String minPrice;
  final String maxPrice;
  final Function(SearchModel) onApplyFilters;

  const _BrandsDialog({
    required this.selectedBrands,
    required this.onApplyFilters,
    required this.selectedCategories,
    required this.minPrice,
    required this.maxPrice,
  });

  @override
  State<_BrandsDialog> createState() => _BrandsDialogState();
}

class _BrandsDialogState extends State<_BrandsDialog> {
  List<String> selectedBrands = [];

  void _onSelectionChanged(List<String> newSelectedBrands) {
    setState(() {
      selectedBrands = newSelectedBrands;
    });
  }

  @override
  void initState() {
    super.initState();
    selectedBrands = widget.selectedBrands;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<BrandsViewModel, ProductFilterViewModel>(
      builder: (context, viewModel, productFilterViewModel, child) {
        return SimpleDialog(
          contentPadding: const EdgeInsets.all(15),
          elevation: 2,
          children: [
            TextFormField(
              controller: viewModel.brandSearchController,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.all(1),
                prefixIcon: const Icon(Icons.search),
                hintText: "Search Brands",
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
            ),
            viewModel.vendorsList.isNotEmpty
                ? viewModel.matchQuery.isEmpty
                    ? const Center(child: Text("No categories found"))
                    : BrandListWidget(
                        listOfBrands: viewModel.matchQuery,
                        onSelectionChanged: _onSelectionChanged,
                      )
                : const Center(
                    heightFactor: 2, child: CircularProgressIndicator()),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      widget.selectedBrands.clear();
                      _onSelectionChanged([]);
                      Navigator.pop(context);
                    });
                  },
                  child: const Text("Clear"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  onPressed: () {
                    final searchModel = SearchModel(
                      price: Price(min: widget.minPrice, max: widget.maxPrice),
                      categories: widget.selectedCategories,
                      brands: selectedBrands,
                    );
                    widget.onApplyFilters(searchModel);
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Done",
                    style: AppStyles.regularText.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

// Similarly modify _PriceDialog and _CategoryDialog

class PriceDialog extends StatefulWidget {
  final List<String> selectedBrands;
  final List<String> selectedCategories;
  final String minPrice;
  final String maxPrice;
  final Function(SearchModel) onApplyFilters;

  const PriceDialog({
    super.key,
    required this.minPrice,
    required this.maxPrice,
    required this.onApplyFilters,
    required this.selectedBrands,
    required this.selectedCategories,
  });

  @override
  State<PriceDialog> createState() => PriceDialogState();
}

class PriceDialogState extends State<PriceDialog> {
  late TextEditingController minRangeController;
  late TextEditingController maxRangeController;
  @override
  void initState() {
    super.initState();
    maxRangeController = TextEditingController(text: widget.maxPrice);
    minRangeController = TextEditingController(text: widget.minPrice);
  }

  @override
  void dispose() {
    maxRangeController.dispose();
    minRangeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double textFieldHeight = 40;
    double textFieldWidth = 100;

    return Consumer<ProductFilterViewModel>(
      builder: (context, productFilterViewModel, child) => SimpleDialog(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "Min",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                "Max",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                  height: textFieldHeight,
                  width: textFieldWidth,
                  child: PriceRangeTextfieldWidget(
                    rangeController: minRangeController,
                  )),
              const Text("-"),
              SizedBox(
                height: textFieldHeight,
                width: textFieldWidth,
                child: PriceRangeTextfieldWidget(
                  rangeController: maxRangeController,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              OutlinedButton(
                  onPressed: () {
                    minRangeController.clear();
                    maxRangeController.clear();
                    Navigator.pop(context);
                  },
                  child: const Text("Clear")),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black), //Modified
                  onPressed: () {
                    final searchModel = SearchModel(
                      brands: widget.selectedBrands,
                      categories: widget.selectedCategories,
                      price: Price(
                          min: minRangeController.text,
                          max: maxRangeController
                              .text), // This would be set in the price dialog
                    );
                    widget.onApplyFilters(searchModel);
                    debugPrint(searchModel.price!.max.toString());
                    debugPrint(searchModel.price!.min.toString());
                    //    WidgetsBinding.instance.addPostFrameCallback((_) {
                    //   productFilterViewModel
                    //       .filterProductsByMultipleStoresAndCategories(
                    //           storeNames: widget.selectedBrands,
                    //           categoryNames: widget.selectedCategories,
                    //           minPrice: double.parse(searchModel.price!.min),
                    //           maxPrice: double.parse(searchModel.price!.max));
                    // });
                    Navigator.pop(context);
                  },
                  child: Text("Done",
                      style:
                          AppStyles.regularText.copyWith(color: Colors.white)))
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryDialog extends StatefulWidget {
  final Function(SearchModel) onApplyFilters;
  final List<String> selectedBrands;
  final List<String> selectedCategories;
  final String minPrice;
  final String maxPrice;

  const _CategoryDialog({
    required this.onApplyFilters,
    required this.selectedCategories,
    required this.selectedBrands,
    required this.minPrice,
    required this.maxPrice,
  });

  @override
  State<_CategoryDialog> createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<_CategoryDialog> {
  List<String> selectedCategories = [];

  void _onSelectionChanged(List<String> newSelectedBrands) {
    setState(() {
      selectedCategories = newSelectedBrands;
    });
  }

  @override
  void initState() {
    super.initState();
    selectedCategories = widget.selectedCategories;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<CategoriesViewModel, ProductFilterViewModel>(
      builder: (context, viewModel, productFilterViewModel, child) {
        return SimpleDialog(
          contentPadding: const EdgeInsets.all(15),
          elevation: 2,
          children: [
            TextFormField(
              controller: viewModel.categorySearchController,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.all(1),
                prefixIcon: const Icon(Icons.search),
                hintText: "Search Categories",
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
            ),
            viewModel.categoryList.isNotEmpty
                ? viewModel.matchQuery.isEmpty
                    ? const Center(child: Text("No categories found"))
                    : CategoryListWidget(
                      listOfCategories: viewModel.matchQuery,
                      onSelectionChanged: _onSelectionChanged,
                    )
                : const Center(
                    heightFactor: 2, child: CircularProgressIndicator()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OutlinedButton(
                  onPressed: () {
                    viewModel.categorySearchController.clear();
                    Navigator.pop(context);
                  },
                  child: const Text("Clear"),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black), //Modified
                    onPressed: () {
                      final searchModel = SearchModel(
                        price:
                            Price(min: widget.minPrice, max: widget.maxPrice),
                        categories: selectedCategories,
                      );
                      widget.onApplyFilters(searchModel);
                      debugPrint(searchModel.categories.toString());
                      //     WidgetsBinding.instance.addPostFrameCallback((_) {
                      //   productFilterViewModel
                      //       .filterProductsByMultipleStoresAndCategories(
                      //           storeNames: widget.selectedBrands,
                      //           categoryNames: widget.selectedCategories,
                      //           minPrice: double.parse(searchModel.price!.min),
                      //           maxPrice: double.parse(searchModel.price!.max));
                      // });
                      Navigator.pop(context);
                    },
                    child: Text("Done",
                        style: AppStyles.regularText
                            .copyWith(color: Colors.white))),
              ],
            ),
          ],
        );
      },
    );
  }
}
