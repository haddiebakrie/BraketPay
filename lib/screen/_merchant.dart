import 'dart:convert';
import 'dart:typed_data';
import 'dart:developer';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:braketpay/brakey.dart';
import 'package:braketpay/screen/merchanttemplateproduct.dart';
import 'package:braketpay/uix/roundbutton.dart';
import 'package:braketpay/utils.dart';
import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:iconly/iconly.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../classes/user.dart';
import '../api_callers/merchant.dart';
import '../constants.dart';
import '../uix/contractmodeselect.dart';
import '../uix/listitemseparated.dart';
import '../uix/merchantcontractmodeselect.dart';
import '../uix/themedcontainer.dart';
import 'merchanttemplateloan.dart';
import 'merchanttemplateservice.dart';
import 'dart:async';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../uix/askpin.dart';
import 'notifications.dart';


class Merchant extends StatefulWidget {
  const Merchant({Key? key, required this.user, required this.pin}) : super(key: key);

  final User user;
  final String pin;
  @override
  State<Merchant> createState() => _MerchantState();
}

class _MerchantState extends State<Merchant> {
  Brakey brakey = Get.put(Brakey());
  final _formKey = GlobalKey<FormState>();
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  final RoundedLoadingButtonController _loginButtonController =
      RoundedLoadingButtonController();
  // String _errorMessage = '';
  String bizName = '';
  String merchantName = 'Merchant';
  String merchantID = '';
  String bizLoc = '';
  String website = '';
  // late Map merchant;
  List _templates = [];
  String email = '';
  String password = '';
  bool hasMerchant = false;
  bool hasTemplate = false;
  bool hasProduct = false;
  bool hasService = false;
  late Future<Map> merchant = getMerchant(
    widget.user.payload!.walletAddress ?? '',
    widget.pin,
    widget.user.payload!.password??''
  );
  late Future<Map> templates = fetchMerchantContract('', '', merchantID,
      widget.user.payload!.walletAddress ?? '', widget.pin, 'all',
                      brakey.user.value?.payload?.password??'',
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          elevation: 0,
          titleSpacing: 5,
          toolbarHeight: 65,
          leading: Container(),
          actions: [
            Obx(() => IconBadge(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: ((context) =>
                        Notifications(user: widget.user, pin: widget.pin))));
              },
              maxCount: 9,
              icon: const Icon(Icons.notifications),
              itemCount: brakey.notiCount.toInt(),
              right: 10.0,
              hideZero: true,
              top: 10.0

              // hideZero: true,

              ))
          ],
          title: Text(merchantName,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        floatingActionButton: FutureBuilder<Map>(
          future: merchant,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.containsKey('Status') &&
                                  snapshot.data!['Status'] == 'successful') {
              return Container(
                decoration: ContainerDecoration().copyWith(
                  boxShadow: [
                    BoxShadow(
                      color:  Colors.black.withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 5,
                      // offset: const Offset(0, 0),
                    )
                  ]
                ),
                child: RoundButton(
                    
                    text: 'Create',
                    color1: Theme.of(context).primaryColor,
                    color2: Theme.of(context).primaryColor,
                    icon: Icons.add,
                    onTap: () {
                      if (merchantID != '') {
                        contractMode();

                      }
                    } 
                ),
              );
              
            } else {
              return Container();
            }

                                } else {
                    return Container();
                  }
          }
        ),
        body: Container(
            decoration: ContainerBackgroundDecoration(),
            child: RefreshIndicator(
              key: brakey.refreshMerchant.value,
                onRefresh: () async {
                  final _merchant = await getMerchant(
                    widget.user.payload!.walletAddress ?? '',
                    widget.pin,
                    widget.user.payload!.password??''
                  );
                  final _templates = await fetchMerchantContract(
                      '',
                      '',
                      '',
                      widget.user.payload!.walletAddress ?? '',
                      widget.pin,
                      'all',
                      brakey.user.value?.payload?.password??'',
                      );
                  //     if (_merchant.containsKey('Payload')) {
                  //       setState(() {
                  //   merchant = Future.value(_merchant);
                  // });
                  //     }
                  //     if (_templates.containsKey('Payload')) {
                  //       setState(() {
                  //                             templates = Future.value(_templates);
                  // });
                      // }
 
                  setState(() {
                    merchant = Future.value(_merchant);
                    templates = Future.value(_templates);
                  });
                },
                child: ListView(
                  children: [
                    FutureBuilder<Map>(
                        future: merchant,
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.none:
                                case ConnectionState.waiting:
                                case ConnectionState.active:
                                  {
                                    return Container(
                                      margin: const EdgeInsets.all(40),
                                        decoration: const BoxDecoration(
                                          borderRadius:
                                              BorderRadius.vertical(
                                                  top: Radius.circular(20),
                                                  bottom: Radius.zero),
                                        ),
                                        child: const Center(
                                            child: Text(
                                                "Please wait...")));
                                  }
                                case ConnectionState.done:
                                  {
                          if (snapshot.hasData && snapshot.data.containsKey('Status')) {
                            // print(snapshot.data);
                            if (snapshot.data.containsKey('Status') &&
                                snapshot.data['Status'] == 'successful') {
                              merchantID =
                                  snapshot.data['Payload']['merchant_id'];
                                  hasMerchant = true;

                              return Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(children: [
                                    Container(
                                        decoration: ContainerDecoration(),
                                        padding: EdgeInsets.all(15),
                                        child: Column(
                                          children: [
                                            const SizedBox(height: 10),
                                            const Text(
                                              'Business Detail',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight:
                                                      FontWeight.bold),
                                            ),
                                            ListItemSeparated(
                                                text:
                                                    snapshot.data['Payload']
                                                        ['merchant_id'],
                                                title: 'Business ID'),
                                            ListItemSeparated(
                                                text:
                                                    snapshot.data['Payload']
                                                        ['business_email'],
                                                title: 'Business Email'),
                                            ListItemSeparated(
                                                text: snapshot
                                                        .data['Payload']
                                                    ['business_location'],
                                                title: 'Business Website',
                                                isLast: true),
                                          ],
                                        )),
                                    const SizedBox(height: 20),

                                    SizedBox(
                                        width: double.infinity,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: const [
                                              Text(
                                                'Your Registered contracts',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        )),
                                    FutureBuilder(
                                      future: templates,
                                      builder: (BuildContext context,
                                          AsyncSnapshot templateSnapshot) {
                                        if (templateSnapshot.hasData &&
                                            templateSnapshot.data
                                                .containsKey('Product')) {
                                          final _dummytemplates = [];
                                          _dummytemplates.addAll(
                                              templateSnapshot
                                                  .data['Product']);
                                          _dummytemplates.addAll(
                                              templateSnapshot
                                                  .data['Service']);
                                          _dummytemplates.addAll(
                                              templateSnapshot
                                                  .data['Loan']);
                                          // print("${_templates.length}, 99999999999999999999 ${template_snapshot.data['Product'].length}");
                                          if (templateSnapshot.data
                                                  .containsKey('Product') &&
                                              _dummytemplates.isNotEmpty) {
                                            _templates = _dummytemplates;
                                            return GridView.builder(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 2,
                                                      mainAxisExtent: 200),
                                              itemCount: _templates.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) { 
                                                List<int> image;
                                            // print(_templates[index]['Payload'].keys.toList());
                                                try {
                                                  if (_templates[index]['Payload']['contract_type'] == 'product') {
                                                      List<dynamic> ld = [0];
                                                      image = ld
                                                          .map((s) => s as int)
                                                          .toList();

                                                    } else if (_templates[index]['Payload']['contract_type'] == 'service') {
                                                      List<dynamic> ld = [];
                                                      image = ld
                                                          .map((s) => s as int)
                                                          .toList();
                                                    
                                                    
                                                    } else if (_templates[index]['Payload'].containsKey('loan_link')) {
                                                      List<dynamic> ld = jsonDecode(
                                                          utf8.decode(hex.decode(
                                                              _templates[index][
                                                                      'Payload']
                                                                  [
                                                                  'loan_picture'])));
                                                      image = ld
                                                          .map((s) => s as int)
                                                          .toList();
                                                    } else {
                                                      List<dynamic> ld = jsonDecode(
                                                          utf8.decode(hex.decode(
                                                              _templates[index][
                                                                      'Payload']
                                                                  [
                                                                  'loan_picture'])));
                                                      image = ld
                                                          .map((s) => s as int)
                                                          .toList();
                                                    }
                                                } catch (e) {
                                                  print(e.toString()+'adfasdl');
                                                  // return;
                                                  print(hex.decode(
                                                          _templates[index][
                                                                  'Payload']
                                                              [
                                                              'loan_picture']??''));
                                                  List<dynamic> ld = jsonDecode(
                                                      utf8.decode(hex.decode(
                                                          _templates[index][
                                                                  'Payload']
                                                              [
                                                              'loan_picture']??'4444')));
                                                  image = ld
                                                      .map((s) => s as int)
                                                      .toList();
                                                }
                                                return InkWell(
                                                  onTap: () {
                                                    if (_templates[index]['Payload']['contract_type'] =='product') {
                                                    Navigator.of(context).push(MaterialPageRoute(
                                                        builder: (context) => 
                                                            MerchantProductDetail(
                                                                product:
                                                                    _templates[
                                                                        index])));
                                                            

                                                    } else if (_templates[index]['Payload']['contract_type'] =='service') {
                                                  print(_templates[index]['Payload']['contract_type']);
                                                      Navigator.of(context).push(MaterialPageRoute(
                                                        builder: (context) => MerchantServiceDetail(
                                                                product:
                                                                    _templates[
                                                                        index]['Payload'])));
                                                    } else if (_templates[index]['Payload'].containsKey('loan_picture')) {
                                                      
                                                      Navigator.of(context).push(MaterialPageRoute(
                                                        builder: (context) => MerchantLoanDetail(
                                                                loan:
                                                                    _templates[
                                                                        index]['Payload'])));
                                                    }
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets
                                                            .all(5.0),
                                                    child: Container(
                                                       
                                                        clipBehavior: Clip.antiAliasWithSaveLayer,
                                                        decoration: ContainerDecoration(),
                                                              padding: EdgeInsets.all(5),
                                                        child: Column(
                                                          children: [
                                                          
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(20),
                                                              ),
                                                              clipBehavior: Clip.antiAliasWithSaveLayer,
                                                              child: Stack(
                                                                alignment: Alignment.bottomLeft,
                                                                children: [
                                                                  _templates[index]['Payload']['contract_type'] =='product' ? 
                                                                  Image.network(_templates[index]['Payload']['product_picture_links']?['link_1']??'https://firebasestorage.googleapis.com/v0/b/braketpay-mobile-app.appspot.com/o/assets%2Fimages.png?alt=media&token=2ca79fe2-172f-49ab-93bf-a6550ef78fa2', fit: BoxFit.cover, width: double.infinity, height: double.infinity, errorBuilder: (_, __, ___) {
                                                        return Image.network(brokenImageUrl, fit: BoxFit.cover, width: double.infinity, height: double.infinity,);
                                                      },) :
                                                                  _templates[index]['Payload']['contract_type'] =='service' ? 
                                                                  Image.network(_templates[index]['Payload']['service_picture_links']?['link_1']??'https://firebasestorage.googleapis.com/v0/b/braketpay-mobile-app.appspot.com/o/assets%2Fimages.png?alt=media&token=2ca79fe2-172f-49ab-93bf-a6550ef78fa2', fit: BoxFit.cover, width: double.infinity, height: double.infinity, errorBuilder: (_, __, ___) {
                                                        return Image.network(brokenImageUrl, fit: BoxFit.cover, width: double.infinity, height: double.infinity,);
                                                      },) :
                                                                  Image.memory(Uint8List.fromList(image), fit: BoxFit.cover, width: double.infinity),
                                                                Padding(
                                                                  padding: const EdgeInsets.only(left:8.0, bottom: 5),
                                                                  child: BlurryContainer(
                                                                    padding: EdgeInsets.all(3),
                                                                    color: Colors.black.withOpacity(0.1),
                                                                    borderRadius: BorderRadius.circular(5),
                                                                    child: Text(_templates[index]['Payload']['contract_type']??'loan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600))),
                                                                ),
                                                                        SizedBox(height:4),
                                                                ],
                                                              ),
                                                              height: 120,
                                                              width: double.infinity,
                                                            ),
                                                                        SizedBox(height:10),

                                                            Padding(
                                                              padding: const EdgeInsets.symmetric(horizontal:5.0),
                                                              child: Text(
                                                                  _templates[index]['Payload'].containsKey(
                                                                          'loan_picture') ? toTitleCase(_templates[index]['Payload']['loan_title']): toTitleCase(_templates[index]['Payload']['contract_title']),
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
                                                  ),
                                                
                                                );
                                              },
                                            );
                                          } else {
                                            return Container(
                                                margin: const EdgeInsets.all(40),
                                                child: Center(
                                                    child: Column(
                                                      children: [
                                                        Image.asset('assets/empty.png'),
                                                        Text(
                                                            'You have not Registered any contract yet.\n Click the add button to create.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),),
                                                      ],
                                                    )));
                                          }
                                        } else {
                                          return Center(
                                              child: Column(
                                                children: [
                                                  Image.asset('assets/sammy-no-connection.gif', height: 200),
                                                  const Text(
                                                      "Couldn't load registered Contracts"),
                                                  const SizedBox(height:10),
                                                  RoundButton(
                                                              icon: Icons.refresh,

                                                    text: 'Retry',
                                                    color1: NeutralButton,
                                                    color2: NeutralButton,
                                                    onTap: () {
                                                      brakey.refreshMerchant.value!.currentState!.show();
                                                    }
                                                    
                                                  )
                                                ],
                                              ));
                                        }
                                      },
                                    )
                                    // :
                                  ]));
                            } else {
                              hasMerchant = false;

                              return Form(
                                key: _formKey,
                                child: Container(
                                  padding:
                                      MediaQuery.of(context).viewInsets,
                                  decoration: ContainerBackgroundDecoration(),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                          'Create a Merchant account',
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Container(
                                            color: Colors.grey,
                                            height: 1,
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 20)),
                                        const Text(
                                          'With a Merchant account, you can create and reuse contract templates to share with your customers.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 15),
                                        ),
                                        const SizedBox(height: 20),
                                        Container(
                                          margin:
                                              const EdgeInsets.symmetric(
                                                  vertical: 5),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 10),
                                                child: const Text(
                                                  'Business Name*',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 15),
                                                ),
                                              ),
                                              TextFormField(
                                                cursorColor: Colors.grey,
                                                decoration:
                                                    const InputDecoration(
                                                  fillColor: Color.fromARGB(
                                                      24, 158, 158, 158),
                                                  filled: true,
                                                  focusedBorder: OutlineInputBorder(
                                                      borderSide:
                                                          BorderSide.none,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius
                                                                  .circular(
                                                                      10))),
                                                  hintText: 'Eg, King store',
                                                  border: OutlineInputBorder(
                                                      borderSide:
                                                          BorderSide.none,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius
                                                                  .circular(
                                                                      10))),
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 10),
                                                ),
                                                onChanged: (text) {
                                                  bizName = text.trim();
                                                },
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Business name is required';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                margin: const EdgeInsets
                                                    .symmetric(vertical: 5),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                  children: [
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 10),
                                                      child: const Text(
                                                        'Business Email*',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600,
                                                            fontSize: 15),
                                                      ),
                                                    ),
                                                    TextFormField(
                                                      keyboardType:
                                                          TextInputType
                                                              .emailAddress,
                                                      cursorColor:
                                                          Colors.black,
                                                      decoration:
                                                          const InputDecoration(
                                                        fillColor:
                                                            Color.fromARGB(
                                                                24,
                                                                158,
                                                                158,
                                                                158),
                                                        filled: true,
                                                        focusedBorder: OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide
                                                                    .none,
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        10))),
                                                        hintText:
                                                            'Eg, king@store.com',
                                                        border: OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide
                                                                    .none,
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        10))),
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        10),
                                                      ),
                                                      onChanged: (text) {
                                                        email = text.trim();
                                                      },
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return 'Business email is required';
                                                        }
                                                        return null;
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 120,
                                              margin: const EdgeInsets
                                                      .symmetric(
                                                  vertical: 5,
                                                  horizontal: 10),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                children: [
                                                  Container(
                                                    margin: const EdgeInsets.only(
                                                        bottom: 10),
                                                    child: const Text(
                                                      'Location*',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight
                                                                  .w600,
                                                          fontSize: 15),
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    keyboardType:
                                                        TextInputType
                                                            .streetAddress,
                                                    cursorColor:
                                                        Colors.black,
                                                    decoration:
                                                        const InputDecoration(
                                                      fillColor:
                                                          Color.fromARGB(
                                                              24,
                                                              158,
                                                              158,
                                                              158),
                                                      filled: true,
                                                      focusedBorder: OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide
                                                                  .none,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      10))),
                                                      hintText: 'Eg, Epe',
                                                      border: OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide
                                                                  .none,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      10))),
                                                      contentPadding:
                                                          EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      10),
                                                    ),
                                                    onChanged: (text) {
                                                      bizLoc = text.trim();
                                                    },
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Business Location is required';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.symmetric(
                                                  vertical: 5),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 10),
                                                child: const Text(
                                                  'Business Website',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 15),
                                                ),
                                              ),
                                              TextFormField(
                                                keyboardType:
                                                    TextInputType.url,

                                                cursorColor: Colors.grey,
                                                decoration:
                                                    const InputDecoration(
                                                  fillColor: Color.fromARGB(
                                                      24, 158, 158, 158),
                                                  filled: true,
                                                  focusedBorder: OutlineInputBorder(
                                                      borderSide:
                                                          BorderSide.none,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius
                                                                  .circular(
                                                                      10))),
                                                  hintText:
                                                      'Eg, www.mybusiness.com',
                                                  border: OutlineInputBorder(
                                                      borderSide:
                                                          BorderSide.none,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius
                                                                  .circular(
                                                                      10))),
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 10),
                                                ),
                                                onChanged: (text) {
                                                  website = text.trim();
                                                },
                                                // validator: (value) {
                                                //   if (value == null || value.isEmpty) {
                                                //     return 'Business name is required';
                                                //   }
                                                //   return null;
                                                // },
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.all(10),
                                          child: RoundedLoadingButton(
                                              borderRadius: 10,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              elevation: 0,
                                              controller:
                                                  _loginButtonController,
                                              onPressed: () async {
                                                FocusManager
                                                    .instance.primaryFocus
                                                    ?.unfocus();
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                    StreamController<ErrorAnimationType> _pinErrorController = StreamController<ErrorAnimationType>();
                        final _pinEditController = TextEditingController();
                          Map? pin = await askPin(_pinEditController, _pinErrorController);
                          
                          if (pin == null || !pin.containsKey('pin')) {
                            _loginButtonController.reset();
                            return;
                          };
                                                  // print('$username, $pin, $password');
                                                  Map a = await createMerchant(
                                                      website,
                                                      email,
                                                      widget.user.payload!
                                                              .password ??
                                                          '',
                                                      bizName,
                                                      widget.user.payload!
                                                              .accountNumber ??
                                                          '',
                                                      pin['pin'],
                                                      bizLoc,
                                                      "",
                                                      "",
                                                      false,
                                                      "",
                                                      "",
                                                      "",
                                                      "");
                                                  if (a.containsKey(
                                                      'Payload')) {
                                                    _loginButtonController
                                                        .success();
                                                    showDialog(
                                                        context: context,
                                                        barrierDismissible:
                                                            false,
                                                        builder: (context) {
                                                          return AlertDialog(
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                                                              actions: [
                                                                TextButton(
                                                                  child: const Text(
                                                                      'Okay'),
                                                                  onPressed:
                                                                      () async {
                                                                    Navigator.of(context)
                                                                        .pop();
                                                                    final _merchant =
                                                                        await getMerchant(
                                                                      widget.user.payload!.walletAddress ??
                                                                          '',
                                                                      widget
                                                                          .pin,
                                                                          widget.user.payload!.password??''
                                                                    );

                                                                    final _templates = await fetchMerchantContract(
                                                                        '',
                                                                        '',
                                                                        '',
                                                                        widget.user.payload!.walletAddress ??
                                                                            '',
                                                                        widget.pin,
                                                                        'all',
                                                                        brakey.user.value?.payload?.password??'',
                                                                        
                                                                        );

                                                                    setState(
                                                                        () {
                                                                      merchant =
                                                                          Future.value(_merchant);
                                                                      templates =
                                                                          Future.value(_templates);
                                                                    });
                                                                    brakey.refreshUserDetail();
                                                                  },
                                                                )
                                                              ],
                                                              title: const Text(
                                                                  "Success!"),
                                                              content:
                                                                  const Text(
                                                                      'Your Merchant account was created successfully, you can now create contract templates.'));
                                                        });
                                                  } else {
                                                    _loginButtonController
                                                        .reset();
                                                    showDialog(
                                                        context: context,
                                                        barrierDismissible:
                                                            false,
                                                        builder: (context) {
                                                          return AlertDialog(
shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                                                              actions: [
                                                                TextButton(
                                                                  child: const Text(
                                                                      'Okay'),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(context)
                                                                        .pop();
                                                                    // Navigator.of(context).pop();
                                                                    // Navigator.of(context).pop();
                                                                  },
                                                                )
                                                              ],
                                                              title: const Text(
                                                                  "Can't create Merchant Account!"),
                                                              content: Text(
                                                                  a['Message']));
                                                        });
                                                  }
                                                } else {
                                                  _loginButtonController
                                                      .reset();
                                                }
                                              },
                                              child: const Text('Create')),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                          } else{
                                      return Container(
                                        margin: const EdgeInsets.all(30),

                                          child: Center(
                                              child: Column(
                                                children: [
                                                  Image.asset('assets/sammy-no-connection.gif'),
                                                  const Text(
                                                      "No internet access"),
                                                  const SizedBox(height:10),
                                                  RoundButton(
                                                              icon: Icons.refresh,

                                                    text: 'Retry',
                                                    color1: Colors.black,
                                                    color2: Colors.black,
                                                    onTap: () {
                                                      brakey.refreshMerchant.value!.currentState!.show();
                                                    }
                                                    
                                                  )
                                                ],
                                              )));
                                    }
                                    
                                  }}
  }),
                  ],
                ))));
  }

  contractMode() {
    Get.to(() => MerchantContractModeSelect(
              user: widget.user, pin: widget.pin, merchantID: merchantID));
  }
  //       // child:
}
