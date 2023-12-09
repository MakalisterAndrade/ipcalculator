import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ipcalculator/controller/NetworkMaskBloc.dart';
import 'package:ipcalculator/view/ip/widgets/calculateNetworkMaskFormByTwoAddressWidget.dart';
import 'package:ipcalculator/view/ip/widgets/calculateNetworkMaskFormWidget.dart';
import 'package:ipcalculator/view/ip/widgets/networkMaskInfoWidget.dart';
import 'package:url_launcher/url_launcher.dart';

enum SingingCharacter { one, two }

class NetworkManagerMainScreen extends StatefulWidget {
  @override
  _NetworkManagerMainScreenState createState() =>
      _NetworkManagerMainScreenState();
}

class _NetworkManagerMainScreenState extends State<NetworkManagerMainScreen> {
  final String _sourceCodeUrl =
      'https://github.com/MakalisterAndrade/ipcalculator';

  SingingCharacter? _character = SingingCharacter.one;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _buildBody(),
        bottomNavigationBar: _buildBottomNavigationBar()
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('IP Calculator'),
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    );
  }

  SafeArea _buildBody() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5,),
              const Text(
                'Calculadora',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6,),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: const Text('Um IP'),
                      leading: Radio<SingingCharacter>(
                        value: SingingCharacter.one,
                        groupValue: _character,
                        onChanged: (SingingCharacter? value) {
                          setState(() {
                            _character = value;
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: const Text('Dois IPs'),
                      leading: Radio<SingingCharacter>(
                        value: SingingCharacter.two,
                        groupValue: _character,
                        onChanged: (SingingCharacter? value) {
                          setState(() {
                            _character = value;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              if (_character == SingingCharacter.one) ... [
                CalculateNetworkMaskFormWidget(
                    networkMaskBloc.networkMaskBySuffixSink),
                NetworkMaskInfoWidget(
                    networkMaskBloc.networkMaskBySuffixStream)
              ] else ... [
                CalculateNetworkMaskFormByTwoAddressWidget(
                    networkMaskBloc.networkMaskByTwoAddressSink),
                NetworkMaskInfoWidget(
                    networkMaskBloc.networkMaskByTwoAddressStream)
              ]
            ],
          ),
        ),
      ),
    );
  }

  Container _buildBottomNavigationBar() {
    return Container(
      color: const Color.fromRGBO(233, 236, 239, 1),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            const Text('©2023 Makalister Andrade'),
            TextButton(
              style: TextButton.styleFrom(
                primary: Colors.blueAccent,
              ),
              onPressed: () async => canLaunch(_sourceCodeUrl) != null
                  ? await launch(_sourceCodeUrl)
                  : throw 'Não foi possível encontrar a url $_sourceCodeUrl',
              child: const Text('Source-Code'),
            )
          ],
        ),
      ),
    );
  }
}
