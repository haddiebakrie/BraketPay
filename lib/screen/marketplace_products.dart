import 'dart:math';

import 'package:braketpay/screen/tabview.dart';
import 'package:braketpay/uix/category_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../api_callers/marketplace.dart';
import '../api_callers/merchant.dart';
import '../brakey.dart';
import '../constants.dart';
import '../uix/roundbutton.dart';
import '../uix/shimmerwidgets.dart';
import '../uix/themedcontainer.dart';
import '../utils.dart';
import 'chats.dart';
import 'marketplace_search.dart';
import 'merchantcreateproduct.dart';

class MarketPlaceProducts extends StatefulWidget {
  MarketPlaceProducts({Key? key}) : super(key: key);

  @override
  State<MarketPlaceProducts> createState() => MarketPlaceProductsState();
}

class MarketPlaceProductsState extends State<MarketPlaceProducts> {
  final Brakey brakey = Get.put(Brakey());
  late Future<Map> _products = fetchMarketContracts(
    brakey.user.value?.payload?.publicKey ?? "",
    brakey.user.value?.payload!.password ?? "",
  );
  String currentCategory = 'All';
  bool hasLoadError = false;
  String loadErrorMsg = '';
  @override
  Widget build(BuildContext context) {
    Widget appBar = Container(
     height: kToolbarHeight + MediaQuery.of(context).padding.top,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: [
              BackButton(color: Colors.white),
          Text('Products', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 22),),
            ],
          ),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(20)
                    ),
                    margin: EdgeInsets.only(right: 15),
                child: IconButton(
                onPressed: () {},
                icon: Icon(CupertinoIcons.heart, color: Colors.white)),
              ),
          Container(
                    margin: EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(20)
                    ),
            child: IconButton(
                onPressed: () {
                  Get.to(ChatHistory());
                },
                icon: Icon(CupertinoIcons.bubble_right_fill, color: Colors.white)),
          ),
           Container(
            decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(20)
                    ),
            child: IconButton(
                onPressed: () {
                  Get.to(MarketPlaceSearch());
                },
                icon: Icon(CupertinoIcons.search, color: Colors.white)),
          ),
            ],
          )
            
        ],
      ),
    );
   
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false, elevation: 0, toolbarHeight: 1,),

      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
    children: [
    appBar,
    // Container(
    //     padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
        
    //     margin: EdgeInsets.symmetric(horizontal: 10),
    //     decoration: BoxDecoration(
    //               color: Colors.white24,
    //               borderRadius: BorderRadius.circular(20)
    //             ),
    //     child: TextField(
    //       textCapitalization: TextCapitalization.sentences,
    //       onChanged: (value) {},
    //       decoration: InputDecoration(
    //         // prefixIcon: Icon(Icons.search),
    //         contentPadding: EdgeInsets.zero,
    //       filled: true,
    //       fillColor: Colors.transparent,
    //       border: InputBorder.none,
    //         focusedBorder: InputBorder.none,
    //         hintText: 'Search Products',
    //         hintStyle: TextStyle(fontSize: 14, color: Colors.white30, fontWeight: FontWeight.w600)
    //       ),
    //     ),
    //   ),
    Expanded(
      child: Container(
        decoration: ContainerBackgroundDecoration(),
        padding: EdgeInsets.all(5).copyWith(right: 0),
        margin: EdgeInsets.only(top: 20),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
          margin: EdgeInsets.only(top: 5),
                            width: 60,
                            height: 5,
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(10)),
                          ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                        padding: const EdgeInsets.all(10.0).copyWith(bottom: 0),
                        child: Text('Categories', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: Colors.black45)),
                      ),
                      Container(
                          height: 150,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: productCategories.length+1,
                            itemBuilder: ((context, index) {
                              if (index == 0) {
                                return InkWell(
                              onTap: () {
                                setState(() {
                                  currentCategory = 'All';
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: currentCategory == 'All' ? Colors.teal : Colors.transparent
                                  ),
                                  borderRadius: BorderRadius.circular(15)
                                ),
                                child: CategoryCard(category: Category(Colors.white, Colors.white, 'All', ''))));
                              } else {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    currentCategory = productCategories[index-1];
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: currentCategory == productCategories[index-1] ? Colors.teal : Colors.transparent
                                    ),
                                    borderRadius: BorderRadius.circular(15)
                                  ),
                                  child: CategoryCard(category: Category(Colors.white, Colors.white, productCategories[index-1], ''))));

                              }
                          })),
                      )
                ],
              ),
                    Container(
                      // height: height * 0.25,
                      child: FutureBuilder<Map>(
                        future: _products,
                        builder: (context, snapshot) {
                          double height = MediaQuery.of(context).size.height;
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                            case ConnectionState.waiting:
                            case ConnectionState.active:
                            {
                              return Container(
                                // height: height * 0.25,
                                child: Expanded(
                            child: RefreshIndicator(
                              onRefresh: () async {
                                  // brakey.reloadUser('');
                                  final product = await fetchMarketContracts(
                                      brakey.user.value?.payload?.publicKey ?? '',
                                      brakey.user.value?.payload?.password ?? '');
                                  setState(() {
                                    _products = Future.value(product);
                                    // _service = Future.value(service);
                                  });
                                },
                              child: GridView.builder(
                              // padding: EdgeInsets.all(20),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  // mainAxisSpacing: 10,
                                  // crossAxisSpacing: 15,
                                  crossAxisCount: 2),
                                  // itemCount: 10,
                                            itemBuilder: (builder, index) {
                                                      return Container(
                                                        height: 140,
                                                        width: 180,
                                                        child: const SquareShimmer());
                                                    }))));
                            }
                            case ConnectionState.done:
                          if (snapshot.hasData) {
                            List sortedProducts = [];
                            if (currentCategory == 'All') {
                              // print(snapshot.data!['PRODUCT'][0]);
                              snapshot.data!['PRODUCT'].sort((a, b) => 
                              DateTime.parse(a['Payload']['date_product_registered']).compareTo(DateTime.parse(b['Payload']['date_product_registered']))
                              );
                              snapshot.data!['PRODUCT'] = snapshot.data!['PRODUCT'].reversed.toList();
                              // print(snapshot.data!['PRODUCT'][0]);
                              sortedProducts = snapshot.data!['PRODUCT'];
                            } else {
                              snapshot.data!['PRODUCT'].forEach((element) {
                                print(element);
                                if (element['Payload']['categories']?['category_1'] == currentCategory) {
                                  sortedProducts.add(element);
                                }
                              });

                            } 
                            if (sortedProducts.isEmpty) {
                              return Container(
                                height: 300,
                                padding: EdgeInsets.all(20),
                                child: 
                              Center(
                                child: Text('There are currently no Items for this category please check back later', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w600),)
                              ));
                            }
                          return Expanded(
                            child: RefreshIndicator(
                              key: brakey.refreshProductMarket.value,
                              onRefresh: () async {
                                  brakey.reloadUser('');
                                  final product = await fetchMarketContracts(
                                      brakey.user.value?.payload?.publicKey ?? '',
                                      brakey.user.value?.payload?.password ?? '');
                                  setState(() {
                                    _products = Future.value(product);
                                    // _service = Future.value(service);
                                  });
                                },
                              child: GridView.builder(
                              padding: EdgeInsets.all(20),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 15,
                                  crossAxisCount: 2),
                                // scrollDirection: Axis.horizontal,
                                itemCount: sortedProducts.length,
                                itemBuilder: (BuildContext context, int index) {
                                  // print(snapshot.data);
                                  // return Container(
                                  //   child: Column(children: [
                              
                                  //     Text(snapshot.data!['PRODUCT'][index]['Payload']['product_name'].toString())
                                  //   ],)
                                  // );
                                  List _templates = sortedProducts;
                                  return InkWell(
                                    onTap: () async{
                                      print(hasLoadError);
                                      Get.bottomSheet(
                                          
                                        BottomSheet(
                                          onClosing: () {
                                            setState(() {
                                              hasLoadError = false;
                                              loadErrorMsg = '';
                                            });
                                          },
                                          builder: (_) {
                                            return Container(
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    hasLoadError ? Icon(Icons.close, color: Colors.redAccent, size: 25,) : CircularProgressIndicator(),
                                                    SizedBox(height:20),
                                                    Flexible(child: Text(hasLoadError ? loadErrorMsg : "Fetching ${toTitleCase(_templates[index]['Payload']['product_name'])}", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey, fontSize: 23),))
                                                  ],
                                                ),
                                              ),
                                            );
                                          }
                                        ),
                                        isDismissible: false
                                      );
                              
                                      Map a =
                                                    await fetchMerchantContract(
                                                        _templates[index]['Payload']['product_id'],
                                                        'product',
                                                        '',
                                                        brakey
                                                                .user
                                                                .value!
                                                                .payload!
                                                                .walletAddress ??
                                                            '',
                                                        brakey.user.value?.payload?.pin??'',
                                                        'single',
                                                        brakey.user.value?.payload?.password??'',
                                                        
                                                        );
                                      if (a
                                                    .containsKey('Payload')) {
                                                  a['Payload'].addEntries({
                                                    'merchant_id': _templates[index]['Payload']['merchant_id'],
                                                    'product_id': _templates[index]['Payload']['product_id']
                                                  }.entries);
                                                  // Navigator.of(context).pop();
                                            Get.close(1);
                                            hasLoadError = false;
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: ((context) =>
                                                              MerchantCreateProductFromScan(
                                                                  product: a[
                                                                      'Payload'],
                                                                  user: brakey
                                                                      .user
                                                                      .value!,
                                                                  pin: brakey.user.value?.payload?.pin??''))));
                                    } else {
                                      Get.close(1);
                                      Get.bottomSheet(
                                          
                                        BottomSheet(
                                          onClosing: () {
                                            setState(() {
                                              hasLoadError = false;
                                              loadErrorMsg = '';
                                            });
                                          },
                                          builder: (_) {
                                            return Container(
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    hasLoadError ? Icon(Icons.close, color: Colors.redAccent, size: 25,) : CircularProgressIndicator(),
                                                    SizedBox(height:20),
                                                    Flexible(child: Text(hasLoadError ? loadErrorMsg : "Fetching ${toTitleCase(_templates[index]['Payload']['contract_title']??'')}", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey, fontSize: 23),))
                                                  ],
                                                ),
                                              ),
                                            );
                                          }
                                        ),
                                        isDismissible: false
                                      );
                                      setState(() {
                                        hasLoadError = true;
                                        loadErrorMsg = a['Message'] ?? 'Failed, Please check your Internet and Try again.';
                                      });
                                    }
                                    
                                    },
                                    child: Container(
                                        height: 200,
                                        width: 140,
                                        // margin: EdgeInsets.all(10),
                                        clipBehavior: Clip.antiAliasWithSaveLayer,
                                        decoration: ContainerDecoration(),
                                              padding: EdgeInsets.all(5),
                                        child: Column(
                                          children: [
                                          
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(15),
                                                color: Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
                                              ),
                                                // child: Image()
                                              clipBehavior: Clip.antiAliasWithSaveLayer,
                                              child: Stack(
                                                alignment: Alignment.bottomLeft,
                                                children: [
                                                  Image.network(_templates[index]['Payload']['product_picture_links']?['link_1']??'https://firebasestorage.googleapis.com/v0/b/braketpay-mobile-app.appspot.com/o/assets%2Fimages.png?alt=media&token=2ca79fe2-172f-49ab-93bf-a6550ef78fa2', fit: BoxFit.cover, width: double.infinity, height: double.infinity,
                                                  errorBuilder: (_, __, ___) {
                                                      return Image.network(brokenImageUrl, fit: BoxFit.cover, width: double.infinity, height: double.infinity,);
                                                    },),
                                                // Padding(
                                                //   padding: const EdgeInsets.only(left:8.0, bottom: 5),
                                                //   child: BlurryContainer(
                                                //     padding: EdgeInsets.all(3),
                                                //     color: Colors.black.withOpacity(0.1),
                                                //     borderRadius: BorderRadius.circular(5),
                                                //     child: Text(_templates[index]['Payload']['contract_type']??'loan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600))),
                                                // ),
                                                        SizedBox(height:4),
                                                ],
                                              ),
                                              height: 90,
                                              width: double.infinity,
                                            ),
                                                        SizedBox(height:10),
                                  
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal:5.0),
                                              child: Text(toTitleCase(_templates[index]['Payload']['product_name']??''),
                                                  maxLines: 1,
                                                  textAlign:
                                                      TextAlign
                                                          .center, style: TextStyle(fontWeight: FontWeight.w600)),
                                            ),
                                            SizedBox(height:5),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                              child: FittedBox(
                                                child: Text(
                                                    _templates[index]['Payload'].containsKey(
                                                            'product_amount')
                                                        ? formatAmount(_templates[index]['Payload']['product_amount']
                                                            .toString()) : _templates[index]['Payload'].containsKey(
                                                            'total_service_amount')
                                                        ? formatAmount(_templates[index]['Payload']['total_service_amount']
                                                            .toString()): 
                                                         _templates[index]['Payload'].containsKey(
                                                            'loan_amount_range')
                                                        ? formatAmount(_templates[index]['Payload']['loan_amount_range']['min'].toString()) + " - "  + formatAmount(_templates[index]['Payload']['loan_amount_range']['max'].toString()) :' ',
                                                    maxLines: 1,
                                                    style: const TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                        fontFamily:
                                                            '')),
                                              ),
                                            ),
                                          ],
                                        )),
                                  );
                                              
                                },
                              ),
                            ),
                          );
                    
                          } else {
                            return RefreshIndicator(
                              key: brakey.refreshProductMarket.value,
                              onRefresh: () async {
                                  // brakey.reloadUser('');
                                  final product = await fetchMarketContracts(
                                      brakey.user.value?.payload?.publicKey ?? '',
                                      brakey.user.value?.payload?.password ?? '');
                                  setState(() {
                                    _products = Future.value(product);
                                    // _service = Future.value(service);
                                  });
                                },
                              child: Center(
                                      child: Column(
                                    children: [
                                      Image.asset(
                                          'assets/sammy-no-connection.gif',
                                          width: 100),
                                      const Text(
                                          "No internet access\nCouldn't Load Products!",
                                          textAlign:
                                              TextAlign.center),
                                      const SizedBox(height: 20),
                                      RoundButton(
                                          icon: Icons.refresh,
                                          text: 'Retry',
                                          color1: Colors.black,
                                          color2: Colors.black,
                                          onTap: () {
                                            print('hi');
                                            brakey.refreshProductMarket.value?.currentState?.show();
                                          })
                                    ],
                                  )),
                            );
                          }
                        }}
                      ),
                    )]),
      
      ),
    )
      ]),
      );
  }
}
