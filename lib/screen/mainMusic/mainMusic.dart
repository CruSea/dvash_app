import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dvash_app/models/song.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MainMusic extends StatefulWidget {
  const MainMusic({Key? key}) : super(key: key);

  @override
  _MainMusicState createState() => _MainMusicState();
}

class _MainMusicState extends State<MainMusic> {
  List songs = [
    Song.initial(),
    Song.initial(),
    Song.initial(),
    Song.initial(),
    Song.initial(),
  ];
  late Song selectedSong = songs[0];
  AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
  bool isPlaying = false;
  bool isStarted = false;
  Duration position = Duration(microseconds: 0, seconds: 0);
  Duration durration = Duration(microseconds: 0, seconds: 0);
  void playSong(BuildContext context, Song song) async {
    if (isPlaying) {
      audioPlayer.pause();
      setState(() {
        this.isPlaying = false;
      });
      int result = await audioPlayer.play(song.audioUrl);
      if (result == 1) {
        setState(() {
          this.isPlaying = true;
          this.isStarted = true;
        });
      }
    } else {
      int result = await audioPlayer.play(song.audioUrl);
      if (result == 1) {
        setState(() {
          this.isPlaying = true;
          this.isStarted = true;
        });
      }
    }
    audioPlayer.onDurationChanged.listen((event) {
      setState(() {
        this.durration = event;
      });
    });
    audioPlayer.onAudioPositionChanged.listen((event) {
      setState(() {
        this.position = event;
      });
    });
  }

  void pause() {
    audioPlayer.pause();
    setState(() {
      this.isPlaying = false;
    });
  }

  void resume() {
    audioPlayer.resume();
    setState(() {
      this.isPlaying = true;
    });
  }

  void showModalView(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white.withAlpha(180),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) {
        return Opacity(
          opacity: 0.1,
          child: Container(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "My Playlist",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: songs.length,
              itemBuilder: (context, index) => musicListTile(
                  song: songs[index],
                  onTap: () {
                    playSong(context, songs[index]);
                    setState(() {
                      selectedSong = songs[index];
                    });
                  }),
            ),
          ),
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.grey.shade600, blurRadius: 5),
              ],
            ),
            child: InkWell(
              onTap: () {
                showModalView(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                            '${position.inMinutes.remainder(60).toString().padLeft(2, '0')}: ${position.inSeconds.remainder(60).toString().padLeft(2, '0')}'),
                        Expanded(
                          child: Slider.adaptive(
                            activeColor: Colors.yellow,
                            inactiveColor: Colors.yellow,
                            value: this.position.inSeconds.toDouble(),
                            min: 0,
                            max: this.isStarted
                                ? this.durration.inSeconds.toDouble()
                                : 1,
                            onChanged: (value) {},
                          ),
                        ),
                        Text(
                            '${this.durration.inMinutes.remainder(60).toString().padLeft(2, '0')}: ${durration.inSeconds.remainder(60).toString().padLeft(2, '0')}'),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            child: CachedNetworkImage(
                              imageUrl: selectedSong.imageUrl,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              placeholder: (context, url) => SpinKitThreeBounce(
                                color: Colors.amber,
                                size: 30.0,
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5),
                              Text(
                                selectedSong.title,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                selectedSong.singer,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () {
                              if (this.isPlaying) {
                                this.pause();
                              } else {
                                this.resume();
                              }
                            },
                            iconSize: 30,
                            icon: Icon(this.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

Widget musicListTile({required Song song, onTap}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.all(5),
      child: Row(
        children: [
          Container(
            height: 120,
            width: 100,
            child: CachedNetworkImage(
              imageUrl: song.imageUrl,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) => SpinKitThreeBounce(
                color: Colors.amber,
                size: 30.0,
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15),
              Text(
                song.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                song.singer,
                style: TextStyle(),
              )
            ],
          ))
        ],
      ),
    ),
  );
}
