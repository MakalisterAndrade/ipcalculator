import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ipcalculator/controller/data/IPMath.dart';
import 'package:ipcalculator/controller/data/NetworkMask.dart';

class CalculateNetworkMaskFormWidget extends StatefulWidget {
  const CalculateNetworkMaskFormWidget(this.networkMaskBySuffixSink);
  final StreamSink<NetworkMask?> networkMaskBySuffixSink;

  @override
  _CalculateNetworkMaskFormWidgetState createState() =>
      _CalculateNetworkMaskFormWidgetState();
}

class _CalculateNetworkMaskFormWidgetState
    extends State<CalculateNetworkMaskFormWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _inputIPAddressString = '';
  int _inputSuffix = 32;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 8,),
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return 'Insira o IPAddress';
                  }
                  if (!IPMath.isValidIPv4AddressString(value) &&
                      (':'.allMatches(value).length < 2 ||
                          !IPMath.isValidIPv6AddressString(
                              IPMath.expandIPv6StringToFullIPv6String(
                                  value)))) {
                    return 'IPAddress inválido';
                  }
                  return null;
                },
                onChanged: (String value) => _inputIPAddressString = value,
                decoration: InputDecoration(
                  labelText: '192.168.1.0',
                  suffixIcon: IconButton(
                    onPressed: () {
                      _formKey.currentState!.reset();
                      widget.networkMaskBySuffixSink.add(null);
                    },
                    icon: const Icon(Icons.clear),
                  ),
                ),
              ),
              SizedBox(height: 11,),
              TextFormField(
                keyboardType: TextInputType.number,
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return 'Insira o Suffix';
                  }
                  final int? suffixInt = int.tryParse(value);
                  if (suffixInt == null) {
                    return 'Suffix deveria ser um inteiro';
                  }
                  if (IPMath.isValidIPv4AddressString(_inputIPAddressString) &&
                      !IPMath.isValidIPv4Suffix(suffixInt)) {
                    return 'Suffix deve estar entre 1 e 32';
                  }
                  if (!IPMath.isValidIPv6Suffix(suffixInt)) {
                    return 'Suffix deve estar entre 1 e 128';
                  }
                  return null;
                },
                onChanged: (String value) {
                  final int? parse = int.tryParse(value);
                  if (parse != null) {
                    _inputSuffix = parse;
                  }
                },
                decoration: InputDecoration(
                  labelText: '24',
                  suffixIcon: IconButton(
                    onPressed: () {
                      _formKey.currentState!.reset();
                      widget.networkMaskBySuffixSink.add(null);
                    },
                    icon: const Icon(Icons.clear),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10,),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final NetworkMask networkMask =
                NetworkMask(_inputIPAddressString, _inputSuffix);
                widget.networkMaskBySuffixSink.add(networkMask);
              }
            },
            child: const Text('Calcular'),
          ),
        ),
        SizedBox(height: 18,),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.lightbulb_outlined),
                    SizedBox(width: 8,),
                    Text("Dica", style: TextStyle(fontWeight: FontWeight.bold),)
                  ],
                ),
                SizedBox(height: 16,),
                Text('Esta função permite calcular a sub-rede com '
                    'base em um endereço IP e sufixo CIDR para IPv4 e'
                    ' IPv6. Você precisa inserir o endereço IP e o sufixo'
                    ' CIDR, e o programa calculará o endereço de '
                    'sub-rede, endereço de broadcast, máscara de sub-rede,'
                    ' número de hosts e intervalo de hosts utilizável para'
                    ' ambas as versões de IP.'),
              ],
            ),
          ),
        ),
        SizedBox(height: 18,),
      ],
    );
  }
}
