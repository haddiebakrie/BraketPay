import 'dart:typed_data';

import 'package:braketpay/brakey.dart';
import 'package:braketpay/uix/roundbutton.dart';
import 'package:braketpay/uix/themedcontainer.dart';
import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

class UserQR extends StatefulWidget {
  UserQR({Key? key}) : super(key: key);

  @override
  State<UserQR> createState() => _UserQRState();
}
// {'data_type':'account_data', 'username':'haddy'}
class _UserQRState extends State<UserQR> {
  Brakey brakey = Get.put(Brakey());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Center(
          child: Container(
            decoration: ContainerDecoration(),
            padding: EdgeInsets.all(30),
            margin: EdgeInsets.all(40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("${brakey.user.value!.payload!.fullname!.split(' ')[1]}'s QRCODE", 
              style: TextStyle(
                fontSize: 25, fontWeight: FontWeight.bold
              )
              ),
              Image.memory(Uint8List.fromList(hex.decode(brakey.user.value?.payload?.qrCode??'')),
              
              width: 200,
              height: 200,
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: QrImage(
              //     backgroundColor: Colors.white,
              //     padding: EdgeInsets.all(5),
              //     eyeStyle: QrEyeStyle(eyeShape: QrEyeShape.square, color: Theme.of(context).primaryColor ),
              //     data: "{'data_type':'account_data', 'username':'haddy'}",
              //     embeddedImage: AssetImage('assets/braket_qr_embed-03.png'),
              //     size: 200,
              //     version: 3,
              //     embeddedImageStyle: QrEmbeddedImageStyle(size: Size(40, 40)),

              //   ),
              // ),
              Text('Ask your friend to scan your qrcode to perform transactions with you.', textAlign: TextAlign.center),
              SizedBox(height: 20),
              RoundButton(text: 'Share',color1: Theme.of(context).primaryColor, color2: Theme.of(context).primaryColor)
            
            ]
          )
          )
        )
      ),
    );
  }
}