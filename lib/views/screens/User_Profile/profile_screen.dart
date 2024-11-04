import 'package:flutter/material.dart';
import 'package:mambo/utils/Reusable_widgets/app.snackBar.dart';
import 'package:mambo/utils/Reusable_widgets/custom_textfield.dart';
import 'package:provider/provider.dart';
import '../../../utils/app.styles.dart';
import '../../../view models/user_profile_view_modal.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProfileProvider>(context, listen: false)
          .fetchUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProfileProvider = Provider.of<UserProfileProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Profile',
        ),
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_ios,
            size: AppStyles.backIconSize,
          ),
        ),
        automaticallyImplyLeading: true,
      ),
      body: userProfileProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: GlobalKey<FormState>(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    CustomTextField(
                      labelText: 'Full Name',
                      controller: userProfileProvider.nameController,
                      onChanged: (_) => userProfileProvider.checkIfEditing(),
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      labelText: 'Email',
                      controller: userProfileProvider.emailController,
                      onChanged: (_) => userProfileProvider.checkIfEditing(),
                      readOnly: true,
                      onTap: () =>
                          customSnackBar(context, 'Email Cannot be edit.'),
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      labelText: 'Phone',
                      controller: userProfileProvider.phoneController,
                      onChanged: (_) => userProfileProvider.checkIfEditing(),
                      wantValidator: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return null;
                        }

                        // Regular expression for phone number validation (assuming a 10-digit US phone number format)
                        final phoneRegExp = RegExp(r'^\d{10}$');

                        if (!phoneRegExp.hasMatch(value)) {
                          return 'Invalid phone number format (10 digits required).';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      labelText: 'Date of Birth',
                      controller: userProfileProvider.dobController,
                      readOnly: true,
                      onTap: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            userProfileProvider.dobController.text =
                                "${pickedDate.toLocal()}".split(' ')[0];
                            userProfileProvider.checkIfEditing();
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButtonFormField<String>(
                        value: userProfileProvider.selectedGender,
                        dropdownColor: Colors.white,
                        decoration: InputDecoration(
                          labelText: 'Gender',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 2.0,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 2.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 2.0,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 2.0,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 2.0,
                            ),
                          ),
                        ),
                        items: ['Male', 'Female', 'Others', 'Prefer Not to say']
                            .map((gender) => DropdownMenuItem(
                                  value: gender,
                                  child: Text(gender),
                                ))
                            .toList(),
                        onChanged: (value) {
                          userProfileProvider.selectedGender = value;
                          userProfileProvider.checkIfEditing();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: BottomAppBar(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepOrange,
          ),
          onPressed: userProfileProvider.isEditing
              ? () async {
                  await userProfileProvider.updateUserProfile();
                  Navigator.pop(context);
                  customSnackBar(context, 'Profile Updated Successfully');
                }
              : null,
          child: userProfileProvider.isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
                  'Save Changes',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                ),
        ),
      ),
    );
  }
}
