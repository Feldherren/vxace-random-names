module Random_Names
  
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
  end
  
  def get_random_name(names)
    a = names.split(',')
    return a[rand(a.length)].strip_or_self!
  end
  
  def strip_or_self!(str)
    str.strip! || str
  end
end