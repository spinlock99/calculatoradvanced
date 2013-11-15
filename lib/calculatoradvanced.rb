class Calculatoradvanced
  attr_reader :expr

  def expr=(expression='')
    set_expr_and_delimeters(expression)
    validate_expression
    set_values
    validate_values
  end

  alias_method :initialize, :expr=

  def method_missing(meth, *args, &block)
    case meth
    when :add
      @values.inject(:+)
    when :diff
      @values.inject(:-)
    when :prod
      @values.inject(:*)
    when :div
      @values.inject(:/)
    else
      super
    end
  end

  private

  def set_expr_and_delimeters(expression)
    @delimiters = [",", "\n"]

    # check if we have any user defined delimiters
    if match = expression.match(/\/\/([^\n]*)\n(.*)/m)
      @expr = match.captures[1]
      @delimiters << match.captures[0].split(/[\[\]]/).reject! { |delimiter| delimiter == '' }
      @delimiters.flatten!
    else
      @expr = expression
    end
  end

  def validate_expression
    @delimiters.permutation(2).to_a.each do |permutation|
      if @expr =~ /#{Regexp.escape(permutation.join)}/
        raise "Consecutive Delimiters"
      end
    end
  end

  def set_values
    @values = @expr.split(/[#{Regexp.escape(@delimiters.join)}]/).map(&:to_i)
  end

  def validate_values
    @negatives = @values.select { |value| value < 0 }
    if @negatives.any?
      raise "negatives not allowed: #{@negatives.join(', ')}"
    end
  end
end
