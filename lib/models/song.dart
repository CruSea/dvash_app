import 'package:faker/faker.dart';

List musicUrls = [
  "https://assets.mixkit.co/music/preview/mixkit-tech-house-vibes-130.mp3",
  "https://assets.mixkit.co/music/preview/mixkit-hazy-after-hours-132.mp3",
  "https://assets.mixkit.co/music/preview/mixkit-dreaming-big-31.mp3",
  "https://assets.mixkit.co/music/preview/mixkit-sleepy-cat-135.mp3"
];

class Song {
  final String id, title, singer, imageUrl, audioUrl;

  Song(this.id, this.title, this.singer, this.imageUrl, this.audioUrl);

  factory Song.initial() {
    var faker = new Faker();
    return Song(
      faker.guid.guid(),
      faker.company.name(),
      faker.person.name(),
      faker.image.image(random: true, keywords: ['song']),
      musicUrls[faker.randomGenerator.integer(musicUrls.length)],
    );
  }
  factory Song.fromJson(Map json) {
    return Song(
      json['id'],
      json['title'],
      json['singer'],
      json['image_url'],
      json['audio_url'],
    );
  }

  toJson() {
    return {
      "id": this.id,
      "title": this.title,
      "singer": this.singer,
      "image_url": this.imageUrl,
      "audio_url": this.audioUrl,
    };
  }
}
