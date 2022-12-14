import 'dart:async';
import 'dart:ui';

import 'package:braketpay/screen/createproductmerchant.dart';
import 'package:braketpay/screen/manager.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../api_callers/contracts.dart';
import '../api_callers/userinfo.dart';
import '../brakey.dart';
import '../classes/user.dart';
import '../modified_packages/modified_elegant_number_button.dart';
import '../ngstates.dart';
import '../uix/askpin.dart';
import '../uix/themedcontainer.dart';
import '../utils.dart';

class ProductPrompt extends StatefulWidget {
  ProductPrompt({Key? key, required this.user, required this.creatorType})
      : super(key: key);

  User user;
  String creatorType;

  @override
  State<ProductPrompt> createState() => _ProductPromptState();
}

class _ProductPromptState extends State<ProductPrompt> {
  Brakey brakey = Get.put(Brakey());
  bool isUsername = true;
  Map opposites = {"Buyer": "Seller", "Seller": "Buyer"};
  late String username;
  String contractTitle = '';
  late String receiverName = 'No username provided';
  String receiveraddr = '';
  String productDetail = '';
  late double price = 0;
  int quantity = 1;
  String logisticFrom = '';
  String logisticTo = '';
  double shipFee = 0;
  final TextEditingController _usernameFieldController =
      TextEditingController();
  final TextEditingController _priceTextController = TextEditingController();
  final TextEditingController _priceFieldController = TextEditingController();
  final TextEditingController _titleFieldController = TextEditingController();
  final TextEditingController _productDetailController =
      TextEditingController();
  final TextEditingController _logFromFieldController = TextEditingController();
  int pageIndex = 0;
  bool _lastIndex = false;
  String deliveryDate = 'YYYY-MM-DD';
  final _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _loginButtonController =
      RoundedLoadingButtonController();
  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: Theme.of(context).primaryColor),
        Image.asset(
          'assets/braket-bg_grad-01.png',
          height: 300,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
        Scaffold(
          extendBody: true,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            // leadingWidth: 20,
            title: Text('${widget.creatorType} Contract'),
          ),
          body: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.max, children: [
              widget.creatorType == 'Buyer'
                  ?
                  // Container(
                  //   // margin: Ed,
                  //   // height: 200,
                  //   child: Stack(
                  //     alignment: Alignment.topRight,
                  //     children: [
                  //     Row(
                  //       children: [
                  //         const Expanded(child: SizedBox()),
                  //         Image.asset('assets/drone_delivers.png', width: 200,),
                  //       ],
                  //     ),
                  //     Container(
                  //       width: double.infinity,
                  //       padding: const EdgeInsets.all(10),
                  //       child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //         Image.asset('assets/wio.png', width: 180,),

                  //           // const Text("Get", style: TextStyle(fontSize: 20, color: Colors.white)),
                  //           // const Text("what you", style: TextStyle(fontSize: 30, color: Colors.white)),
                  //           // const Text('ORDERED', style: TextStyle(fontSize: 50, color: Colors.white)),
                  //           // const Text('LOAN', style: TextStyle(fontSize: 60, color: Colors.white)),
                  //           FittedBox(
                  //             child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //                     const SizedBox(height: 10),
                  //                 Row(
                  //                   children: [
                  //                          Container(
                  //                       decoration: ContainerDecoration(),
                  //                       padding: EdgeInsets.all(5),child: const Text('\u2713 Automatic refund if you wish to cancel your order', style: TextStyle(fontSize: 9,))),
                  //                   ],
                  //                 ),
                  //                 const SizedBox(height: 10,),
                  //                     Row(
                  //                       children: [
                  //                     Container(
                  //                       decoration: ContainerDecoration(),
                  //                       padding: const EdgeInsets.all(5),
                  //                       child: const Text('\u2713 Prevent sellers from scamming you', style: TextStyle(fontSize: 9,))),
                  //                     const SizedBox(width: 10),
                  //                      Container(
                  //                       decoration: ContainerDecoration(),
                  //                       padding: const EdgeInsets.all(5),child: const Text('\u2713 Secure your payment', style: TextStyle(fontSize: 9,))),
                  //                       ],
                  //                     ),
                  //                 const SizedBox(height: 10,),
                  //               ],
                  //             ),
                  //           ),

                  //     ]
                  //   )

                  // ),
                  Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                      child: Container(
                          decoration: ContainerDecoration(),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Image.asset('assets/preventwio.png')),
                    )
                  // ])

                  // )
                  : Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                      child: Container(
                          decoration: ContainerDecoration(),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child:
                              Image.asset('assets/secure_your_payments.png')),
                    ),
              Container(
                width: double.infinity,
                decoration: ContainerBackgroundDecoration(),
                padding: const EdgeInsets.all(20.0),
                child: Column(children: [
                  Container(
                    width: 60,
                    height: 5,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  const SizedBox(height: 10),
                                      
                    Column(children: [
                    Visibility(
                      visible: widget.creatorType == 'Seller',
                      child: Container(
                        decoration: BoxDecoration(

                          // borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.withAlpha(40),
                        ),
                          height: 40,
                          margin: EdgeInsets.all(5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: TextButton(
                                  style: ButtonStyle(
                                    backgroundColor:MaterialStateProperty.all(
                                            Color.fromARGB(255, 255, 30, 0))
                                  ),
                                  child: Text(
                                    'One-off',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600

                                    ),
                                  ),
                                  onPressed: () {
                                    
                                  },
                                ),
                              ),
                              Expanded(
                                child: TextButton(
                                  style: ButtonStyle(
                                    backgroundColor: !isUsername
                                        ? MaterialStateProperty.all(
                                            Color.fromARGB(255, 255, 30, 0))
                                        : MaterialStateProperty.all(
                                            Color.fromARGB(0, 255, 255, 255)),
                                  ),
                                  child: Text(
                                    'Continuous',
                                    style: TextStyle(
                                      color:adaptiveColor,
                                      fontWeight: FontWeight.w600
                                    ),
                                  ),
                                  onPressed: () {
                                    Get.to(()=> MerchantCreateProduct(merchantID: '', pin: '', user: brakey.user.value!));
                                  },
                                ),
                              ),
                            ],
                          )),
                    ),
                   
                    ]),
              
                  Form(
                      key: _formKey,
                      child: Column(children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: TextFormField(
                                controller: _usernameFieldController,
                                cursorColor: Colors.grey,
                                keyboardType: TextInputType.multiline,
                                minLines: null,
                                maxLines: null,
                                decoration: InputDecoration(
                                  fillColor: const Color.fromARGB(24, 158, 158, 158),
                                  filled: true,
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  hintText:
                                      "@ ${opposites[widget.creatorType]}'s username\n",
                                  hintStyle:
                                      const TextStyle(fontWeight: FontWeight.w600),
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                ),
                                onChanged: (text) async {
                                  setState(() {
                                    receiverName = 'Looking for user...';
                                  });
                                  Map a = await getUserWith(
                                      text.trim(), 'username');
                                  print(a);
                                  if (!a.containsKey('Status')) {
                                    setState(() {
                                      receiverName =
                                          'No Internet access (Tap to retry)';
                                    });
                                    return;
                                  }
                                  receiverName = a.containsKey('Payload')
                                      ? a['Payload']['fullname']
                                      : 'Incorrect Braket Account';
                                  username = text.trim();
                                  setState(() {
                                    if (a.containsKey('Payload') &&
                                        a['Payload']['wallet_address'] ==
                                            widget
                                                .user.payload!.walletAddress) {
                                      setState(() {
                                        receiverName =
                                            "You can't create a contract with yourself";
                                      });
                                      return;
                                    }
                                    if (a.containsKey('Payload')) {
                                      setState(() {
                                        receiveraddr =
                                            a['Payload']['wallet_address'];
                                      });
                                      return;
                                    }
                                    receiverName = 'Looking for user...';
                                    receiverName = a.containsKey('Payload')
                                        ? '${a['Payload']['fullname']}'
                                        : a.containsKey('Message')
                                            ? a['Message']
                                            : 'No Internet access (Tap to retry)';
                                  });
                                  // username = text.trim();
                                  // Future<Map<String, dynamic>> fullname =
                                  //     getUserInfo(text);
                                  // fullname.then((value) {
                                  //   if (value.containsKey('Payload')) {
                                  //     if (value['Payload']['wallet_address'] ==
                                  //         widget.user.payload!.walletAddress) {
                                  //       setState(() {
                                  //         receiverName =
                                  //             "You can't create a contract with yourself";
                                  //       });
                                  //     } else {
                                  //       setState(() {
                                  //         receiverName = value['Payload']['fullname'];
                                  //         receiveraddr =
                                  //             value['Payload']['wallet_address'];

                                  //         // print(value);
                                  //       });
                                  //     }
                                  //   } else {
                                  //     setState(() {
                                  //       receiverName =
                                  //           'This username does not match any user';
                                  //     });
                                  //   }
                                  // });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'The second party is required';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                setState(() {
                                  receiverName = 'Looking for user...';
                                });
                                Map a = await getUserWith(username, 'username');
                                print(a);
                                if (!a.containsKey('Status')) {
                                  setState(() {
                                    receiverName =
                                        'No Internet access (Tap to retry)';
                                  });
                                  return;
                                }
                                receiverName = a.containsKey('Payload')
                                    ? a['Payload']['fullname']
                                    : 'Incorrect Braket Account';

                                setState(() {
                                  if (a.containsKey('Payload') &&
                                      a['Payload']['wallet_address'] ==
                                          widget.user.payload!.walletAddress) {
                                    setState(() {
                                      receiverName =
                                          "You can't create a contract with yourself";
                                    });
                                    return;
                                  }
                                  receiverName = 'Looking for user...';
                                  receiverName = a.containsKey('Payload')
                                      ? '${a['Payload']['fullname']}'
                                      : a.containsKey('Message')
                                          ? a['Message']
                                          : 'No Internet access (Tap to retry)';
                                });
                              },
                              child: Row(children: [
                                const Icon(CupertinoIcons.profile_circled,
                                    color: Colors.teal),
                                const SizedBox(width: 5),
                                Flexible(
                                    child: Text(receiverName,
                                        style: const TextStyle(
                                            color: Colors.teal,
                                            fontWeight: FontWeight.w600))),
                              ]),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 5),
                                      child: const Text(
                                        'Contract title',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15),
                                      ),
                                    ),
                                    TextFormField(
                                      controller: _titleFieldController,
                                      cursorColor: Colors.grey,
                                      minLines: null,
                                      maxLines: null,
                                      decoration: const InputDecoration(
                                        fillColor:
                                            Color.fromARGB(24, 158, 158, 158),
                                        hintStyle: TextStyle(
                                            fontWeight: FontWeight.w600),
                                        filled: true,
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        hintText:
                                            'Eg. Apple Iphone 13 6.1" Super Retina\n',
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        contentPadding: EdgeInsets.all(10),
                                      ),
                                      onChanged: (text) {
                                        contractTitle = text.trim();
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'The contract title is required';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 5),
                                      child: const Text(
                                        'Product Detail',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15),
                                      ),
                                    ),
                                    TextFormField(
                                      controller: _productDetailController,
                                      keyboardType: TextInputType.multiline,
                                      minLines: null,
                                      maxLines: null,
                                      style: const TextStyle(height: 1.5),
                                      maxLength: 3000,
                                      cursorColor: Colors.grey,
                                      decoration: const InputDecoration(
                                        fillColor:
                                            Color.fromARGB(24, 158, 158, 158),
                                        filled: true,
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        hintText:
                                            'Eg. 12MP TrueDepth front camera \nwith Night mode, 4K Dolby Vision \nHDR recording\n',
                                        hintStyle: TextStyle(
                                            fontWeight: FontWeight.w500),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                      ),
                                      onChanged: (text) {
                                        productDetail = text.trim();
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'The Product detail is required';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 5),
                                      child: const Text(
                                        'Product Price',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15),
                                      ),
                                    ),
                                    TextFormField(
                                      controller: _priceTextController,
                                      cursorColor: Colors.grey,
                                      keyboardType: TextInputType.number,
                                      // textAlign: TextAlign.center,

                                      style: const TextStyle(
                                        fontSize: 35,
                                      ),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      decoration: InputDecoration(
                                          icon: Text(nairaSign(),
                                              style: const TextStyle(
                                                fontSize: 20,
                                                color: Colors.grey,
                                              )),
                                          prefixStyle: const TextStyle(
                                              color: Colors.grey),
                                          fillColor: const Color.fromARGB(
                                              24, 158, 158, 158),
                                          // filled: true,
                                          focusedBorder:
                                              const OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                          hintText: '0.00',
                                          hintStyle: const TextStyle(
                                              color: Colors.grey),
                                          border: const OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          contentPadding: EdgeInsets.zero),
                                      onChanged: (text) {
                                        price = text == ''
                                            ? 0
                                            : double.parse(text.trim());
                                        // setState(() {
                                        //   _priceTextController.text = price.toString();
                                        // });
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'The Product price is required';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Quantity',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600)),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(
                                      10,
                                    ),
                                    decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            24, 158, 158, 158),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: NumberButton(
                                      initialValue: quantity,
                                      minValue: 1,
                                      maxValue: 1000000,
                                      decimalPlaces: 0,
                                      extended: true,
                                      color: Colors.redAccent,
                                      textStyle: const TextStyle(color: Colors.white),
                                      step: 1,
                                      onChanged: (value) {
                                        // get the latest value from here
                                        setState(() {
                                          quantity = value.toInt();
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Shipping from',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15),
                                  ),
                                  InkWell(
                                    // onTap: () {
                                    //   CupertinoPicker(itemExtent: 20, onSelectedItemChanged: (e) {
                                    //     logisticFrom = e,
                                    //   }, children: children)

                                    // },
                                    child: Container(
                                      padding: const EdgeInsets.only(left: 10),
                                      decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              24, 158, 158, 158),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: DropdownSearch<dynamic>(
                                          onChanged: (e) {
                                            logisticFrom = e;
                                          },
                                          dropdownSearchDecoration:
                                              const InputDecoration(
                                            hintText: 'Select State',
                                            border: InputBorder.none,
                                            // filled: true,
                                          ),
                                          //  itemAsString: (value) {
                                          //   return Text
                                          //  },
                                          // showSearchBox: true,
                                          // showClearButton: true,
                                          dropdownBuilder: (context, widget) {
                                            return Text(
                                              widget + '\n',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600),
                                            );
                                          },
                                          mode: Mode.BOTTOM_SHEET,
                                          searchDelay: Duration.zero,
                                          items: ngStates
                                              .map((e) => e['name'])
                                              .toList(),
                                          selectedItem: logisticFrom != ''
                                              ? logisticFrom
                                              : 'Select State'),
                                      // child: Padding(
                                      //   padding: const EdgeInsets.all(10.0),
                                      //   child: Row(
                                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      //     children: [
                                      //       Text('Select State', style: TextStyle(fontSize: 18)),
                                      //       Icon(Icons.arrow_drop_down)
                                      //     ],
                                      //   ),
                                      // )
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: const Text(
                                      'Shipping to',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(left: 10),
                                    decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            24, 158, 158, 158),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: DropdownSearch<dynamic>(
                                        dropdownSearchDecoration:
                                            const InputDecoration(
                                          hintText: 'Select State',
                                          border: InputBorder.none,
                                          // filled: true,
                                        ),
                                        onChanged: (e) {
                                          logisticTo = e;
                                        },
                                        dropdownBuilder: (context, widget) {
                                          return Text(
                                            widget + '\n',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600),
                                          );
                                        },
                                        // showSearchBox: true,
                                        // showClearButton: true,
                                        mode: Mode.BOTTOM_SHEET,
                                        searchDelay: Duration.zero,
                                        items: ngStates
                                            .map((e) => e['name'])
                                            .toList(),
                                        // selectedItem: ngStates.map((e) => e['name']).toList()[0]
                                        selectedItem: logisticTo != ''
                                            ? logisticTo
                                            : 'Select State'),
                                  ),
                                ],
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 5),
                                            child: const Text(
                                              'Choose delivery date',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 15),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              final now = DateTime.now();
                                              _loginButtonController.reset();
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                              DatePicker.showDatePicker(context,
                                                  minTime: DateTime(now.year,
                                                      now.month, now.day + 1),
                                                  currentTime: deliveryDate ==
                                                          'YYYY-MM-DD'
                                                      ? DateTime(
                                                          now.year,
                                                          now.month,
                                                          now.day + 1)
                                                      : DateTime.tryParse(
                                                          deliveryDate),
                                                  maxTime: DateTime(2101),
                                                  onConfirm: (date) {
                                                setState(() {
                                                  deliveryDate =
                                                      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                                                });
                                              });

                                              print(deliveryDate);
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      24, 158, 158, 158),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              width: double.infinity,
                                              child: Row(
                                                children: [
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.all(
                                                            2.0),
                                                    //  child: Icon(IconlyBold.calendar, color: Theme.of(context).primaryColor),
                                                  ),
                                                  const SizedBox(width: 3),
                                                  Expanded(
                                                    child: Text(
                                                        deliveryDate + "\n",
                                                        style: const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                  ),
                                                  const Icon(
                                                      Icons.arrow_drop_down,
                                                      color: Colors.grey)
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Container(
                                      // margin: const EdgeInsets.only(bottom: 5),
                                      child: const Text(
                                        'Cost of shipping',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15),
                                      ),
                                    ),
                                    TextFormField(
                                      cursorColor: Colors.grey,
                                      keyboardType: TextInputType.number,
                                      // textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 35,
                                      ),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.zero,
                                        icon: Text(nairaSign(),
                                            style: const TextStyle(
                                                fontSize: 20,
                                                color: Colors.grey)),
                                        prefixStyle:
                                            const TextStyle(color: Colors.grey),
                                        fillColor: const Color.fromARGB(
                                            24, 158, 158, 158),
                                        // filled: true,
                                        focusedBorder: const OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        hintText: '0.00',
                                        hintStyle:
                                            const TextStyle(color: Colors.grey),
                                        border: const OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        // contentPadding: EdgeInsets.symmetric(
                                        //     horizontal: 10, vertical: 20),
                                      ),
                                      onChanged: (text) {
                                        shipFee = text == ''
                                            ? 0
                                            : double.parse(text.trim());
                                        // setState(() {
                                        //   _priceTextController.text = price.toString();
                                        // });
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Cost of shipping is required';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 90)
                      ])),
                ]),
              )
            ]),
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                color: Get.isDarkMode ? Color.fromARGB(255, 42, 42, 59) : Colors.white
                ),
            child: RoundedLoadingButton(
                borderRadius: 10,
                color: Theme.of(context).primaryColor,
                elevation: 0,
                controller: _loginButtonController,
                child: const Text('Create'),
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) {
                    _loginButtonController.reset();
                  } else if (receiverName == 'Looking for user...' ||
                      receiverName == 'This username does not match any user' ||
                      receiverName ==
                          "You can't create a contract with yourself" ||
                      receiverName == 'Unknown' ||
                      receiverName == 'No Internet access (Tap to retry)' ||
                      receiverName == 'No username provided') {
                    _loginButtonController.reset();

                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return AlertDialog(
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              actions: [
                                TextButton(
                                  child: const Text('Okay'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                              title: const Text("Invalid Receiver username!"),
                              content: const Text('Enter a valid username'));
                        });
                  } else if (deliveryDate == 'YYYY-MM-DD') {
                    _loginButtonController.reset();
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return AlertDialog(
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              actions: [
                                TextButton(
                                  child: const Text('Okay'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                              title: const Text("Delivery date not set!"),
                              content:
                                  const Text('Please choose a delivery date'));
                        });
                  } else {
                    setState(() {
                      _lastIndex = false;
                    });
                    StreamController<ErrorAnimationType> _pinErrorController =
                        StreamController<ErrorAnimationType>();
                    final _pinEditController = TextEditingController();
                    Map? pin =
                        await askPin(_pinEditController, _pinErrorController);
                    if (pin == null || !pin.containsKey('pin')) {
                      _loginButtonController.reset();
                      return;
                    }
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) {
                          return AlertDialog(
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              title: Text(
                                'YOU ARE CREATING A PRODUCT CONTRACT \nWITH\n ${receiverName.toUpperCase()}',
                                textAlign: TextAlign.center,
                              ),
                              // content: SizedBox(width: 50, height: 50, child: Center(child: CircularProgressIndicator()))
                              content: Row(children: const [
                                Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: CircularProgressIndicator(),
                                ),
                                Text('Creating Contract....',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500))
                              ]));
                        });
                    Map a = await createProductContract(
                        widget.creatorType.toLowerCase(),
                        widget.creatorType.toLowerCase() == 'buyer'
                            ? widget.user.payload!.walletAddress ?? ''
                            : receiveraddr,
                        widget.creatorType.toLowerCase() == 'seller'
                            ? widget.user.payload!.walletAddress ?? ''
                            : receiveraddr,
                        widget.user.payload!.bvn ?? '',
                        contractTitle,
                        productDetail,
                        price.toString(),
                        shipFee.toString(),
                        logisticFrom,
                        logisticTo,
                        deliveryDate,
                        pin['pin'],
                        quantity.toString());
                    if (a.containsKey('Payload')) {
                      _loginButtonController.success();
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return AlertDialog(
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                                actions: [
                                  TextButton(
                                    child: const Text('Okay'),
                                    onPressed: () {
                                      Get.offUntil(MaterialPageRoute(
                                            builder: (_) => 
                                            Manager(user: widget.user, pin: brakey.pin.value)), (route) => false);
                                            // brakey.changeManagerIndex(3);
                                      brakey.refreshUserDetail();
                                    },
                                  )
                                ],
                                title: const Text(
                                    "Product contract created successfuly!"),
                                content: Text(
                                    'Your contract has been sent to $receiverName, you would be notified when the contract is accepted.'));
                          });
                    } else {
                      _loginButtonController.reset();
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return AlertDialog(
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                                actions: [
                                  TextButton(
                                    child: const Text('Okay'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                      // Navigator.of(context).pop();
                                    },
                                  )
                                ],
                                title: const Text("Contract creation failed"),
                                content: Text(toTitleCase(a['Message'])));
                          });
                    }
                  }
                }),
          ),
        ),
      ],
    );
  }
}
