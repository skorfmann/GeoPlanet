require File.dirname(__FILE__) + '/test_helper.rb'


class AlterTableMethodTest < Test::Unit::TestCase

  def setup
    load_schema
  end
  
  def test_alter_table_should_be_available_in_migration
    assert ActiveRecord::Migration.respond_to?(:alter_table)
  end
  
  def test_alter_table_should_yield_with_alter_table_statement_object_as_block_parameter
    block_parameter = nil
    ActiveRecord::Migration.alter_table(:people) do |t|
      block_parameter = t
    end
    assert_kind_of ActiveRecord::Migration::AlterTableStatement, block_parameter
  end
  
  def test_add_column_without_options
    ActiveRecord::Migration.alter_table(:people) do |t|
      t.add_column(:last_name, :string)
    end
    
    columns = ActiveRecord::Base.connection.columns(:people)
    last_name = columns.detect { |c| c.name == "last_name" }
    
    assert_equal :string, last_name.type
  end

  def test_add_column
    ActiveRecord::Migration.alter_table(:people) do |t|
      t.add_column(:last_name, :string, :default => "Default", :null => false)
    end
    
    columns = ActiveRecord::Base.connection.columns(:people)
    last_name = columns.detect { |c| c.name == "last_name" }
    
    assert_equal "Default", last_name.default
    assert !last_name.null
    assert_equal :string, last_name.type
  end

  def test_remove_column
    ActiveRecord::Migration.alter_table(:people) do |t|
      t.remove_column(:first_name)
    end

    columns = ActiveRecord::Base.connection.columns(:people)
    assert !columns.any? { |c| c.name == "first_name" }
  end
  
  def test_change_column
    ActiveRecord::Migration.alter_table(:people) do |t|
      t.change_column(:first_name, :string, :default => "New Name", :null => false)
    end

    columns = ActiveRecord::Base.connection.columns(:people)
    first_name = columns.detect { |c| c.name == "first_name" }

    assert_equal "New Name", first_name.default
    assert !first_name.null
    assert_equal :string, first_name.type
  end

  def test_change_column_with_null_true
    ActiveRecord::Migration.alter_table(:people) do |t|
      t.change_column(:first_name, :string, :default => "New Name", :null => true)
    end

    columns = ActiveRecord::Base.connection.columns(:people)
    first_name = columns.detect { |c| c.name == "first_name" }

    assert_equal "New Name", first_name.default
    assert first_name.null
    assert_equal :string, first_name.type
  end
  
  def test_rename_column
    ActiveRecord::Migration.alter_table(:people) do |t|
      t.rename_column(:first_name, :new_first_name)
    end
    columns = ActiveRecord::Base.connection.columns(:people)
    
    assert columns.any? { |c| c.name == "new_first_name" }
    assert !columns.any? { |c| c.name == "first_name" }
  end

  def test_rename_not_existing_column
    assert_raise(ActiveRecord::ActiveRecordError) do
      ActiveRecord::Migration.alter_table(:people) do |t|
        t.rename_column(:not_existing_column, :new_not_existing_column)
      end
    end
  end
  
  def test_add_index
    ActiveRecord::Migration.alter_table(:people) do |t|
      t.add_index(:first_name)
    end
    
    indexes = ActiveRecord::Base.connection.indexes("people")
    
    assert_equal "people", indexes.first.table
    assert_equal "index_people_on_first_name", indexes.first.name
    assert !indexes.first.unique
    assert_equal ["first_name"], indexes.first.columns
  end

  def test_add_unique_index
    ActiveRecord::Migration.alter_table(:people) do |t|
      t.add_index(:first_name, :unique => true)
    end
    indexes = ActiveRecord::Base.connection.indexes("people")
    
    assert_equal "people", indexes.first.table
    assert_equal "index_people_on_first_name", indexes.first.name
    assert indexes.first.unique
    assert_equal ["first_name"], indexes.first.columns
  end

  def test_add_named_index
    ActiveRecord::Migration.alter_table(:people) do |t|
      t.add_index(:first_name, :name => "my_named_index")
    end
    
    indexes = ActiveRecord::Base.connection.indexes("people")
    
    assert_equal "my_named_index", indexes.first.name
    assert_equal ["first_name"], indexes.first.columns
  end

  def test_remove_index
    #  first add the index that we want to remove
    ActiveRecord::Migration.alter_table(:people) do |t|
      t.add_index(:first_name)
    end

    ActiveRecord::Migration.alter_table(:people) do |t|
      t.remove_index(:first_name)
    end
    indexes = ActiveRecord::Base.connection.indexes("people")

    assert indexes.empty?
  end

  def test_remove_named_index
    #  first add the index that we want to remove
    ActiveRecord::Migration.alter_table(:people) do |t|
      t.add_index(:first_name, :name => "my_named_index")
    end

    ActiveRecord::Migration.alter_table(:people) do |t|
      t.remove_index(:first_name, :name => "my_named_index")
    end
    indexes = ActiveRecord::Base.connection.indexes("people")

    assert indexes.empty?
  end

  def test_multiple_alterations
    # setup columns and index so we can alter them
    ActiveRecord::Migration.alter_table(:people) do |t|
      t.add_column(:removeable_column, :string)
      t.add_column(:renameable_column, :string)
      t.add_column(:indexed_column, :string)
      t.add_index(:indexed_column)
    end
    
    alter_table_statement = ActiveRecord::Migration.alter_table(:people) do |t|
      t.change_column(:first_name, :string, :default => "New Default", :null => false)
      t.add_column(:new_column, :string, :default => "New", :null => false)
      t.remove_column(:removeable_column)
      t.rename_column(:renameable_column, :new_renameable_column)
      t.add_index(:new_column)
      t.remove_index(:indexed_column)
    end
    
    assert_match /(ALTER TABLE.*){1}/, alter_table_statement.to_s
    
    columns = ActiveRecord::Base.connection.columns(:people)
    
    first_name = columns.detect { |c| c.name == "first_name" }
    assert_equal "New Default", first_name.default
    assert !first_name.null
    assert_equal :string, first_name.type
    
    new_column = columns.detect { |c| c.name == "new_column" }
    assert_equal "New", new_column.default
    assert !new_column.null
    assert_equal :string, new_column.type
    
    assert !columns.any? { |c| c.name == "removeable_column" }
    
    assert !columns.any? { |c| c.name == "renameable_column" }
    assert columns.any? { |c| c.name == "new_renameable_column" }
    
    indexes = ActiveRecord::Base.connection.indexes("people")
    
    assert_equal 1, indexes.size
    
    assert_equal "index_people_on_new_column", indexes.first.name
    assert_equal ["new_column"], indexes.first.columns
  end
end
