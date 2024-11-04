// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:swipe_cards/swipe_cards.dart';

// import 'package:video_player/video_player.dart';

// enum MediaType { image, video }

// class MediaItem {
//   final List<String> urls; // List of URLs for horizontal swiping
//   final MediaType type;

//   MediaItem({
//     required this.urls,
//     required this.type,
//   });
// }

// class VideoPlayerWidget extends StatefulWidget {
//   final String url;

//   const VideoPlayerWidget({super.key, required this.url});

//   @override
//   // ignore: library_private_types_in_public_api
//   _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
// }

// class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
//   late VideoPlayerController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));
//     _controller.initialize().then((_) {
//       setState(() {
//         _controller.pause();
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _controller.value.isInitialized
//         ? AspectRatio(
//             aspectRatio: _controller.value.aspectRatio,
//             child: Stack(children: [
//               VideoPlayer(_controller),
//               Align(
//                 alignment: Alignment.center,
//                 child: IconButton(
//                     onPressed: () {
//                       setState(() {
//                         _controller.value.isPlaying
//                             ? _controller.pause()
//                             : _controller.play();
//                       });
//                     },
//                     icon: _controller.value.isPlaying
//                         ? const Text("")
//                         : const Icon(
//                             Icons.play_arrow_rounded,
//                             size: 65,
//                             color: Color.fromARGB(193, 115, 115, 115),
//                           )),
//               ),
//             ]))
//         : const Text("");
//   }
// }

// class SwipeableMediaItem extends StatelessWidget {
//   final MediaItem item;

//   const SwipeableMediaItem({super.key, required this.item});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onDoubleTap: () {
//         // showPopup(context, "Wishlist");
//       },
//       onTap: () {
//         // showPopup(context, "Details");
//       },
//       child: PageView.builder(
//         scrollDirection: Axis.vertical,
//         itemCount: item.urls.length,
//         itemBuilder: (context, index) {
//           return item.type == MediaType.image
//               ? Image.network(item.urls[index], fit: BoxFit.cover)
//               : VideoPlayerWidget(url: item.urls[index]);
//         },
//       ),
//     );
//   }
// }

// class ReelScreen extends StatefulWidget {
//   final List<MediaItem> items;
//   const ReelScreen({
//     super.key,
//     required this.items,
//   });
//   @override
//   State<ReelScreen> createState() => _ReelScreenState();
// }

// class _ReelScreenState extends State<ReelScreen> {
//   late List<SwipeItem> _swipeItems;
//   late MatchEngine _matchEngine;
//   late List<MediaItem> originalItems;

//   @override
//   void initState() {
//     super.initState();
//     originalItems = widget.items;
//     _swipeItems = _generateSwipeItems(widget.items);

//     _matchEngine = MatchEngine(swipeItems: _swipeItems);
//   }

//   List<SwipeItem> _generateSwipeItems(List<MediaItem> items) {
//     return items.map((item) {
//       return SwipeItem(
//         content: SwipeableMediaItem(item: item),
//         likeAction: () {
//           // showPopup(context, "Cart");
//         },
//         nopeAction: () {},
//         superlikeAction: () {},
//       );
//     }).toList();
//   }

//   void _refillSwipeItems() {
//     setState(() {
//       _swipeItems.addAll(_generateSwipeItems(originalItems));
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SizedBox(
//         width: double.infinity,
//         height: MediaQuery.of(context).size.height,
//         child: Center(
//           child: SwipeCards(
//             upSwipeAllowed: true,
//             fillSpace: true,
//             matchEngine: _matchEngine,
//             itemBuilder: (BuildContext context, int index) {
//               return _swipeItems[index].content;
//             },
//             onStackFinished: () {
//               _refillSwipeItems();
//             },
//             itemChanged: (SwipeItem item, int index) {
//               if (kDebugMode) {
//                 print("Item changed: ${item.content}");
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

// // void showPopup(BuildContext context, String message) {
// //   showDialog(
// //     context: context,
// //     builder: (BuildContext context) {
// //       Future.delayed(const Duration(seconds: 1), () {
// //         Navigator.of(context).pop(true);
// //       });
// //       return AlertDialog(
// //         title: const Text('Popup'),
// //         content: Text(message),
// //       );
// //     },
// //   );
// // }


// // MediaItem(
// //                 id: "1",
// //                 urls: [
// //                   'https://assets.ajio.com/medias/sys_master/root/20230808/LYRE/64d14ea9eebac147fcb0c892/-1117Wx1400H-466431240-black-MODEL.jpg'
// //                 ],
// //                 type: MediaType.image),
// //             MediaItem(
// //                 id: "2",
// //                 urls: [
// //                   'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4'
// //                 ],
// //                 type: MediaType.video),
// //             MediaItem(
// //                 id: "3",
// //                 urls: [
// //                   'https://assets.ajio.com/medias/sys_master/root/20230808/LYRE/64d14ea9eebac147fcb0c892/-1117Wx1400H-466431240-black-MODEL.jpg'
// //                 ],
// //                 type: MediaType.image),
// //             MediaItem(
// //                 id: "2",
// //                 urls: [
// //                   'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4'
// //                 ],
// //                 type: MediaType.video),
// //             MediaItem(
// //                 id: "3",
// //                 urls: [
// //                   'https://assets.ajio.com/medias/sys_master/root/20230808/LYRE/64d14ea9eebac147fcb0c892/-1117Wx1400H-466431240-black-MODEL.jpg'
// //                 ],
// //                 type: MediaType.image),
// //             MediaItem(
// //                 id: "4",
// //                 urls: [
// //                   'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4'
// //                 ],
// //                 type: MediaType.video),
// //             MediaItem(
// //                 id: "5",
// //                 urls: [
// //                   'https://assets.ajio.com/medias/sys_master/root/20230808/LYRE/64d14ea9eebac147fcb0c892/-1117Wx1400H-466431240-black-MODEL.jpg'
// //                 ],
// //                 type: MediaType.image),