class AddTsvColumnsToJobs < ActiveRecord::Migration
  def up
    add_column :jobs, :tsv, :tsvector
    add_index :jobs, :tsv, using: "gin"

    execute <<-SQL
      CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE
      ON jobs FOR EACH ROW EXECUTE PROCEDURE
      tsvector_update_trigger(
        tsv, 'pg_catalog.english', title, company, description
      );
    SQL

    now = Time.current.to_s(:db)
    update("UPDATE jobs SET updated_at = '#{now}'")
  end

  def down
    execute <<-SQL
      DROP TRIGGER tsvectorupdate
      ON jobs
    SQL

    remove_index :products, :tsv
    remove_column :products, :tsv    
  end
end
