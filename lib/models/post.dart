
class Post {
  DateTime date;
  String imageURL;
  int quantity;
  double longitude;
  double latitude;

  Post({this.date, this.imageURL, this.quantity, this.longitude, this.latitude});

  @override
  String toString() {
    return 'Post: date: ${date}, url: ${imageURL}, quantity: ${quantity}, lat: ${latitude}, lon: ${longitude}';
  }

  Map<String, dynamic> toJson() =>
  {
    'date': this.date,
    'url': this.imageURL,
    'latitude': this.latitude,
    'longitude': this.longitude,
    'quantity': this.quantity,
  };

}