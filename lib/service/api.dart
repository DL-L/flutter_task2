import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter_task2/models/History.dart';
import 'package:flutter_task2/models/Task.dart';
import 'package:flutter_task2/models/User.dart';
import 'package:flutter_task2/models/Users.dart';
import 'package:flutter_task2/models/Invitation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SingletonDio {
  static var cookiemanager = CookieManager(CookieJar());

  static Dio getDio() {
    Dio dio = Dio(
      BaseOptions(
        headers: {
          "Accept": "application/json",
        },
      ),
    );
    dio.options.connectTimeout = 90000;
    dio.options.receiveTimeout = 90000;
    dio.interceptors.add(cookiemanager);
    return dio;
  }
}

class Network {
  final String _url = 'http://10.0.2.2:8000/api';
  //when using android studio emulator, change localhost to 10.0.2.2

  postData(data, apiUrl) async {
    try {
      var fullUrl = _url + apiUrl;
      var response =
          await SingletonDio.getDio().post(fullUrl, data: jsonEncode(data));
      return response; // return json.decode(response.body)
    } catch (e) {
      var _error = e.toString();
      return false;
    }
  }

  //////////////////////////////////////////TASK/////////////////////////////////////////
  updateTaskAdmin(data, apiUrl) async {
    try {
      var fullUrl = _url + apiUrl;
      var response =
          await SingletonDio.getDio().put(fullUrl, queryParameters: data);
      return response;
    } catch (e) {
      var _error = e.toString();
      return false;
    }
  }

  updateTaskSub(data, apiUrl) async {
    try {
      var fullUrl = _url + apiUrl;
      var response =
          await SingletonDio.getDio().put(fullUrl, queryParameters: data);
      return response;
    } catch (e) {
      var _error = e.toString();
      return false;
    }
  }

  Future<List<Task>> getAdminTasksData(data, apiUrl) async {
    try {
      var response = await SingletonDio.getDio().get(_url + apiUrl,
          options: Options(headers: {"Authorization": "Bearer $_getToken()"}),
          queryParameters: data);

      if (response.statusCode == 200) {
        List<Task> tasks =
            (response.data as List).map((x) => Task.fromJson(x)).toList();
        return tasks;
      } else {
        return <Task>[];
      }
    } catch (error, stacktrace) {
      throw Exception("Exception occured: $error stacktrace: $stacktrace");
    }
  }

  Future<Task> showTaskData(apiUrl) async {
    try {
      var response = await SingletonDio.getDio().get(_url + apiUrl,
          options: Options(headers: {"Authorization": "Bearer $_getToken()"}));

      Task task = Task.fromJson(response.data);
      return task;
    } catch (error, stacktrace) {
      throw Exception("Exception occured: $error stacktrace: $stacktrace");
    }
  }

  Future<List<Task>> getTaskData(apiUrl) async {
    try {
      var response = await SingletonDio.getDio().get(_url + apiUrl,
          options: Options(
            headers: {"Authorization": "Bearer $_getToken()"},
            // responseType: ResponseType.plain,
            contentType: 'application/json;charset=UTF-8',
            // receiveTimeout: 10000,
          ));
      // print('object');
      // print(response.data);
      if (response.statusCode == 200) {
        List<Task> tasks =
            (response.data as List).map((x) => Task.fromJson(x)).toList();
        return tasks;
      } else {
        return <Task>[];
      }
    } catch (error, stacktrace) {
      throw Exception("Exception occured: $error stacktrace: $stacktrace");
    }
  }

  DeleteTask(taskId) async {
    try {
      print(taskId);
      var response = await SingletonDio.getDio().delete(
          _url + '/admin/tasks/' + taskId,
          options: Options(headers: {"Authorization": "Bearer $_getToken()"}));
      if (response.statusCode == 204) {
        return true;
      } else {
        return false;
      }
    } catch (error, stacktrace) {
      throw Exception("Exception occured: $error stacktrace: $stacktrace");
    }
  }

