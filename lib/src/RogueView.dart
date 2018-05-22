part of rogue;

class RogueView {
  final Element home = querySelector("#home");
  final Element game = querySelector("#game");
  final Element dungeon = querySelector("#dungeon");
  final Element tiles = querySelector("#tiles");

  final Element mainMenu = querySelector("#start-menu");
  final Element highscore = querySelector("#highscore");
  final Element howToPlay = querySelector("#how-to-play");
  final Element about = querySelector("#about");

  //Temporarily
  final Element fightingScreen = querySelector("#fighting-screen");

  /* ########## HERO SCREEN START ########## */
  final Element heroScreen = querySelector("#hero-screen");

  /* EQUIPMENT */
  final Element equipment = querySelector("#equipment");
  final Element helmet = querySelector("#helmet");
  final Element gloves = querySelector("#gloves");
  final Element chest = querySelector("#chest");
  final Element legs = querySelector("#legs");
  final Element boots = querySelector("#boots");
  final Element weapon = querySelector("#weapon");

  /* ATTRIBUTES */
  final Element level = querySelector("#lvl");
  final Element strength = querySelector("#strength");
  final Element constitution = querySelector("#const");
  final Element luck = querySelector("#luck");
  final Element damage = querySelector("#damage");
  final Element critDamage = querySelector("#cd");
  final Element critChance = querySelector("#cc");

  /*XP-BAR*/
  final Element xpContainer = querySelector("#xp-container");
  final Element playerXp = querySelector("#xp");
  final Element playerLvlXp = querySelector("#lvl-xp");
  final Element playerXpBar = querySelector("#xp-bar-inner");

  /* ########## HERO SCREEN END ########### */

  /* ########## FIGHTING SCREEN START ########### */
  /* PLAYER */
  final Element playerFightHealthContainer =
      querySelector("#player-fight-health-container");
  final Element playerFightHealth = querySelector("#player-fight-health");
  final Element playerFightMaxHealth =
      querySelector("#player-fight-max-health");
  final Element playerFightHealthBar =
      querySelector("#player-fight-health-inner");

  /* MONSTER */
  final Element monsterFightHealthContainer =
      querySelector("#monster-fight-health-container");
  final Element monsterFightHealth = querySelector("#monster-fight-health");
  final Element monsterFightMaxHealth =
      querySelector("#monster-fight-max-health");
  final Element monsterFightHealthBar =
      querySelector("#monster-fight-health-inner");

  /* OPTIONS */
  final ButtonInputElement attackButton = querySelector("#attack");
  final ButtonInputElement usePotionButton = querySelector("#use-potion");

  /* ########## FIGHTING SCREEN END ########### */

  /* HEALTH BAR */
  final Element playerHealth = querySelector("#player-health-text");
  final Element playerHealthBar = querySelector("#health-bar-inner");
  final Element potionsMenu = querySelector("#potions-menu");

  /* EP BAR */
  final Element playerEp = querySelector("#player-ep-text");
  final Element playerEpBar = querySelector("#ep-bar-inner");
  final Element playerLevel = querySelector("#level-value");

  /* MAIN MENU BUTTONS */
  final ButtonInputElement startButton = querySelector("#start-game-button");
  final ButtonInputElement highscoreButton = querySelector("#highscore-button");
  final ButtonInputElement howToPlayButton = querySelector("#howToPlay-button");
  final ButtonInputElement aboutButton = querySelector("#about-button");

  /* HIGHSCORE BUTTONS */
  final ButtonInputElement backHighscoreButton =
      querySelector("#back-highscore-button");

  /* HOW TO PLAY BUTTONS */
  final ButtonInputElement backHowToPlayButton =
      querySelector("#back-howToPlay-button");

  /* ABOUT BUTTONS */
  final ButtonInputElement backAboutButton =
      querySelector("#back-about-button");

  /* GAME BUTTONS */
  final ButtonInputElement heroScreenButton = querySelector("#hero-screen-button");
  final ButtonInputElement fightingScreenButton = querySelector("#fighting-screen-button");
  final ButtonInputElement potionsMenuButton = querySelector("#potions-button");

  /* POTIONS BUTTONS */
  final ButtonInputElement potionSmallButton = querySelector("#potion-s");
  final ButtonInputElement potionMediumButton = querySelector("#potion-m");
  final ButtonInputElement potionLargeButton = querySelector("#potion-l");
}

