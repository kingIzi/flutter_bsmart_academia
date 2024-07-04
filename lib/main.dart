// import 'package:english_words/english_words.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => MyAppState(),
//       child: MaterialApp(
//         title: 'Namer App',
//         theme: ThemeData(
//           useMaterial3: true,
//           colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
//         ),
//         home: MyHomePage(),
//       ),
//     );
//   }
// }

// class MyAppState extends ChangeNotifier {
//   var current = WordPair.random();
//   var favorites = <WordPair>[];
//   void getNext() {
//     current = WordPair.random();
//     notifyListeners();
//   }

//   void toggleFavorite() {
//     if (containsFavorite(current)) {
//       favorites.remove(current);
//     } else {
//       favorites.add(current);
//     }
//     notifyListeners();
//   }

//   bool containsFavorite(WordPair pair) {
//     return favorites.contains(pair);
//   }
// }

// // ...

// class MyHomePage extends StatefulWidget {
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   var selectedIndex = 0;
//   Widget toggleSelectedIndex(int selectedIndex) {
//     Widget page = Placeholder();
//     switch (selectedIndex) {
//       case 0:
//         page = GeneratorPage();
//       case 1:
//         page = FavoritesPage();
//       default:
//         throw UnimplementedError('no widget for $selectedIndex');
//     }
//     return page;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(builder: (context, constraint) {
//       Widget page = toggleSelectedIndex(selectedIndex);
//       return Scaffold(
//         body: Row(
//           children: [
//             SafeArea(
//               child: NavigationRail(
//                 extended: constraint.maxWidth >= 600,
//                 destinations: [
//                   NavigationRailDestination(
//                     icon: Icon(Icons.home),
//                     label: Text('Home'),
//                   ),
//                   NavigationRailDestination(
//                     icon: Icon(Icons.favorite),
//                     label: Text('Favorites'),
//                   ),
//                 ],
//                 selectedIndex: selectedIndex,
//                 onDestinationSelected: (value) {
//                   setState(() {
//                     selectedIndex = value;
//                   });
//                 },
//               ),
//             ),
//             Expanded(
//               child: Container(
//                 color: Theme.of(context).colorScheme.primaryContainer,
//                 child: page,
//               ),
//             ),
//           ],
//         ),
//       );
//     });
//   }
// }

// class GeneratorPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     var appState = context.watch<MyAppState>();
//     var pair = appState.current;

//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           BigCard(pair: pair),
//           SizedBox(height: 10),
//           CardActions(appState: appState),
//         ],
//       ),
//     );
//   }
// }

// class FavoritesPage extends StatelessWidget {
//   const FavoritesPage({
//     super.key,
//   });
//   @override
//   Widget build(BuildContext context) {
//     var appState = context.watch<MyAppState>();
//     return Container(
//         color: Theme.of(context).colorScheme.primaryContainer,
//         child: SafeArea(
//           child: Padding(
//             padding:
//                 const EdgeInsets.only(left: 0, top: 10, right: 10, bottom: 10),
//             child: Column(
//               children: [
//                 const Text(
//                   'Favorites',
//                   style: TextStyle(
//                       fontSize: 32,
//                       fontWeight: FontWeight.bold,
//                       letterSpacing: 2),
//                 ),
//                 for (var item in appState.favorites)
//                   ListTile(
//                     title: Text('${item.first} ${item.second}'),
//                     trailing: IconButton(
//                       onPressed: () {},
//                       icon: const Icon(
//                         Icons.delete_outline,
//                         color: Colors.red,
//                       ),
//                     ),
//                   )
//               ],
//             ),
//           ),
//         ));
//   }
// }

// class CardActions extends StatelessWidget {
//   const CardActions({
//     super.key,
//     required this.appState,
//   });

//   final MyAppState appState;

//   @override
//   Widget build(BuildContext context) {
//     IconData icon = appState.containsFavorite(appState.current)
//         ? Icons.favorite
//         : Icons.favorite_outline;
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         ElevatedButton.icon(
//           onPressed: () {
//             appState.toggleFavorite();
//           },
//           label: const Text('Like'),
//           icon: Icon(icon),
//         ),
//         SizedBox(width: 10),
//         ElevatedButton(
//           child: const Text('Next'),
//           onPressed: () {
//             appState.getNext();
//           },
//         ),
//       ],
//     );
//   }
// }

// class BigCard extends StatelessWidget {
//   const BigCard({
//     super.key,
//     required this.pair,
//   });

//   final WordPair pair;

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final style = theme.textTheme.displayMedium!
//         .copyWith(color: theme.colorScheme.onPrimary);
//     return Card(
//       elevation: 4,
//       color: theme.colorScheme.primary,
//       child: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Text(
//           pair.asSnakeCase,
//           style: style,
//           semanticsLabel: "${pair.first} ${pair.second}",
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:namer_app/core/entities/GetSDetail.dart';
import 'package:namer_app/core/utilities/app_config.dart';
import 'package:namer_app/core/utilities/local_response_model.dart';
import 'package:namer_app/customs/custom_text_fields.dart';
import 'package:namer_app/pages/LoginPage.dart';
import 'package:namer_app/pages/StudentAccountPage.dart';
import 'package:namer_app/services/api/auth_requests.dart';
import 'package:provider/provider.dart';
import 'dart:developer';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:quickalert/quickalert.dart';

void main() {
  runApp(const MyApp());
}

class MyAppState extends ChangeNotifier {
  var loginReqBody = <String, String>{};
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        ),
        home: const LoginPage(),
      ),
    );
  }
}
