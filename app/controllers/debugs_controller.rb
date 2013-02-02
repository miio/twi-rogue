class DebugsController < ApplicationController
  before_filter :authenticate_user_info!
  def new
    @dungeon_id = Dungeon.get_by_random
    @ug = UserGame.create! user_id: current_user_info, dungeon_id: @dungeon_id, status: 0
    @map = Dungeon.get_xy_by_dungeon_id @dungeon_id
    @ug = UserGame.find(@ug)
    redirect_to action: :show, id: @ug.id
  end

  def show
    @user_game = UserGame.find params[:id]
    battle = DungeonBattle.new @user_game
    @battle_enemies = battle.enemies.map {|e| YAML::load(e)}
    @map = Dungeon.get_xy_by_dungeon_id @user_game.dungeon_id

    # Rewrite for views
    @map.each_with_index do |line, x|
      line.each_with_index do |elem, y|
        if @map[x][y].type == DungeonMap::MAP_TYPE_ENEMY
          @map[x][y].type = DungeonMap::MAP_TYPE_NONE
        end
      end
    end
    @battle_enemies.each do |e|
      @map[e.x][e.y].type = DungeonMap::MAP_TYPE_ENEMY
    end
    @map[battle.player.x][battle.player.y].type = DungeonMap::MAP_TYPE_PLAYER

    @report = UserGameReport.where(user_game_id: params[:id]).all
    @user_status = UserStatus.find current_user_info
  end

  def step
    @ug = UserGame.find(params[:id])
    battle = DungeonBattle.new @ug
    battle.attack params[:x], params[:y]
    redirect_to action: :show, id: @ug.id
  end
end
