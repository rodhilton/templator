require_relative 'templator'

describe Templator do

  it "should parse yaml and substitute into templates" do

    data = <<-EOF
      experience:
        jobs:
          - company: Company X
            title: Widget Genius
            time: 2000-Present
            accomplishments:
              - Made Widgets
              - Made More Widgets
          - company: Company Y
            title: Truck Driver
            time: 1990-2000
            accomplishments:
              - Kicked Ass
              - Chewed Bubblegum

    EOF

    template = <<-EOF
      My first job was <%= @experience.jobs[0].company %>
      I was there <%= @experience.jobs[0].time %>
      At my next company I <%= experience.jobs[1].accomplishments[0] %>
    EOF

    templater = Templator.new(template)

    result = templater.fill_in(data)

    result.should =~ /My first job was Company X/
    result.should =~ /I was there 2000-Present/
    result.should =~ /At my next company I Kicked Ass/

  end

  it "should ignore empty data file" do

    data = "---#nothin"

    template = <<-EOF
      Stuff
    EOF

    templater = Templator.new(template)

    result = templater.fill_in(data)

    result.should =~ /Stuff/

  end

  it "should support options" do

    data = <<-EOF
      one:
        two: three
    EOF

    template = <<-EOF
      false: <%= @flags[:option] %>
    EOF

    templater = Templator.new(template)

    result = templater.fill_in(data, :option=>false)

    result.should =~ /false: false/

  end


  it "should support options in data file" do

    data = <<-EOF
      one:
        two: <%= @flags[:test] %>
    EOF

    template = <<-EOF
      stuff: <%= one.two %>
    EOF

    templater = Templator.new(template)

    result = templater.fill_in(data, :test=>"stuff")

    result.should =~ /stuff: stuff/

  end

  it "should support allow traversal through nil objects" do

    data = <<-EOF
      one:
        two: three
    EOF

    template = <<-EOF
      stuff: <%= one.four %>
      stuff2: <%= one.four.five.six %>
      stuff3: <%= nothing.here %>
      stuff4: <%= "works" if there.are.no.limits.to.dot.chaining.nil? %>
      anything: <%= "truthy" unless nilobjects.do.not.count.as.truthy %>
    EOF

    templater = Templator.new(template)

    result = templater.fill_in(data, :test=>"stuff")

    result.should =~ /stuff: $/
    result.should =~ /stuff2: $/
    result.should =~ /stuff3: $/
    result.should =~ /stuff4: works/
    result.should =~ /anything: truthy/

  end

end
