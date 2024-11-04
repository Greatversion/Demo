import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mambo/providers/online_connectivity_provider.dart';
import 'package:mambo/routes/app.nameRoutes.dart';
import 'package:mambo/utils/Error%20Messages/error_widget.dart';
import 'package:mambo/utils/app.colors.dart';
import 'package:mambo/utils/app.styles.dart';
import 'package:mambo/view%20models/address_view_model.dart';
import 'package:provider/provider.dart';

/// The `AddressScreen` class is a StatefulWidget that displays the user's saved addresses.
/// It allows users to view, delete, or add new addresses.
class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  ErrorMessages errorMessages = ErrorMessages();

  @override
  void initState() {
    super.initState();
    // Initialize the screen by fetching user addresses.
    // This action is performed after the widget has been built to ensure context is available.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FirebaseAuth auth = FirebaseAuth.instance;
      Provider.of<AddressViewModel>(context, listen: false)
          .getUerAddresses(auth.currentUser!.email!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
          child: Icon(
            Icons.arrow_back_ios,
            size: AppStyles.backIconSize, // Size of the back arrow icon
          ),
        ),
        centerTitle: true,
        title: const Text("Saved Addresses",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400)

            // Title of the screen
            // Text style for the title
            ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Expanded(
              child: Consumer<AddressViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.isLoading) {
                    // Display a loading indicator while addresses are being fetched
                    return const Center(child: CircularProgressIndicator());
                  } else if (viewModel.errorMessage.isNotEmpty) {
                    // Display error message if there is an issue fetching addresses
                    return Center(child: Text(viewModel.errorMessage));
                  } else if (viewModel.usersavedAddresses.isEmpty) {
                    // Display an error widget if no addresses are available
                    return Center(
                      child: ErrorDisplayWidget(
                          msg: errorMessages.checkoutAddressPageError().message,
                          desc: errorMessages
                              .checkoutAddressPageError()
                              .description),
                    );
                  } else {
                    // Display the list of saved addresses
                    return ListView.builder(
                      itemCount: viewModel.usersavedAddresses.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: ListTile(
                              selectedColor: AppColors.primary,
                              shape: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  width: 1.5,
                                  color: Color.fromARGB(255, 81, 81, 81),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              title: Text(
                                viewModel.usersavedAddresses[index].name!,
                                style: const TextStyle(
                                  fontWeight: FontWeight
                                      .bold, // Bold text for address name
                                ),
                              ),
                              subtitle: Text(
                                viewModel
                                    .usersavedAddresses[index].localAddress!,
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  // Handle address deletion
                                  viewModel.deleteAddress(
                                      viewModel.usersavedAddresses[index]);
                                  // Update the UI by removing the deleted address from the list
                                  setState(() {
                                    viewModel.usersavedAddresses
                                        .removeAt(index);
                                  });
                                },
                                icon: const Icon(Icons.delete),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            Consumer<ConnectivityService>(
              builder: (context, value, child) => GestureDetector(
                onTap: () {
                  if (value.isOnline) {
                    Navigator.pushNamed(context, RoutesName.addAddress);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        duration: Duration(seconds: 1),
                        content: Text("Please Connect to the Internet")));
                  }
                  // Navigate to the "Add new address" screen
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    height: 40,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(
                          25), // Rounded corners for button
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Center(
                        child: Text(
                          "Add new address", // Button text
                          style: AppStyles.whiteColoredText.copyWith(
                              fontWeight: FontWeight.w500, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
