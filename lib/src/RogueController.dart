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

      const oneSec = const Duration(milliseconds: 16); // TODO proposal: use Settings.refreshRate instead?
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
    Element el = new Element.div()..classes.add("tile");

    for (int i = 0; i < 1024; i++) {
      querySelector("#tiles").append(new Element.div()..classes.add("tile"));
    }

    querySelectorAll(".tile").onClick.listen((MouseEvent e) {
      DivElement d = e.target;
      d.classes.add("clicked");

      print(e.client.x);
      print(e.client.y);

      _moveCamera(64);

      //querySelector("#level").scroll(e.client.x, e.client.y);


      //d.scrollIntoView(ScrollAlignment.TOP);
      //view.game.scrollTop = -5;
    });

    view.heroScreenButton.onClick.listen((e) {
      _toggleOverlay(view.heroScreen);
      _toggleOverlay(view.tiles);
    });

    view.potionsMenuButton.onClick.listen((e) {
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
  }

  _updatePlayerHealth() {
    /*view.playerHealth.text = player.currHealth;
    view.playerMaxHealth.text = player.maxHealth;*/
    view.playerHealthBar.style.setProperty("width", "${player.currHealthPercent}%");
  }

  _moveCamera(int value) {
    view.level.scrollLeft += value;
  }
}