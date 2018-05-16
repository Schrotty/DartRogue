part of rogue;

class RogueController {

  final RogueView view = new RogueView();

  RogueController() {
    _init();

    _registerMenuEvents();
    _registerGameEvents();

    const oneSec = const Duration(milliseconds: 16); // TODO proposal: use Settings.refreshRate instead?
    new Timer.periodic(oneSec, (Timer t) => _update());
  }

  _registerMenuEvents() {
    /* MAIN MENU EVENTS */
    view.startButton.onClick.listen((e) {
      _switchMenu(view.game, view.home);
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
      _toggleOverlay(view.heroScreen);
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
    view.playerHealth.text = player.currHealth;
    view.playerMaxHealth.text = player.maxHealth;
  }
}