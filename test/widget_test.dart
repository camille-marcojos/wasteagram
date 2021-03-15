// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import '../lib/models/post.dart';
import 'package:test/test.dart';

void main() {

  group('Counter', () {
    test('Post object should be converted to json', (){

      final foodWastePost = Post(date: DateTime.parse('2020-03-20'),
      imageURL: 'TEST',
      latitude: 1.0,
      longitude: 2.0,
      quantity: 9);

      var jsonPost = foodWastePost.toJson();

      expect(jsonPost['date'], foodWastePost.date);
      expect(jsonPost['url'], foodWastePost.imageURL);
      expect(jsonPost['latitude'], foodWastePost.latitude);
      expect(jsonPost['longitude'], foodWastePost.longitude);
      expect(jsonPost['quantity'], foodWastePost.quantity);
    
    });

    test('Post object should be converted to string', (){

      final foodWastePost = Post(date: DateTime.parse('2020-03-20'),
      imageURL: 'TEST',
      latitude: 1.0,
      longitude: 2.0,
      quantity: 9);

      var stringPost = foodWastePost.toString();

      expect('Post: date: 2020-03-20 00:00:00.000, url: TEST, quantity: 9, lat: 1.0, lon: 2.0', stringPost);

      });

  });

}
