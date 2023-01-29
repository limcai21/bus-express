import 'package:flutter/material.dart';

loadingAlert(context, {String title}) async {
  if (context != null) {
    await Future.delayed(Duration(milliseconds: 1));
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // DISABLE BACK BUTTON AT THE BOTTOM TO CANCEL DIALOG
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            insetPadding: const EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor,
                        ),
                      ),
                      height: 30,
                      width: 30,
                    ),
                    if (title != null) SizedBox(height: 20),
                    if (title != null) Text(title),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
