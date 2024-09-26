import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:payment/upi_app.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String body = "";
  String callback = "flutterDemoApp";
  String checksum = "";

  Map<String, String> headers = {};
  List<String> environmentList = <String>['SANDBOX', 'PRODUCTION'];
  bool enableLogs = true;
  Object? result;
  String environmentValue = 'SANDBOX';
  String appId = "";
  String merchantId = "";
  String packageName = "com.phonepe.simulator";

  void initPhonePeSdk() {
    PhonePePaymentSdk.init(environmentValue, appId, merchantId, enableLogs)
        .then((isInitialized) => {
              setState(() {
                result = 'PhonePe SDK Initialized - $isInitialized';
              })
            })
        .catchError((error) {
      handleError(error);
      return <dynamic>{};
    });
  }

  void isPhonePeInstalled() {
    PhonePePaymentSdk.isPhonePeInstalled()
        .then((isPhonePeInstalled) => {
              setState(() {
                result = 'PhonePe Installed - $isPhonePeInstalled';
              })
            })
        .catchError((error) {
      handleError(error);
      return <dynamic>{};
    });
  }

  void isGpayInstalled() {
    PhonePePaymentSdk.isGPayAppInstalled()
        .then((isGpayInstalled) => {
              setState(() {
                result = 'GPay Installed - $isGpayInstalled';
              })
            })
        .catchError((error) {
      handleError(error);
      return <dynamic>{};
    });
  }

  void isPaytmInstalled() {
    PhonePePaymentSdk.isPaytmAppInstalled()
        .then((isPaytmInstalled) => {
              setState(() {
                result = 'Paytm Installed - $isPaytmInstalled';
              })
            })
        .catchError((error) {
      handleError(error);
      return <dynamic>{};
    });
  }

  void getPackageSignatureForAndroid() {
    if (Platform.isAndroid) {
      PhonePePaymentSdk.getPackageSignatureForAndroid()
          .then((packageSignature) => {
                setState(() {
                  result = 'getPackageSignatureForAndroid - $packageSignature';
                })
              })
          .catchError((error) {
        handleError(error);
        return <dynamic>{};
      });
    }
  }

  void getInstalledUpiAppsForiOS() {
    if (Platform.isIOS) {
      PhonePePaymentSdk.getInstalledUpiAppsForiOS()
          .then((apps) => {
                setState(() {
                  result = 'getUPIAppsInstalledForIOS - $apps';

                  // For Usage
                  List<String> stringList = apps
                          ?.whereType<
                              String>() // Filters out null and non-String elements
                          .toList() ??
                      [];

                  // Check if the string value 'Orange' exists in the filtered list
                  String searchString = 'PHONEPE';
                  bool isStringExist = stringList.contains(searchString);

                  if (isStringExist) {
                    print('$searchString app exist in the device.');
                  } else {
                    print('$searchString app does not exist in the list.');
                  }
                })
              })
          .catchError((error) {
        handleError(error);
        return <dynamic>{};
      });
    }
  }

  void getInstalledApps() {
    if (Platform.isAndroid) {
      getInstalledUpiAppsForAndroid();
    } else {
      getInstalledUpiAppsForiOS();
    }
  }

  void getInstalledUpiAppsForAndroid() {
    PhonePePaymentSdk.getInstalledUpiAppsForAndroid()
        .then((apps) => {
              setState(() {
                if (apps != null) {
                  Iterable l = json.decode(apps);
                  List<UPIApp> upiApps = List<UPIApp>.from(
                      l.map((model) => UPIApp.fromJson(model)));
                  String appString = '';
                  for (var element in upiApps) {
                    appString +=
                        "${element.applicationName} ${element.version} ${element.packageName}";
                  }
                  result = 'Installed Upi Apps - $appString';
                } else {
                  result = 'Installed Upi Apps - 0';
                }
              })
            })
        .catchError((error) {
      handleError(error);
      return <dynamic>{};
    });
  }

  void startTransaction() async {
    try {
      PhonePePaymentSdk.startTransaction(body, callback, checksum, packageName)
          .then((response) => {
                setState(() {
                  if (response != null) {
                    String status = response['status'].toString();
                    String error = response['error'].toString();
                    if (status == 'SUCCESS') {
                      result = "Flow Completed - Status: Success!";
                    } else {
                      result =
                          "Flow Completed - Status: $status and Error: $error";
                    }
                  } else {
                    result = "Flow Incomplete";
                  }
                })
              })
          .catchError((error) {
        handleError(error);
        return <dynamic>{};
      });
    } catch (error) {
      handleError(error);
    }
  }

  void handleError(error) {
    setState(() {
      if (error is Exception) {
        result = error.toString();
      } else {
        result = {"error": error};
      }
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;

      // Check if the counter is a multiple of 10
      if (_counter % 10 == 0) {
        // Show a dialog to ask the user to pay
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Payment Required'),
            content: const Text('Please make a payment.'),
            actions: [
              TextButton(
                onPressed: () {
                  // Close the dialog
                  startTransaction();
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
