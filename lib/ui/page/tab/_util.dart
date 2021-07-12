import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

typedef OnPreRequest<T> = T? Function();
typedef StreamResolver<T> = Stream Function(T param);

void showSaveOrCancelDialog<T>(
    {required BuildContext context,
    required Widget child,
    required StreamResolver<T> streamResolver,
    required Function onSaved,
    required OnPreRequest<T> preProcessor,
    Widget? bottomChild}) async {
  final saved = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
            child: ProgressHUD(
              // TODO barrier not work completely.
                barrierEnabled: true,
                child: Builder(builder: (progressContext) {
                  return Container(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      child,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.blueGrey),
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('cancel')),
                          _saveButton(preProcessor, progressContext,
                              streamResolver, context
                          ),
                        ],
                      ),
                      if (null != bottomChild) bottomChild,
                    ],
                  ));
                })));
      });
  if (saved) {
    onSaved();
  }
}

ElevatedButton _saveButton<T>(
    OnPreRequest<T> preProcessor,
    BuildContext progressContext,
    StreamResolver<T> streamResolver,
    BuildContext context) {
  return ElevatedButton(
    child: const Text('save'),
    onPressed: () async {
      T? value = preProcessor();
      if (null == value) {
        return;
      }
      final progress = ProgressHUD.of(progressContext)!;
      progress.show();
      // @formatter:off
      streamResolver(value).listen((ignore) {},
          onDone: () {
            progress.dismiss();
            Navigator.of(context).pop(true);
          },
          onError: (e, stackTrace) {
            print('an error occurred!\nStacktrace is below.');
            print(stackTrace);
            final snackBar = SnackBar(
                content: Container(
                    height: 90,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'What went wrong!!',
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                          Text(e.response?.data.toString() ??
                              'Server not responded.'),
                    ])
                ),
                duration: Duration(seconds: 10));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
      );
      // @formatter:on
    },
  );
}
