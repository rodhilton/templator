require_relative 'parser'

describe Templater do

  it "should parse yaml and substitute into templates" do

    data = <<-EOF
      experience:
        jobs:
          - company: Rally Software
            title: Java Web Applications Developer
            time: 2008-Present
            accomplishments:
              - Helped make ALM
              - Made Rallydroid
          - company: OpenLogic, Inc
            title: Software Engineer
            time: 2007-2008
            accomplishments:
              - Census
              - OLEX

    EOF

    template = <<-EOF
      My first job was <%= @experience.jobs[0].company %>
    EOF

    templater = Templater.new(template)

    result = templater.fill_in(data)

    result.should =~ /My first job was Rally Software/

  end

  it "should support options" do

    data = <<-EOF
      one:
        two: three
    EOF

    template = <<-EOF
      false: <%= @flags[:option] %>
    EOF

    templater = Templater.new(template)

    result = templater.fill_in(data, :option=>false)

    result.should =~ /false: false/

  end

end
