class DungeonBattle

  include Redis::Objects

  STATE_CURRENT = 0
  STATE_WIN = 1
  STATE_LOSE = 2
  STATE_CLEAR = 4

  def initialize user_game
    @user_game = user_game
    @enemies = Redis::List.new("DungeonBattle:#{user_game.id}:enemies")
    @player = Redis::Value.new("DungeonBattle:#{user_game.id}:player")
  end

  def near x, y
    [[x-1,y],[x+1,y],[x,y-1],[x,y+1]]
  end

  def near? x, y
    player_near = self.near self.player.x, self.player.y
    near = player_near.select{|e| e[0] == x.to_i and e[1] == y.to_i }
    !near.empty?
  end

  def attack x,y
    dungeon = Dungeon.get_xy_by_dungeon_id @user_game.dungeon_id

    enemy = self.get_target(x,y)
    unless enemy
      if self.near? x,y
        # update player
        player = self.player
        player.x = x.to_i
        player.y = y.to_i
        @player.value = player.to_yaml
      end
      return
    end
    UserInfo.transaction do
      #@enemies.lock do
        state = STATE_CURRENT
        player = UserStatus.where(user_id: @user_game.user_id).first(lock: :write)
        # attack
        enemy.hp -= player.attack
        state = STATE_WIN if enemy.hp <= 0

        # damage
        player.hp -= enemy.attack
        state = STATE_LOSE if player.hp <= 0

        # report
        self.make_report state, player.attack, enemy.attack

        #save
        # Debug (Auto heal)
        player.hp = UserStatus::FIRST_HP - enemy.attack
        player.save!
        @enemies.delete self.get_target(x, y, true)
        unless state == STATE_WIN or state == STATE_CLEAR
          @enemies << enemy.to_yaml
        end
        if @enemies.count <= 0
          self.make_report STATE_CLEAR, player.attack, enemy.attack
        end
        #end
    end

  end

  def get_target x, y, raw = false
    @enemies.each do |enemy|
      e = YAML::load(enemy)
      if e.x.to_i == x.to_i and e.y.to_i == y.to_i
        return e unless raw
        return enemy
      end
    end
    false
  end

  def initialize_enemy
    enemies = DungeonEnemy.get_by_dungeon_id(@user_game.dungeon_id)
    default_position = Dungeon.get_default_enemy_xy_by_dungeon_id @user_game.dungeon_id
    default_position.each_with_index do |obj, p|
      # TODO Get from memcached
      @enemies << DungeonBattleEnemy.new(obj[0], obj[1], NpcEnemy.find(enemies[p].npc_enemy_id)).to_yaml
    end
  end

  def initialize_player
    # FIXME START POSITION
    @player.value = DungeonUser.new(@user_game.user_id, 8,1).to_yaml
  end

  def make_report state, attack, damage
    # TODO Save to redis(save db after game clear)
    case state
    when STATE_CURRENT
      body = "[BATTLE] Attack #{attack} Get Damage #{damage}."
    when STATE_WIN
      body = "[WIN] Attack #{attack} Get Damage #{damage}. Win!"
    when STATE_LOSE
      body = "[LOSE] Attack #{attack} Get Damage #{damage}. Died..."
    when STATE_CLEAR
      body = "[CLEAR] Attack #{attack} Get Damage #{damage}. Stage Clear!"
    end
    UserGameReport.create!(user_game: @user_game, body: body) unless body.nil?
  end

  def enemies
    @enemies
  end

  def player
    YAML::load(@player.value)
  end
end
