import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agoraexample/screens/constants.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class AgoraScreen extends StatefulWidget {
  const AgoraScreen({super.key});

  @override
  State<AgoraScreen> createState() => _AgoraScreenState();
}

class _AgoraScreenState extends State<AgoraScreen> {
  late Map<String, dynamic> config; // Configuration parameters
  int localUid = -1;
  String appId = agoraId, channelName = "agora";
  List<int> remoteUids = []; // Uids of remote users in the channel
  bool isJoined = false; // Indicates if the local user has joined the channel
  bool isBroadcaster = true; // Client role
  RtcEngine? agoraEngine; // Agora engine instance


  Future<void> setupAgoraEngine() async {
    // Retrieve or request camera and microphone permissions
    await [Permission.microphone, Permission.camera].request();

    // Create an instance of the Agora engine
    agoraEngine = createAgoraRtcEngine();
    await agoraEngine!.initialize(RtcEngineContext(appId: appId));

    await agoraEngine!.enableVideo();

    // Register the event handler
    agoraEngine!.registerEventHandler(getEventHandler());
  }
  RtcEngineEventHandler getEventHandler() {
    return RtcEngineEventHandler(
        // Occurs when the network connection state changes
        onConnectionStateChanged: (RtcConnection connection,
            ConnectionStateType state, ConnectionChangedReasonType reason) {
            if (reason ==
                ConnectionChangedReasonType.connectionChangedLeaveChannel) {
                remoteUids.clear();
                isJoined = false;
            }
            // Notify the UI
            Map<String, dynamic> eventArgs = {};
            eventArgs["connection"] = connection;
            eventArgs["state"] = state;
            eventArgs["reason"] = reason;
            // eventCallback("onConnectionStateChanged", eventArgs);
        },
        // Occurs when a local user joins a channel
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            isJoined = true;
            // messageCallback(
            //     "Local user uid:${connection.localUid} joined the channel");
            // Notify the UI
            Map<String, dynamic> eventArgs = {};
            eventArgs["connection"] = connection;
            eventArgs["elapsed"] = elapsed;
            // eventCallback("onJoinChannelSuccess", eventArgs);
        },
        // Occurs when a remote user joins the channel
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
            remoteUids.add(remoteUid);
            // messageCallback("Remote user uid:$remoteUid joined the channel");
            // Notify the UI
            Map<String, dynamic> eventArgs = {};
            eventArgs["connection"] = connection;
            eventArgs["remoteUid"] = remoteUid;
            eventArgs["elapsed"] = elapsed;
            // eventCallback("onUserJoined", eventArgs);
        },
        // Occurs when a remote user leaves the channel
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
            remoteUids.remove(remoteUid);
            // messageCallback("Remote user uid:$remoteUid left the channel");
            // Notify the UI
            Map<String, dynamic> eventArgs = {};
            eventArgs["connection"] = connection;
            eventArgs["remoteUid"] = remoteUid;
            eventArgs["reason"] = reason;
            // eventCallback("onUserOffline", eventArgs);
        },
    );
}


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setupAgoraEngine();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('agora video')),
      body: Stack(
        children: [
          Center(
            child: _remoteVideo(),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
                width: 100,
                height: 150,
                child: Center(
                    child: isJoined
                        ? AgoraVideoView(
                            controller: VideoViewController(
                                rtcEngine: agoraEngine!,
                                canvas: VideoCanvas(uid: 0)))
                        : const CircularProgressIndicator())),
          )
        ],
      ),
    );
  }
    Widget _remoteVideo() {
    if (remoteUids.isNotEmpty) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: agoraEngine!,
          canvas: VideoCanvas(uid:remoteUids.first ),
          connection: const RtcConnection(channelId: 'agora'),
        ),
      );
    } else {
      return const Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
      );
    }
  }

}
