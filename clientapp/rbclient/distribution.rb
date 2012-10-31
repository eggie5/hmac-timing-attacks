class Distribution < Hash
  def [](k)
    unless self.key?(k)
      self[k]=[]
    end
    self.fetch(k)
  end
  
  def sorted_avg
    h={}
    self.each do |k,v|
      h[k]=v.mean
    end
    
    h.sort_by{|k,v| v }
  end
end

class Numeric
  def square ; self * self ; end
end

class Array
  def sum ; self.inject(0){|a,x|x+a} ; end
  def mean ; self.sum.to_f/self.size ; end
  def median
    case self.size % 2
      when 0 then self.sort[self.size/2-1,2].mean
      when 1 then self.sort[self.size/2].to_f
    end if self.size > 0
  end
  def histogram ; self.sort.inject({}){|a,x|a[x]=a[x].to_i+1;a} ; end
  def mode
    map = self.histogram
    max = map.values.max
    map.keys.select{|x|map[x]==max}
  end
  def squares ; self.inject(0){|a,x|x.square+a} ; end
  def variance ; self.squares.to_f/self.size - self.mean.square; end
  def deviation ; Math::sqrt( self.variance ) ; end
  def permute ; self.dup.permute! ; end
  def permute!
    (1...self.size).each do |i| ; j=rand(i+1)
      self[i],self[j] = self[j],self[i] if i!=j
    end;self
  end
  def sample n=1 ; (0...n).collect{ self[rand(self.size)] } ; end
end

#d=Distribution.new
# 
# d['a'].push 1
# d['a'].push 3
# d['3'].push 4
# 
# p d['a']
# p d['3']
# 
# p d.sorted_avg