  subUpdateTask(data, apiUrl) async {
    try {
      var fullUrl = _url + '/sub/tasks/' + apiUrl;
      var response =
          await SingletonDio.getDio().put(fullUrl, data: jsonEncode(data));
      print(response.headers);
      return response; // return json.decode(response.body)
    } catch (e) {
      var _error = e.toString();
      print(_error);
      return false;
    }
  }

//////////////////////////////////////USER///////////////////////////////////////////////
  Future<List<User>> getPublicData(apiUrl) async {
    try {
      var response = await SingletonDio.getDio().get(_url + apiUrl,
          options: Options(headers: {"Authorization": "Bearer $_getToken()"}));
      if (response.statusCode == 200) {
        List<User> users =
            (response.data as List).map((x) => User.fromJson(x)).toList();
        return users;
      } else {
        return <User>[];
      }
    } catch (error, stacktrace) {
      throw Exception("Exception occured: $error stacktrace: $stacktrace");
    }
  }

  Future<User1> getUserData(apiUrl) async {
    try {
      var response = await SingletonDio.getDio().get(_url + apiUrl,
          options: Options(headers: {"Authorization": "Bearer $_getToken()"}));

      User1 users = User1.fromJson(response.data);
      return users;
    } catch (error, stacktrace) {
      throw Exception("Exception occured: $error stacktrace: $stacktrace");
    }
  }

  ///////////////////////////////STATUS////////////////////////////////////////////
  Future<List<Status>> getStatuses(apiUrl) async {
    try {
      var response = await SingletonDio.getDio().get(_url + apiUrl,
          options: Options(headers: {"Authorization": "Bearer $_getToken()"}));
      if (response.statusCode == 200) {
        List<Status> statuses =
            (response.data as List).map((x) => Status.fromJson(x)).toList();
        return statuses;
      } else {
        return <Status>[];
      }
    } catch (error, stacktrace) {
      throw Exception("Exception occured: $error stacktrace: $stacktrace");
    }
  }

  /////////////////////////////HISTORY//////////////////////////////////////////
  Future<List<History>> getHistoryData(data, apiUrl) async {
    try {
      var response = await SingletonDio.getDio().get(_url + apiUrl,
          options: Options(headers: {"Authorization": "Bearer $_getToken()"}),
          queryParameters: data);

      if (response.statusCode == 200) {
        List<History> histories =
            (response.data as List).map((x) => History.fromJson(x)).toList();
        return histories;
      } else {
        return <History>[];
      }
    } catch (error, stacktrace) {
      throw Exception("Exception occured: $error stacktrace: $stacktrace");
    }
  }
  //////////////////////////////Invitations////////////////////////////////////

  Future<List<Invitation>> getInvitationData(apiUrl) async {
    try {
      var response = await SingletonDio.getDio().get(_url + apiUrl,
          options: Options(
            headers: {"Authorization": "Bearer $_getToken()"},
            // responseType: ResponseType.plain,
            contentType: 'application/json;charset=UTF-8',
            // receiveTimeout: 10000,
          ));
      if (response.statusCode == 200) {
        List<Invitation> invitations =
            (response.data as List).map((x) => Invitation.fromJson(x)).toList();
        return invitations;
      } else {
        return <Invitation>[];
      }
    } catch (error, stacktrace) {
      throw Exception("Exception occured: $error stacktrace: $stacktrace");
    }
  }

  updateInvitation(data, apiUrl) async {
    try {
      var fullUrl = _url + apiUrl;
      var response =
          await SingletonDio.getDio().put(fullUrl, queryParameters: data);
      return response;
    } catch (e) {
      var _error = e.toString();
      return false;
    }
  }

  DeleteInvitation(invitationId) async {
    try {
      print(invitationId);
      var response = await SingletonDio.getDio().delete(
          _url + '/invitations/' + invitationId,
          options: Options(headers: {"Authorization": "Bearer $_getToken()"}));
      if (response.statusCode == 204) {
        return true;
      } else {
        return false;
      }
    } catch (error, stacktrace) {
      throw Exception("Exception occured: $error stacktrace: $stacktrace");
    }
  }

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    return '?token=$token';
  }
}
