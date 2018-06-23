part of rogue;

class RogueController {
  final RogueView view = new RogueView();

  Timer gameTimer;
  Timer movementTimer;

  Map<int, Monster> monsters;

  RogueController() {
    _init();

    _registerMenuEvents();
    _registerGameEvents();
  }

  _registerMenuEvents() async {
    /* MAIN MENU EVENTS */
    view.startButton.onClick.listen((e) {
      _switchMenu(view.nameInput, view.mainMenu);
    });

    view.nameInputField.onClick.listen((e) => view.nameInputField.value = "");

    view.submitNameButton.onClick.listen((e) async {
      _switchMenu(view.game, view.home);

      if ("" != view.nameInputField.value) {
        player.highscoreName = view.nameInputField.value;
      } else {
        player.highscoreName = "Player";
      }

      /* GAME TIMER */
      const oneSec = const Duration(milliseconds: 16);
      gameTimer = new Timer.periodic(oneSec, (Timer t) => _update());

      /* MOVEMENT TIMER */
      const ti = const Duration(milliseconds: 250);
      movementTimer = new Timer.periodic(ti, (Timer t) => _updateMoveablePositions());

      _renderLevel(player.currentStage);
      querySelector("#tiles").onTouchMove.listen((onData) {
        onData.preventDefault();
      });
    });

    view.backNameInputButton.onClick.listen((e) {
      _switchMenu(view.mainMenu, view.nameInput);
    });

    view.highscoreButton.onClick.listen((e) {
      String first = "${window.localStorage['1'].split("-")[0]} - ${window.localStorage['1'].split(
          "-")[1]}";
      view.highscoreFirst.text = first;
      String second = "${window.localStorage['2'].split("-")[0]} - ${window.localStorage['2'].split(
          "-")[1]}";
      view.highscoreSecond.text = second;
      String third = "${window.localStorage['3'].split("-")[0]} - ${window.localStorage['3'].split(
          "-")[1]}";
      view.highscoreThird.text = third;

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

    /* CREATE NEW GAMEDATA */
    view.backGameOverButton.onClick.listen((e) {
      _switchMenu(view.mainMenu, view.gameOver);
      _switchMenu(view.fightingOptions, view.fightEnd);
      _toggleOverlay(view.fightingScreen);

      gameTimer.cancel();
      movementTimer.cancel();
      buildStorage();
    });

    /* GAME WON EVENTS */
    view.backGameWin.onClick.listen((e) {
      _switchMenu(view.mainMenu, view.gameWin);

      gameTimer.cancel();
      movementTimer.cancel();
      buildStorage();
    });
  }

  _renderLevel(int stage) {
    querySelector("#tiles").children.clear();

    levels[stage].fields.forEach((row) {
      row.forEach((tile) {
        DivElement elm = new Element.div()
          ..classes.add("tile")
          ..classes.add(tile.style)
          ..id = "tile-${tile.id}"
          ..append(new Element.div());

        tile.element = elm;
        querySelector("#tiles").append(elm);
      });
    });

    //get monsters for level
    levels[stage].monsters = monsterList[stage].values.toList();

    //get boss for level
    levels[stage].boss = bosses[stage];

    _spawnPlayer(stage);
    _spawnMonster(stage);
    _spawnTreasure(stage);
    _spawnExit(stage);

    querySelectorAll(".tile").onClick.listen((MouseEvent e) {
      Field old = null;
      DivElement clicked = e.target;

      if (clicked.id.length < 5) {
        Field tmp = levels[stage].getField(int.parse(clicked.parent.id.substring(5)));

        // check for treasure
        if (tmp.hasTreasure && player.position.isNeighbour(tmp)) {
          DivElement el = querySelector("#tile-${tmp.id}");
          el.children[0].classes.clear();
          el.children[0].classes.addAll(["treasure-opened", "entity"]);
          _addLootToPlayerInventoryFromTreasure(tmp);
        }

        // check for exit
        if (tmp.isExit && player.position.isNeighbour(tmp)) {
          if (player.killedEndboss) {
            _switchMenu(view.home, view.game);
            _switchMenu(view.gameWin, view.nameInput);
            _calcAndUpdateHighscore();
            return;
          }

          player.currentStage += 1;
          _renderLevel(player.currentStage);
          _spawnPlayer(player.currentStage);
        }

        return;
      }

      if (!clicked.classes.contains("player")) {
        var tmp = levels[stage].getField(int.parse(clicked.id.substring(5)));
        if (tmp.isAccessible) {
          if (old == null) {
            querySelector("#tile-${levels[stage].spawnPoint.id}")
                .children
                .first
                .classes
                .remove("player");
          }

          if (Level.clicked != null) {
            old = Level.clicked;
            querySelector("#tile-${Level.clicked.id}").children.first.classes.remove("player");
          }

          Level.clicked = levels[stage].getField(int.parse(clicked.id.substring(5)));
          player.calcPath(Level.clicked);

          _centerPlayer();
        }
      }
    });
  }

  _registerGameEvents() {
    view.attackButton.onClick.listen((e) {
      view.skillZeroButton.value = skills[0].name;
      view.skillOneButton.value = "${skills[1].name} ${skills[1].useableCount}/${skills[1]
          .useableCountMax}";
      view.skillTwoButton.value = "${skills[2].name} ${skills[2].useableCount}/${skills[2]
          .useableCountMax}";
      view.skillThreeButton.value = "${skills[3].name} ${skills[3].useableCount}/${skills[3]
          .useableCountMax}";
      _switchMenu(view.skills, view.fightingOptions);
    });

    view.skillZeroButton.onClick.listen((e) {
      if (player.isAlive) attacker.takeDamage(player.calcDamage(skills[0].skillMod));
      if (attacker.isAlive) {
        player.takeDamage(attacker.calcDamage());
      }
      _updateFightEnd();
    });

    view.skillOneButton.onClick.listen((e) {
      _fight(1);
    });

    view.skillTwoButton.onClick.listen((e) {
      _fight(2);
    });

    view.skillThreeButton.onClick.listen((e) {
      _fight(3);
    });

    view.backAttackButton.onClick.listen((e) {
      _switchMenu(view.fightingOptions, view.skills);
    });

    view.usePotionButton.onClick.listen((e) {
      player.usePotion(player.selectedPot);
    });

