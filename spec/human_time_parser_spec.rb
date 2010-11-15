require File.dirname(__FILE__) + '/../spec_helper.rb'

require 'activesupport'
require 'human_time_parser'

describe HumanTimeParser do

  before do
    HumanTimeParser.locale = 'ru'
    time_at_now = Time.now
    Time.stub!(:now).and_return(time_at_now)
  end

  def parse_time(human_time)
    HumanTimeParser.parse(human_time)
  end

  def today
    Time.now.beginning_of_day
  end

  it { parse_time('сейчас').should == Time.now }
  it { parse_time('сегодня').should == today }
  it { parse_time('сегодня в 18:00').should == today + 18.hours }
  it { parse_time('послезавтра в 23:15').should == today + 2.day + 23.hours + 15.minutes }
  it { parse_time('завтра в 15:00').should == today + 1.day + 15.hours }
  it { parse_time('через неделю').should == Time.now + 7.day }

  it do
    wendsday = today + (3 - today.wday).days
    parse_time('в следующую среду').should == wendsday + 7.day + 12.hours
  end

  it { parse_time('завтра с 18 до 23:15').should == [today + 1.day + 18.hours, today + 1.day + 23.hours + 15.minutes] }

  it do
    sunday = today + (7 - today.wday).days
    parse_time('воскресенье с 14 до 16').should == [sunday + 14.hours, sunday + 16.hours]
  end

  it do
    next_saturday = today + (13 - today.wday).days
    next_sunday   = (next_saturday + 1.day).end_of_day
    parse_time('в следующие выходные').should == [next_saturday, next_sunday]
  end
end