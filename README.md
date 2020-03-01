# todo
* p0
  * *_area should remove from indexes when gone
  * ui:
    * show status effects in ui
    * hover on EntityListItem highlights entities on map
    * wire in clicking in menu items
    * move up/down through menu
  * items:
    * scrolls:
      * confusion
* p1
  * session recorder for setting up integration test scenarios
  * inventory hotkeys static like brogue
  * multiple floors
  * inventory button
  * save/load game
  * restart after death
  * hp bar ui
  * scaling difficulty
  * more enemies
  * restart after death
  * text isn't as crisp as it ideally would be
    * messing with filtering and antialiasing settings doesn't seem to affect
  * FieldOfView should use circular area instead of square
  * fire can burn and transform
* refactoring opportunieis:
  * all console messages generated from events
  * refactor down use of globals

# bugs
* goblin doesn't disapear with quick attcks:
  * aren't getting properly cleaned up after dieing, workaround timeout in place
* inventory menu sometimes doesn't size to fit list items
* goblin sprite anim sometimes overlaps, producing double sprite effect on single tile:
  * combine all anim sheets into single sprite to fix?
* grammar in console is getting terrible

# architecture
* ECS in roguelikes; https://www.youtube.com/watch?v=fGLJC5UY2o4
  * traditional:
    * entity: identifier
    * component: data
    * system: behavior
  * better system for RLs:
    * E: identifier + data
    * C: data initialization, simple behavior
    * S: complex and reusable behavior
  * benefits:
    * DDD
    * enhanced productivity
    * better creativity
    * combinatorial explosion of possibilities
    * emergent gameplay
  * AGE design:
    * rendering completely decoupled from core game engine
    * UI updated with signals
    * two threads:
      * rendering, game engine
      * benefits include: no ui locking
      * UI can query into game engine, but very limited
  * ECS-light: https://www.youtube.com/watch?v=JxI3Eu5DPwE
* event-based systems:
  * https://www.reddit.com/r/roguelikedev/comments/9wzyoo/setting_up_an_event_system_as_a_backbone/
  * https://www.youtube.com/watch?v=p48ArjJweSo

# sound
* https://github.com/kyzfrintin/Godot-Mixing-Desk
 
# game ideas
* find items, find gems:
  * combine items and gems using logic:
    * player has fun discovering synergies
* different biomes:
  * can combine things between biomes to discover synergies
  * need to use things in one biome to help with things in another:
    * e.g. fire to destroy ice
* from brogue:
  * efficient, easy, intuitive player actions
  * constrained design:
    * one "perform action" for items instead of drink, read, use, etc.
  * pickup on collide with item
  * visual contrasting
* genre ideas:
  * one of:
    * pirate
    * generational spaceship gone wrong, inspired by the expanse
    * space bounty hunter, inspired by mandalorian
    * standard tolkien fantasy (bleh)
    * wasteland
* player may be able to take on properties of defeated enemies
* make ai smarter:
  * http://www.gameaipro.com/
* scroll crafting:
  * collect liquids, gems, papers to create scrolls
  * scroll recipes are randomly generated with every game
  * player can risk using ingredients to discover recipes, or find or buy recipe books
  * scrolls can be combined for seemingly emergent syngeries, ala binding of isaac
* home base:
  * the player can decorate their house
* themes:
  * dark atmosphere, avoid cute sprites and animations
* 1-3hr typical playruns
* mining for coin and materials
* big color contrasts in tilesets:
  * emulate some of the feel of ascii without being ascii
* no floors, or minimal use of floors, very large map:
  * dynamically load and unload areas into memory
  * areas should be meaningfully connected
  * clear guide on what areas to visit in what order, ala hollow knight
* room design:
  * lots of visual contrast between rooms
  * aesthetic changes between rooms
  * room and enemy combinations forces player to think of different tactics
  * power-ups
* feel:
  * frenetic turn-based:
    * quickly and efficiently execute plans
    * quick, tight animations and movements
* skill system:
  * is this needed?
* town and storekeeper:
  * would be great to have for game pacing dynamics
* make it difficult for players to screw up unintentionally:
  * damage, as much as possible, should be a calculated risk

# art
* transitioning between different tiles:
  * https://www.youtube.com/watch?v=FgV-OIg90nM
* general pixelart guides:
  * http://lpc.opengameart.org/static/lpc-style-guide/styleguide.html#useful-generalist-resources

# ui
* roguelikedev faq threa
  * https://www.reddit.com/r/roguelikedev/comments/3cqsaq/faq_friday_16_ui_design/
