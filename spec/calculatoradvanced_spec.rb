require 'spec_helper'
require 'calculatoradvanced'

describe Calculatoradvanced do
  subject(:calc) { Calculatoradvanced.new(expression) }
  context 'with an empty expression' do
    let(:expression) { '' }
    specify { expect { calc }.to_not raise_exception }
  end
  context 'with expression "1\n2\n3"' do
    let(:expression) { "1\n2\n3" }

    specify { expect { calc }.to_not raise_exception }
    its(:add) { should eq(6) }
  end
  context 'with expression "2,3\n4"' do
    let(:expression) { "2,3\n4" }

    its(:add) { should eq(9) }
    its(:expr) { should eq("2,3\n4") }
  end
  context 'with expression "1,\n2"' do
    let(:expression) { "1,\n2" }

    specify { expect { calc.add }.to raise_exception }
  end
  context 'with expression "1\n,2"' do
    let(:expression) { "1\n,2" }

    specify { expect { calc.add }.to raise_exception }
  end
  shared_examples_for 'expression validation' do
    specify { expect { method }.to raise_exception(RuntimeError, /negatives not allowed/) }
    specify { expect { method }.to raise_exception(RuntimeError, /-1, -2, -3/) }
  end
  context 'with expression "-1,-2\n-3"' do
    let(:expression) { "-1,-2\n-3" }
    context '.add' do
      let(:method) { calc.add }

      it_behaves_like 'expression validation'
    end
    context '.diff' do
      let(:method) { calc.diff }
      it_behaves_like 'expression validation'
    end
    context '.prod' do
      let(:method) { calc.prod }
      it_behaves_like 'expression validation'
    end
  end
  context 'with expression "//[;]\n1;2"' do
    let(:expression) { "//[;]\n1;2" }

    its(:add) { should eq(3) }
  end
  context 'with expression "//[;]\n2;1"' do
    let(:expression) { "//[;]\n2;1" }
    its(:diff) { should eq(1) }
    its(:prod) { should eq(2) }
  end
  context 'with expression "//[;]\n3;2"' do
    let(:expression) { "//[;]\n3;2" }

    its(:div) { should eq(1) }
  end
  context 'with expression "//[*][;]\n1*2;3"' do
    let(:expression) { "//[*][;]\n1*2;3" }
    its(:add)  { should eq(6)  }
    its(:diff) { should eq(-4) }
    its(:prod) { should eq(6)  }
    its(:div)  { should eq(0)  }
  end
  context 'with expression "//[*][;][#]\n5*4;3#2"' do
    let(:expression) { "//[*][;][#]\n5*4;3#2" }
    its(:diff) { should eq(-4) }
  end
  context 'with expression "//[#][;][*]\n1*2#3;4,5\n6"' do
    let(:expression) { "//[#][;][*]\n1*2#3;4,5\n6" }
    its(:add) { should eq(21) }
  end
  context 'with expression "//[#]\n1,#2#3"' do
    let(:expression) { "//[#]\n1,#2#3" }
    specify { expect { calc }.to raise_error(/Consecutive Delimiters/)  }
  end
  context 'with expression "//[;]\n1;2;\n3"' do
    let(:expression) { "//[;]\n1;2;\n3" }
    specify { expect { calc }.to raise_error(/Consecutive Delimiters/) }
  end
end
