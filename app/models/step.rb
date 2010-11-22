class Step < ActiveRecord::Base
  ORDER = ['StepSeason', 'StepStage', 'StepLeague', 'StepTour']
  
  has_and_belongs_to_many :phases,
    :class_name => 'Step',
    :join_table => 'steps_phases',
    :foreign_key => 'step_id',
    :association_foreign_key => 'phase_id'
  
  has_and_belongs_to_many :parent_phases,
    :class_name => 'Step',
    :join_table => 'steps_phases',
    :foreign_key => 'phase_id',
    :association_foreign_key => 'step_id'
  
  def phase_class_name
    ORDER[ORDER.index(self[:type]) + 1]
  end
  
  def full_name
    case self
    when StepSeason: 'Сезон ' + name
    when StepStage: 'Этап ' + identifier.to_s
    when StepLeague: name
    when StepTour: name + ' Тур'
    end
  end
  
  def self.tree tournament_id
    steps = find_all_by_tournament_id(tournament_id,
      :select => "steps.*, steps_phases.step_id AS parent_id",
      :joins => 'LEFT JOIN steps_phases ON steps_phases.phase_id = steps.id'
    ).sort_by{ |s| ORDER.index(s[:type]) }
    steps.inject([]) do |res, step|
      hash = step.to_hash
      (res << hash).tap do
        if step['parent_id']
          (res.find{ |s| s['id'] == step['parent_id'].to_i }['phases'] ||= []) << hash
        end
      end
    end.select{ |step| step[:kind] == 'season'  }
  end
  
  def to_hash
    attributes.delete_if{ |k, v| %w{created_at updated_at parent_id}.include? k }.merge :kind => self[:type][/Step(\w+)$/, 1].downcase
  end
end
