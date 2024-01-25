import 'package:agora_uikit/agora_uikit.dart';
import 'package:agoraexample/constants.dart';
import 'package:flutter/material.dart';

class BaseVideoCallPage extends StatefulWidget {

  const BaseVideoCallPage({super.key, });
  @override
  State<BaseVideoCallPage> createState() => _BaseVideoCallPageState();
}
class _BaseVideoCallPageState extends State<BaseVideoCallPage> {
  static String channelName = "agora";
 
  bool isLoading = true;
  late AgoraClient client;
  @override
  void initState() {
    super.initState();
   
    isLoading = true;
   initAgora();
  }
  Future<void> initAgora() async {
    
    client = AgoraClient(
      
      agoraConnectionData: AgoraConnectionData(
        appId: agoraId,
        channelName: channelName,
        tempToken: '007eJxTYFixftYcpiPs087MtebevWz7s+D1c+PXrjMJYp2z2+oLZ8JvBYY0C/PkVEsDAwPLZEOTVGMjy6S05BRjE/MkC4M0CxMTi8gvG1MbAhkZ/K5psjAyQCCIz8qQmJ5flMjAAAC3xyC1',
      ),
    );
    await client.initialize();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AgoraVideoViewer(
            client: client,
            layoutType: Layout.oneToOne,
            enableHostControls: true, // Add this to enable host controls
          ),
          AgoraVideoButtons(
            client: client,
            addScreenSharing: false, // Add this to enable screen sharing
            onDisconnect: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

