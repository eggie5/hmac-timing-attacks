require 'test/unit'

def strings_are_equal?(str1, str2)
  _s1=str1.scan(/./)
  _s2=str2.scan(/./)
  # not valid if lengths are different
  return false unless (_s1.length == _s2.length)

  # check each character
  _s1.each_index do |i|
    unless (str1[i] == str2[i])
      puts "short circuiting @ #{i}- #{str1}!=#{str2}"
      return false 
    end
    puts "matched at index #{i}"
  end

  # yay
  true
end


class TestStringsAreEqual < Test::Unit::TestCase
 
  def test_strings_are_equal
    assert(strings_are_equal?("aaaa", "aaaa"))
  end
 
end


