require_relative "../lib/block"
require 'rspec/its'

describe Block do

  # ============
  # = Creation =
  # ============

  describe "creation" do
    context "when the beginning is less than the end" do
      let(:block) { Block.new(1,2) }
      it "creates the block with the specified top" do
        block.top.should eq(1)
      end

      it "creates the block with the specified bottom" do
        block.bottom.should eq(2)
      end
    end

    context "when the end is less than the beginning" do
      let(:block) { Block.new(2,1) }
      it "creates the block with the inverse start" do
        block.top.should eq(1)
      end

      it "creates the block with the inverse end" do
        block.bottom.should eq(2)
      end
    end
  end

  # ===========
  # = #length =
  # ===========

  describe '#length' do
    it 'is 0 when start == end' do
      block = Block.new(2, 2)
      block.length.should eq(0)
    end

    it 'is 1 when end == (start + 1)' do
      block = Block.new(1, 2)
      block.length.should eq(1)
    end
  end

  # ==============
  # = Comparison =
  # ==============

  describe "equality" do

    let(:a) { Block.new(1,2) }

    context "when start and end are equal" do
      let(:b) { Block.new(1,2) }

      it "is equal" do
        (a == b).should eq(true)
      end
    end

    context "when start and end are not equal" do
      let(:b) { Block.new(1,3) }

      it "is not equal" do
        (a == b).should eq(false)
      end
    end
  end

  describe "spaceship" do
    let(:a) { Block.new(2,4) }

    context "when both a start and end are bigger than b" do
      let(:b) { Block.new(1,2) }

      it "returns 1" do
        (a <=> b).should eq(1)
      end
    end

    context "when both a start and end are smaller than b" do
      let(:b) { Block.new(3,4) }

      it "returns -1" do
        (a <=> b).should eq(-1)
      end
    end

    context "when both a start and end are equal than b" do
      let(:b) { Block.new(2,4) }

      it "returns 0" do
        (a <=> b).should eq(0)
      end
    end
  end

  describe "include?" do
    let(:a) { Block.new(2,6) }

    context "when number stay between start and end" do
      it "returns true" do
        a.include?(3).should eq(true)
      end
    end

    context "when number out of start and end" do
      it "returns false" do
        a.include?(3).should eq(true)
      end
    end
  end

  # ============
  # = Addition =
  # ============

  describe "addition" do

    let(:a)       { Block.new(100, 200) }

    let(:result)  { a + b }

    context "when a encompasses b" do

      let(:b)    { Block.new(110, 190) }

      it "returns a" do
        result.should eq([a])
      end
    end

    context "when b encompasses a" do

      let(:b)   { Block.new(90, 210) }

      it "returns b" do
        result.should eq([b])
      end
    end

    context "when b subsumes a's origin" do

      let(:b)   { Block.new(90, 110) }

      it "returns one block" do
        result.size.should eq(1)
      end

      it "begins with b" do
        result.first.top.should eq(90)
      end

      it "ends with a" do
        result.first.bottom.should eq(200)
      end
    end

    context "when b subsumes a's ending" do

      let(:b)   { Block.new(190, 210) }

      it "returns one block" do
        result.size.should eq(1)
      end

      it "begins with a" do
        result.first.top.should eq(100)
      end

      it "ends with b" do
        result.first.bottom.should eq(210)
      end
    end

    context "when there is no overlap" do

      let(:b)   { Block.new(10, 20) }

      it "returns the original blocks" do
        result.should eq([b, a])
      end
    end

    context "when a == b" do

      let(:b)  { Block.new(a.start, a.end) }

      it "returns a" do
        pending "Needs to be implemented"
      end
    end
  end

  # ===========
  # = Padding =
  # ===========

  describe "padding" do
    let(:a)         { Block.new(100, 200) }
    subject         { a.padded(top, bottom) }

    context "with positive value padding (10, 20)" do
      let(:top)    { 10 }
      let(:bottom) { 20 }
      its(:start)  {
        pending "Needs to be implemented" }
      its(:end)    {
        pending "Needs to be implemented"
      }
    end

    context "with negative value padding (-10, -20)" do
      let(:top)    { -10 }
      let(:bottom) { -20 }
      its(:start)  {
        #Code Here
      }
      its(:end)    {
        pending "Needs to be implemented"
      }
    end
  end


  # ===============
  # = Subtraction =
  # ===============

  describe "subtraction" do

    let(:a)       { Block.new(100, 200) }

    let(:result)  { a - b }

    context "when a encompasses b" do

      let(:b)    { Block.new(150, 170) }

      it "returns two blocks" do
        pending "Needs to be implemented"
      end

      describe "first block" do
        it "begins at the original point" do
          pending "Needs to be implemented"
        end

        it "ends at the start of b" do
          pending "Needs to be implemented"
        end
      end

      describe "second block" do
        it "begins at the end of b" do
          pending "Needs to be implemented"
        end

        it "ends at the original point" do
          pending "Needs to be implemented"
        end
      end
    end

    context "when b encompasses a" do
      let(:b) { Block.new(90, 210) }

      it "returns a nil block" do
        pending "Needs to be implemented"
      end
    end

    context "when b covers a with a shared beginning" do
      let(:b) { Block.new(a.start, a.end + 10) }
      it "returns a nil block" do
        pending "Needs to be implemented"
      end
    end

    context "when b covers a with a shared ending" do
      let(:b) { Block.new(a.start - 10, a.end) }
      it "returns a nil block" do
        pending "Needs to be implemented"
      end
    end

    context "when b encompasses a's origin" do

      let(:b) { Block.new(a.start, a.start + 10) }

      it "returns a single block" do
        pending "Needs to be implemented"
      end

      it "begins at the end of b" do
        pending "Needs to be implemented"
      end

      it "ends at the original point" do
        pending "Needs to be implemented"
      end
    end

    context "when b encompasses a's ending" do

      let(:b) { Block.new(190, 200) }

      it "returns a single block" do
        pending "Needs to be implemented"
      end

      it "begins at the original point" do
        pending "Needs to be implemented"
      end

      it "ends at the start of b" do
        pending "Needs to be implemented"
      end
    end

    context "when there is no overlap" do
      let(:b) { Block.new(0, 100) }

      it "returns self" do
        pending "Needs to be implemented"
      end
    end

    context "when b == a" do
      let(:b) { Block.new(a.start, a.end) }

      it "returns empty" do
        pending "Needs to be implemented"
      end
    end
  end

  # =====================
  # = Array Subtraction =
  # =====================

  describe "array subtraction" do

    let(:a) { Block.new(100, 200) }

    let(:b) { Block.new(90, 110) }

    let(:c) { Block.new(130, 140) }

    let(:d) { Block.new(180, 220) }

    let(:others) { [b, c, d] }

    let(:result) { a - others }

    it "returns each of the remaining spaces" do
      pending "Needs to be implemented"
    end

    describe "first block" do
      it "starts where b ended" do
        pending "Needs to be implemented"
      end

      it "ends where c starts" do
        pending "Needs to be implemented"
      end
    end

    describe "second block" do
      it "starts where c ended" do
        pending "Needs to be implemented"
      end

      it "ends where d starts" do
        pending "Needs to be implemented"
      end
    end

  end

  # ===========
  # = Merging =
  # ===========

  describe "merging" do

    let(:a)       { Block.new(10, 20) }

    let(:b)       { Block.new(20, 25) } # Contiguous with A

    let(:c)       { Block.new(30, 40) }

    let(:d)       { Block.new(35, 45) } # Overlapping with C

    let(:e)       { Block.new(55, 65) } # Isolated

    let(:result)  { a.merge([b,c,d,e]) }

    it "collapses contiguous and overlapping blocks" do
      pending "Needs to be implemented"
    end

    describe "first block (collapsed contiguous)" do
      it "start aligns with start of A" do
        pending "Needs to be implemented"
      end

      it "end aligns with end of B" do
        pending "Needs to be implemented"
      end
    end

    describe "second block (collapsed overlapping)" do
      it "start aligns with start of C" do
        pending "Needs to be implemented"
      end

      it "end aligns with end of D" do
        pending "Needs to be implemented"
      end
    end

    describe "third block (isolated)" do
      it "starts as it was" do
        pending "Needs to be implemented"
      end

      it "ends as it was" do
        pending "Needs to be implemented"
      end
    end

  end

  # ============
  # = Limiting =
  # ============

  describe "limiting" do

    let(:b)       { Block.new(0, 100) }

    let(:result)  { a.limited(b) }

    context "when the limited block overlaps with the limiter's beginning" do
      let(:a)       { Block.new(-10, 10) }
      it "trims the top of the block" do
        pending "Needs to be implemented"
      end

      it "keeps the original end" do
        pending "Needs to be implemented"
      end
    end

    context "when the limited block overlaps with the limiter's end" do
      let(:a) { Block.new(90, 110) }

      it "trims the bottom of the block to the limiter's end" do
        pending "Needs to be implemented"
      end

      it "keeps the original beginning" do
        pending "Needs to be implemented"
      end
    end

  end

end
