class AddTagsColumnToJobs < ActiveRecord::Migration
  def up
    add_column :jobs, :tags, :text, array: true, default: []
    
    # Creates a sorting unique case insensitive index on the tags.
    # See http://blog.plataformatec.com.br/2014/07/rails-4-and-postgresql-arrays/
    execute <<-SQL
      CREATE FUNCTION sort_array(unsorted_array anyarray) RETURNS anyarray AS $$
        BEGIN
          RETURN (SELECT ARRAY_AGG(val) AS sorted_array
          FROM
          (SELECT
            UNNEST(string_to_array(lower(array_to_string(unsorted_array, ',')), ','))
            AS val ORDER BY val)
          AS sorted_vals);
        END;
      $$ LANGUAGE plpgsql IMMUTABLE STRICT;

      CREATE INDEX index_jobs_on_tags ON jobs USING BTREE (sort_array(tags));
    SQL
  end

  def down
    remove_column :jobs, :tags

    execute <<-SQL
      DROP INDEX IF EXISTS index_products_on_category_id_and_name_and_tags;
      DROP FUNCTION IF EXISTS sort_array(unsorted_array anyarray);
    SQL
  end
end
