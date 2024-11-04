import 'dart:math'; // Importing Dart's math library for generating random numbers
import 'package:flutter/material.dart'; // Importing Flutter's material design library
import 'package:mambo/models/Database%20models/address_model.dart'; // Importing the address model class
import 'package:mambo/routes/app.nameRoutes.dart'; // Importing named routes for navigation
import 'package:mambo/utils/Address/input_fields.dart'; // Importing custom input fields for the address form
import 'package:mambo/utils/app.styles.dart'; // Importing app styles for consistent styling
import 'package:mambo/view%20models/address_view_model.dart'; // Importing the view model for managing address data
import 'package:provider/provider.dart'; // Importing Provider for state management

// StatefulWidget to handle state and form operations
class NewAddressScreen extends StatefulWidget {
  const NewAddressScreen({super.key}); // Constructor for the widget

  @override
  State<NewAddressScreen> createState() =>
      _NewAddressScreenState(); // Creating state for the widget
}

class _NewAddressScreenState extends State<NewAddressScreen> {
  // TextEditingControllers to manage input fields
  TextEditingController address = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController postcode = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController town = TextEditingController();
  final formkey = GlobalKey<FormState>(); // Key to manage form state

  @override
  void dispose() {
    // Disposing of controllers to free up resources
    country.dispose();
    name.dispose();
    postcode.dispose();
    phone.dispose();
    address.dispose();
    town.dispose();
    state.dispose();
    super.dispose(); // Calls the superclass dispose method
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leadingWidth: 0, // Disables the leading widget
        leading: InkWell(
          onTap: () {
            Navigator.pop(
                context); // Pops the current route off the navigator stack
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Icon(
              Icons.arrow_back_ios,
              size: AppStyles.backIconSize, // Custom size for the back icon
            ),
          ),
        ), // Placeholder for the leading widget
        title: const Text(
          "Add new address", // Title text for the AppBar
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w400), // Custom style for the title text
        ),
      ),
      body: SingleChildScrollView(
        // Allows scrolling if content overflows
        child: Consumer<AddressViewModel>(builder: (context, value, child) {
          // Listens to changes in AddressViewModel
          return Padding(
            padding: const EdgeInsets.all(8.0), // Padding around the form
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Aligning children to start
              children: [
                Form(
                  key: formkey, // Key to manage form state
                  child: Column(children: [
                    // Custom input fields for different address attributes
                    StringInput('Country/Region', country),
                    StringInput('Name', name),
                    NumericInput('Phone number', phone),
                    AddressInput(
                        'Flat, house number, building, street, etc ', address),
                    StringInput('Town/City', town),
                    StringInput('State', state),
                    NumericInput('Postcode', postcode),
                    const SizedBox(
                        height: 20), // Spacing between fields and button
                    InkWell(
                      onTap: () {
                        if (formkey.currentState!.validate()) {
                          // Validates the form
                          value
                              .addUserAddress(AddressModel(
                                  name: name.text,
                                  phoneNumber: phone.text,
                                  country: country.text,
                                  state: state.text,
                                  city: town.text,
                                  postcode: postcode.text,
                                  localAddress: address.text,
                                  addressId: Random().nextInt(
                                      10000))) // Creates a new AddressModel with a random ID
                              .then((_) {
                            // Clears all input fields after address is added
                            country.clear();
                            name.clear();
                            phone.clear();
                            address.clear();
                            town.clear();
                            state.clear();
                            postcode.clear();
                            // Navigates to the address list screen after adding the address
                            Navigator.pushReplacementNamed(
                                // ignore: use_build_context_synchronously
                                context, RoutesName.address);
                          });
                        }
                        // Navigator.pushNamed(context, RoutesName.address); // Uncomment for direct navigation without clearing fields
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5), // Padding around button
                        child: Container(
                          height: 40, // Button height
                          width: double
                              .infinity, // Button width spans the entire container
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(
                                  25)), // Custom style for the button
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                                top: 5,
                                bottom: 5), // Inner padding for the button
                            child: Center(
                                child: Text(
                              "Add Address", // Text for the add address button
                              style: AppStyles.whiteColoredText.copyWith(
                                  fontSize: 18,
                                  fontWeight:
                                      FontWeight.w500), // Custom text style
                            )),
                          ),
                        ),
                      ),
                    )
                  ]),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
