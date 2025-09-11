import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  List<String> quotes=['cooking up recipes', 'scrumptious meals being generated', 'frAId rice coming up', 'preheating your screen', 'stirring up the AI pot'];
  int index=Random().nextInt(5);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer){
      setState(() {
        index = (index+1)%quotes.length;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
                    'assets/images/loading.gif',
                    height: 125.0,
                    width: 125.0,
                  ),
            SizedBox(height: 10),
            Text('${quotes[index]}...',
              style: TextStyle(
                color: Colors.white,
                letterSpacing: 2.0,
                fontStyle: FontStyle.italic
              ),
            )
          ],
        ),
      ),
    );
  }
}