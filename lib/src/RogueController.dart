part of rogue;

class RogueController {
  final RogueView view = new RogueView();

  Map<int, Monster> monsters;

  RogueController() {
    _init();

    _registerDebugEvents();
    _registerMenuEvents();
    _registerGameEvents();
  }

  _registerMenuEvents() async {
    /* MAIN MENU EVENTS */
    view.startButton.onClick.listen((e) async {
      _switchMenu(view.game, view.home);

      /* GAME TIMER */
      const oneSec = const Duration(milliseconds: 16);
      new Timer.periodic(oneSec, (Timer t) => _update());

      /* MOVEMENT TIMER */
      const ti = const Duration(milliseconds: 500);
      new Timer.periodic(ti, (Timer t) => _updateMoveablePositions());

      _renderLevel(player.currentStage);

      querySelector("#tiles").onTouchMove.listen((onData) {
        onData.preventDefault();
      });
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

    /* GAME OVER EVENTS */
    /*view.backFromDead.onClick.listen((e) {
      _switchMenu(view.mainMenu, view.gameOver);
    });*/
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

    levels[stage].monsters = monsterList[stage].values.toList();
    _spawnPlayer(stage);
    _spawnMonster(stage);
    _spawnTreasure(stage);

    querySelectorAll(".tile").onClick.listen((MouseEvent e) {
      Field old = null;
      DivElement clicked = e.target;

      if (clicked.id.length < 5) return;
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

      if (old != null && old.id > Level.clicked.id) {
        view.dungeon.scrollLeft -= 32;
      }

      if (null != Level.clicked.monsterId) {
        _startFight(Level.clicked.monsterId);
        view.dungeon.scrollTop = -32 * 100;
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
      player.usePotion(0);
    });

    view.leaveFightButton.onClick.listen((e) {
      _toggleOverlay(view.fightingScreen);
      _centerPlayer();
    });

    view.leaveFightEndButton.onClick.listen((e) {
      _switchMenu(view.fightingOptions, view.fightEnd);
      _toggleOverlay(view.fightingScreen);
      _centerPlayer();
    });

    view.heroScreenButton.onClick.listen((e) {
      _openHeroScreen();
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
      view.monsterIcon.style.backgroundImage =
          "url(${Settings.getImgPath()}monsters/${attacker.name}.png)";

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
      String msg = !attacker.isAlive
          ? "You killed ${attacker.name.replaceAll("_", " ")}, you gained ${attacker
          .grantedXP} XP!" +
              (attacker.grantedXP >= player.leftXpUntilLvlUp
                  ? " You reached level ${player.level + 1}!"
                  : "")
          : "YOU DIED!";

      view.fightEndMessage.text = msg;

      if (!attacker.isAlive) {
        player.gainXP(attacker.grantedXP);
        if (levels[player.currentStage].boss != null && !levels[player.currentStage].boss.isAlive) {
          player.currentStage += 1;
          _renderLevel(player.currentStage);
          _spawnPlayer(player.currentStage);
        }
      }

      if (!player.isAlive) {
        _switchMenu(view.gameOver, view.game);
      }

      player.fight = false;
      _switchMenu(view.fightEnd, view.fightingOptions);
    }
  }

  _registerDebugEvents() {
    view.debugButton.onClick.listen((e) {
      _toggleOverlay(view.debugScreen);
      print(levels);
    });

    view.debugAddEXPButton.onClick.listen((e) {
      player.gainXP(50);
    });

    view.debugTakeDMGButton.onClick.listen((e) {
      player.takeDamage(15);
    });

    view.debugEquipLegendaryButton.onClick.listen((e) {
      player.weapon = weapons['axes'][0][4];
    });
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
      monster.position = levels[lvl].monsterSpawnPoints.firstWhere((field) => field.isAccessible, orElse: () => null);

      if (monster.position != null) {
        _spawnEntity(monster);
      }
    });
  }

  _spawnTreasure(int lvl) {
    levels[lvl].treasures.forEach((treasure) {
      DivElement e = querySelector("#tile-${treasure.id}");
      e.children[0].classes.addAll(["treasure", "entity"]);
    });
  }

  _spawnEntity(Moveable entity) {
    DivElement e = querySelector("#tile-${entity.position.id}");
    e.children[0].classes.addAll([entity.skin, "entity"]);
    (entity.position as Field).accessible = false;
  }

  _despawnEntity(Moveable entity) {
    DivElement e = querySelector("#tile-${entity.position.id}");
    e.children[0].classes.removeAll([entity.skin, "entity"]);

    (entity.position as Field).accessible = true;
  }

  _centerPlayer() {
    int mod = 32;
    view.dungeon.scrollTop = ((player.position.row + 4) * (mod + 8));
    view.dungeon.scrollLeft = (player.position.col * mod);
  }

  _updatePlayerHealth() {
    view.playerHealth.text = "${player.currHealth}/${player.maxHealth}";
    view.playerHealthBar.style.setProperty("width", "${player.currHealthPercent}%");
  }

  _updatePlayerEquipment() {
    /* SELECT WEAPON */
    _selectItem(player.weapon, "Weapon", "Damage", Settings.getWeaponImgPath());
    _previewItem(player.inventory.first);

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
    view.heroLuck.text = player.luck;
    view.heroSpeed.text = player.speed;
  }

  _updatePlayerXp() {
    view.playerEp.text = "${player.gainedXpByCurrentLvl}/${player.neededXpByCurrentLvl}";
    view.playerEpBar.style.setProperty("width", "${player.currXpPercent}%");
    view.playerLevel.text = player.level;
  }

  _updateFightScreen() {
      view.monsterFightHealth.text = attacker.currHealth;
      view.monsterFightMaxHealth.text = attacker.maxHealth;
      view.monsterFightHealthBar.style.setProperty("width", "${attacker.currHealthPercent}%");

      view.playerFightHealth.text = player.currHealth;
      view.playerFightMaxHealth.text = player.maxHealth;
      view.playerFightHealthBar.style.setProperty("width", "${player.currHealthPercent}%");
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
      player.equip(player.currentInvtentoryItem);
      _updatePlayerEquipment();
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

      element.children[0].style.backgroundImage = "url($imagePath/${item.icon})";
      index++;
    });
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
      String imagePath =
      item.classification == "Weapon" ? Settings.getWeaponImgPath() : Settings.getArmorImgPath();

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

        String text = "$prefix$value ${key[0].toUpperCase()}${key.substring(1)}";
        view.previewItemMods.append(new LIElement()..text = text);
      });
    }
  }

  _openHeroScreen() {
    _updatePlayerEquipment();
    _toggleOverlay(view.heroScreen);
  }

  _updateMoveablePositions() {
    if (!player.inFight) {
      player.position.element.children.first.classes.removeAll(player.skins);
      player.position.element.children.first.classes.remove("entity");
      player.move();

      Field elm = player.position;
      if (elm != null) {
        elm.element.children.first.classes.addAll([player.skin, "entity"]);
      }

      levels[player.currentStage].monsters.forEach((monster) {
        monster.move();

        elm = monster.position;
        if (elm != null) {
          monster.position.element.children.first.classes.addAll([monster.skin, "entity"]);
        }
      });

      _centerPlayer();

      if (!player.inFight) {
        _checkFight();
      }
    }
  }

  _checkFight() {
    levels[player.currentStage].monsters.forEach((monster) {
      if (player.position.isNeighbour(monster.position)) {
        _startFight(monster);
      }
    });
  }
}
