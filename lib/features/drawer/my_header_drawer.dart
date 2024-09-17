import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:ride_safe/features/login.dart';
import 'package:ride_safe/services/helpers.dart';

import '../../services/constants.dart';
import '../../services/models/user.dart';
import '../../services/providers/ride_safe_provider.dart';

class MyHeaderDrawer extends StatefulWidget {
  MyHeaderDrawer({super.key});

  late User user;
  bool isAuthorized = false;

  @override
  State<MyHeaderDrawer> createState() => _MyHeaderDrawerState();
}

class _MyHeaderDrawerState extends State<MyHeaderDrawer> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var provider = Provider.of<RideSafeProvider>(context, listen: false);
    print('Update state of header: ');
    print('user');
    print(provider.user?.email);
    setState(() {
      if (provider.user != null &&
          provider.user!.id > 0 &&
          provider.user!.id != AppValues.anonymousUserId) {
        widget.isAuthorized = true;
        widget.user = provider.user!;
      } else {
        widget.isAuthorized = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: AppColors.secondaryTextColor,
      width: double.infinity,
      height: 224,
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.25),
                spreadRadius: 0,
                blurRadius: 4,
                offset: const Offset(0, 2))
          ],
          borderRadius: const BorderRadius.all(Radius.circular(16.0))),
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IntrinsicHeight(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.only(right: 10.0),
                      height: 96,
                      width: 96,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image:
                                  AssetImage('assets/images/user_logo.png'))),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          widget.isAuthorized
                              ? widget.user.firstName + widget.user.lastName
                              : '',
                          style: const TextStyle(
                              color: AppColors.primaryTextColor,
                              fontWeight: FontWeight.w800,
                              height: 1.2,
                              fontSize: 32),
                        ),
                        Text(
                          widget.isAuthorized
                              ? widget.user.email
                              : AppValues.loginMessage,
                          style: const TextStyle(
                              color: AppColors.neutrals5,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        if (widget.isAuthorized)
                          const Text(
                            'Edit info',
                            style: TextStyle(
                                color: AppColors.neutrals3,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          )
                      ],
                    ),
                  )
                ]),
          ),
          const Expanded(child: SizedBox()),
          OutlinedButton(
              onPressed: () => {Navigator.pushReplacementNamed(context, '/login')},
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                    color: createMaterialColor(AppColors.primaryColor)),
                textStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Ubuntu',
                ),
                backgroundColor: createMaterialColor(AppColors.primaryColor),
                foregroundColor: createMaterialColor(AppColors.neutrals8),
                minimumSize: const Size(double.infinity, 48),
                // Set minimum width to 100%
                elevation: 0,
                shape: RoundedRectangleBorder(
                  side: BorderSide.none,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: widget.isAuthorized
                  ? const Text('Upgrade to Premium')
                  : const Text('Login')),
        ],
      ),
    );
  }
}
