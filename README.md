# todo
* items
* restart after death
* refactor out globals, like open rpg
* hp bar ui

# bugs
* actions run out of order
* queue order of actions is off under some circumstances
* enemies still have trouble seeing around each other
* performance issues when multiple enemies are pathing and attacking player

# long-term would be nice
* animations, animation frames
* skills
* sqlite db:
  * https://github.com/khairul169/gdsqlite-native
* game ai pro:
  * http://www.gameaipro.com/


# ideas
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
* pixelart:
  * http://lpc.opengameart.org/static/lpc-style-guide/styleguide.html#useful-generalist-resources
* procedural sound:
  * https://github.com/kyzfrintin/Godot-Mixing-Desk
* game ideas:
  * find items, find gems:
    * combine items and gems using logic:
      * player has fun discovering synergies
  * different biomes:
    * can combine things between biomes to discover synergies
    * need to use things in one biome to help with things in another:
      * e.g. fire to destroy ice
* player may be able to take on properties of defeated enemies
