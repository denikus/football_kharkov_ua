# -*- encoding : utf-8 -*-
class Tour < ActiveRecord::Base
  belongs_to :stage
  #  has_many :matches
  has_many :schedules

  def tour_table
    table = Table.new self
  end
  
  class Table
    class Record < Struct.new(:team, :results, :games_count, :games, :goals, :score, :fouls, :position_change)
      def initialize(*args)
        defaults = [nil, {}, 0, [0, 0, 0], [0, 0], 0, 0, 0]
        super(*(args + defaults[args.length..-1]))
      end
      
      def update match
        comps = match.competitors
        comps.reverse! if self.team.id != comps.first.team_id
        goals = comps.collect{ |c| c.stats.get('score') || 0 }
        self[:results][comps.last.team_id] = goals
        self[:games_count] += 1
        self[:games] = self[:games].zip(lambda{ |a, i| a[i] += 1; a }[[0, 0, 0], (1-goals.inject(&:<=>)).abs]).collect{ |e| e.inject(&:+) }
        self[:goals] = self[:goals].zip(goals).collect{ |e| e.inject(&:+) }
        self[:score] = self[:games].zip([3, 1, 0]).collect{ |e| e.inject(&:*) }.inject(&:+)
        self[:fouls] = self[:fouls] + (comps.first.stats.get('first_period_fouls') || 0) + (comps.first.stats.get('second_period_fouls') || 0)
      end
      
      def <=> other
        return other.score <=> self.score unless (other.score <=> self.score).zero?
        unless self[:results][other.team.id].nil?
          return self[:results][other.team.id].reverse.inject(&:<=>) unless self[:results][other.team.id].inject(&:==)
        end
        wins = [other, self].collect{ |e| e.games[0] }
        return wins.inject(&:<=>) unless wins.inject(&:==)
        diff = [other, self].collect{ |e| e.goals.inject(&:-) }
        return diff.inject(&:<=>) unless diff.inject(&:==)
        [self, other].collect(&:fouls).inject(&:<=>)
      end
    end
    
    class Set < ::Array
      def << tour
        push Table.new(tour, length.zero? ? nil : last)
        self
      end
    end
    
    attr_accessor :records
    attr_accessor :values
    
    def initialize tour, table=nil
      @tour = tour
      @processed = false
      if table
        table.process unless table.processed?
        @records = table.clone_records
      else
        @records = {}
      end
    end
    
    def << match
      raise ArgumentError unless match.is_a? Match
      
      match.competitors.each do |c|
        @records[c.team_id] ||= Record.new(c.team)
        @records[c.team_id].update(match)
      end
      
      self
    end
    
    def get
      process unless processed?
      values
    end
    
    def process
      return if @processed
      @tour.matches.inject(self){ |res, m| res << m }
      @values = @records.values.sort
      @processed = true
    end
    
    def processed?
      @processed
    end
    
    def clone_records
      Hash[*@records.map{ |k, r| [k, Record.new(r.team, r.results.clone, r.games_count, r.games.clone, r.goals.clone, r.score, r.fouls, r.position_change)] }.flatten]
    end
  end
end
