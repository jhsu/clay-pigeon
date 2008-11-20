require 'time'

class Task < Sequel::Model
  set_schema do
    primary_key(:id, :null => false)
    text :title, :null => false
    boolean :done, :null => false, :default => false
    timestamp :due
    timestamp :created_at
    timestamp :updated_at
  end

  attr_accessor :input_text, :pulled_date, :date

  def input_text=(text)
    self.date = self.pulled_date = text.match(/\d{1,2}\/\d{1,2}/) ? text.match(/\d{1,2}\/\d{1,2}/)[0] : Time.now
    self.title = text.slice(/[a-zA-Z\s]*/).lstrip.rstrip
  end

  def date=(d)
    self.due = Time.parse(d.to_s) 
  end

  def done?
    self.done
  end

  def past?
    self.due <= (Time.now - Time.now.sec - Time.now.min * 60 - Time.now.hour * 60 * 60) ? true : false
  end

  def days_left
    c = self.created_at
    d = self.due
    "#{((d - c) / 60 / 60 / 24).round}"
  end

  def status
    unless done?
      self.created_at < Time.now - 24 * 60 * 60 ? 'late' : 'new'
    else
      'old'
    end
  end

  def delay
    self.due += 2 * 60 * 60
  end
end

Task.create_table unless Task.table_exists?
