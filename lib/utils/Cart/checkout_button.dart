import 'package:flutter/material.dart';
import 'package:mambo/providers/online_connectivity_provider.dart';
import 'package:mambo/routes/app.nameRoutes.dart';
import 'package:mambo/utils/app.styles.dart';
import 'package:provider/provider.dart';
// import 'package:mambo/views/screens/checkout_screen.dart';

class CheckOutButton extends StatefulWidget {
  const CheckOutButton({super.key});

  @override
  State<CheckOutButton> createState() => _CheckOutButtonState();
}

class _CheckOutButtonState extends State<CheckOutButton> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityService>(
      builder: (context, value, child) => GestureDetector(
        onTap: () {
          if (value.isOnline) {
            Navigator.pushNamed(context, RoutesName.checkoutScreen);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                duration: Duration(seconds: 1),
                content: Text("Please Connect to the Internet")));
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
          child: Container(
            height: 40,
            decoration: BoxDecoration(
                color: Colors.black87, borderRadius: BorderRadius.circular(30)),
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              child: Center(
                child: Text(
                  "Continue to checkout",
                  style: AppStyles.whiteColoredText
                      .copyWith(fontWeight: FontWeight.w600, fontSize: 16),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
