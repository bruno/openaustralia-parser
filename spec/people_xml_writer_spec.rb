$:.unshift "#{File.dirname(__FILE__)}/../lib"

require "test/unit"
require 'spec'

require "people_xml_writer"

describe PeopleXMLWriter do
  it "writes out xml file of electoral divisions" do
    people = mock("People")
    people.stub!(:divisions).and_return(["Blah", "Foo"])
        
    result = ""
    # So confusing: This is divisions as in electoral divisions rather than voting divisions
    PeopleXMLWriter.write_divisions(people, result)
    result.should == <<EOF
<publicwhip>
  <constituency fromdate="1000-01-01" id="uk.org.publicwhip/cons/1" todate="9999-12-31">
    <name text="Blah"/>
  </constituency>
  <constituency fromdate="1000-01-01" id="uk.org.publicwhip/cons/2" todate="9999-12-31">
    <name text="Foo"/>
  </constituency>
</publicwhip>
EOF
  end
end
