import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialShareClass {
// Share with all the platforms...
  shareProductDetails(String productName, String imageUrl, String storeName,
      String price, String storeOwnerName) {
    Share.share(
      "Hey, just have a look on this amazing product $productName from $storeName by $storeOwnerName at just Rs.$price.\n** For more such products download our app MAMBO! from google Playstore.**\n$imageUrl",
    );
  }

  SocialShare(String content) {
    Share.share(content);
  }

  // Function to open Instagram profile
  Future<void> openInstagramProfile(String username) async {
    final url = 'https://www.instagram.com/$username/';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      debugPrint('Could not launch $url');
    }
  }

  Future<void> sendWhatsAppMessage(String phoneNumber, String message) async {
    // Construct the URL for WhatsApp
    final String url =
        "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}";

    // Parse the URL
    final Uri uri = Uri.parse(url);

    // Check if the device can launch the URL
    if (await canLaunchUrl(uri)) {
      // Launch the URL
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  // Function to send an email
  Future<void> sendEmail(String toEmail, String subject, String body) async {
    final url =
        'mailto:$toEmail?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      debugPrint('Could not launch $url');
    }
  }
}
