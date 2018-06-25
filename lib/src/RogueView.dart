part of rogue;

class RogueView {
  final Element home = querySelector("#home");
  final Element nameInput = querySelector("#name-input-menu");
  final Element game = querySelector("#game");
  final Element gameOver = querySelector("#game-over");
  final Element gameWin = querySelector("#game-win");
  final Element dungeon = querySelector("#dungeon");
  final Element tiles = querySelector("#tiles");
  final Element player = querySelector(".player");

  final Element mainMenu = querySelector("#start-menu");
  final Element highscore = querySelector("#highscore");
  final Element howToPlay = querySelector("#how-to-play");
  final Element about = querySelector("#about");

  //final Element backFromDead = querySelector("#back-menu");

  //Temporarily
  final Element fightingScreen = querySelector("#fighting-screen");

  /* ########## HERO SCREEN START ########## */
  final Element heroScreen = querySelector("#hero-screen");
  final Element heroEquipmentButton = querySelector("#hero-equipment");
  final Element heroEquipmentScreen = querySelector("#hero-equipment-screen");

  final Element heroAttributesButton = querySelector("#hero-attributes");
  final Element heroAttributesScreen = querySelector("#hero-attributes-screen");

  final Element heroInventoryButton = querySelector("#hero-inventory");
  final Element heroInventoryScreen = querySelector("#hero-inventory-screen");

  final List<Element> inventoryGrid = querySelectorAll(".inventory-item");

  /* EQUIPMENT */
  final Element equipment = querySelector("#equipment");

  final Element helmet = querySelector("#helmet");
  final Element helmetSlot = querySelector("#helmet-slot");

  final Element gloves = querySelector("#gloves");
  final Element glovesSlot = querySelector("#gloves-slot");

  final Element chest = querySelector("#chest");
  final Element chestSlot = querySelector("#chest-slot");

  final Element legs = querySelector("#legs");
  final Element legsSlot = querySelector("#legs-slot");

  final Element boots = querySelector("#boots");
  final Element bootsSlot = querySelector("#boots-slot");

  final Element weapon = querySelector("#weapon");
  final Element weaponSlot = querySelector("#weapon-slot");

  /* SELECTED ITEM */
  final Element selectedItemName = querySelector("#selected-item #item-name");
  final Element selectedItemIcon = querySelector("#selected-item #item-icon");
  final Element selectedItemQuality =
  querySelector("#selected-item #item-quality");
  final Element selectedItemType = querySelector("#selected-item #item-type");
  final Element selectedItemValue = querySelector("#selected-item #item-value");
  final Element selectedItemKey = querySelector("#selected-item #item-key");
  final Element selectedItemMods =
  querySelector("#selected-item #item-mods ul");

  /* PREVIEW ITEM */
  final Element previewItemName = querySelector("#preview-item #preview-item-name");
  final Element previewItemIcon = querySelector("#preview-item #preview-item-icon");
  final Element previewItemQuality = querySelector("#preview-item #preview-item-quality");
  final Element previewItemType = querySelector("#preview-item #preview-item-type");
  final Element previewItemValue = querySelector("#preview-item #preview-item-value");
  final Element previewItemKey = querySelector("#preview-item #preview-item-key");
  final Element previewItemMods = querySelector("#preview-item #preview-item-mods ul");

  final Element equipItem = querySelector("#equip-item-button");
  final Element dropItem = querySelector("#drop-item-button");

  /* ATTRIBUTES */
  final Element heroStrength = querySelector("#hero-strength");
  final Element heroDamage = querySelector("#hero-damage");
  final Element heroCritChance = querySelector("#hero-crit");
  final Element heroCritDamage = querySelector("#hero-crit-dmg");

  final Element heroArmor = querySelector("#hero-armor");

  final Element heroConst = querySelector("#hero-const");
  final Element heroMaxLife = querySelector("#hero-max-life");

  final Element heroLevel = querySelector("#hero-level");
  final Element heroLuck = querySelector("#hero-luck");
  final Element heroSpeed = querySelector("#hero-speed");
  final Element heroScore = querySelector("#hero-score");

