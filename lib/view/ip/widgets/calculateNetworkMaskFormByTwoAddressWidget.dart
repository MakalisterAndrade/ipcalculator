import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ipcalculator/controller/data/IPMath.dart';
import 'package:ipcalculator/controller/data/IPv6Address.dart';
import 'package:ipcalculator/controller/data/NetworkMask.dart';

class CalculateNetworkMaskFormByTwoAddressWidget extends StatefulWidget {
  const CalculateNetworkMaskFormByTwoAddressWidget(
      this.networkMaskByTwoAddressSink);
  final StreamSink<NetworkMask?> networkMaskByTwoAddressSink;

  @override
  _CalculateNetworkMaskFormByTwoAddressWidgetState createState() =>
      _CalculateNetworkMaskFormByTwoAddressWidgetState();
}

class _CalculateNetworkMaskFormByTwoAddressWidgetState
    extends State<CalculateNetworkMaskFormByTwoAddressWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _inputIPAddress1String = '';
  String _inputIPAddress2String = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 8,
        ),
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

                  print(value);
                  print(IPMath.expandIPv6StringToFullIPv6String(value));
                  if (!IPMath.isValidIPv4AddressString(value) &&
                      (':'.allMatches(value).length < 2 ||
                          !IPMath.isValidIPv6AddressString(
                              IPMath.expandIPv6StringToFullIPv6String(
                                  value)))) {
                    return 'IPAddress inválido';
                  }
                  return null;
                },
                onChanged: (String value) => _inputIPAddress1String = value,
                decoration: InputDecoration(
                  labelText: '192.168.1.0',
                  suffixIcon: IconButton(
                    onPressed: () {
                      _formKey.currentState!.reset();
                      widget.networkMaskByTwoAddressSink.add(null);
                    },
                    icon: const Icon(Icons.clear),
                  ),
                ),
              ),
              const SizedBox(height: 11),
              TextFormField(
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return 'Insira o IP Address';
                  }
                  if (!IPMath.isValidIPv4AddressString(value) &&
                      (':'.allMatches(value).length < 2 ||
                          !IPMath.isValidIPv6AddressString(
                              IPMath.expandIPv6StringToFullIPv6String(
                                  value)))) {
                    return 'IP Address inválido';
                  }
                  return null;
                },
                onChanged: (String value) => _inputIPAddress2String = value,
                decoration: InputDecoration(
                  labelText: '192.168.56.2',
                  suffixIcon: IconButton(
                    onPressed: () {
                      _formKey.currentState!.reset();
                      widget.networkMaskByTwoAddressSink.add(null);
                    },
                    icon: const Icon(Icons.clear),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      IPv6Address iPv6Address1 =
                          IPMath.parseIPv4OrIPv6StringToIPv6Address(
                              _inputIPAddress1String);
                      IPv6Address iPv6Address2 =
                          IPMath.parseIPv4OrIPv6StringToIPv6Address(
                              _inputIPAddress2String);

                      final bool isIPv4Address = iPv6Address1.isIPv4Address() &&
                          iPv6Address2.isIPv4Address();

                      if (iPv6Address1.isGreaterThan(iPv6Address2)) {
                        final IPv6Address iPv6AddressTemp = iPv6Address1;
                        iPv6Address1 = iPv6Address2;
                        iPv6Address2 = iPv6AddressTemp;
                      }

                      int smallestSuffix =
                          IPMath.getSmallestSuffixBetweenTwoIPv6Address(
                              iPv6Address1, iPv6Address2,
                              isIPv4Address: isIPv4Address);

                      bool success;
                      String ip = iPv6Address1.isIPv4Address()
                          ? iPv6Address1.getIPv4String()
                          : iPv6Address1.getIPv6String();

                      NetworkMask networkMask;
                      do {
                        success = true;
                        networkMask = NetworkMask(ip, smallestSuffix,
                            showIPOnPrint: false);

                        final IPv6Address networkIPv6Address =
                            networkMask.getNetworkIPv6Address();

                        if (networkIPv6Address.isGreaterThan(iPv6Address1) ||
                            networkIPv6Address.isGreaterThan(iPv6Address2)) {
                          smallestSuffix--;
                          ip = iPv6Address1.isIPv4Address()
                              ? iPv6Address1.getIPv4String()
                              : iPv6Address1.getIPv6String();
                          success = false;
                        } else {
                          final IPv6Address broadcastIPv6Address =
                              networkMask.getBroadcastIPv6Address();

                          if (iPv6Address1
                                  .isGreaterThan(broadcastIPv6Address) ||
                              iPv6Address2
                                  .isGreaterThan(broadcastIPv6Address)) {
                            final BigInt countHosts =
                                IPMath.getCountHostsBySuffix(smallestSuffix,
                                    isIPv4Address: isIPv4Address);

                            String binaryString = IPMath.binaryPlusBinary(
                                iPv6Address1.getBinary(),
                                IPMath.bigIntToBinary(countHosts <= BigInt.zero
                                    ? BigInt.one
                                    : countHosts));

                            final int byteCount = isIPv4Address
                                ? IPMath.iPv4AddressByteCount
                                : IPMath.iPv6AddressByteCount;
                            binaryString = binaryString
                                .padLeft(byteCount)
                                .replaceAll(' ', '0');

                            ip = isIPv4Address
                                ? IPMath.binaryToIPv4String(binaryString)
                                : IPMath.binaryToIPv6String(binaryString);

                            success = false;
                          }
                        }
                      } while (!success);

                      widget.networkMaskByTwoAddressSink.add(networkMask);
                    }
                  },
                  child: const Text('Calcular'),
                ),
              ),
              SizedBox(
                height: 18,
              ),
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.lightbulb_outlined),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            "Dica",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text('Esta função permite calcular a sub-rede com base '
                          'em dois endereços IP para IPv4 e IPv6. Você precisa '
                          'inserir os dois endereços IP e o programa calculará o '
                          'endereço de sub-rede, endereço de broadcast, máscara'
                          ' de sub-rede, número de hosts e intervalo de hosts'
                          ' utilizável para ambas as versões de IP.'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
            ],
          ),
        ),
      ],
    );
  }
}
