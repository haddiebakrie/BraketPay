import 'package:braketpay/uix/contractmodeselect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iconly/iconly.dart';

import '../api_callers/contracts.dart';
import '../classes/product_contract.dart';
import '../classes/user.dart';
import '../uix/contractlistcard.dart';

class Contracts extends StatefulWidget {
  Contracts({Key? key, required this.user, required this.pin})
      : super(key: key);

  final User user;
  final String pin;
  @override
  State<Contracts> createState() => _ContractsState();
}

class _ContractsState extends State<Contracts> {
  late Future<List<dynamic>> _transactions = fetchContracts(
      widget.user.payload!.accountNumber ?? "",
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
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications))
        ],
        title: Text('Contracts',
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
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
      ),
      body: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(20), bottom: Radius.zero),
            color: Colors.white,
          ),
          child: RefreshIndicator(
            onRefresh: () async {
              final transactions = await fetchContracts(
                  widget.user.payload!.accountNumber ?? "",
                  widget.user.payload!.password ?? "",
                  widget.pin);
              setState(() {
                _transactions = Future.value(transactions);
              });
            },
            child: FutureBuilder<List>(
              future: _transactions,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data!.length > 0 ? ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        ProductContract product = snapshot.data![index];
                        return ContractListCard(product: product, pin: widget.pin, user:widget.user);
                }) : ListView(children: [Center(child: Text('You have not created any contract!'),)]);
                } else if (snapshot.hasError) {
                  
                  return ListView(
                  children: [
                    Center(
                          child: Column(
                            children: [
                              SizedBox(height:40),
                              Icon(Icons.wifi_off_rounded),
                              Text(
                                  "No internet access\nCoudn't Load Contracts!\n\nPull down to refresh", textAlign: TextAlign.center),
                            ],
                          )),
                  ],
                );
                }

                return const Center(
                    child: SpinKitCubeGrid(
                  color: Colors.deepOrange,
                ));
              },
            ),
          )),
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