  /*XP-BAR*/
  final Element xpContainer = querySelector("#xp-container");
  final Element playerXp = querySelector("#xp");
  final Element playerLvlXp = querySelector("#lvl-xp");
  final Element playerXpBar = querySelector("#xp-bar-inner");

  /* ########## HERO SCREEN END ########### */

  /* ########## FIGHTING SCREEN START ########### */
  final Element fightTopBar = querySelector("#fight-top-bar");

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
  final Element monsterIcon = querySelector("#sprite-monster");
  final Element mimicIcon = querySelector("#sprite-mimic");

  /* OPTIONS */
  final Element fightingOptions = querySelector("#fighting-options");
  final ButtonInputElement attackButton = querySelector("#attack");
  final ButtonInputElement usePotionButton = querySelector("#use-potion");

  /* SKILLS */
  final Element skills = querySelector("#skills");
  final ButtonInputElement skillZeroButton = querySelector("#s0");
  final ButtonInputElement skillOneButton = querySelector("#s1");
  final ButtonInputElement skillTwoButton = querySelector("#s2");
  final ButtonInputElement skillThreeButton = querySelector("#s3");
  final ButtonInputElement backAttackButton = querySelector("#backAttack");

  /* FIGHT END */
  final Element fightEnd = querySelector("#fight-end");
  final Element fightEndMessage = querySelector("#fight-end-message");
  final Element leaveFightEndButton = querySelector("#leave-fight-end");

  /* ########## FIGHTING SCREEN END ########### */

  /* HEALTH BAR */
  final Element playerHealth = querySelector("#player-health-text");
  final Element playerHealthBar = querySelector("#health-bar-inner");

  /* EP BAR */
  final Element playerEp = querySelector("#player-ep-text");
  final Element playerEpBar = querySelector("#ep-bar-inner");

  //final Element playerLevel = querySelector("#level-value");

  /* MAIN MENU BUTTONS */
  final ButtonInputElement startButton = querySelector("#start-game-button");
  final ButtonInputElement highscoreButton = querySelector("#highscore-button");
  final ButtonInputElement howToPlayButton = querySelector("#howToPlay-button");
  final ButtonInputElement aboutButton = querySelector("#about-button");

  /* NAME INPUT */
  final InputElement nameInputField = querySelector("#name-input");
  final ButtonInputElement submitNameButton = querySelector("#name-submit");
  final ButtonInputElement backNameInputButton = querySelector("#name-input-back");

  /* HIGHSCORE BUTTONS */
  final ButtonInputElement backHighscoreButton =
  querySelector("#back-highscore-button");

  final Element highscoreFirst = querySelector("#highscore-first");
  final Element highscoreSecond = querySelector("#highscore-second");
  final Element highscoreThird = querySelector("#highscore-third");

  /* HOW TO PLAY BUTTONS */
  final ButtonInputElement backHowToPlayButton =
  querySelector("#back-howToPlay-button");

  /* ABOUT BUTTONS */
  final ButtonInputElement backAboutButton =
  querySelector("#back-about-button");

  /* GAME BUTTONS */
  final ButtonInputElement heroScreenButton =
  querySelector("#hero-screen-button");
  final ButtonInputElement potionsMenuButton = querySelector("#potion-screen-button");

  /* POTIONS BUTTONS */
  final Element potionsMenu = querySelector("#potions-menu");
  final ButtonInputElement potionSmallButton = querySelector("#potion-s");
  final ButtonInputElement potionMediumButton = querySelector("#potion-m");
  final ButtonInputElement potionLargeButton = querySelector("#potion-l");

  /* GAME WON */
  final Element backGameWin = querySelector("#back-game-win");
  final Element winScore = querySelector("#win-highscore");
  final Element lostScore = querySelector("#loose-highscore");

  /* GLOBAL EVENT */
  final Element eventWindow = querySelector("#event-window");
  final Element eventText = querySelector("#event-text");
  final ButtonInputElement hideEventButton = querySelector("#hide-event-button");

  final ButtonInputElement backGameOverButton = querySelector("#back-game-over");
}
