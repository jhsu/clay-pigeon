require File.dirname(__FILE__) + '/base'

describe Task do
  before do
    @task = Task.new
  end

  it "has 6 days left" do
    @task.created_at = '2008-11-14'
    @task.due = '2008-11-20'
    @task.days_left.should == '6'
  end

  it "has already past" do
    @task.due = '2008-11-10'
    @task.past?.should == true
  end

  it "should not be past due if due today" do
    @task.due = Time.now
    @task.past?.should == false
  end

  it "should have a #status if no due date" do
    @task.created_at = Time.now
    @task.status.should_not == nil
  end

  it "should have a #status of new if just created" do
    @task.created_at = Time.now
    @task.status.should == 'new'
  end

  it "should have a #status of late if older than a day" do
    @task.created_at = Time.now - (24 * 60 * 60) * 7
    @task.status.should == 'late'
  end

  it "should have a #status of old if older than a day and done" do
    @task.created_at = Time.now - (24 * 60 * 60) * 7
    @task.done = true
    @task.status.should == 'old'
  end

  it "should pull the date out of input_text" do
    @task.input_text = 'i hope you know this is due 10/31'
    @task.pulled_date.should == '10/31'
  end

  it "should set a due date from the pulled date" do
    @task.date = "10/31"
    @task.due.should == Time.parse("10/31")
  end
end

