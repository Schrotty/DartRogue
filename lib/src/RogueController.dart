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
  }

  _updateItemIcon(Element element, String itemType, String icon) {
    element.style.backgroundImage = "url(${Settings.getImgPath()}items/$itemType/$icon)";
  }

  _updatePlayerAttributes() {
    /*view.level.text = player.level;
    view.strength.text = player.strength;
    view.constitution.text = player.constitution;
    view.luck.text = player.luck;
    view.damage.text = player.damage;
    view.critDamage.text = player.critDamage;
    view.critChance.text = player.critChance;*/
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

  _updateInventoryItemStats(Item item) {
    view.inventorySelectedItemName.text = item.name;
    view.inventorySelectedItemQuality.text = "Quality: ${item.quality}";
    view.inventorySelectedItemValue.text = "Value: ${item.value}";

    item.modifier.forEach((key, value) {
      view.inventorySelectedItemMods.text += "$key: $value";
    });

    _switchMenu(view.inventorySelectedItem, null);
  }

  _updateDebugScreen() {
    view.debugWeapons.text = weapons.toString();
  }
}