//    view.leaveFightButton.onClick.listen((e) {
//      _toggleOverlay(view.fightingScreen);
//      player.fight = false;
//      _centerPlayer();
//    });

    view.leaveFightEndButton.onClick.listen((e) {
      _switchMenu(view.fightingOptions, view.fightEnd);
      _toggleOverlay(view.fightingScreen);

      player.fight = false;
      _centerPlayer();
    });

    view.heroScreenButton.onClick.listen((e) {
      _openHeroScreen();
      _updateInventory();
    });

    // ### POTIONS MENU ###
    view.potionsMenuButton.onClick.listen((e) {
      _openPotionsMenu();
    });

    view.potionSmallButton.onClick.listen((e) {
      player.selectedPot = 0;
      _toggleOverlay(view.potionsMenu);
    });

    view.potionMediumButton.onClick.listen((e) {
      player.selectedPot = 1;
      _toggleOverlay(view.potionsMenu);
    });

    view.potionLargeButton.onClick.listen((e) {
      player.selectedPot = 2;
      _toggleOverlay(view.potionsMenu);
    });

    view.hideEventButton.onClick.listen((e) {
      _toggleOverlay(view.eventWindow);
    });

    _registerHeroScreenEvents();
  }

  _startFight(Monster monster) {
    if (player.isAlive) {
      player.fight = true;
      player.start = null; //stop player from moving & reset target

      attacker = monster;
      _updateFightScreen();

      view.fightTopBar.text = "${attacker.name.replaceAll("_", " ")} attacks!";
      if ("Mimic" != monster.name) {
        view.monsterIcon.style.backgroundImage =
            "url(${Settings.getImgPath()}monsters/${attacker.name}.png)";
        _switchMenu(view.monsterIcon, view.mimicIcon);
      } else {
        view.mimicIcon.style.backgroundImage = "url(${Settings.getImgPath()}monsters/Mimic.png)";
        _switchMenu(view.mimicIcon, view.monsterIcon);
      }

      _toggleOverlay(view.fightingScreen);
    } else {
      if (!view.fightingScreen.classes.contains("invisible"))
        view.fightingScreen.classes.add("invisible");
    }
  }

  _fight(int skill) {
    if (skills[skill].isUseable) {
      if (player.isAlive) {
        attacker.takeDamage(player.calcDamage(skills[skill].skillMod));
        skills[skill].use();
      }

      if (attacker.isAlive) {
        player.takeDamage(attacker.calcDamage());
      }

      _updateFightEnd();
    }
  }

  _updateFightEnd() {
    _switchMenu(view.fightingOptions, view.skills);

    if (!attacker.isAlive) {
      Level.clicked.monsterId = null;

      _despawnEntity(attacker);
      levels[player.currentStage].monsters.remove(attacker);
    }

    if (!attacker.isAlive || !player.isAlive) {
      if (!attacker.isAlive) {
        view.fightEndMessage.text = _fightEndMessage();
        _addLootToPlayerInventoryFromMonster();
        _addHighScorePoints();
        player.gainXP(attacker.grantedXP);
        if (levels[player.currentStage].boss != null && !levels[player.currentStage].boss.isAlive) {
          _activateExit(player.currentStage);

          if ((levels[player.currentStage].boss as Monster).isEndboss) {
            player.killedEnboss = true;
          }

          levels[player.currentStage].boss = null;
        }
      }

      if (!player.isAlive) {
        _switchMenu(view.home, view.game);
        _switchMenu(view.gameOver, view.nameInput);
        _calcAndUpdateHighscore();
      }

      _switchMenu(view.fightEnd, view.fightingOptions);
    }

    _updateFightScreen();
  }


  _addHighScorePoints() {
    player.highscorePoints += attacker.level * (attacker.isBoss ? 30 : 10);
    print(player.highscorePoints);
  }

  _calcAndUpdateHighscore() {
    Map<int, String> highscores = new Map();
    List<int> test = new List();

    window.localStorage.forEach((k, v) {
      String name = v.split("-")[0];
      int score = int.parse(v.split("-")[1]);
      highscores[score] = name;
      test.add(score);
    });

    test.add(player.highscorePoints);

    test.sort((b, a) => a.compareTo(b));

    for (int i = 0; i < 3; i++) {
      int value = test[i];
      if (highscores.containsKey(value)) {
        window.localStorage['${i + 1}'] = "${highscores[value]}-$value";
      } else {
        window.localStorage['${i + 1}'] = "${player.highscoreName}-$value";
      }
    }

    window.localStorage.forEach((k, v) {
      print(v);
    });

    view.winScore.text = player.highscorePoints.toString();
    view.lostScore.text = player.highscorePoints.toString();
  }

  _addLootToPlayerInventoryFromMonster() {
    if (attacker.pots.isNotEmpty) {
      player.pots[0] += attacker.pots[0];
      player.pots[1] += attacker.pots[1];
      player.pots[2] += attacker.pots[2];
    }

    List<String> toRemove = new List();

    attacker.loot.forEach((k, v) {
      if (!player.isInventoryFull) {
        if (armors.containsKey(k)) {
          player.inventory.add(armors[k][v][0]);
        } else {
          player.inventory.add(weapons[k][v][0]);
        }
        toRemove.add(k);
      }
    });

    toRemove.forEach((i) => attacker.loot.remove(i));

    if (attacker.loot.isNotEmpty) {
      Field tmp = attacker.position;
      tmp.treasure = true;
      tmp.accessible = false;
      tmp.monsterDrop = true;

      Treasure t = new Treasure();
      t.treasureLoot = attacker.loot;
      levels[player.currentStage].monsterDrops[attacker.position.id] = t;

      DivElement el = querySelector("#tile-${tmp.id}");
      el.children[0].classes.addAll(["treasure-opened", "entity"]);
    }

    _updateInventory();
  }

  _addLootToPlayerInventoryFromTreasure(Field tmp) {
    Treasure t;
    if (!tmp.isMonsterDrop) {
      t = levels[player.currentStage].treasures.first;
    } else {
      t = levels[player.currentStage].monsterDrops[tmp.id];
    }

    _toggleOverlay(view.eventWindow);
    view.eventText.text = _treasureMessage(t);

    if (t.treasurePotions.isNotEmpty) {
      player.pots[0] += t.treasurePotions[0];
      t.treasurePotions.remove(0);
      player.pots[1] += t.treasurePotions[1];
      t.treasurePotions.remove(1);
      player.pots[2] += t.treasurePotions[2];
      t.treasurePotions.remove(2);
    }

    List<String> toRemove = new List();

    t.treasureLoot.forEach((k, v) {
      if (!player.isInventoryFull) {
        if (armors.containsKey(k)) {
          player.inventory.add(armors[k][v][0]);
        } else if (weapons.containsKey(k)) {
          player.inventory.add(weapons[k][v][0]);
        }
        toRemove.add(k);
      }
    });

    toRemove.forEach((i) => t.treasureLoot.remove(i));

    if (t.isEmpty && !tmp.isMonsterDrop) {
      levels[player.currentStage].treasures.remove(t);
      tmp.treasure = false;
    }

    if (tmp.isMonsterDrop && t.isEmpty) {
      DivElement el = querySelector("#tile-${tmp.id}");
      el.children[0].classes.clear();
      levels[player.currentStage].monsterDrops.remove(tmp.id);
      tmp.accessible = true;
    }
  }

  String _fightEndMessage() {
    String msg = "You killed ${attacker.name.replaceAll("_", " ")}, you gained ${attacker
        .grantedXP} XP!";

    if (attacker.grantedXP >= player.leftXpUntilLvlUp) {
      msg += " You reached level ${player.level + 1}!";
    }

    if (0 < attacker.loot.length || attacker.pots.isNotEmpty) {
      // add items
      String loot = "";
      int size = 0;

      attacker.loot.forEach((k, v) {
        if (armors.containsKey(k)) {
          loot += "${armors[k][v][0].name}";
        } else {
          loot += "${weapons[k][v][0].name}";
        }
        size++;
        if (attacker.loot.length > size) {
          loot += ", ";
        }
      });

      // add potions
      for (int i = 0; i < 3; i++) {
        if (attacker.pots.containsKey(i) && 0 < attacker.pots[i]) {
          if ("" != loot) {
            loot += ", ";
          }
          loot += "${potions[i].name} (${attacker.pots[i]})";
        }
      }

      msg += " ${attacker.name.replaceAll("_", " ")} dropped: $loot";
    }

    return msg;
  }

  _treasureMessage(Treasure t) {
    String msg = "You found: ";
    if (0 < t.treasureLoot.length || t.treasurePotions.isNotEmpty) {
      // add items
      String loot = "";
      int size = 0;
      t.treasureLoot.forEach((k, v) {
        if (armors.containsKey(k)) {
          loot += "${armors[k][v][0].name}";
        } else {
          loot += "${weapons[k][v][0].name}";
        }
        size++;
        if (t.treasureLoot.length > size) {
          loot += ", ";
        }
      });

      // add potions
      for (int i = 0; i < 3; i++) {
        if (t.treasurePotions.containsKey(i) && 0 < t.treasurePotions[i]) {
          if ("" != loot) {
            loot += ", ";
          }
          loot += "${potions[i].name} (${t.treasurePotions[i]})";
        }
      }
      msg += loot;
    }

    return msg;
  }

  _switchMenu(Element toShow, Element toHide) {
    if (toShow != null) {
      toShow.classes.add("visible");
      toShow.classes.remove("invisible");
    }

    if (toHide != null) {
      toHide.classes.add("invisible");
      toHide.classes.remove("visible");
    }
  }

  _toggleOverlay(Element overlay) {
    overlay.classes.toggle("invisible");
    overlay.classes.toggle("visible");
  }

  _init() async {
    await buildStorage();
    _buildHighscoreList();
  }

  _buildHighscoreList() {
//    window.localStorage.clear();
    if (window.localStorage.isEmpty) {
      window.localStorage['1'] = "Player1-300";
      window.localStorage['2'] = "Player2-200";
      window.localStorage['3'] = "Player3-0";
    }

    window.localStorage.forEach((k, v) {
      print(v);
    });
  }

  _update() {
    _updatePlayerXp();
    _updatePlayerAttributes();
    _updatePlayerHealth();

    if (player.inFight) {
      _updateFightScreen();
    }
  }

  _spawnPlayer(int lvl) {
    Field spawn = levels[lvl].spawnPoint;
    Level.clicked = spawn;

    player.position = spawn;
    _spawnEntity(player);

    _centerPlayer();
  }

  _spawnMonster(int lvl) {
    levels[lvl].monsters.forEach((monster) {
      monster.position = levels[lvl]
          .monsterSpawnPoints
          .firstWhere((field) => field.isAccessible, orElse: () => null);

      if (monster.position != null) {
        _spawnEntity(monster);
      }
    });

    levels[lvl].boss.position = levels[lvl].bossSpawn;
    if (levels[lvl].boss.position != null) {
      _spawnEntity(levels[lvl].boss);
    }
  }

  _spawnTreasure(int lvl) {
    levels[lvl].treasureFields.forEach((treasure) {
      DivElement e = querySelector("#tile-${treasure.id}");
      e.children[0].classes.addAll(["treasure-closed", "entity"]);
    });
  }

  _spawnExit(int lvl) {
    DivElement e = querySelector("#tile-${levels[lvl].exit.id}");
    e.children[0].classes.addAll(["exit-closed", "entity"]);
  }

  _activateExit(int lvl) {
    DivElement e = querySelector("#tile-${levels[lvl].exit.id}");
    e.children[0].classes.addAll(["exit-opened", "entity"]);
  }

  _spawnEntity(Moveable entity) {
    DivElement e = querySelector("#tile-${entity.position.id}");
    e.children[0].classes.addAll([entity.skin, "entity"]);

    entity.position.accessible = false;
  }

  _despawnEntity(Moveable entity) {
    DivElement e = querySelector("#tile-${entity.position.id}");
    e.children[0].classes.removeAll([entity.skin, "entity"]);

    entity.position.accessible = true;
  }

  _centerPlayer() {
    int mod = 32;
    if (browser.isFirefox) {
      view.dungeon.scrollTop = ((player.position.row) * mod);
      view.dungeon.scrollLeft = ((player.position.col - 5) * mod);
    } else {
      view.dungeon.scrollTop = ((player.position.row + 1.5) * (mod + 16));
      view.dungeon.scrollLeft = ((player.position.col - 2) * (mod + 16));
    }
  }

  _updatePlayerHealth() {
    view.playerHealth.text = "${player.currHealth}/${player.maxHealth} hp";
    view.playerHealthBar.style.setProperty("width", "${player.currHealthPercent}%");
  }

  _updatePlayerEquipment() {
    /* SELECT WEAPON */
    _selectItem(player.weapon, "Weapon", "Damage", Settings.getWeaponImgPath());
    if (player.inventory.isNotEmpty) _previewItem(player.inventory.first);

    /* WEAPON */
    _updateItemIcon(view.weapon, 'weapon', player.weapon.icon);
    view.weaponSlot.classes.removeWhere((clss) => !clss.contains("item-slot"));
    view.weaponSlot.classes.add(player.weapon.quality);

    /* CHEST */
    _updateItemIcon(view.chest, 'armor', player.chest.icon);
    view.chestSlot.classes.removeWhere((clss) => !clss.contains("item-slot"));
    view.chestSlot.classes.add(player.chest.quality);

    /* HELMET */
    _updateItemIcon(view.helmet, 'armor', player.helmet.icon);
    view.helmetSlot.classes.removeWhere((clss) => !clss.contains("item-slot"));
    view.helmetSlot.classes.add(player.helmet.quality);

    /* BOOTS */
    _updateItemIcon(view.boots, 'armor', player.boots.icon);
    view.bootsSlot.classes.removeWhere((clss) => !clss.contains("item-slot"));
    view.bootsSlot.classes.add(player.boots.quality);

    /* GLOVES */
    _updateItemIcon(view.gloves, 'armor', player.gloves.icon);
    view.glovesSlot.classes.removeWhere((clss) => !clss.contains("item-slot"));
    view.glovesSlot.classes.add(player.gloves.quality);

    /* LEGS */
    _updateItemIcon(view.legs, 'armor', player.legs.icon);
    view.legsSlot.classes.removeWhere((clss) => !clss.contains("item-slot"));
    view.legsSlot.classes.add(player.legs.quality);
  }

  _updateItemIcon(Element element, String itemType, String icon) {
    element.style.backgroundImage = "url(${Settings.getImgPath()}items/$itemType/$icon)";
  }

  _updatePlayerAttributes() {
    /* OFFENSE */
    view.heroStrength.text = player.strength;
    view.heroDamage.text = player.damage;
    view.heroCritChance.text = "${player.critChance}%";
    view.heroCritDamage.text = "${(player.critMulti * 100).ceil()}%";

    /* DEFENSE */
    view.heroArmor.text = player.armor;

    /* LIFE */
    view.heroConst.text = player.constitution;
    view.heroMaxLife.text = player.maxHealth;

    /* ADVENTURE */
    view.heroLevel.text = player.level;
    view.heroLuck.text = player.luck;
    view.heroSpeed.text = player.speed;
  }

  _updatePlayerXp() {
    view.playerEp.text = "${player.gainedXpByCurrentLvl}/${player.neededXpByCurrentLvl} exp";
    view.playerEpBar.style.setProperty("width", "${player.currXpPercent}%");
  }

  _updateFightScreen() {
    view.monsterFightHealth.text = attacker.currHealth;
    view.monsterFightMaxHealth.text = attacker.maxHealth;
    view.monsterFightHealthBar.style.setProperty("width", "${attacker.currHealthPercent}%");

    view.playerFightHealth.text = player.currHealth;
    view.playerFightMaxHealth.text = player.maxHealth;
    view.playerFightHealthBar.style.setProperty("width", "${player.currHealthPercent}%");
    view.usePotionButton.value = "Use Potion (${player.pots[player.selectedPot]})";
  }

  _registerHeroScreenEvents() {
    /* NAVIGATION EVENTS */
    view.heroInventoryButton.onClick.listen((e) {
      _switchHeroScreenMenu(view.heroInventoryScreen, view.heroInventoryButton);

      _updateInventory();
    });

    view.heroEquipmentButton.onClick.listen((e) {
      _switchHeroScreenMenu(view.heroEquipmentScreen, view.heroEquipmentButton);
    });

    view.heroAttributesButton.onClick.listen((e) {
      _switchHeroScreenMenu(view.heroAttributesScreen, view.heroAttributesButton);
      _updatePlayerAttributes();
    });

    /* EQUIPMENT EVENTS */
    view.weapon.onClick.listen((e) {
      _selectItem(player.weapon, "Weapon", "Damage", Settings.getWeaponImgPath());
    });

    view.helmet.onClick.listen((e) {
      _selectItem(player.helmet, "Helmet", "Armor", Settings.getArmorImgPath());
    });

    view.chest.onClick.listen((e) {
      _selectItem(player.chest, "Chest", "Armor", Settings.getArmorImgPath());
    });

    view.gloves.onClick.listen((e) {
      _selectItem(player.gloves, "Gloves", "Armor", Settings.getArmorImgPath());
    });

    view.legs.onClick.listen((e) {
      _selectItem(player.legs, "Legs", "Armor", Settings.getArmorImgPath());
    });

    view.boots.onClick.listen((e) {
      _selectItem(player.boots, "Boots", "Armor", Settings.getArmorImgPath());
    });

    /* INVENTORY EVENTS */
    view.inventoryGrid.forEach((Element element) {
      element.onClick.listen((Event e) {
        DivElement clicked = e.target as DivElement;
        int id = int.parse(clicked.parent.id.substring(5));

        if (id < player.inventory.length) {
          _previewItem(player.inventory[id]);
        }
      });
    });

    view.equipItem.onClick.listen((e) {
      if (null != player.currentInvtentoryItem) {
        player.equip(player.currentInvtentoryItem);
        _updatePlayerEquipment();
        _updateInventory();
      }
    });

    view.dropItem.onClick.listen((e) {
      player.inventory.remove(player.currentInvtentoryItem);
      if (player.inventory.isEmpty) {
        player.currentInvtentoryItem = null;
      } else {
        player.currentInvtentoryItem = player.inventory.first;
      }
      _previewItem(player.currentInvtentoryItem);
      _updateInventory();
    });
  }

  _updateInventory() {
    int index = 0;
    player.inventory.forEach((Item item) {
      String imagePath = item.classification == "Weapon"
          ? Settings.getWeaponImgPath()
          : Settings.getArmorImgPath();

      Element element = querySelector("#slot-$index");
      element.classes
          .removeWhere((clss) => !clss.contains("item-slot") && !clss.contains("inventory-item"));
      element.classes.add(item.quality);

      element.children[0].style.backgroundImage = "url($imagePath${item.icon})";
      index++;
    });

    for (int i = index; i < 12; i++) {
      Element element = querySelector("#slot-$index");
      element.classes.removeAll(Qualities);
      element.classes.add("common");
      element.children[0].style.backgroundImage = null;
    }
  }

  _switchHeroScreenMenu(Element target, Element caller) {
    List menus = [view.heroEquipmentScreen, view.heroAttributesScreen, view.heroInventoryScreen];
    List buttons = [view.heroEquipmentButton, view.heroAttributesButton, view.heroInventoryButton];

    caller.classes.add("item-active");
    target.classes.remove("invisible");

    menus.forEach((Element menu) {
      if (target != menu) {
        menu.classes.add("invisible");
      }
    });

    buttons.forEach((Element button) {
      if (caller != button) {
        button.classes.remove("item-active");
      }
    });
  }

  _selectItem(Item item, String type, String valueKey, String imagePath) {
    view.selectedItemName.classes.clear();
    view.selectedItemQuality.classes.clear();
    view.selectedItemIcon.parent.classes.removeWhere((clss) => !clss.contains("item-slot"));
    view.selectedItemMods.nodes.clear();

    view.selectedItemName.text = item.name;
    view.selectedItemName.classes.add("${item.quality}-color");

    view.selectedItemQuality.text = item.quality;
    view.selectedItemQuality.classes.add("${item.quality}-color");

    view.selectedItemIcon.parent.classes.add(item.quality);
    view.selectedItemIcon.style.backgroundImage = "url($imagePath${item.icon})";

    view.selectedItemType.text = item.display;
    view.selectedItemValue.text = item.value.toString();
    view.selectedItemKey.text = valueKey;

    item.modifier.forEach((String key, value) {
      String prefix = "";
      if (value > 0) prefix = "+";

      String text = "$prefix$value ${key[0].toUpperCase()}${key.substring(1)}";
      view.selectedItemMods.append(new LIElement()..text = text);
    });
  }

  _previewItem(Item item) {
    if (item != null) {
      player.currentInvtentoryItem = item;
      String imagePath = item.classification == "Weapon"
          ? Settings.getWeaponImgPath()
          : Settings.getArmorImgPath();

      view.previewItemName.classes.clear();
      view.previewItemQuality.classes.clear();
      view.previewItemIcon.parent.classes.removeWhere((clss) => !clss.contains("item-slot"));
      view.previewItemMods.nodes.clear();

      view.previewItemName.text = item.name;
      view.previewItemName.classes.add("${item.quality}-color");

      view.previewItemQuality.text = item.quality;
      view.previewItemQuality.classes.add("${item.quality}-color");

      view.previewItemIcon.parent.classes.add(item.quality);
      view.previewItemIcon.style.backgroundImage = "url($imagePath${item.icon})";

      view.previewItemType.text = item.display;
      view.previewItemValue.text = item.value.toString();
      view.previewItemKey.text = item.type == 0 ? "Damage" : "Armor";

      item.modifier.forEach((String key, value) {
        String prefix = "";
        if (value > 0) prefix = "+";

        String text = "$prefix$value ${key[0].toUpperCase()}${key.substring(
            1)}";
        view.previewItemMods.append(new LIElement()..text = text);
      });
    } else {
      view.previewItemName.classes.clear();
      view.previewItemQuality.classes.clear();
      view.previewItemMods.nodes.clear();

      view.previewItemName.text = "";
      view.previewItemName.classes.removeAll(Qualities);

      view.previewItemQuality.text = "";

      view.previewItemIcon.parent.classes.removeAll(Qualities);
      view.previewItemIcon.style.backgroundImage = null;

      view.previewItemType.text = "";
      view.previewItemValue.text = "";
      view.previewItemKey.text = "";
    }
  }

  _openHeroScreen() {
    _updatePlayerEquipment();
    _toggleOverlay(view.heroScreen);
  }

  _openPotionsMenu() {
    _toggleOverlay(view.potionsMenu);
    _updatePotionMenu();
  }

  _updatePotionMenu() {
    view.potionSmallButton.value = "(${player.pots[0]})";
    view.potionMediumButton.value = "(${player.pots[1]})";
    view.potionLargeButton.value = "(${player.pots[2]})";
  }

  _updateMoveablePositions() {
    if (!player.inFight) {
      _despawnEntity(player);
      player.move();

      if (player.position != null) {
        _spawnEntity(player);
      }

      levels[player.currentStage].monsters.forEach((monster) {
        if (monster.position != null) {
          _despawnEntity(monster);
          monster.move();

          if (monster.position != null) {
            _spawnEntity(monster);
          }
        }
      });

      _centerPlayer();
      if (!player.inFight) {
        _checkFight();
      }
    }
  }

  _checkFight() {
    if (null != levels[player.currentStage].boss &&
        player.position.isNeighbour(levels[player.currentStage].boss.position)) {
      _startFight(levels[player.currentStage].boss);
    }

    levels[player.currentStage].monsters.forEach((monster) {
      if (player.position.isNeighbour(monster.position)) {
        _startFight(monster);
      }
    });
  }
}
