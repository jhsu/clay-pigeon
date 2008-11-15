class Task < Sequel::Model
  set_schema do
    primary_key(:id, :null => false)
    text :title, :null => false
    boolean :done, :null => false, :default => false
    timestamp :due
    timestamp :created_at
    timestamp :updated_at
  end

  def days_left
    c = created_at
    d = due
    "#{((d - c) / 60 / 60 / 24).round}"
  end

  def done?
    done
  end

  def past?
    due <= (Time.now - Time.now.sec - Time.now.min * 60 - Time.now.hour * 60 * 60) ? true : false
  end

  def status
    unless done?
      created_at < Time.now - 24 * 60 * 60 ? 'late' : 'new'
    else
      'old'
    end
  end
end

Task.create_table unless Task.table_exists?
