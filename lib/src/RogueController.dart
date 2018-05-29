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

      /* GAME TIMER */
      const oneSec = const Duration(milliseconds: 16);
      new Timer.periodic(oneSec, (Timer t) => _update());

      levels[0].fields.forEach((row) {
        row.forEach((tile) {
          querySelector("#tiles").append(new Element.div()
            ..classes.add("tile")
            ..id = "tile-${tile.id}");
        });
      });

      querySelectorAll(".tile").onClick.listen((MouseEvent e) {
        Field old = null;
        DivElement clicked = e.target;

        if (Level.clicked != null) {
          old = Level.clicked;
          querySelector("#tile-${Level.clicked.id}").classes.remove("clicked");
        }

        Level.clicked = levels[0].getField(int.parse(clicked.id.substring(5)));
        clicked.classes.add("clicked");

        if (old != null) {
          if (old.id < Level.clicked.id) {
            view.dungeon.scrollLeft += 32;
          }

          if (old.id > Level.clicked.id) {
            view.dungeon.scrollLeft -= 32;
          }
        }

        //_moveCamera(64);
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
  }

  _registerGameEvents() {
    view.attackButton.onClick.listen((e) {
      view.skillZeroButton.value = skills[0].name;
      view.skillOneButton.value =
          "${skills[1].name} ${skills[1].useableCount}/${skills[1]
          .useableCountMax}";
      view.skillTwoButton.value =
          "${skills[2].name} ${skills[2].useableCount}/${skills[2]
          .useableCountMax}";
      view.skillThreeButton.value =
          "${skills[3].name} ${skills[3].useableCount}/${skills[3]
          .useableCountMax}";
      _switchMenu(view.skills, view.fightingOptions);
    });

    view.skillZeroButton.onClick.listen((e) {
      if (player.isAlive)
        attacker.takeDamage(player.calcDamage(skills[0].skillMod));
      if (attacker.isAlive) {
        player.takeDamage(attacker.calcDamage());
      }
      _updateEndScreen();
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
    });

    view.leaveFightEndButton.onClick.listen((e) {
      _switchMenu(view.fightingOptions, view.fightEnd);
      _toggleOverlay(view.fightingScreen);
    });

    view.heroScreenButton.onClick.listen((e) {
      _updatePlayerEquipment();
      _toggleOverlay(view.heroScreen);
    });

    view.fightingScreenButton.onClick.listen((e) {
      if (player.isAlive) {
        if (monsters.isNotEmpty) {
          var _rnd = new Random();
          do {
            attackerId = _rnd.nextInt(monsterCount_DEBUG);
          } while (!monsters.containsKey(attackerId));
          attacker = monsters[attackerId];
          view.monsterIcon.src = "img/monsters/${attacker.name}.png";
          _toggleOverlay(view.fightingScreen);
        } else {
          if (!view.fightingScreen.classes.contains("invisible"))
            view.fightingScreen.classes.add("invisible");
        }
      }
    });

    _registerHeroScreenEvents();

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

  _updateEndScreen() {
    _switchMenu(view.fightingOptions, view.skills);

    if (!attacker.isAlive || !player.isAlive) {
      String msg = !attacker.isAlive
          ? "You killed ${attacker.name}, you gained ${attacker
          .grantedXP} XP!" +
              (attacker.grantedXP > player.leftXpUntilLvlUp
                  ? "\nYou reched level ${player.level + 1}!"
                  : "")
          : "YOU DIED!";

      view.fightEndMessage.text = msg;
      _switchMenu(view.fightEnd, view.fightingOptions);
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
      _updateEndScreen();
    }
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
    /* SELECT WEAPON */
    _selectItem(player.weapon, "Weapon", "Damage", Settings.getWeaponImgPath());

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
    view.playerEp.text =
        "${player.gainedXpByCurrentLvl}/${player.neededXpByCurrentLvl}";
    view.playerEpBar.style.setProperty("width", "${player.currXpPercent}%");
    view.playerLevel.text = player.level;
  }

  _updateFightScreen() {
    view.monsterFightHealth.text = attacker.currHealth;
    view.monsterFightMaxHealth.text = attacker.maxHealth;
    view.monsterFightHealthBar.style
        .setProperty("width", "${attacker.currHealthPercent}%");

    view.playerFightHealth.text = player.currHealth;
    view.playerFightMaxHealth.text = player.maxHealth;
    view.playerFightHealthBar.style
        .setProperty("width", "${player.currHealthPercent}%");

    if (!attacker.isAlive) {
      if (monsters.containsKey(attackerId)) {
        monsters.remove(attackerId);
        player.gainXP(attacker.grantedXP);
        print(monsters.length);
      }
    }
  }

  _registerHeroScreenEvents() {
    /* NAVIGATION EVENTS */
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
  }

  _switchHeroScreenMenu(Element target, Element caller) {
    List menus = [view.heroEquipmentScreen, view.heroAttributesScreen];
    List buttons = [view.heroEquipmentButton, view.heroAttributesButton];

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

    view.selectedItemType.text = type;
    view.selectedItemValue.text = item.value.toString();
    view.selectedItemKey.text = valueKey;

    item.modifier.forEach((String key, value) {
      String prefix = "";
      if (value > 0) prefix = "+";

      String text = "$prefix$value ${key[0].toUpperCase()}${key.substring(1)}";
      view.selectedItemMods.append(new LIElement()..text = text);
    });
  }
}
