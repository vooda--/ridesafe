import 'package:flutter/material.dart';

class MyHeaderDrawer extends StatefulWidget {
  @override
  State<MyHeaderDrawer> createState() => _MyHeaderDrawerState();
}

class _MyHeaderDrawerState extends State<MyHeaderDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green.shade700,
      width: double.infinity,
      height: 200,
      padding: EdgeInsets.only(top: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10.0),
            height: 70,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('assets/images/diamond.png')
              )
            ),
          ),
          const Text('VoodaLab', style: TextStyle(color:Colors.white, fontSize: 20),),
          Text('info@voodalab.dev', style: TextStyle(
            color: Colors.grey[200],
            fontSize: 14,
          ),)
        ],
      ),
    );
  }
}
