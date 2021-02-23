import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroypt/constants/keys.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    print('got here');
    myData = result[0];
    setState(() {
      print(myData);
    });
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
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 50.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.menu,
                        color: Colors.black,
                      ),
                      Icon(
                        Icons.search,
                        color: Colors.black,
                      )
                    ],
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Your Wallet',
                          style: GoogleFonts.spaceMono(
                              fontSize: 28, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                    height: height * 0.25,
                    width: width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        gradient: LinearGradient(colors: [
                          Color(0xFF28313B),
                          Color(0xFF485461),
                        ]),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey[300],
                              offset: Offset(2, 10),
                              blurRadius: 10)
                        ]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SvgPicture.asset('assets/Group.svg'),
                            SvgPicture.asset('assets/Logo.svg')
                          ],
                        ),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Heropyt',
                                    style: GoogleFonts.spaceMono(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Krish Bhanushali',
                                    style: GoogleFonts.spaceMono(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Balance',
                                    style: GoogleFonts.spaceMono(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('\$$myData',
                                    style: GoogleFonts.spaceMono(
                                        color: Colors.white,
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Transactions',
                          style: GoogleFonts.spaceMono(
                              fontSize: 28, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Container(
                              padding: EdgeInsets.all(18.0),
                              height: height * 0.08,
                              decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0))),
                              child: SvgPicture.asset('assets/Group.svg'),
                            )),
                        SizedBox(
                          width: 20.0,
                        ),
                        Expanded(
                            flex: 4,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('HPT',
                                        style: GoogleFonts.spaceMono(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    Text('-\$200',
                                        style: GoogleFonts.spaceMono(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Withdraw',
                                        style: GoogleFonts.spaceMono(
                                            color: Colors.grey,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold)),
                                    Text('29 Oct. 12:07',
                                        style: GoogleFonts.spaceMono(
                                            color: Colors.grey,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                )
                              ],
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.only(left: 30.0, right: 30.0, bottom: 20.0),
                height: height * 0.2,
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          offset: Offset(1, -1),
                          blurRadius: 10),
                    ],
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('${sliderValue.round()}',
                        style: GoogleFonts.spaceMono(
                            fontSize: 12, fontWeight: FontWeight.bold)),
                    Slider(
                        value: sliderValue,
                        max: 100,
                        min: 0,
                        onChanged: (value) {
                          setState(() {
                            sliderValue = value;
                          });
                        }),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                            flex: 2,
                            child: GestureDetector(
                              onTap: () {
                                getBalance(myAddress);
                              },
                              child: Container(
                                height: 50.0,
                                child: Center(
                                  child: Text('Refresh',
                                      style: GoogleFonts.spaceMono(
                                          color: Colors.white, fontSize: 12)),
                                ),
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey[300],
                                          offset: Offset(2, 10),
                                          blurRadius: 10)
                                    ],
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(15.0))),
                              ),
                            )),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                            flex: 2,
                            child: GestureDetector(
                              onTap: () async {
                                await sendCoin();
                                setState(() {});
                                await getBalance(myAddress);
                                setState(() {});
                              },
                              child: Container(
                                height: 50.0,
                                child: Center(
                                  child: Text('Deposit',
                                      style: GoogleFonts.spaceMono(
                                          color: Colors.white, fontSize: 12)),
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(15.0))),
                              ),
                            )),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                            flex: 2,
                            child: GestureDetector(
                              onTap: () async {
                                await withdrawCoin();
                                getBalance(myAddress);
                                setState(() {});
                              },
                              child: Container(
                                height: 50.0,
                                child: Center(
                                  child: Text('Withdraw',
                                      style: GoogleFonts.spaceMono(
                                          color: Colors.white, fontSize: 12)),
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.pink,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(15.0))),
                              ),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
