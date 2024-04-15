import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thinktank_mobile/api/game_api.dart';
import 'package:thinktank_mobile/api/room_api.dart';
import 'package:thinktank_mobile/data/data.dart';
import 'package:thinktank_mobile/helper/sharedpreferenceshelper.dart';
import 'package:thinktank_mobile/models/account.dart';
import 'package:thinktank_mobile/models/game.dart';
import 'package:thinktank_mobile/models/game_of_server.dart';
import 'package:thinktank_mobile/models/room.dart';
import 'package:thinktank_mobile/models/topic.dart';
import 'package:thinktank_mobile/screens/game/room/waiting_lobby_screen.dart';
import 'package:thinktank_mobile/widgets/appbar/owner_appbar.dart';
import 'package:thinktank_mobile/widgets/game/room_game_selector.dart';
import 'package:thinktank_mobile/widgets/others/spinrer.dart';
import 'package:thinktank_mobile/widgets/others/style_button.dart';

class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({super.key});

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  Account? account = null;
  late Future _initAccount;
  final TextEditingController _controller = TextEditingController();
  bool _isFieldValid = true;
  bool isSelecting = false;
  int selectedPlayers = 3;
  Topic? selectedTopic;
  Game? selectedGame = null;
  GameOfServer? gameOfServer = null;
  DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  Future<Account?> getAccount() async {
    return await SharedPreferencesHelper.getInfo();
  }

  @override
  void initState() {
    super.initState();
    _initAccount = getAccount();
    _initAccount.then((value) {
      setState(() {
        account = value;
        print(account);
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _validateField() {
    setState(() {
      _isFieldValid = _controller.text.isNotEmpty;
    });
  }

  void onSelectGame(Game game) async {
    setState(() {
      selectedGame = game;
      isSelecting = true;
      selectedTopic = null;
      print(selectedGame);
    });
    gameOfServer = await ApiGame.getGameById(game.id);
    print(gameOfServer.toString());
    setState(() {
      isSelecting = false;
    });
  }

  void onCreateRoom() async {
    _validateField();
    if (!_isFieldValid ||
        selectedPlayers <= 0 ||
        selectedGame == null ||
        selectedTopic == null) {
      _showResizableDialogError(
        context,
        "Make sure you have inputted all room required information!",
      );
    } else {
      _showResizableDialog(context);

      Room newRoom = await ApiRoom.createRoom(
          _controller.text, selectedPlayers, selectedTopic!.id);

      if (newRoom ==
          Room(
            id: 0,
            name: _controller.text,
            code: "",
            amountPlayer: selectedPlayers,
            startTime: "",
            endTime: "",
            status: false,
            topicId: selectedTopic!.id,
            topicName: "",
            gameName: "",
            accountInRoomResponses: [],
          )) {
        // ignore: use_build_context_synchronously
        _closeDialog(context);
        // ignore: use_build_context_synchronously
        _showResizableDialogError(
          context,
          "Something went wrong! Can not create a new room party.",
        );
      } else {
        await _databaseReference
            .child('room')
            .child(newRoom.code)
            .child('ownerId')
            .set(account!.id);
        await _databaseReference
            .child('room')
            .child(newRoom.code)
            .child('amountPlayer')
            .set(1);
        await _databaseReference
            .child('room')
            .child(newRoom.code)
            .child('gameId')
            .set(selectedGame!.id);
        await _databaseReference
            .child('room')
            .child(newRoom.code)
            .child('roomName')
            .set(newRoom.name);
        await _databaseReference
            .child('room')
            .child(newRoom.code)
            .child('topicId')
            .set(newRoom.topicId);
        await _databaseReference
            .child('room')
            .child(newRoom.code)
            .child('us1')
            .child('name')
            .set(account!.userName);
        await _databaseReference
            .child('room')
            .child(newRoom.code)
            .child('us1')
            .child('done')
            .set(false);
        await _databaseReference
            .child('room')
            .child(newRoom.code)
            .child('us1')
            .child('avt')
            .set(account!.avatar);
        // ignore: use_build_context_synchronously
        _closeDialog(context);
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) {
              return WaitingLobbyScreen(
                room: newRoom,
                gameId: selectedGame!.id,
              );
            },
          ),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 240, 199),
      extendBodyBehindAppBar: false,
      appBar: TOwnerAppBar(
        preferredHeight: MediaQuery.of(context).size.height * 0.23,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.77,
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  "Create room party",
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Center(
                child: Text(
                  "Please fill all your room information below",
                  style: GoogleFonts.roboto(
                    color: Color.fromARGB(255, 129, 140, 155),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  label: Row(
                    children: [
                      Text(
                        "Room Name",
                        style: GoogleFonts.inter(
                          color: const Color.fromARGB(255, 45, 64, 89),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "*",
                        style: GoogleFonts.inter(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  hintText: "My Room",
                  hintStyle: GoogleFonts.roboto(
                    fontSize: 14,
                  ),
                  errorText: _isFieldValid ? null : 'Room name is required',
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 207, 190, 142),
                    ),
                  ),
                  border: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 255, 213, 96),
                    ),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 255, 213, 96),
                    ),
                  ),
                ),
                onChanged: (value) {
                  _validateField();
                },
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Number of players",
                    style: GoogleFonts.inter(
                      color: const Color.fromARGB(255, 45, 64, 89),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "*",
                    style: GoogleFonts.inter(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  DropdownButtonHideUnderline(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 0,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: DropdownButton<int>(
                        value: selectedPlayers,
                        items: [3, 4, 5, 6, 7, 8]
                            .map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text('$value'),
                          );
                        }).toList(),
                        dropdownColor: Colors.white,
                        onChanged: (int? newValue) {
                          setState(() {
                            selectedPlayers = newValue!;
                          });
                        },
                        style: GoogleFonts.roboto(
                          color: const Color.fromARGB(255, 139, 139, 139),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Select game",
                    style: GoogleFonts.inter(
                      color: const Color.fromARGB(255, 45, 64, 89),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "*",
                    style: GoogleFonts.inter(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  // children: games.sublist(0, 3).map(
                  //   (game) {
                  //     return RoomGameSelector(
                  //       gameSelector: game,
                  //       onSelectGame: () {
                  //         onSelectGame(game);
                  //       },
                  //       isSelected: selectedGame == game,
                  //     );
                  //   },
                  // ).toList(),
                  children: [
                    RoomGameSelector(
                      gameSelector: games[0],
                      onSelectGame: () {
                        onSelectGame(games[0]);
                      },
                      isSelected: selectedGame == games[0],
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    RoomGameSelector(
                      gameSelector: games[2],
                      onSelectGame: () {
                        onSelectGame(games[2]);
                      },
                      isSelected: selectedGame == games[2],
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Text(
                    "Select game topic",
                    style: GoogleFonts.inter(
                      color: const Color.fromARGB(255, 45, 64, 89),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "*",
                    style: GoogleFonts.inter(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  isSelecting == true
                      ? Container(
                          width: 30,
                          height: 30,
                          child: const Center(
                            child: CustomLoadingSpinner(
                              color: Colors.white,
                            ),
                          ),
                        )
                      : gameOfServer != null
                          ? DropdownButtonHideUnderline(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 0,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: DropdownButton<Topic>(
                                  value: selectedTopic,
                                  items:
                                      gameOfServer!.topics.map((Topic topic) {
                                    return DropdownMenuItem<Topic>(
                                      value: topic,
                                      child: Text(topic.name),
                                    );
                                  }).toList(),
                                  hint: const Text("Selected Topic"),
                                  dropdownColor: Colors.white,
                                  onChanged: (Topic? value) {
                                    setState(() {
                                      selectedTopic = value;
                                    });
                                  },
                                  style: GoogleFonts.roboto(
                                    color: const Color.fromARGB(
                                        255, 139, 139, 139),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            )
                          : DropdownButtonHideUnderline(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 0,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: DropdownButton<String>(
                                  value: "Sample",
                                  hint: Text("Sample topic"),
                                  items: ["Sample", "Football"]
                                      .map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  dropdownColor: Colors.white,
                                  onChanged: (String? newValue) {},
                                ),
                              ),
                            ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Center(
                child: SizedBox(
                  height: 80,
                  width: MediaQuery.of(context).size.width - 80,
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(100),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(255, 40, 52, 68),
                          blurRadius: 0,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        onCreateRoom();
                      },
                      style: buttonLoseVer2(context),
                      child: const Text(
                        'CREATE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'ButtonCustomFont',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _showResizableDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(0),
        content: Container(
          width: 250,
          height: 400,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Color.fromARGB(255, 249, 249, 249)),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Image.asset(
                'assets/pics/accOragne.png',
                height: 150,
                width: 150,
              ),
              const SizedBox(height: 10),
              const Text(
                'Please wait...',
                style: TextStyle(
                    color: Color.fromRGBO(234, 84, 85, 1),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 5,
                ),
                child: Text(
                  'Please wait a moment, we\'re preparing room party for you.',
                  style: TextStyle(
                      color: Color.fromRGBO(129, 140, 155, 1),
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const CustomLoadingSpinner(
                  color: Color.fromARGB(255, 245, 149, 24)),
            ],
          ),
        ),
      );
    },
  );
}

void _showResizableDialogError(BuildContext context, String message) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(0),
        content: Container(
          width: 250,
          height: 300,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Color.fromARGB(255, 249, 249, 249)),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Image.asset(
                'assets/pics/error.png',
                height: 150,
                width: 150,
              ),
              const SizedBox(height: 10),
              const Text(
                'Oh no!',
                style: TextStyle(
                    color: Color.fromRGBO(234, 84, 85, 1),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 5,
                ),
                child: Text(
                  message,
                  style: const TextStyle(
                      color: Color.fromRGBO(129, 140, 155, 1),
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

void _closeDialog(BuildContext context) {
  Navigator.of(context).pop();
}
