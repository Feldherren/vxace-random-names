=begin

Random Names, by Feldherren
v 1.0

Changelog:
  v1.0: first working version!

Currently only for enemies.

Known issues:
If multiple examples of the same enemy are in the same troop, they can end up with the same randomly-picked name, because they're drawing from the same pool. They'll be labelled '[name] A', '[name] B' and so forth, unless you have a script that changes how RPG Maker deals with enemies with the same name.

Notebox tags:
  Enemies:
    <random names: [name][, name][, name][, etc]>
=end
module Random_Names
  name_lists['male'] = ['Hector', 'Eliwood', 'Marth', 'Seth', 'Ephraim', 'Travis', 'Jant', 'Rictor', 'Alphonse', 'Destin', 'Lans', 'Neless', 'Bob']
  name_lists['female'] = ['Lyn', 'Eirika', 'Misty', 'Eleanor', 'Serra']
  name_lists['pets'] = ['Fluffy', 'Binky', 'Fuzzums', 'Tibbers', 'Precious']
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
      @original_name = name_lists[match[1].to_s][rand(name_lists[match[1].to_s].length)]
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