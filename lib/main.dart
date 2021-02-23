import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heroypt/constants/keys.dart';
import 'package:heroypt/screens/home_screen.dart';
import 'package:heroypt/screens/onboard_screen.dart';

import 'package:http/http.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:web3dart/web3dart.dart';
import 'constants/keys.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: OnBoardScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Client httpClient;
  Web3Client ethClient;
  bool data = false;
  double sliderValue = 0;
  final myAddress = ImportantKeys.metamaskAccountAddress;
  var myData;
  Future<DeployedContract> loadContract() async {
    String abi = await rootBundle.loadString("assets/abi.json");
    String contactAddress = ImportantKeys.solidityDeployedAddress;
    final contract = DeployedContract(ContractAbi.fromJson(abi, 'Heropyt'),
        EthereumAddress.fromHex(contactAddress));
    return contract;
  }

  Future<String> sendCoin() async {
    var bigAmount = BigInt.from(sliderValue.round());
    var response = await submit("depositBalance", [bigAmount]);
    print(response);
    return response;
  }

  Future<String> withdrawCoin() async {
    var bigAmount = BigInt.from(sliderValue.round());
    var response = await submit("withdrawBalance", [bigAmount]);
    print(response);
    return response;
  }

  Future<List<dynamic>> query(String functionName, List<dynamic> args) async {
    final contract = await loadContract();
    final ethFunction = contract.function(functionName);
    final result = await ethClient.call(
        contract: contract, function: ethFunction, params: args);
    return result;
  }

  Future<String> submit(String functionName, List<dynamic> args) async {
    EthPrivateKey credential =
        EthPrivateKey.fromHex(ImportantKeys.metamaskPrivateKey);

    DeployedContract contract = await loadContract();
    final ethFunction = contract.function(functionName);
    final result = await ethClient.sendTransaction(
        credential,
        Transaction.callContract(
            contract: contract, function: ethFunction, parameters: args),
        fetchChainIdFromNetworkId: true);
    return result;
  }

  Future<void> getBalance(String targetAddress) async {
    //   EthereumAddress address = EthereumAddress.fromHex(targetAddress);
    List<dynamic> result = await query("getBalance", []);
    myData = result[0];
    data = true;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    httpClient = Client();
    ethClient = Web3Client(ImportantKeys.blockchainServerAddress, httpClient);

    getBalance(myAddress);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Vx.gray300,
      body: ZStack([
        VxBox()
            .blue600
            .size(context.screenWidth, context.percentHeight * 30)
            .make(),
        VStack([
          (context.percentHeight * 10).heightBox,
          "\$Heropyt".text.xl4.white.bold.center.makeCentered().py16(),
          (context.percentHeight * 5).heightBox,
          VxBox(
                  child: VStack([
            "Balance".text.gray700.xl2.semiBold.makeCentered(),
            10.heightBox,
            data
                ? "\$${myData}".text.bold.xl6.makeCentered()
                : CircularProgressIndicator().centered()
          ]))
              .p16
              .white
              .size(context.screenWidth, context.percentHeight * 18)
              .rounded
              .shadowXl
              .make()
              .p16(),
          30.heightBox,
          "${sliderValue.round()}".text.bold.makeCentered(),
          Slider(
              value: sliderValue,
              max: 100,
              min: 0,
              onChanged: (value) {
                setState(() {
                  sliderValue = value;
                });
              }).centered(),
          HStack(
            [
              FlatButton.icon(
                      color: Colors.blue,
                      shape: Vx.roundedSm,
                      onPressed: () {
                        getBalance(myAddress);
                      },
                      icon: Icon(Icons.refresh, color: Colors.white),
                      label: "Refresh".text.white.make())
                  .h(50),
              FlatButton.icon(
                      color: Colors.green,
                      shape: Vx.roundedSm,
                      onPressed: () {
                        sendCoin();
                      },
                      icon: Icon(
                        Icons.call_made_outlined,
                        color: Colors.white,
                      ),
                      label: "Deposit".text.white.make())
                  .h(50),
              FlatButton.icon(
                      color: Colors.red,
                      shape: Vx.roundedSm,
                      onPressed: () {
                        withdrawCoin();
                      },
                      icon: Icon(Icons.call_received, color: Colors.white),
                      label: "Withdraw".text.white.make())
                  .h(50),
            ],
            alignment: MainAxisAlignment.spaceAround,
            axisSize: MainAxisSize.max,
          )
        ]).p16()
      ]),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
