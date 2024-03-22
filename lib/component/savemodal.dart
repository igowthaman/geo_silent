import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geo_silent/constant/types.dart';

class SaveModal extends StatefulWidget {
  const SaveModal({
    super.key,
    required this.closefunction,
    required this.savefunction,
  });
  final Function closefunction;
  final Function savefunction;

  @override
  _SaveModalState createState() => _SaveModalState();
}

class _SaveModalState extends State<SaveModal> {
  String? _name = '';
  List _days = [];
  SoundMode? _mode = SoundMode.silent;

  void submit() {
    widget.savefunction(_name, _days, _mode);
  }

  void handleDays(day) {
    List tempDays = [..._days];
    if (tempDays.contains(day)) {
      tempDays.remove(day);
      setState(() {
        _days = tempDays;
      });
    } else {
      tempDays.add(day);
      setState(() {
        _days = tempDays;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(40))),
          height: 450,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Name',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blueGrey,
                      ),
                    ),
                    TextField(
                      decoration:
                          const InputDecoration(hintText: 'Name of the place'),
                      onChanged: (String? value) {
                        setState(() {
                          _name = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Mode',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blueGrey,
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: ListTile(
                            title: const Text('Silent'),
                            onTap: () {
                              setState(() {
                                _mode = SoundMode.silent;
                              });
                            },
                            leading: Radio<SoundMode>(
                              value: SoundMode.silent,
                              groupValue: _mode,
                              onChanged: (SoundMode? value) {
                                setState(() {
                                  _mode = SoundMode.silent;
                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: ListTile(
                            title: const Text('Vibrate'),
                            style: ListTileStyle.drawer,
                            onTap: () {
                              setState(() {
                                _mode = SoundMode.vibrate;
                              });
                            },
                            leading: Radio<SoundMode>(
                              value: SoundMode.vibrate,
                              groupValue: _mode,
                              onChanged: (SoundMode? value) {
                                setState(() {
                                  _mode = SoundMode.vibrate;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Repeat',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blueGrey,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 10,
                          child: TextButton(
                            onPressed: () {
                              handleDays(0);
                            },
                            style: ButtonStyle(
                              backgroundColor: _days.contains(0)
                                  ? const MaterialStatePropertyAll(
                                      Colors.teal,
                                    )
                                  : const MaterialStatePropertyAll(
                                      Colors.transparent,
                                    ),
                            ),
                            child: Text(
                              'S',
                              style: TextStyle(
                                color: _days.contains(0)
                                    ? Colors.white
                                    : const Color.fromARGB(255, 0, 102, 92),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 10,
                          child: TextButton(
                            onPressed: () {
                              handleDays(1);
                            },
                            style: ButtonStyle(
                              backgroundColor: _days.contains(1)
                                  ? const MaterialStatePropertyAll(
                                      Colors.teal,
                                    )
                                  : const MaterialStatePropertyAll(
                                      Colors.transparent,
                                    ),
                            ),
                            child: Text(
                              'M',
                              style: TextStyle(
                                color: _days.contains(1)
                                    ? Colors.white
                                    : const Color.fromARGB(255, 0, 102, 92),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 10,
                          child: TextButton(
                            onPressed: () {
                              handleDays(2);
                            },
                            style: ButtonStyle(
                              backgroundColor: _days.contains(2)
                                  ? const MaterialStatePropertyAll(
                                      Colors.teal,
                                    )
                                  : const MaterialStatePropertyAll(
                                      Colors.transparent,
                                    ),
                            ),
                            child: Text(
                              'T',
                              style: TextStyle(
                                color: _days.contains(2)
                                    ? Colors.white
                                    : const Color.fromARGB(255, 0, 102, 92),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 10,
                          child: TextButton(
                            onPressed: () {
                              handleDays(3);
                            },
                            style: ButtonStyle(
                              backgroundColor: _days.contains(3)
                                  ? const MaterialStatePropertyAll(
                                      Colors.teal,
                                    )
                                  : const MaterialStatePropertyAll(
                                      Colors.transparent,
                                    ),
                            ),
                            child: Text(
                              'W',
                              style: TextStyle(
                                color: _days.contains(3)
                                    ? Colors.white
                                    : const Color.fromARGB(255, 0, 102, 92),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 10,
                          child: TextButton(
                            onPressed: () {
                              handleDays(4);
                            },
                            style: ButtonStyle(
                              backgroundColor: _days.contains(4)
                                  ? const MaterialStatePropertyAll(
                                      Colors.teal,
                                    )
                                  : const MaterialStatePropertyAll(
                                      Colors.transparent,
                                    ),
                            ),
                            child: Text(
                              'T',
                              style: TextStyle(
                                color: _days.contains(4)
                                    ? Colors.white
                                    : const Color.fromARGB(255, 0, 102, 92),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 10,
                          child: TextButton(
                            onPressed: () {
                              handleDays(5);
                            },
                            style: ButtonStyle(
                              backgroundColor: _days.contains(5)
                                  ? const MaterialStatePropertyAll(
                                      Colors.teal,
                                    )
                                  : const MaterialStatePropertyAll(
                                      Colors.transparent,
                                    ),
                            ),
                            child: Text(
                              'F',
                              style: TextStyle(
                                color: _days.contains(5)
                                    ? Colors.white
                                    : const Color.fromARGB(255, 0, 102, 92),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 10,
                          child: TextButton(
                            onPressed: () {
                              handleDays(6);
                            },
                            style: ButtonStyle(
                              backgroundColor: _days.contains(6)
                                  ? const MaterialStatePropertyAll(
                                      Colors.teal,
                                    )
                                  : const MaterialStatePropertyAll(
                                      Colors.transparent,
                                    ),
                            ),
                            child: Text(
                              'S',
                              style: TextStyle(
                                color: _days.contains(6)
                                    ? Colors.white
                                    : const Color.fromARGB(255, 0, 102, 92),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                          Colors.white,
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.teal,
                        ),
                      ),
                      onPressed: () => widget.closefunction(),
                    ),
                    ElevatedButton(
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                          Colors.teal,
                        ),
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () => submit(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
