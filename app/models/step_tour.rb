class StepTour < Step
  belongs_to_step :stage
  
  has_many :schedules, :foreign_key => 'tour_id'
  
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
      
      def clone
        Record.new(team, results.clone, games_count, games.clone, goals.clone, score, fouls, position_change)
      end
    end
    
    class Set < ::Array
      def initialize
        yield self if block_given?
      end
      
      def << table
        clone = table.clone
        clone.process
        if last
          clone.values.each_with_index do |record, position|
            record.position_change = last.values.index{ |v| v.team.id == tecord.team.id } - position
          end
        end
        unshift clone
      end
    end
    
    attr_accessor :records
    attr_accessor :values
    
    def initialize
      @records = {}
      yield self if block_given?
    end
    
    def << match
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
    
    def clone
      Table.new do |t|
        records.each do |k, r|
          t.records[k] = r.clone
        end
        t.process if processed?
      end
    end
  end
end
