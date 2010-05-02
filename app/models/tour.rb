class Tour < ActiveRecord::Base
  belongs_to :league
  has_many :matches
  
  def tour_table
    table = Table.new
    matches.inject(table){ |res, m| res << m }
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
        goals = comps.collect(&:score)
        self[:results][comps.last.team_id] = goals
        self[:games_count] += 1
        self[:games] = self[:games].zip(lambda{ |a, i| a[i] += 1; a }[[0, 0, 0], (1-goals.inject(&:<=>)).abs]).collect{ |e| e.inject(&:+) }
        self[:goals] = self[:goals].zip(goals).collect{ |e| e.inject(&:+) }
        self[:score] = self[:games].zip([3, 1, 0]).collect{ |e| e.inject(&:*) }.inject(&:+)
        self[:fouls] = self[:fouls] + comps.first.fouls
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
    
    attr_accessor :records
    
    def initialize
      @records = {}
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
      @records.values.sort
    end
  end
end
