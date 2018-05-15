part of rogue;

class RogueView {
  final Element home = querySelector("#home");
  final Element game = querySelector("#game");

  final Element mainMenu = querySelector("#start-menu");
  final Element highscore = querySelector("#highscore");
  final Element howToPlay = querySelector("#how-to-play");
  final Element about = querySelector("#about");

  final Element heroScreen = querySelector("#hero-screen");

  /* MAIN MENU BUTTONS */
  final ButtonInputElement startButton = querySelector("#start-game-button");
  final ButtonInputElement highscoreButton = querySelector("#highscore-button");
  final ButtonInputElement howToPlayButton = querySelector("#howToPlay-button");
  final ButtonInputElement aboutButton = querySelector("#about-button");

  /* HIGHSCORE BUTTONS */
  final ButtonInputElement backHighscoreButton = querySelector("#back-highscore-button");

  /* HOW TO PLAY BUTTONS */
  final ButtonInputElement backHowToPlayButton = querySelector("#back-howToPlay-button");

  /* ABOUT BUTTONS */
  final ButtonInputElement backAboutButton = querySelector("#back-about-button");

  /* GAME BUTTONS */
  final ButtonInputElement heroScreenButton = querySelector("#hero-screen-button");

  final Element playerHealth = querySelector("#health");
  final Element playerMaxHealth = querySelector("#max-health");
}