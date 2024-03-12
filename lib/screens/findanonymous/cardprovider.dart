import 'package:flutter/material.dart';

enum CardStatus { confirm, skip }

class CardProvider extends ChangeNotifier {
  Offset _position = Offset.zero;
  bool isDragging = false;
  Offset get position => _position;
  Size _screenSize = Size.zero;
  double _angle = 0;
  List<Color> _urlImages = [];

  CardProvider() {}

  List<Color> get urlImages => _urlImages;
  set urlImages(List<Color> images) {
    _urlImages = images;
  }

  double get angle => _angle;

  void startPosition(DragStartDetails details) {
    isDragging = true;
    notifyListeners();
  }

  void updatePosition(DragUpdateDetails details) {
    _position += details.delta;
    final x = _position.dx;
    _angle = 45 * x / _screenSize.width;

    notifyListeners();
  }

  void endPosition() {
    isDragging = false;
    notifyListeners();
    final status = getStatus();

    switch (status) {
      case CardStatus.confirm:
        confirm();
        break;
      case CardStatus.skip:
        skip();
        break;
      default:
        resetPosition();
    }
  }

  void resetPosition() {
    isDragging = false;
    _position = Offset.zero;
    _angle = 0;
    notifyListeners();
  }

  void setScreenSize(Size size) => _screenSize = size;

  CardStatus? getStatus() {
    final x = _position.dx;
    const delta = 100;
    if (x >= delta) {
      return CardStatus.confirm;
    } else if (x <= -delta) {
      return CardStatus.skip;
    }
    return null;
  }

  void confirm() {
    _angle = 20;
    _position += Offset(2 * _screenSize.width, 0);
    _nextCard();
    notifyListeners();
  }

  void skip() {
    _angle = 20;
    _position -= Offset(2 * _screenSize.width, 0);
    _nextCard();
    notifyListeners();
  }

  Future _nextCard() async {
    if (_urlImages.isEmpty) return;
    await Future.delayed(Duration(milliseconds: 200));
    _urlImages.removeLast();
    resetPosition();
  }

  void resetSource() {
    _urlImages = <Color>[Colors.black, Colors.amber, Colors.pink, Colors.green]
        .reversed
        .toList();
    notifyListeners();
  }
}
