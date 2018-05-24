part of rogue;

class RogueController {
  final RogueView view = new RogueView();

  RogueController() {
    _init();

    _registerDebugEvents();
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
    for (int i = 0; i < 1024; i++) {
      querySelector("#tiles").append(new Element.div()..classes.add("tile"));
    }

    querySelectorAll(".tile").onClick.listen((MouseEvent e) {
      DivElement d = e.target;
      d.classes.add("clicked");

      _moveCamera(64);
    });

    view.attackButton.onClick.listen((e) {
      monsters[0].takeDamage(player.calcDamage());
      player.takeDamage(monsters[0].calcDamage());
    });

    view.usePotionButton.onClick.listen((e) {
      player.usePotion(0);
    });

    view.heroScreenButton.onClick.listen((e) {
      _toggleOverlay(view.heroScreen);
      //_toggleOverlay(view.tiles);
    });

    view.fightingScreenButton.onClick.listen((e) {
      //_toggleOverlay(view.healthContainer);
      _toggleOverlay(view.fightingScreen);
    });

    view.inventoryHelmet.onClick.listen((e) {
      _updateInventoryItemStats(player.helmet);
    });

    view.inventoryChest.onClick.listen((e) {
      _updateInventoryItemStats(player.chest);
    });

    view.inventoryGloves.onClick.listen((e) {
      _updateInventoryItemStats(player.gloves);
    });

    view.inventoryWeapon.onClick.listen((e) {
      _updateInventoryItemStats(player.weapon);
    });

    view.inventoryLegs.onClick.listen((e) {
      _updateInventoryItemStats(player.legs);
    });

    view.inventoryBoots.onClick.listen((e) {
      _updateInventoryItemStats(player.boots);
    });

    view.inventorySecond.onClick.listen((e) {
      //_updateInventoryItemStats(player.helmet);
    });

    /*view.potionsMenuButton.onClick.listen((e) {
      _toggleOverlay(view.potionsMenu);
    });

    view.potionSmallButton.onClick.listen((e) {
      player.usePotion(0);
    });

    view.potionMediumButton.onClick.listen((e) {
      player.usePotion(1);
    });

    view.potionLargeButton.onClick.listen((e) {
      player.usePotion(2);
    });*/
  }

  _registerDebugEvents() {
    view.debugButton.onClick.listen((e) {
      _toggleOverlay(view.debugScreen);
    });

    view.debugAddEXPButton.onClick.listen((e) {
      player.gainXP(50);
    });

    view.debugTakeDMGButton.onClick.listen((e) {
      player.takeDamage(15);
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
    //player.gainXP(100);

    _updatePlayerXp();
    _updatePlayerAttributes();
    _updatePlayerHealth();
    _updatePlayerEquipment();
    _updateFightScreen();
  }

  _updatePlayerHealth() {
    view.playerHealth.text = "${player.currHealth}/${player.maxHealth}";
    view.playerHealthBar.style
        .setProperty("width", "${player.currHealthPercent}%");
  }

  _moveCamera(int value) {
    view.dungeon.scrollLeft += value;
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
    view.playerEp.text = "${player.gainedXp}/${player.neededXp}";
    view.playerEpBar.style.setProperty("width", "${player.currXpPercent}%");
    view.playerLevel.text = player.level;
  }

  _updateFightScreen() {
    view.monsterFightHealth.text = monsters[0].currHealth;
    view.monsterFightMaxHealth.text = monsters[0].maxHealth;
    view.monsterFightHealthBar.style
        .setProperty("width", "${monsters[0].currHealthPercent}%");

    view.playerFightHealth.text = player.currHealth;
    view.playerFightMaxHealth.text = player.maxHealth;
    view.playerFightHealthBar.style
        .setProperty("width", "${player.currHealthPercent}%");
  }

  _updateInventoryItemStats(Item item) {
    view.inventorySelectedName.text = item.name;
  }
}
