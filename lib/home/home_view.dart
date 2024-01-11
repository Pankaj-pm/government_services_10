import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:government_services/home/home_provider.dart';
import 'package:government_services/home/my_web_view.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<NetProvider>(
          builder: (context, np, child) {
            return Text("Internet ${np.isNet}");
          },
        ),
      ),
      body: OverflowBar(
        alignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          TextButton(
              child: const Text('Google'),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyWebView(url: "https://www.google.com/"),
                    ));
              }),
          TextButton(child: const Text('Youtube'), onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyWebView(url: "https://www.youtube.com/"),
                ));
          }),
          TextButton(child: const Text('pub'), onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyWebView(url: "https://www.pub.dev/"),
                ));
          }),

        ],
      ),
      bottomNavigationBar: Consumer<NetProvider>(builder: (context, netProvider, val) {
        if (netProvider.connectivityResult == ConnectivityResult.wifi ||
            netProvider.connectivityResult == ConnectivityResult.mobile) {
          return SizedBox.shrink();
        } else {
          return Container(
            color: Colors.red,
            width: double.infinity,
            height: 40,
            padding: EdgeInsets.all(8),
            child: Center(
                child: Text(
              "No Connection..",
              style: TextStyle(color: Colors.white),
            )),
          );
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var checkConnectivity = await Connectivity().checkConnectivity();
          print(checkConnectivity);
          if (checkConnectivity == ConnectivityResult.mobile || checkConnectivity == ConnectivityResult.wifi) {
            Provider.of<NetProvider>(context, listen: false).changeNetConnection(true);
          } else {
            Provider.of<NetProvider>(context, listen: false).changeNetConnection(false);
          }
        },
      ),
    );
  }
}

// bottomNavigationBar: StreamBuilder<ConnectivityResult>(
//     stream: Connectivity().onConnectivityChanged,
//     builder: (context, snapshot) {
//       if (snapshot.data == ConnectivityResult.wifi || snapshot.data == ConnectivityResult.mobile) {
//         return SizedBox.shrink();
//       } else {
//         return Container(
//           color: Colors.red,
//           width: double.infinity,
//           height: 40,
//           padding: EdgeInsets.all(8),
//           child: Center(
//               child: Text(
//             "No Connection..",
//             style: TextStyle(color: Colors.white),
//           )),
//         );
//       }
//     }),

/*
StreamBuilder<ConnectivityResult>(
                stream: Connectivity().onConnectivityChanged,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var res = snapshot.data;
                    return Text("Connection $res");
                  } else {
                    return Text("no Connection Data");
                  }
                }),
* */
