=begin

Random Names v1.1, by Feldherren

Changelog:
  v1.1: now supports lists
  v1.0: first working version!

Currently only for enemies. May add support for actors.

Known issues:
If multiple examples of the same enemy are in the same troop, they can end up with the same randomly-picked name, because they're drawing from the same pool. They'll be labelled '[name] A', '[name] B' and so forth, unless you have a script that changes how RPG Maker deals with enemies with the same name.

Usage:
  In an enemy's notebox, enter one of the following tags:
    <random names: [name][, name][, name][, etc]>
    <random name list: [list]>
  [list] should correspond with the name of one of the lists in NAME_LISTS
=end
module Random_Names
  # Add new lists here, similar to the default ones.
  # Do not remove
  NAME_LISTS = {
      "male" => ['Hector', 'Eliwood', 'Marth', 'Seth', 'Ephraim', 'Travis', 'Jant', 'Rictor', 'Alphonse', 'Destin', 'Lans', 'Bob'],
      "female" => ['Lyn', 'Eirika', 'Misty', 'Eleanor', 'Serra', 'Rachel', 'Alice', 'Hester', 'Carol', 'Eve', 'Jane'],
      "pets" => ['Fluffy', 'Binky', 'Fuzzums', 'Tibbers', 'Precious', 'Rex']
  }
end

class Game_Enemy < Game_Battler
  # on creation, get notebox tags from data and pick a random name. Return that for original name instead
  alias initialize_random initialize
  def initialize(index, enemy_id)
    initialize_random(index, enemy_id)
    # if notebox tags present, do stuff
    if (match = $data_enemies[@enemy_id].note.match( /^<random names\s*:\s*([\w\d,\s*]*)>/i ))
      @original_name = get_random_name(match[1].to_s)
    end
    if (match = $data_enemies[@enemy_id].note.match( /^<random name list\s*:\s*([\w\d\s*]*)>/i ))
      names = Random_Names::NAME_LISTS[match[1].to_s]
      @original_name = names[rand(names.length)]
    end
  end
  
  def strip_or_self!(str)
    str.strip! || str
  end
  
  def get_random_name(names)
    a = names.split(',')
    return strip_or_self!(a[rand(a.length)])
  end
end