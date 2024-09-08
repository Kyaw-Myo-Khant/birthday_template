import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: InitialPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class InitialPage extends StatelessWidget {
  final AssetsAudioPlayer _audioPlayer = AssetsAudioPlayer();

  InitialPage({super.key});

  void _playMusic() {
    _audioPlayer
        .open(
      Audio('assets/music.mp3'),
      loopMode: LoopMode.single,
      autoStart: true,
      showNotification: true,
    )
        .then((_) {
      print('Music started successfully.');
    }).catchError((error) {
      print('Error starting music: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[100],
      body: Center(
        child: GestureDetector(
          onTap: () {
            _playMusic();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ImageTogglePage()),
            );
          },
          child: Stack(
            children: [
              Center(
                child: Image.asset(
                  'assets/image1.png', // Replace with your initial image
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageTogglePage extends StatefulWidget {
  const ImageTogglePage({super.key});

  @override
  _ImageTogglePageState createState() => _ImageTogglePageState();
}

class _ImageTogglePageState extends State<ImageTogglePage>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  final List<String> _images = [
    'assets/image2.png',
    'assets/image3.png',
    'assets/image4.png',
  ];

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleImage() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _images.length;
      _controller.reset();
      _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[100],
      body: Center(
        child: GestureDetector(
          onTap: _toggleImage,
          child: Stack(
            children: [
              AnimatedSwitcher(
                duration: const Duration(seconds: 1),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: Center(
                  child: ScaleTransition(
                    scale: _animation,
                    child: Image.asset(
                      _images[_currentIndex],
                      key: ValueKey<int>(_currentIndex),
                      fit: BoxFit.contain,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
