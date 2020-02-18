# todo
* BUG: player moves when hitting "u" in action modal
* items
  * scrolls:
    * magic missle scroll
      * target visible entities within range
    * fireball scroll:
      * aoe, dot
* restart after death
* hp bar ui

# bugs
* enemies still have trouble seeing around each other
* text isn't as crisp as it ideally would be
  * messing with filtering and antialiasing settings doesn't seem to affect

# long-term would be nice
* animations, animation frames
* skills

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
  * latin american indiginous
  * pirate
  * generational spaceship gone wrong, inspired by the expanse
  * space bounty hunter, inspired by mandalorian
* player may be able to take on properties of defeated enemies
* make ai smarter:
  * http://www.gameaipro.com/

# art
* transitioning between different tiles:
  * https://www.youtube.com/watch?v=FgV-OIg90nM
* general pixelart guides:
  * http://lpc.opengameart.org/static/lpc-style-guide/styleguide.html#useful-generalist-resources
