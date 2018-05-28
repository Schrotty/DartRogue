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
  final Element helmetSlot = querySelector("#helmet-slot");

  final Element gloves = querySelector("#gloves");
  final Element glovesQuality = querySelector("#gloves-quality");
  final Element glovesValue = querySelector("#gloves-value");

  final Element chest = querySelector("#chest");
  final Element chestSlot = querySelector("#chest-slot");

  final Element legs = querySelector("#legs");
  final Element legsQuality = querySelector("#legs-quality");
  final Element legsValue = querySelector("#legs-value");

  final Element boots = querySelector("#boots");
  final Element bootsQuality = querySelector("#boots-quality");
  final Element bootsValue = querySelector("#boots-value");

  final Element weapon = querySelector("#weapon");
  final Element weaponSlot = querySelector("#weapon-slot");

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
  final ImageElement monsterIcon = querySelector("#monster-icon");

  /* OPTIONS */
  final Element fightingOptions = querySelector("#fighting-options");
  final ButtonInputElement attackButton = querySelector("#attack");
  final ButtonInputElement usePotionButton = querySelector("#use-potion");
  final ButtonInputElement leaveFightButton = querySelector("#leave-fight");

  /* SKILLS */
  final Element skills = querySelector("#skills");
  final ButtonInputElement skillZeroButton = querySelector("#s0");
  final ButtonInputElement skillOneButton = querySelector("#s1");
  final ButtonInputElement skillTwoButton = querySelector("#s2");
  final ButtonInputElement skillThreeButton = querySelector("#s3");
  final ButtonInputElement backAttackButton = querySelector("#backAttack");

  /* FIGHT END */
  final Element fightEnd =querySelector("#fight-end");
  final Element fightEndMessage = querySelector("#fight-end-message");
  final Element leaveFightEndButton = querySelector("#leave-fight-end");

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
  final ButtonInputElement heroScreenButton =
      querySelector("#hero-screen-button");
  final ButtonInputElement fightingScreenButton =
      querySelector("#fighting-screen-button");
  final ButtonInputElement potionsMenuButton = querySelector("#potions-button");

  /* POTIONS BUTTONS */
  final ButtonInputElement potionSmallButton = querySelector("#potion-s");
  final ButtonInputElement potionMediumButton = querySelector("#potion-m");
  final ButtonInputElement potionLargeButton = querySelector("#potion-l");

  /* ########## DEBUG START ########### */
  final Element debugButton = querySelector("#debug-screen-button");
  final Element debugScreen = querySelector("#debug-screen");
  final Element debugWeapons = querySelector("#debug-weapons");

  final Element debugAddEXPButton = querySelector("#debug-add-exp");
  final Element debugTakeDMGButton = querySelector("#debug-take-dmg");
  final Element debugEquipLegendaryButton =
      querySelector("#debug-equip-legendary");
}
