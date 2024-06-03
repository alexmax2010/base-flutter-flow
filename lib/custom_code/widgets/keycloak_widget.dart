// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
import 'package:keycloak_flutter/keycloak_flutter.dart';
import 'dart:html';

class KeycloakWidget extends StatefulWidget {
  const KeycloakWidget({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<KeycloakWidget> createState() => _KeycloakWidgetState();
}

class _KeycloakWidgetState extends State<KeycloakWidget> {
  KeycloakProfile? _keycloakProfile;
  late KeycloakService keycloakService;

  void _login() {
    keycloakService = KeycloakService(KeycloakConfig(
        url: 'http://localhost:8080', // Keycloak auth base url
        realm: 'sample',
        clientId: 'sample-flutter'));
    keycloakService.init(
      initOptions: KeycloakInitOptions(
        onLoad: 'check-sso',
        responseMode: 'query',
        silentCheckSsoRedirectUri:
            '${window.location.origin}/silent-check-sso.html',
      ),
    );

    keycloakService.login(KeycloakLoginOptions(
      redirectUri: '${window.location.origin}',
    ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    try {
      this._login();
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        keycloakService.keycloakEventsStream.listen((event) async {
          print(event);
          if (event.type == KeycloakEventType.onAuthSuccess) {
            _keycloakProfile = await keycloakService.loadUserProfile();
          } else {
            _keycloakProfile = null;
          }
          setState(() {});
        });
        if (keycloakService.authenticated) {
          _keycloakProfile = await keycloakService.loadUserProfile(false);
        }
        setState(() {});
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
