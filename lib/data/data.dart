import 'package:flutter/material.dart';
import 'package:thinktank_mobile/models/game.dart';

const games = [
  Game(
    imageUrl: "assets/pics/game_1.png",
    name: "Flip Card Challenge",
    description:
        "Experience the thrill of our Flip Card game! Memorize cards and seek out matching pairs, enhancing both your visual and short-term memory skills.",
    type: ["Visual memory"],
    color: Color.fromARGB(255, 252, 144, 42),
  ),
  Game(
    imageUrl: "assets/pics/game_2.png",
    name: "Music Password",
    description:
        "Players will listen to a piece of music provided by the host to decipher the password for the house, enhancing their auditory memory skills.",
    type: ["Auditory memory", "Interactive memory", "Sensory memory"],
    color: Color.fromARGB(255, 245, 171, 43),
  ),
  Game(
    imageUrl: "assets/pics/game_3.png",
    name: "Find The Anonymous",
    description:
        "The player's mission is to identify the 'anonymous' within a group of people after being provided with a description of that person.",
    type: ["Associative memory"],
    color: Color.fromARGB(255, 234, 84, 85),
  ),
  Game(
    imageUrl: "assets/pics/game_4.png",
    name: "Images Walkthrough",
    description:
        "The player simply has to identify what the previous image was, a task that's simple yet not so simple.",
    type: ["Sequential memory"],
    color: Color.fromARGB(255, 85, 125, 176),
  ),
  Game(
    imageUrl: "assets/pics/game_5.png",
    name: "Storyteller",
    description:
        "The player is given an intriguing story, and your task is to arrange provided images to form a complete narrative.",
    type: ["Sequential memory", "Spatial memory", "Associative memory"],
    color: Color.fromARGB(255, 45, 64, 89),
  ),
];

const contest = [
  "https://firebasestorage.googleapis.com/v0/b/thinktank-79ead.appspot.com/o/0%2Fcontest_1.png?alt=media&token=56159759-0357-4f10-b276-cd39bb333006",
  "https://firebasestorage.googleapis.com/v0/b/thinktank-79ead.appspot.com/o/0%2Fcontest_2.png?alt=media&token=ade1f3b9-2b52-4bad-a84d-2e80bc6e577b",
];
