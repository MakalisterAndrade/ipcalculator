import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ipcalculator/bloc/data/IPMath.dart';
import 'package:ipcalculator/bloc/data/NetworkMask.dart';

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
        const Text(
          'Calcule a sub-rede com base em um endereço IP e no sufixo CIDR:',
          textScaleFactor: 1.4,
        ),
        const Text(
            'Esta função permite calcular a sub-rede com base em um endereço IP e sufixo CIDR para IPv4 e IPv6. Você precisa inserir o endereço IP e o sufixo CIDR, e o programa calculará o endereço de sub-rede, endereço de broadcast, máscara de sub-rede, número de hosts e intervalo de hosts utilizável para ambas as versões de IP.'),
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
                decoration: const InputDecoration(
                  labelText: 'IPAddress:',
                ),
              ),
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
                decoration: const InputDecoration(
                  labelText: 'Suffix:',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final NetworkMask networkMask =
                              NetworkMask(_inputIPAddressString, _inputSuffix);
                          widget.networkMaskBySuffixSink.add(networkMask);
                        }
                      },
                      child: const Text('Calcular'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _formKey.currentState!.reset();
                        widget.networkMaskBySuffixSink.add(null);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red, // background
                        onPrimary: Colors.white, // foreground
                      ),
                      child: const Text('Limpar'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
