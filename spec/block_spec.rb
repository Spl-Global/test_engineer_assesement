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
    let(:a) { Block.new(1, 1) }

    it 'is 0 when start == end' do
      a.length.should eq(0)
    end

    let(:b) { Block.new(1, 2) }

    it 'is 1 when end == (start + 1)' do
      b.length.should eq(1)
    end
  end

  # ==============
  # = Comparison =
  # ==============

  describe "equality" do

    let(:a) { Block.new(1, 2) }

    context "when start and end are equal" do
      let(:b) { Block.new(1, 2) }

      it "is equal" do
        a.should eq(b)
      end
    end

    context "when start and end are not equal" do
      let(:b) { Block.new(1, 3) }

      it "is not equal" do
        a.should_not eq(b)
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
        result.first.should eq(a)
      end
    end

    context "when b encompasses a" do

      let(:b)   { Block.new(90, 210) }

      it "returns b" do
        result.first.should eq(b)
      end
    end

    context "when b subsumes a's origin" do

      let(:b)   { Block.new(90, 110) }

      it "returns one block begins with b and ends with a" do
        result.first.top.should eq(b.top)
        result.first.bottom.should eq(a.bottom)
      end
      
      it "begins with b" do
        result.first.top.should eq(b.top)
      end
      
      it "ends with a" do
        result.first.bottom.should eq(a.bottom)
      end
    end
    
    context "when b subsumes a's ending" do
      
      let(:b)   { Block.new(190, 210) }
      
      it "returns one block begins with a and ends with b" do
        result.first.top.should eq(a.top)
        result.first.bottom.should eq(b.bottom)
      end
      
      it "begins with a" do
        result.first.top.should eq(a.top)
      end
      
      it "ends with b" do
        result.first.bottom.should eq(b.bottom)
      end
    end
    
    context "when there is no overlap" do
      
      let(:b)   { Block.new(10, 20) }
      
      it "returns the original blocks" do
        result.first.should eq(b)
        result.last.should eq(a)
      end
    end
    
    context "when a == b" do
      
      let(:b)  { Block.new(a.start, a.end) }
      
      it "only returns a" do
        result.first.should eq(a)
        result.last.should eq(a)
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
        subject.top.should eq(a.start - top)
      }
      its(:end)    { 
        subject.bottom.should eq(a.bottom + bottom)
      }
    end
    
    context "with negative value padding (-10, -20)" do
      let(:top)    { -10 }
      let(:bottom) { -20 }
      its(:start)  { 
        subject.top.should eq(a.start)
      }
      its(:end)    { 
        subject.bottom.should eq(a.bottom)
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
        result.count.should eq(2)
      end
      
      describe "first block" do
        it "begins at the original point" do
          result.first.top.should eq(a.top)
        end
        
        it "ends at the start of b" do
          result.first.bottom.should eq(b.top)
        end
      end
      
      describe "second block" do
        it "begins at the end of b" do
          result.last.top.should eq(b.bottom)
        end
        
        it "ends at the original point" do
          result.last.bottom.should eq(a.bottom)
        end
      end
    end
    
    context "when b encompasses a" do
      let(:b) { Block.new(90, 210) }
      
      it "returns a nil block" do
        result.should eq([])
      end
    end
    
    context "when b covers a with a shared beginning" do
      let(:b) { Block.new(a.start, a.end + 10) }
      it "returns a nil block" do
        result.should eq([])
      end
    end
    
    context "when b covers a with a shared ending" do
      let(:b) { Block.new(a.start - 10, a.end) }
      it "returns a nil block" do
        result.should eq([])
      end
    end

    context "when b encompasses a's origin" do

      let(:b) { Block.new(a.start, a.start + 10) }
      
      it "returns a single block" do
        result.count.should eq(1)
      end
      
      it "begins at the end of b" do
        result.first.top.should eq(b.bottom)
      end
      
      it "ends at the original point" do
        result.first.bottom.should eq(a.bottom)
      end
    end

    context "when b encompasses a's ending" do
      
      let(:b) { Block.new(190, 200) }
      
      it "returns a single block" do
        result.count.should eq(1)
      end
      
      it "begins at the original point" do
        result.first.top.should eq(a.top)
      end
      
      it "ends at the start of b" do
        result.first.bottom.should eq(b.top)
      end
    end
    
    context "when there is no overlap" do
      let(:b) { Block.new(0, 100) }

      it "returns self" do
        result.first.should eq(a)
      end
    end
    
    context "when b == a" do
      let(:b) { Block.new(a.start, a.end) }

      it "returns empty" do
        result.should eq([])
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
      result.count.should eq(2)
    end
    
    describe "first block" do
      it "starts where b ended" do
        result.first.top.should eq (b.bottom)
      end
      
      it "ends where c starts" do
        result.first.bottom.should eq (c.top)
      end
    end
    
    describe "second block" do
      it "starts where c ended" do
        result.last.top.should eq (c.bottom)
      end
      
      it "ends where d starts" do
        result.last.bottom.should eq (d.top)
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
      result.count.should eq(3)
    end
    
    describe "first block (collapsed contiguous)" do
      it "start aligns with start of A" do
        result.first.top.should eq (a.top)
      end
      
      it "end aligns with end of B" do
        result.first.bottom.should eq (b.bottom)
      end
    end
    
    describe "second block (collapsed overlapping)" do
      it "start aligns with start of C" do
        result[1].top.should eq (c.top)
      end
      
      it "end aligns with end of D" do
        result[1].bottom.should eq (d.bottom)
      end
    end
    
    describe "third block (isolated)" do
      it "starts as it was" do
        result.last.top.should eq(e.top)
      end
      
      it "ends as it was" do
        result.last.bottom.should eq(e.bottom)
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

      it "keeps the max top" do
        result.top.should eq (b.top)
      end
      
      it "keeps the min bottom" do
        result.bottom.should eq (a.bottom)
      end
    end
    
    context "when the limited block overlaps with the limiter's end" do
      let(:a) { Block.new(90, 110) }
      
      it "trims the bottom of the block to the limiter's end" do
        result.bottom.should eq (b.bottom)
      end
      
      it "keeps the original beginning" do
        result.top.should eq (a.top)
      end
    end

  end

end
