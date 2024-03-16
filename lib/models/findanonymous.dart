import 'package:thinktank_mobile/models/findanounymous_assets.dart';

class FindAnonymous {
  const FindAnonymous({
    required this.level,
    required this.listAnswer,
    required this.time,
  });

  final int level;
  final List<FindAnonymousAsset> listAnswer;
  final int time;
}
