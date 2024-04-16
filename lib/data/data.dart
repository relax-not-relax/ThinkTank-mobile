import 'package:flutter/material.dart';
import 'package:thinktank_mobile/controller/network_manager.dart';
import 'package:thinktank_mobile/models/account_in_room.dart';
import 'package:thinktank_mobile/models/contest.dart';
import 'package:thinktank_mobile/models/game.dart';
import 'package:thinktank_mobile/models/notification_item.dart';

const games = [
  Game(
    id: 1,
    imageUrl: "assets/pics/game_1.png",
    name: "Flip Card Challenge",
    description:
        "Experience the thrill of our Flip Card game! Memorize cards and seek out matching pairs, enhancing both your visual and short-term memory skills.",
    type: ["Visual memory"],
    color: Color.fromARGB(255, 252, 144, 42),
  ),
  Game(
    id: 2,
    imageUrl: "assets/pics/game_2.png",
    name: "Music Password",
    description:
        "Players will listen to a piece of music provided by the host to decipher the password for the house, enhancing their auditory memory skills.",
    type: ["Auditory memory", "Interactive memory", "Sensory memory"],
    color: Color.fromARGB(255, 245, 171, 43),
  ),
  Game(
    id: 4,
    imageUrl: "assets/pics/game_4.png",
    name: "Images Walkthrough",
    description:
        "The player simply has to identify what the previous image was, a task that's simple yet not so simple.",
    type: ["Sequential memory"],
    color: Color.fromARGB(255, 85, 125, 176),
  ),
  Game(
    id: 5,
    imageUrl: "assets/pics/game_3.png",
    name: "Find The Anonymous",
    description:
        "The player's mission is to identify the 'anonymous' within a group of people after being provided with a description of that person.",
    type: ["Associative memory"],
    color: Color.fromARGB(255, 234, 84, 85),
  ),
  Game(
    id: 6,
    imageUrl: "assets/pics/game_5.png",
    name: "Room Party",
    description:
        "Create a common playroom for friends to improve memory together.",
    type: [],
    color: Color.fromARGB(255, 45, 64, 89),
  ),
];

const contest = [
  "https://firebasestorage.googleapis.com/v0/b/thinktank-79ead.appspot.com/o/0%2Fcontest_1.png?alt=media&token=56159759-0357-4f10-b276-cd39bb333006",
  "https://firebasestorage.googleapis.com/v0/b/thinktank-79ead.appspot.com/o/0%2Fcontest_2.png?alt=media&token=ade1f3b9-2b52-4bad-a84d-2e80bc6e577b",
];

var genders = [
  "Male",
  "Female",
  "Other",
];

const usersTest = [
  "Hoang Duc Nguyen",
  "Tran Hoang Phuc",
  "Tram Bao",
  "Pham Ha Vi",
  "Hieu Bui"
];

var usersRoomTest = [
  AccountInRoom(
    id: 1,
    isAdmin: false,
    accountId: 1,
    username: "Hannah",
    roomId: 1,
    duration: 0,
    mark: 0,
    pieceOfInformation: 0,
    avatar:
        "https://firebasestorage.googleapis.com/v0/b/thinktank-79ead.appspot.com/o/0%2Fgirl_1.jpg?alt=media&token=694244ad-cd59-4368-80e3-84fd940d97e6",
  ),
  AccountInRoom(
    id: 2,
    isAdmin: false,
    accountId: 2,
    username: "Layla",
    roomId: 1,
    duration: 0,
    mark: 0,
    pieceOfInformation: 0,
    avatar:
        "https://firebasestorage.googleapis.com/v0/b/thinktank-79ead.appspot.com/o/0%2Fgirl_2.jpg?alt=media&token=5baaf827-5064-413c-ad0b-9fcfbeff93ec",
  ),
  AccountInRoom(
    id: 3,
    isAdmin: false,
    accountId: 3,
    username: "Kate",
    roomId: 1,
    duration: 0,
    mark: 0,
    pieceOfInformation: 0,
    avatar:
        "https://firebasestorage.googleapis.com/v0/b/thinktank-79ead.appspot.com/o/0%2Fgirl_3.jpg?alt=media&token=e508fd56-617c-4e64-ad4d-71a16ddaa5d7",
  ),
  AccountInRoom(
    id: 4,
    isAdmin: false,
    accountId: 4,
    username: "Violet",
    roomId: 1,
    duration: 0,
    mark: 0,
    pieceOfInformation: 0,
    avatar:
        "https://firebasestorage.googleapis.com/v0/b/thinktank-79ead.appspot.com/o/0%2Fgirl_4.jpg?alt=media&token=fbe1b207-55fe-4ef3-b93e-67d7f05c24ca",
  ),
  AccountInRoom(
    id: 5,
    isAdmin: false,
    accountId: 5,
    username: "Sally",
    roomId: 1,
    duration: 0,
    mark: 0,
    pieceOfInformation: 0,
    avatar:
        "https://firebasestorage.googleapis.com/v0/b/thinktank-79ead.appspot.com/o/0%2Fgirl_5.jpg?alt=media&token=eb3261a0-2381-40f5-847d-6f3cd9a983da",
  ),
];
