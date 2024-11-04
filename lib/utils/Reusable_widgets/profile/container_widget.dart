// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class ContainerWidget extends StatelessWidget {
  String data;
  Function() onTap;
  IconData iconData;
  ContainerWidget({
    Key? key,
    required this.data,
    required this.onTap,
    required this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          decoration:
              const BoxDecoration(color: Color.fromARGB(0, 158, 158, 158)),
          height: MediaQuery.of(context).size.height * 0.04,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(iconData),
                  const SizedBox(width: 15),
                  Text(
                    data,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Color.fromARGB(182, 80, 80, 80),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
