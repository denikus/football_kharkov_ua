class CompetitorsRemoveForeignKey < ActiveRecord::Migration
  def up
    execute <<-SQL
      ALTER TABLE competitors
        DROP CONSTRAINT competitors_match_id_fkey
    SQL
  end

  def down
    execute <<-SQL
              ALTER TABLE competitors
                ADD CONSTRAINT competitors_match_id_fkey
                FOREIGN KEY (match_id)
                REFERENCES matches(id)
            SQL
  end
end
