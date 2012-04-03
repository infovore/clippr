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
      it "should extract the author"
      it "should extract the title"
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
end