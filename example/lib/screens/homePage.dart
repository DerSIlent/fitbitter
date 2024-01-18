import 'dart:convert';
import 'dart:math';

import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';

import '../utils/strings.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  static const route = '/';
  static const routename = 'HomePage';

  @override
  Widget build(BuildContext context) {
    print('${HomePage.routename} built');
    return Scaffold(
      appBar: AppBar(
        title: Text(HomePage.routename),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                // Authorize the app and get the Fitbit credentials
                FitbitCredentials? fitbitCredentials =
                    await FitbitConnector.authorize(
                        clientID: Strings.fitbitClientID,
                        clientSecret: Strings.fitbitClientSecret,
                        redirectUri: Strings.fitbitRedirectUri,
                        callbackUrlScheme: Strings.fitbitCallbackScheme,
                        codeChallenge: '', verifier: '');
                print(fitbitCredentials);

                //Instantiate a proper data manager (for example, for SpO2 data)
                FitbitSpO2DataManager fitbitSpO2DataManager =
                    FitbitSpO2DataManager(
                  clientID: Strings.fitbitClientID,
                  clientSecret: Strings.fitbitClientSecret,
                );

                //Fetch yesterday's data
                final spO2Data =
                    await fitbitSpO2DataManager.fetch(FitbitSpO2APIURL.day(
                  date: DateTime.now().subtract(Duration(days: 1)),
                  fitbitCredentials: fitbitCredentials!,
                )) as List<FitbitSpO2Data>;
                print(spO2Data);
                // Use them as you want
                if (spO2Data.isNotEmpty) {
                  final snackBar = SnackBar(
                      content: Text(
                          'Yesterday your SpO2 was ${spO2Data[0].avgValue}% on average!'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              child: Text('Tap to authorize and fetch data'),
            ),
          ],
        ),
      ),
    );
  } //build
} //HomePage



// String generateCodeVerifier() {
//   final random = Random.secure();
//   return List<String>.generate(50, (i) => random.nextInt(9).toString())
//       .join();
// }
//
// String generateCodeChallenge(String codeVerifier) {
//   var bytes = utf8.encode(codeVerifier);
//   var digest = sha256.convert(bytes);
//   String codeChallenge = base64Url.encode(digest.bytes);
//   return codeChallenge.replaceAll('=', '');
// }