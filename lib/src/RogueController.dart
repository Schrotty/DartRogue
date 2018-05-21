part of rogue;

class RogueController {
  final RogueView view = new RogueView();

  RogueController() {
    _init();

    print(player.toString());

    _registerMenuEvents();
    _registerGameEvents();
  }

  _registerMenuEvents() {
    /* MAIN MENU EVENTS */
    view.startButton.onClick.listen((e) {
      _switchMenu(view.game, view.home);

      const oneSec = const Duration(milliseconds: 16);
      new Timer.periodic(oneSec, (Timer t) => _update());
    });

    view.highscoreButton.onClick.listen((e) {
      _switchMenu(view.highscore, view.mainMenu);
    });

    view.howToPlayButton.onClick.listen((e) {
      _switchMenu(view.howToPlay, view.mainMenu);
    });

    view.aboutButton.onClick.listen((e) {
      _switchMenu(view.about, view.mainMenu);
    });

    /* HIGHSCORE EVENTS */
    view.backHighscoreButton.onClick.listen((e) {
      _switchMenu(view.mainMenu, view.highscore);
    });

    /* HOW TO PLAY EVENTS */
    view.backHowToPlayButton.onClick.listen((e) {
      _switchMenu(view.mainMenu, view.howToPlay);
    });

    /* ABOUT EVENTS */
    view.backAboutButton.onClick.listen((e) {
      _switchMenu(view.mainMenu, view.about);
    });
  }

  _registerGameEvents() {
    view.heroScreenButton.onClick.listen((e) {
      _toggleOverlay(view.healthContainer);
      _toggleOverlay(view.heroScreen);
    });
    view.fightingScreenButton.onClick.listen((e) {
      _toggleOverlay(view.healthContainer);
      _toggleOverlay(view.fightingScreen);
    });
    view.attackButton.onClick.listen((e) {
      player.takeDamage(10);
    });
    view.usePotionButton.onClick.listen((e) {
      player.usePotion(0);
    });
  }

  _switchMenu(Element toShow, Element toHide) {
    toShow.classes.add("visible");
    toShow.classes.remove("invisible");

    toHide.classes.add("invisible");
    toHide.classes.remove("visible");
  }

  _toggleOverlay(Element overlay) {
    overlay.classes.toggle("invisible");
    overlay.classes.toggle("visible");
  }

  _init() {
    buildStorage();
  }

  _update() {
    _updatePlayerHealth();
    _updatePlayerEquipment();
    _updatePlayerAttributes();
    _updatePlayerXp();
    _updateFightScreen();
  }

  _updatePlayerHealth() {
    view.playerHealth.text = player.currHealth;
    view.playerMaxHealth.text = player.maxHealth;
    view.playerHealthBar.style
        .setProperty("width", "${player.currHealthPercent}%");
  }

  _updatePlayerEquipment() {
    view.helmet.text = player.helmet.name;
    view.gloves.text = player.gloves.name;
    view.chest.text = player.chest.name;
    view.legs.text = player.legs.name;
    view.boots.text = player.boots.name;
    view.weapon.text = player.weapon.name;
  }

  _updatePlayerAttributes() {
    view.level.text = player.level;
    view.strength.text = player.strength;
    view.constitution.text = player.constitution;
    view.luck.text = player.luck;
    view.damage.text = player.damage;
    view.critDamage.text = player.critDamage;
    view.critChance.text = player.critChance;
  }

  _updatePlayerXp() {
    view.playerXp.text = "${player.getGainedXpByCurrentLvl()}";
    view.playerLvlXp.text = "${player.getNeededXpByCurrentLvl()}";
    view.playerXpBar.style.setProperty("width", "${player.currXpPercent}%");
  }

  _updateFightScreen() {
    view.playerFightHealth.text = player.currHealth;
    view.playerFightMaxHealth.text = player.maxHealth;
    view.playerFightHealthBar.style
        .setProperty("width", "${player.currHealthPercent}%");

    view.monsterFightHealth.text = monsters[0].maxHealth;
    view.monsterFightMaxHealth.text = monsters[0].maxHealth;
    view.monsterFightHealthBar.style
        .setProperty("width", "${monsters[0].currHealthPercent}");
  }
}
