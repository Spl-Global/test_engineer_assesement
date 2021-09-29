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
        expect(block.top).to eq(1)
      end

      it "creates the block with the specified bottom" do
        expect(block.bottom).to eq(2)
      end
    end

    context "when the end is less than the beginning" do
      let(:block) { Block.new(2,1) }
      it "creates the block with the inverse start" do
        expect(block.top).to eq(1)
      end

      it "creates the block with the inverse end" do
        expect(block.bottom).to eq(2)
      end
    end
  end

  # ===========
  # = #length =
  # ===========

  describe '#length' do
    it 'is 0 when start == end' do
      block = Block.new(2, 2)
      expect(block.length).to eq(0)
    end

    it 'is 1 when end == (start + 1)' do
      block = Block.new(1, 2)
      expect(block.length).to eq(1)
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
        expect(a).to eq(b)
      end
    end

    context "when start and end are not equal" do
      let(:b) { Block.new(1,3) }

      it "is not equal" do
        expect(a).not_to eq(b)
      end
    end
  end

  describe "spaceship" do
    let(:a) { Block.new(2,4) }

    context "when both a start and end are bigger than b" do
      let(:b) { Block.new(1,2) }

      it "returns 1" do
        expect(a <=> b).to eq(1)
      end
    end

    context "when both a start and end are smaller than b" do
      let(:b) { Block.new(3,4) }

      it "returns -1" do
        expect(a <=> b).to eq(-1)
      end
    end

    context "when both a start and end are equal than b" do
      let(:b) { Block.new(2,4) }

      it "returns 0" do
        expect(a <=> b).to eq(0)
      end
    end
  end

  describe "inclusion" do
    let(:a) { Block.new(2,6) }

    context "when number stay between start and end" do
      it "is included" do
        expect(a).to include(3)
      end
    end

    context "when number out of start and end" do
      it "is not included" do
        expect(a).not_to include(8)
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
        expect(result).to contain_exactly(a)
      end
    end

    context "when b encompasses a" do

      let(:b)   { Block.new(90, 210) }

      it "returns b" do
        expect(result).to contain_exactly(b)
      end
    end

    context "when b subsumes a's origin" do

      let(:b)   { Block.new(90, 110) }

      it "returns one block" do
        expect(result.size).to eq(1)
      end

      it "begins with b" do
        expect(result.first).to have_attributes(start: b.start)
      end

      it "ends with a" do
        expect(result.first).to have_attributes(end: a.end)
      end
    end

    context "when b subsumes a's ending" do

      let(:b)   { Block.new(190, 210) }

      it "returns one block" do
        expect(result.size).to eq(1)
      end

      it "begins with a" do
        expect(result.first).to have_attributes(start: a.start)
      end

      it "ends with b" do
        expect(result.first).to have_attributes(end: b.end)
      end
    end

    context "when there is no overlap" do

      let(:b)   { Block.new(10, 20) }

      it "returns the original blocks" do
        expect(result).to match_array([b, a])
      end
    end

    context "when a == b" do

      let(:b)  { Block.new(a.start, a.end) }

      it "returns a" do
        expect(result).to contain_exactly(a)
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
      its(:start)  { is_expected.to eq(90) }
      its(:end)    { is_expected.to eq(220) }
    end

    context "with negative value padding (-10, -20)" do
      let(:top)    { -10 }
      let(:bottom) { -20 }
      its(:start)  { is_expected.to eq(100) }
      its(:end)    { is_expected.to eq(200) }
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
        expect(result.size).to eq(2)
      end

      describe "first block" do
        it "begins at the original point" do
          expect(result.first).to have_attributes(start: a.start)
        end

        it "ends at the start of b" do
          expect(result.first).to have_attributes(end: b.start)
        end
      end

      describe "second block" do
        it "begins at the end of b" do
          expect(result[1]).to have_attributes(start: b.end)
        end

        it "ends at the original point" do
          expect(result[1]).to have_attributes(end: a.end)
        end
      end
    end

    context "when b encompasses a" do
      let(:b) { Block.new(90, 210) }

      it "returns a nil block" do
        expect(result.first).to be_nil
      end
    end

    context "when b covers a with a shared beginning" do
      let(:b) { Block.new(a.start, a.end + 10) }
      it "returns a nil block" do
        expect(result.first).to be_nil
      end
    end

    context "when b covers a with a shared ending" do
      let(:b) { Block.new(a.start - 10, a.end) }
      it "returns a nil block" do
        expect(result.first).to be_nil
      end
    end

    context "when b encompasses a's origin" do

      let(:b) { Block.new(a.start, a.start + 10) }

      it "returns a single block" do
        expect(result.size).to eq(1)
      end

      it "begins at the end of b" do
        expect(result.first).to have_attributes(start: b.end)
      end

      it "ends at the original point" do
        expect(result.first).to have_attributes(end: a.end)
      end
    end

    context "when b encompasses a's ending" do

      let(:b) { Block.new(190, 200) }

      it "returns a single block" do
        expect(result.size).to eq(1)
      end

      it "begins at the original point" do
        expect(result.first).to have_attributes(start: a.start)
      end

      it "ends at the start of b" do
        expect(result.first).to have_attributes(end: b.start)
      end
    end

    context "when there is no overlap" do
      let(:b) { Block.new(0, 100) }

      it "returns self" do
        expect(result).to contain_exactly(a)
      end
    end

    context "when b == a" do
      let(:b) { Block.new(a.start, a.end) }

      it "returns empty" do
        expect(result).to be_empty
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
      expect(result).to eq([Block.new(110, 130), Block.new(140, 180)])
    end

    describe "first block" do
      it "starts where b ended" do
        expect(result.first.start).to eq(b.end)
      end

      it "ends where c starts" do
        expect(result.first.end).to eq(c.start)
      end
    end

    describe "second block" do
      it "starts where c ended" do
        expect(result[1].start).to eq(c.end)
      end

      it "ends where d starts" do
        expect(result[1].end).to eq(d.start)
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
      expect(result).to eq([Block.new(10, 25), Block.new(30, 45), Block.new(55, 65)])
    end

    describe "first block (collapsed contiguous)" do
      it "start aligns with start of A" do
        expect(result[0].start).to eq(a.start)
      end

      it "end aligns with end of B" do
        expect(result[0].end).to eq(b.end)
      end
    end

    describe "second block (collapsed overlapping)" do
      it "start aligns with start of C" do
        expect(result[1].start).to eq(c.start)
      end

      it "end aligns with end of D" do
        expect(result[1].end).to eq(d.end)
      end
    end

    describe "third block (isolated)" do
      it "starts as it was" do
        expect(result[2].start).to eq(e.start)
      end

      it "ends as it was" do
        expect(result[2].end).to eq(e.end)
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
        expect(result.top).to eq(0)
      end

      it "keeps the original end" do
        expect(result.end).to eq(a.end)
      end
    end

    context "when the limited block overlaps with the limiter's end" do
      let(:a) { Block.new(90, 110) }

      it "trims the bottom of the block to the limiter's end" do
        expect(result.bottom).to eq(b.end)
      end

      it "keeps the original beginning" do
        expect(result.start).to eq(a.start)
      end
    end

  end

end
