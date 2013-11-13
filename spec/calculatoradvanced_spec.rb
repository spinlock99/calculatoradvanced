require 'spec_helper'
require 'calculatoradvanced'

describe Calculatoradvanced do
  describe "#initialize" do
    it "instantiates" do
      expect {
        Calculatoradvanced.new
      }.to_not raise_exception
    end
  end
end
