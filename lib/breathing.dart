import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:breathing_collection/breathing_collection.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'dart:math' as math;

import 'package:neon_circular_timer/neon_circular_timer.dart';

class BreathingGame extends StatefulWidget {
  @override
  _BreathingGameState createState() => _BreathingGameState();
}

class _BreathingGameState extends State<BreathingGame> {
  final CountDownController controller = new CountDownController();
  bool countDown =true;
  final player = AudioPlayer();
  bool isPlay = true, inhalebool = true;
  String inhale = 'Breath In';
  static const countdownDuration = Duration(minutes: 10);
  Duration duration = const Duration();
  Timer? timer;
  @override
  void initState() {
    player.play(AssetSource('sounds/meditate.mp3')).then((value) => null);
    startTimer();
    reset();
    super.initState();
  }

  @override
  void dispose() {
    player.stop();
    // _controller.dispose();
    super.dispose();
  }
  void reset(){
    if (countDown){
      setState(() =>
      duration = countdownDuration);
    } else{
      setState(() =>
      duration = Duration());
    }
  }

  void startTimer(){
    setState(() {

      timer = Timer.periodic(const Duration(seconds: 1),(_) => addTime());
    });
  }

  void addTime(){
    final addSeconds = countDown ? -1 : 1;
    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      if (seconds < 0){
        timer?.cancel();
      } else{
        duration = Duration(seconds: seconds);

      }
    });
  }

  void stopTimer({bool resets = true}){
    if (resets){
      reset();
    }
    setState(() => timer?.cancel());
  }
  Widget buildTime(){
    String twoDigits(int n) => n.toString().padLeft(2,'0');
    final hours =twoDigits(duration.inHours);
    final minutes =twoDigits(duration.inMinutes.remainder(60));
    final seconds =twoDigits(duration.inSeconds.remainder(60));
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildTimeCard(time: minutes, header:'MINUTES'),
          SizedBox(width: 8,),
          buildTimeCard(time: seconds, header:'SECONDS'),
        ]
    );
  }

  Widget buildTimeCard({required String time, required String header}) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20)
            ),
            child: Text(
              time, style: TextStyle(fontWeight: FontWeight.bold,
                color: Colors.black,fontSize: 50),),
          ),
          SizedBox(height: 24,),
          Text(header,style: TextStyle(color: Colors.black45)),
        ],
      );
  Widget buildButtons(){
    final isRunning = timer == null? false: timer!.isActive;
    final isCompleted = duration.inSeconds == 0;
    return isRunning || isCompleted
        ? Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16)
            ),
            onPressed: (){
              if (isRunning){
                stopTimer(resets: false);
              }
            },
            child: Text('STOP',style: TextStyle(fontSize: 20,color: Colors.black,),)
        ),
        SizedBox(width: 12,),
        ElevatedButton(
        style: ElevatedButton.styleFrom(
        primary: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16)
        ),
        onPressed: stopTimer,
        child: Text('CANCEL',style: TextStyle(fontSize: 20,color: Colors.black,),)
        )
      ],
    )
        :
    ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16)
        ),
        onPressed: startTimer,
        child: Text("Start Timer!",style: TextStyle(fontSize: 20,color: Colors.black,),)
    );}
  @override
  Widget build(BuildContext context) {
    // inhalebool=!inhalebool;
    return Scaffold(
      body: Stack(
        children: [
          BreathingBackground(
            initialMainColor: Colors.white,
            transformedMainColor: Colors.cyanAccent,
            initialSecondaryColor: Colors.greenAccent,
            transformedSecondaryColor: Colors.limeAccent,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            duration: const Duration(seconds: 3),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 500),
            child:  buildTime(),
          ),
          Center(
            child: Ripples(
              onPressed: () {},
              child: const CircleAvatar(
                  radius: 48,
                  backgroundImage: AssetImage(
                    'assets/images/meditate.jpg',
                  )),
            ),
          ),
          Center(
            child: NeonCircularTimer(
              width: 200,
              duration: 5,
              onComplete: () {
                controller.restart();
                // print('Book:${inhalebool}');
              },
              controller: controller,
              isTimerTextShown: false,
              neumorphicEffect: false,
              innerFillGradient: const LinearGradient(
                  colors: [Colors.greenAccent, Colors.blueAccent]),
              neonGradient: const LinearGradient(
                  colors: [Colors.greenAccent, Colors.blueAccent]),
            ),
          ),
          // Center(
          //     child: Container(
          //       margin:const EdgeInsets.only(top: 400),
          //       child: Text(inhalebool ? 'Breath In' : 'Breath Out',style: const TextStyle(color: Colors.white,fontSize: 30),),
          //     )),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 100),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GFButton(
                      onPressed: () {
                        setState(() {
                          isPlay
                              ? {controller.pause(), player.pause(),
                          stopTimer(resets: false)}
                              : {controller.resume(), player.resume(),startTimer()};
                          isPlay = !isPlay;
                        });
                      },
                      text: "",
                      icon: isPlay
                          ? const Icon(
                              Icons.pause_circle,
                              color: Colors.white,
                            )
                          : const Icon(
                              Icons.play_circle,
                              color: Colors.white,
                            ),
                      shape: GFButtonShape.pills,
                    ),
                    GFButton(
                      icon: const Icon(
                        Icons.repeat,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          stopTimer();
                          isPlay = true;
                        });
                        player
                            .play(AssetSource('sounds/meditate.mp3'))
                            .then((value) => null);
                        controller.restart();
                      },
                      text: "",
                      shape: GFButtonShape.pills,
                    ),
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}

class Ripples extends StatefulWidget {
  const Ripples({
    this.size = 250.0,
    this.color = Colors.lightBlueAccent,
    required this.onPressed,
    required this.child,
  });

  final double size;
  final Color color;
  final Widget child;
  final VoidCallback onPressed;

  @override
  _RipplesState createState() => _RipplesState();
}

class _CirclePainter extends CustomPainter {
  _CirclePainter(
    this._animation, {
    required this.color,
  }) : super(repaint: _animation);

  final Color color;
  final Animation<double> _animation;

  void circle(Canvas canvas, Rect rect, double value) {
    final double opacity = (1.0 - (value / 4.0)).clamp(0.0, 1.0);
    final Color _color = color.withOpacity(opacity);

    final double size = rect.width / 2;
    final double area = size * size;
    final double radius = math.sqrt(area * value / 4);

    final Paint paint = Paint()..color = _color;
    canvas.drawCircle(rect.center, radius, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);

    for (int wave = 3; wave >= 0; wave--) {
      circle(canvas, rect, wave + _animation.value);
    }
  }

  @override
  bool shouldRepaint(_CirclePainter oldDelegate) => true;
}

class _RipplesState extends State<Ripples> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _button() {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.size),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: <Color>[
                widget.color,
                Color.lerp(widget.color, Colors.black, .05)!
              ],
            ),
          ),
          child: ScaleTransition(
            scale: Tween(begin: 0.95, end: 1.0).animate(
              CurvedAnimation(
                parent: _controller,
                curve: const _PulsateCurve(),
              ),
            ),
            child: SizedBox(height: 200, width: 200, child: widget.child),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CirclePainter(
        _controller,
        color: widget.color,
      ),
      child: SizedBox(
        width: widget.size * 2.125,
        height: widget.size * 2.125,
        child: _button(),
      ),
    );

  }

}

class _PulsateCurve extends Curve {
  const _PulsateCurve();

  @override
  double transform(double t) {
    if (t == 0 || t == 1) {
      return 0.01;
    }
    return math.sin(t * math.pi);
  }
}
