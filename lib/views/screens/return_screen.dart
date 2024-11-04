// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mambo/routes/app.nameRoutes.dart';
import 'package:provider/provider.dart';

import 'package:mambo/utils/app.colors.dart';
import 'package:mambo/utils/app.styles.dart';
import 'package:mambo/view%20models/address_view_model.dart';
import 'package:mambo/view%20models/return_request_view_model.dart';

class ReturnScreen extends StatefulWidget {
  final String productID; // ID of the product being returned
  final String orderID;   // ID of the order containing the product
  final String productName; // Name of the product being returned

  const ReturnScreen({
    super.key,
    required this.productID,
    required this.orderID,
    required this.productName,
  });

  @override
  State<ReturnScreen> createState() => _ReturnScreenState();
}

class _ReturnScreenState extends State<ReturnScreen> {
  @override
  void initState() {
    super.initState();
    FirebaseAuth auth = FirebaseAuth.instance;

    // Fetch user addresses after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AddressViewModel>(context, listen: false)
          .getUerAddresses(auth.currentUser!.email!);
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController reasonFieldController = TextEditingController();
    FocusNode reasonFocus = FocusNode();

    // Displays a confirmation dialog upon successful return request
    void showConfirmationDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Our team will investigate the issue and get back to you as soon as possible.",
                  textAlign: TextAlign.center,
                  style: AppStyles.semiBoldText.copyWith(fontSize: 15),
                ),
                const SizedBox(height: 20.0),
                Text(
                  "Thank you for your patience  : )",
                  textAlign: TextAlign.center,
                  style: AppStyles.semiBoldText,
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                  width: 100,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, RoutesName.pastOrder);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80.0),
                        side: const BorderSide(color: Colors.black),
                      ),
                    ),
                    child: const Text(
                      "Okay",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Request a return",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              size: AppStyles.backIconSize, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          // Dismiss keyboard when tapping outside text field
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Input field for return reason
                const Text(
                  "Reason for return",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 90, 90, 90)),
                ),
                const SizedBox(height: 8.0),
                TextField(
                  controller: reasonFieldController,
                  focusNode: reasonFocus,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Tell us why are you returning the order?',
                    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.black38),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                
                // Container for future widgets or spacing
                const SizedBox(height: 8.0),
                Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                ),
                const SizedBox(height: 100),
                
                // Submit button for the return request
                SizedBox(
                  width: double.maxFinite,
                  child: Center(
                    child: SizedBox(
                      width: 200,
                      child: Consumer<ReturnRequestViewModel>(
                          builder: (context, value, child) {
                        if (value.isLoading) {
                          return const Center(
                              child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ));
                        }
                        return ElevatedButton(
                          onPressed: () async {
                            await value
                                .requestReturn(
                                    widget.orderID,
                                    "Customer requested a return for the Product: ${widget.productName} & OrderID: ${widget.orderID}.\n Reason: ${reasonFieldController.text}",
                                    "return-requested")
                                .then((_) {
                              showConfirmationDialog(context);
                            });
                            // Handle submit action
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(80.0),
                            ),
                          ),
                          child: const Text("Submit",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white)),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
