import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:meeting/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Api {
  static const baseUrl = "http://192.168.43.107:2000/";
  static const socketurl = "http://192.168.43.107:2000";

  static verifyuser() async {}

//post method
  static Future<Map<String, dynamic>> getmessagat(index, discussion) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    Map<String, String> headers = {
      'Authorization': token.toString(),
      // Adjust the content type if needed
    };
    print('hee');

    var url = Uri.parse("${baseUrl}messagesget/${discussion}?index=${index}");

    try {
      final res = await http.get(url, headers: headers);

      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        print(data);

        if (data != null) {
          // Check if the data itself is not null

          return {'messages': data, 'state': true};
        } else {
          print("There are no profile to show");
          return {'state': false};
        }
      } else {
        return {'state': false};
      }
    } catch (e) {
      return {'state': false};
    }
  }

  static addUser(Map pdata) async {
    print(pdata);
    var url = Uri.parse("${baseUrl}add_user");

    try {
      final res = await http.post(url, body: pdata);

      if (res.statusCode == 200) {
        var data = jsonDecode(res.body.toString());
        print(data);
      } else {
        print("Failed to get response");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

// Add a new message
  static addTextMessage(Map pdata) async {
    print(pdata);
    var url = Uri.parse("${baseUrl}send_message");

    try {
      final res = await http.post(url, body: pdata);

      if (res.statusCode == 200) {
        var data = jsonDecode(res.body.toString());
        print(data);
      } else {
        print("Failed to get response");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

//get method
  static Future<List<User>> getUser() async {
    List<User> products = [];

    var url = Uri.parse("${baseUrl}get_user/");

    try {
      final res = await http.get(url);

      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        print(data);

        if (data != null) {
          // Check if the data itself is not null
          for (var userData in data) {
            products.add(User(
              //  firstname: userData['fname'],
              // lastname: userData['lname'],
              email: userData['email'],
              password: userData['password'],
              id: userData[
                  '_id'], // You might need to adjust the actual field name here
            ));
          }

          return products;
        } else {
          print("There are no products to show");
          return [];
        }
      } else {
        return [];
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  static Future<ProfileUser?> getProfileUserToUpdate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    Map<String, String> headers = {
      'Authorization': token.toString(),
      // Adjust the content type if needed
    };
    ProfileUser? prodata;

    var url = Uri.parse("${baseUrl}get_profileusertoupdate");

    try {
      final res = await http.get(url, headers: headers);

      if (res.statusCode == 200) {
        var productData = jsonDecode(res.body);

        if (productData != null) {
          // Check if the data itself is not null
          prodata = ProfileUser(
            firstname: productData['fname'],
            lastname: productData['lname'],
            age: productData['age'],
            phone: productData['phone'],
            image: productData['image'],
            user: productData['user'],
            id: productData[
                '_id'], // You might need to adjust the actual field name here
          );
        }

        return prodata;
      } else {
        print("There are no profile to show");
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  static updateProfile(String id, String firstname, String lastname, String age,
      String phone) async {
    var url =
        Uri.parse("$baseUrl/update_profileuser/$id"); // Use / instead of +
    print(id);
    print("$baseUrl/update_profileuser/$id"); // Use / instead of +

    try {
      final response = await http.put(
        url,
        headers: <String, String>{
          'Content-Type':
              'application/json; charset=UTF-8', // Set appropriate content type
        },
        body: jsonEncode({
          'fname': firstname,
          'lname': lastname,
          'age': age,
          'phone': phone,
        }),
      );

      if (response.statusCode == 200) {
        print("Profile updated successfully: ${jsonDecode(response.body)}");
      } else {
        print("Failed to update profile: ${response.statusCode}");
        print(response.body);
      }
    } catch (error) {
      print("An error occurred: $error");
    }
  }

  // Update method
  static updateUser(String id, String firstname, String lastname, String email,
      String password) async {
    var url = Uri.parse("$baseUrl" + "update/$id");
    print(id);
    print("$baseUrl" + "delete/$id");

    try {
      final response = await http.put(url, body: {
        'fname': firstname,
        'lname': lastname,
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        print("Product updated successfully: ${jsonDecode(response.body)}");
      } else {
        print("Failed to update product: ${response.statusCode}");
        print(response.body);
      }
    } catch (error) {
      print("An error occurred: $error");
    }
  }

  static Future<int> like(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    // Check if the token is null or empty and return an appropriate value

    Map<String, String> headers = {
      'Authorization': token.toString(),
      'Content-Type': 'application/json',
      // Adjust the content type if needed
    };

    var url = Uri.parse("$baseUrl" + "like/${id}");
    print(url);

    try {
      final res = await http.post(url, headers: headers);
      if (res.statusCode == 201) {
        return 1;
      } else if (res.statusCode == 400) {
        return 2;
      } else {
        return 3;
      }

      // Check the HTTP response status code
    } catch (error) {
      print('API Error: $error');
      return 3;
      // Return 0 for "error" or handle as needed
    }
  }

  static Future<int> dislike(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    // Check if the token is null or empty and return an appropriate value

    Map<String, String> headers = {
      'Authorization': token.toString(),
      'Content-Type': 'application/json',
      // Adjust the content type if needed
    };

    var url = Uri.parse("$baseUrl" + "dislike/${id}");
    print(url);

    try {
      final res = await http.post(url, headers: headers);
      if (res.statusCode == 200) {
        return 1;
      } else if (res.statusCode == 400) {
        return 2;
      } else {
        return 3;
      }

      // Check the HTTP response status code
    } catch (error) {
      print('API Error: $error');
      return 3;
      // Return 0 for "error" or handle as needed
    }
  }

  static Future<int> loginsuccess() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    // Check if the token is null or empty and return an appropriate value
    if (token == null || token.isEmpty) {
      return 3; // Return 2 for "not logged in" or handle as needed
    }

    print(token);

    Map<String, String> headers = {
      'Authorization': token,
      'Content-Type': 'application/json',
      // Adjust the content type if needed
    };

    var url = Uri.parse("$baseUrl" + "check-login");
    print(url);

    try {
      final res = await http.post(url, headers: headers);

      // Check the HTTP response status code
      if (res.statusCode == 200) {
        return 1; // Return 1 for "logged in"
      } else if (res.statusCode == 401) {
        return 2; // Return 2 for "not logged in" or handle as needed
      } else {
        return 3; // Handle other cases as needed
      }
    } catch (error) {
      print('API Error: $error');
      return 0; // Return 0 for "error" or handle as needed
    }
  }

  static Future<void> deleteUser(id) async {
    var url = Uri.parse("$baseUrl" + "delete/$id");
    print("$baseUrl" + "delete/$id");
    try {
      final res = await http.delete(url);

      if (res.statusCode == 204) {
        print("user deleted successfully");
      } else {
        print("Failed to delete user: ${res.statusCode}");
        print(res.body);
      }
    } catch (error) {
      print("An error occurred: $error");
    }
  }

  static Future<Map<String, dynamic>> getdiscussion(id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    Map<String, String> headers = {
      'Authorization': token.toString(),
      // Adjust the content type if needed
    };
    List<ProfileUser> prodata = [];

    var url = Uri.parse("${baseUrl}discussion/${id}");

    try {
      final res = await http.get(url, headers: headers);

      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        print(data);

        if (data != null) {
          // Check if the data itself is not null
          var messz = new List.from(data['messages']);
          return {
            'messages': messz,
            'profile': data['profile'],
            'id': data['id'],
            'iduser': data['iduser'],
            'lenmsg': data['lenmsg']
          };
        } else {
          print("There are no profile to show");
          return {};
        }
      } else {
        return {};
      }
    } catch (e) {
      print(e.toString());
      return {};
    }
  }

  static Future<List<ProfileUser>> getMatchUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    Map<String, String> headers = {
      'Authorization': token.toString(),
      // Adjust the content type if needed
    };
    List<ProfileUser> prodata = [];

    var url = Uri.parse("${baseUrl}getchatlist");

    try {
      final res = await http.get(url, headers: headers);

      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        print(data);

        if (data != null) {
          // Check if the data itself is not null
          for (var productData in data) {
            prodata.add(ProfileUser(
              firstname: productData['fname'],
              lastname: productData['lname'],
              age: productData['age'],
              phone: productData['phone'],
              image: productData['image'],
              user: productData['user'],
              id: productData[
                  '_id'], // You might need to adjust the actual field name here
            ));
          }

          return prodata;
        } else {
          print("There are no profile to show");
          return [];
        }
      } else {
        return [];
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  //get method
  static Future<List<ProfileUser>> getProfileUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    Map<String, String> headers = {
      'Authorization': token.toString(),
      // Adjust the content type if needed
    };
    List<ProfileUser> prodata = [];

    var url = Uri.parse("${baseUrl}get_profileuser");

    try {
      final res = await http.get(url, headers: headers);

      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        print(data);

        if (data != null) {
          // Check if the data itself is not null
          for (var productData in data) {
            prodata.add(ProfileUser(
              firstname: productData['fname'],
              lastname: productData['lname'],
              age: productData['age'],
              phone: productData['phone'],
              image: productData['image'],
              user: productData['user'],
              id: productData[
                  '_id'], // You might need to adjust the actual field name here
            ));
          }

          return prodata;
        } else {
          print("There are no profile to show");
          return [];
        }
      } else {
        return [];
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  static Future<List<ProfileUser>> getlikes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    Map<String, String> headers = {
      'Authorization': token.toString(),
      // Adjust the content type if needed
    };
    List<ProfileUser> prodata = [];

    var url = Uri.parse("${baseUrl}likes");

    try {
      final res = await http.get(url, headers: headers);

      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        print(data);

        if (data != null) {
          // Check if the data itself is not null
          for (var productData in data) {
            prodata.add(ProfileUser(
              firstname: productData['liked']['profile']['fname'],
              lastname: productData['liked']['profile']['lname'],
              age: productData['liked']['profile']['age'],
              phone: productData['liked']['profile']['phone'],
              image: productData['liked']['profile']['image'],
              user: productData['liked']['profile']['user'],
              id: productData[
                  '_id'], // You might need to adjust the actual field name here
            ));
          }

          return prodata;
        } else {
          print("There are no profile to show");
          return [];
        }
      } else {
        return [];
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
