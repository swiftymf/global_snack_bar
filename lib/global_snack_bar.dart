library global_snack_bar;

import 'dart:async';

import 'package:flutter/material.dart';

/// Provides a universal snack bar
/// Must be a child of a scaffold
/// Simply wrap the content with [GlobalMsgWrapper]
class GlobalMsgWrapper extends StatefulWidget {
  /// The content that will appear from this widget
  final Widget content;
  GlobalMsgWrapper(this.content);

  @override
  _GlobalMsgWrapperState createState() => _GlobalMsgWrapperState();
}

/// The state of the [GlobalMsgWrapper] Widget
class _GlobalMsgWrapperState extends State<GlobalMsgWrapper> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await for (var message in GlobalSnackBarBloc.newMessage) {
        showSnackBar(message);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void showSnackBar(SnackBar snackBar) {
    ScaffoldMessenger.of(context)..showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return widget.content;
  }
}

/// Provides the stream logic for the [GlobalSnackBar]
class GlobalSnackBarBloc {
  /// Create a new [streamController] to handle broadcasting to a [Stream]
  static final streamController =
      StreamController.broadcast(); // create a StreamController or
  // final counterController = PublishSubject() or any other rxdart option;

  /// Provides a [Stream] for new messages
  static Stream get newMessage =>
      streamController.stream; // create a getter for our Stream
  // the rxdart stream controllers returns an Observable instead of a Stream

  /// Method to show a [SnackBar] message on any [GlobalSnackBar] Widgets
  static void showSnackBar(SnackBar data) {
    streamController.sink.add(data); // add whatever data we want into the Sink
  }

  /// Allows for the stream to be closed
  dispose() {
    streamController.close();
  }
}
