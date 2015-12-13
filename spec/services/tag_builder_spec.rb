require 'rails_helper'

describe TagBuilder do
  it "should set ruby-on-rails for Ruby on Rails in the description" do
    tb = TagBuilder.new('development','title','A Ruby on Rails job')
    expect(tb.tags[:library]).to include('ruby-on-rails')
  end

  it "should set d3 for d3.js in the description" do
    tb = TagBuilder.new('development','title','A d3.js job')
    expect(tb.tags[:library]).to include('d3')    
  end

  it "should only add a tag once" do
    tb = TagBuilder.new('development','title','A Ruby on Rails Ruby on Rails Ruby on Rails job')
    expect(tb.tags[:library]).to eq ['ruby-on-rails']
  end

  it "should set sql-server for Microsoft SQL Server" do
    tb = TagBuilder.new('development','title','A Microsoft SQL Server job')
    expect(tb.tags[:tools]).to include('sql-server')  
  end
end
