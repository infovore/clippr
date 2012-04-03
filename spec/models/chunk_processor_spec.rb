require 'app/models/chunk_processor.rb'
include ChunkProcessor

class ChunkProcessorSpec
  describe "when dechunking title and author" do
    describe "and there is no author" do
      before(:each) do
        @string = "Capital without an Author"
      end

      it "should return nil as the author" do
        dechunk_title_and_author(@string)[1].should be_nil
      end

      it "should return the full title of the book as the title" do
        dechunk_title_and_author(@string)[0].should == @string
      end
    end

    describe "and there is an author" do
      before(:each) do
        @string = "Reamde (Neal Stephenson)"
      end

      it "should extract the author" do
        dechunk_title_and_author(@string)[1].should == "Neal Stephenson"
      end

      it "should extract the title" do
        dechunk_title_and_author(@string)[0].should == "Reamde"
      end
    end
  end

  describe "extracting locations to an array" do
    describe "and there is a single location" do
      it "should return an array containing that location as start and end" do
        location_string_to_array("275").should == [275,275]
      end
    end

    describe "and there is a start and end location" do
      it "should return an array containing that start and end location" do
        location_string_to_array("284-312").should == [284,312]
      end

      it "should return an array containing that start and end location even if going over a unit boundary" do
        location_string_to_array("978-1024").should == [978,1024]
      end

      it "should return an array containing the full start and end location even if abbreviatons are used" do
        location_string_to_array("284-87").should == [284,287]
      end
    end
  end

  describe "parsing details" do
    describe "with three fragments" do
      before(:each) do
        @string = "- Highlight on Page 63 | Loc. 1270-72  | Added on Tuesday, October 11, 2011, 08:49 AM"
      end
      it "should call parse_detail with the correct elements" do
        self.should_receive(:parse_detail).with(:page => "- Highlight on Page 63",
                                    :location => "Loc. 1270-72",
                                    :datetime => "Added on Tuesday, October 11, 2011, 08:49 AM")
        parse_details(@string)
      end
    end

    describe "with two fragments" do
      before(:each) do
        @string = "- Highlight Loc. 3261  | Added on Saturday, January 08, 2011, 03:44 PM"
      end
      it "should call parse_detail with the correct elements" do
        self.should_receive(:parse_detail).with(:page =>nil,
                                    :location => "- Highlight Loc. 3261",
                                    :datetime => "Added on Saturday, January 08, 2011, 03:44 PM")
        parse_details(@string)
      end
    end
  end      
end