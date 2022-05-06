import 'package:braketpay/api_callers/transactions.dart';
import 'package:braketpay/classes/transaction.dart';
import 'package:braketpay/screen/createproduct.dart';
import 'package:braketpay/classes/user.dart';
import 'package:braketpay/screen/createservice.dart';
import 'package:braketpay/screen/utilities.dart';
import 'package:braketpay/uix/transactioncard.dart';
import 'package:braketpay/uix/walletcard.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iconly/iconly.dart';
import 'package:lottie/lottie.dart';

import '../api_callers/contracts.dart';
import '../classes/product_contract.dart';
import '../uix/contractlistcard.dart';
import '../uix/contractmodeselect.dart';
import '../uix/utilitybutton.dart';

class Home extends StatefulWidget {
  Home({Key? key, required this.user, required this.pin}) : super(key: key);

  final User user;
  final String pin;

  @override
  State<Home> createState() => _HomeState();

}

class _HomeState extends State<Home> {
  late Future<List<dynamic>> _contracts = fetchContracts(widget.user.payload!.accountNumber ?? "",
      widget.user.payload!.password ?? "",
      widget.pin);
  late Future<List<dynamic>> _transactions = fetchTransactions(widget.user.payload!.accountNumber ?? "",
    widget.user.payload!.password ?? "",
    widget.pin);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 5,
        toolbarHeight: 65,
        leading: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(20)),
            child: IconButton(
                icon: const Icon(IconlyBold.profile),
                color: Theme.of(context).primaryColor,
                iconSize: 20,
                onPressed: () {}),
          ),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications))
        ],
        title: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hi, ${widget.user.payload!.fullname?.split(' ')[0]}',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
                '@${widget.user.payload!.fullname?.split(' ')[1].toLowerCase()}',
                style: TextStyle(fontSize: 14))
          ],
        ),
      ),
      body: Column(children: [
        SizedBox(
            height: 150,
            width: double.infinity,
            child: CarouselSlider(
              items: [
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: WalletCard(
                      balance: widget.user.payload!.accountBalance.toString(),
                      title: 'Refferal Bonus'),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: WalletCard(
                      balance: widget.user.payload!.accountBalance.toString(),
                      title: 'Braket Wallet'),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: WalletCard(
                      balance: widget.user.payload!.accountBalance.toString(),
                      title: 'Braket Savings'),
                )
              ],
              options: CarouselOptions(
                  enlargeCenterPage: true,
                  initialPage: 1,
                  enableInfiniteScroll: false,
                  viewportFraction: 0.9,
                  enlargeStrategy: CenterPageEnlargeStrategy.height),
            )),
        Expanded(
          child: Container(
              padding: EdgeInsets.only(top: 10),
              margin: EdgeInsets.only(top: 20),
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(29),
                      topRight: Radius.circular(20))),
              child: RefreshIndicator(
                onRefresh: () async {
                  final contracts = await fetchContracts(
                      widget.user.payload!.accountNumber ?? "",
                      widget.user.payload!.password ?? "",
                      widget.pin);
                  final transactions = await fetchTransactions(widget.user.payload!.accountNumber??'', widget.user.payload!.password ?? "",
                      widget.pin);
                  setState(() {
                    _contracts = Future.value(contracts);
                    _transactions = Future.value(transactions);
                  });
                },
                child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Center(
                          child: Container(
                            //  margin: EdgeInsets.only(top: 10),
                            width: 60,
                            height: 5,
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        );
                      } else if (index == 1) {
                        return Container(
                          margin: EdgeInsets.only(top: 10),
                          padding: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 3,
                                  blurRadius: 10,
                                  offset: const Offset(
                                      0, 0), // changes position of shadow
                                ),
                              ]),
                          height: 115,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                UtilityButton(
                                    url: 'assets/saving-money (1).png', text: 'Savings',
                                    
                                    ),
                                UtilityButton(
                                    url: 'assets/qr-code (3).png', text: 'QR Scan'),
                                UtilityButton(
                                    url: 'assets/pay (1).png', text: 'Utilities',
                                    onTap: () {
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (BuildContext context) => Utilities(user: widget.user, pin: widget.pin)));
                                    }
                                    ),
                              ]),
                        );
                      } else if (index == 4) {
                        return Container(
                            margin: EdgeInsets.only(top: 10),
                            height: 320,
                            decoration: const BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40.0),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const Flexible(
                                        child: Text(
                                      'Get Bonus for telling your friends about BraketPay',
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    )),
                                    Image.asset(
                                      'assets/open_gift.png',
                                      height: 200,
                                    ),
                                  ]),
                            ));
                      } else if (index == 2) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                margin: EdgeInsets.all(10),
                                child: Text('Recent contracts',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700))),
                            Container(
                              height: 420,
                              child: FutureBuilder<List>(
                                future: _contracts,
                                builder: (context, snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.none:
                                    case ConnectionState.waiting:
                                    case ConnectionState.active:
                                      {
                                        return Container(
                                            decoration: const BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top: Radius.circular(20),
                                                      bottom: Radius.zero),
                                              color: Colors.white,
                                            ),
                                            child: Center(
                                                child: Text(
                                                    "Loading your Contracts!")));
                                      }
                                    case ConnectionState.done:
                                      {
                                        if (snapshot.hasData) {
                                          return snapshot.data!.length > 0 ? ListView.builder(
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount: snapshot.data!.length > 0 ? snapshot.data!.length : 0,
                                              itemBuilder: (context, index) {
                                                ProductContract product =
                                                    snapshot.data![index];
                                                return ContractListCard(
                                                    product: product, pin: widget.pin, user: widget.user);
                                              }) : Center(child: Text('You have not created any contract!'),);
                                        } else if (snapshot.hasError) {
                                          return Container(
                                              decoration: const BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                        top:
                                                            Radius.circular(20),
                                                        bottom: Radius.zero),
                                                color: Colors.white,
                                              ),
                                              child: Center(
                                                  child: Column(
                                                    children: [
                                                      Icon(Icons.wifi_off_rounded),
                                                      Text(
                                                          "No internet access\nCoudn't Load Contract History!"),
                                                    ],
                                                  )));
                                        }
                                      }
                                  }

                                  return const Center(
                                      child: SpinKitCubeGrid(
                                    color: Colors.deepOrange,
                                  ));
                                },
                              ),
                            ),
                          ],
                        );
                      } else if (index == 3) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                margin: EdgeInsets.all(10),
                                child: Text('Recent Transactions',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700))),
                            Container(
                              height: 420,
                              child: FutureBuilder<List>(
                                future: _transactions,
                                builder: (context, snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.none:
                                    case ConnectionState.waiting:
                                    case ConnectionState.active:
                                      {
                                        return Container(
                                            decoration: const BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top: Radius.circular(20),
                                                      bottom: Radius.zero),
                                              color: Colors.white,
                                            ),
                                            child: Center(
                                                child: Text(
                                                    "Loading your Transactions!")));
                                      }
                                    case ConnectionState.done:
                                      {
                                        if (snapshot.hasData) {
                                          return snapshot.data!.length > 0 ? ListView.builder(
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount: snapshot.data!.length > 0 ? snapshot.data!.length : 0,
                                              itemBuilder: (context, index) {
                                                Transaction transaction =
                                                    snapshot.data![index];
                                                return TransactionListCard(
                                                    transaction: transaction, user: widget.user);
                                              }) : Center(child: Text('You have not made any transactions yet!'),);
                                        } else if (snapshot.hasError) {
                                          return Container(
                                              decoration: const BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                        top:
                                                            Radius.circular(20),
                                                        bottom: Radius.zero),
                                                color: Colors.white,
                                              ),
                                              child: Center(
                                                  child: Column(
                                                    children: [
                                                      Icon(Icons.wifi_off_rounded),
                                                      Text(
                                                          "No internet access\nCoudn't Load Transaction History!"),
                                                    ],
                                                  )));
                                        }
                                      }
                                  }

                                  return const Center(
                                      child: SpinKitCubeGrid(
                                    color: Colors.deepOrange,
                                  ));
                                },
                              ),
                            ),
                          ],
                        );
                      }
                      return Container();
                      //  }
                      //    Container(
                      //      height: 150,
                      //      decoration: BoxDecoration(
                      //        color: Colors.blueAccent,
                      //        borderRadius: BorderRadius.all(Radius.circular(20))
                      //      ),
                      //      child: Row(
                      //        children: [

                      //        ]
                      //      )
                      //    )
                      //  ],
                    }),
              )),
        )
      ]),
      floatingActionButton: ElevatedButton(
          onPressed: () {
            contractMode();
          },
          child: SizedBox(
            width: 70,
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Icon(
                  IconlyBold.paper_plus,
                  color: Colors.white,
                ),
                Text(
                  'Create',
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          )),
    );
  }

  Future<dynamic> contractMode() {
    return showModalBottomSheet(
        context: context,
        isDismissible: true,
        enableDrag: true,
        backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
        isScrollControlled: true,
        builder: (context) {
          return ContractModeSelect(user: widget.user, pin: widget.pin);
        });
  }
}
