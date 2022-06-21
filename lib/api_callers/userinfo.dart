import 'dart:convert';
import 'package:braketpay/classes/user.dart';
import "package:http/http.dart" as http;

Future<Map<String, dynamic>> getUserInfo(
  String userName,
  ) async {
  String param = Uri(queryParameters: {
      "caller_email" :"classichaddy@gmail.com",
      "caller_password": "love4haddy",
      "id_type": "username",
      "second_party_id": userName
    }).query;

    try {
    final response = await http.get(
      Uri.parse('https://api.braketpay.com/fetch_second_party_credentials?$param'),
      headers: {
        'Content-Type':'application/json',
        'AUTHORIZATION': "ca417768436ff0183085b3d7c382773f"
        },
      );
      // print('4${response.body}');
    if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    Map<String, dynamic> payloads = jsonDecode(response.body);
    return payloads;
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    return {'Message':'No Internet access'};
  }

    } catch (e) {
      print(e);
    return {'Message':'No Internet access'};
    }

}

Future<Map<String, dynamic>> getUserWith(
  String id,
  String type, 
  ) async {
  String param = Uri(queryParameters: {
      "caller_email" :"classichaddy@gmail.com",
      "caller_password": "love4haddy",
      "id_type": type,
      "second_party_id": id
    }).query;
    try {
    final response = await http.get(
      Uri.parse('https://api.braketpay.com/fetch_second_party_credentials?$param'),
      headers: {
        'Content-Type':'application/json',
        'AUTHORIZATION': "ca417768436ff0183085b3d7c382773f"
        },
      );
    // print(response.body);
    if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
      Map<String, dynamic> payloads = jsonDecode(response.body);
    return payloads;
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
      print('Hell');
    return {'Message':'No Internet access'};
  }

    } catch (e) {
      print(e);
    return {'Message':'No Internet access'};
    }
}


Future<Map> verifyUserAccount(
  String userName,
  String password,
  String transactionPin,  
  ) async {
  String param = Uri(queryParameters: {
      "caller_email" :userName,
      "caller_password": password,
      "id_type": "account number",
      "second_party_id": "2204112769"
    }).query;
    try {
    final response = await http.get(
      Uri.parse('https://api.braketpay.com/fetch_second_party_credentials?$param'),
      headers: {
        'Content-Type':'application/json',
        'AUTHORIZATION': "ca417768436ff0183085b3d7c382773f"
        },
      );
    if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    if (response.body is Map) {
      Map<String, dynamic> payloads = jsonDecode(response.body);
      return payloads;
    } else {
      return {"Info": response.body};
    }


  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw response.statusCode;
  }

    } catch (e)
 {
   print(e);
   throw 'No Internet Access';
 }}

Future<User> fetchUserAccount(
  String accountNumber,
  String password,
  String transactionPin,
) async {
  String param = Uri(queryParameters: {
                      "account_number" : accountNumber,
                      "password" : password,
                      "transaction_pin": transactionPin,
                      "observation": "fetch account",
                      "datetime": "Wed, 13 Apr 2022 01:21:07 GMT"
                  }).query;
    // try {
    final response = await http.get(
      Uri.parse('https://api.braketpay.com/braket_electronic_notification/v1?$param'),
      headers: {
        'Content-Type':'application/json',
        'AUTHORIZATION': "ca417768436ff0183085b3d7c382773f"
        },
      );
    // print(response.body);
    if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    if (jsonDecode(response.body) is Map) {
      Map a = jsonDecode(response.body);
      // print(a['Payload']);
      if (jsonDecode(response.body).containsKey('Payload')) {
        Map<String, dynamic> payloads = jsonDecode(response.body);
        return User.fromJson(payloads);
        } 
      else {
          throw 'Incorrect Password!';
        }
    } else {
      // print(response.body);
      // print("$password, $transactionPin");
      throw 'Incorrect Password!';
    }

  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw 'Please check your internet connection';
  }
    // } catch (e) {
    //   print(e);
    //   throw 'No internet Connection';

    // }
    
}

Future<User> loginUser(  
  String userName,
  String password,
  String transactionPin,  
  ) async {
  Map<String, dynamic> validUsername =  await getUserInfo(userName);
  if (validUsername.containsKey('Payload')) {
    String accountNumber =  validUsername['Payload']['account_number'];
    
    return fetchUserAccount(accountNumber, password, transactionPin);
  } else if (validUsername.containsKey('Message')) {
    throw validUsername['Message'];

  }else {
    throw 'Please check your internet connection';
  };
}

Future<Map> getLoginOtp(
  String email,
  String password,
  String deviceName,
  String deviceProcessor,
  String deviceArchi,
  String location,
  String operatingSystem,
)  async {
  
   String param = Uri(queryParameters: {
                  "email_address" : email,
                  "password": password,
                  "device_name": deviceName,
                  "operating_system": operatingSystem,
                  "device_processor": deviceProcessor,
                  "device_architecture": deviceArchi,
                  "location": location
                  }).query;
      print(param);
    try {
    final response = await http.get(
      Uri.parse('https://api.braketpay.com/verify_new_device_login?$param'),
      headers: {
        'Content-Type':'application/json',
        'AUTHORIZATION': "ca417768436ff0183085b3d7c382773f"
        },
      );
    print(response);
    if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
      Map a = jsonDecode(response.body);
      print(a);
        return a;

  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
      return {'Message':'Please check your internet connection!'};
  }
    } catch (e) {
      print(e);
      return {'Message':'Please check your internet connection!'};
    }
}


Future<User> fetchUserRecord(
  String email,
  String password,
  String otp,
) async {
  String param = Uri(queryParameters: {
                      "email_address" : email,
                      "password" : password,
                      "verification_code": otp,
                  }).query;
    // try {
    final response = await http.get(
      Uri.parse('https://api.braketpay.com/fetch_record?$param'),
      headers: {
        'Content-Type':'application/json',
        'AUTHORIZATION': "ca417768436ff0183085b3d7c382773f"
        },
      );
      print(response);
    if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    if (jsonDecode(response.body) is Map) {
      Map a = jsonDecode(response.body);
      // print(a['Payload']);
      if (jsonDecode(response.body).containsKey('Payload')) {
        Map<String, dynamic> payloads = jsonDecode(response.body);
        return User.fromJson(payloads);
        } 
      else {
          throw 'Incorrect Password!';
        }
    } else {
      // print(response.body);
      // print("$password, $transactionPin");
      throw 'Incorrect Password!';
    }

  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw 'Please check your internet connection';
  }
    // } catch (e) {
    //   print(e);
    //   throw 'No internet Connection';

    // }
    
}