
class SimpleHash

  def initialize
    @table = []
    @bins = []
  end

  def push(k, v)
    id = convertion k
    !@bins[id].nil? ? @bins[id] << v : @bins[id] = [k, v]
    @table << k
    @table.uniq!
  end

  def convertion(k)
    k.hash % 1000
  end

  def pop(k)
    id = convertion k
    if @bin[id].size > 2
      @bin[id].pop
    else
      @bin[id] = nil      
    end
  end

  def has_key?(k)
    !@bins[convertion(k)].nil?
  end

  def to_s
    str = ""
    @table.each do |k|
      id = convertion k
      str += "Key: #{k} Value: #{@bins[id][1..-1]}\n"
    end
    str
  end
end

hash = SimpleHash.new
hash.push(5, 100)
p hash.has_key?(5)
p hash.has_key?(8)

hash.push(5, 300)
hash.push(8, 30)
p hash.has_key?(8)

puts "#{hash}"