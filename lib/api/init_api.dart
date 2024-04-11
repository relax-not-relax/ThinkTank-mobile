import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/image_resource.dart';
import 'package:thinktank_mobile/models/musicpasssource.dart';
import 'package:thinktank_mobile/models/musicpassword.dart';
import 'package:thinktank_mobile/models/resourceversion.dart';

class ApiInit {
  static Future<ResourceVersion?> getResourceVersion() async {
    final response = await http.get(
      Uri.parse(
          'https://thinktank-sep490.azurewebsites.net/api/versionOfResources'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return ResourceVersion.fromJson(jsonData);
    } else {
      return null;
    }
  }
}
