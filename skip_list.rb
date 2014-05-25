class SkipNode
  attr_accessor :next_node, :key

  def initialize(key)
    @key = key
    @next_node = nil
  end
end

class SkipList
  attr_accessor :list
  
  def initialize(key)
    @list ||= [].push [SkipNode.new(key)]
  end

  def insert(key)
    level = random_level
    size = @list.size
    if level > size
      add_in_each_level(size, key)
      @list.push([SkipNode.new(key)])
    else
      add_in_each_level level, key
    end
  end

  def delete(key)
    location = search key
    level = location[0]
    index = location[1]

    level.downto(0) do |i|
      @list[i].each.with_index do |e, id|
        if e.key == key
          index = id
          break
        end
      end
      @list[i].delete_at(index)
    end
  end

  def search(key)
    levels = @list.size - 1
    level_num = nil
    index = nil
    levels.downto(0) do |i| 
      level_size = @list[i].size
      level_size.times do |s|
        if @list[i][s].key == key 
            level_num = i
            index = s
            break
        end
      end
      break if level_num
    end
    puts "#{level_num ? "Found" : "Not found"} #{key}, at level #{level_num ? level_num + 1 : nil}, index #{index}"
    return level_num, index
  end

  def print_list
    @list.each.with_index do |l, i|
      puts "In level #{i + 1}:"
      str = ""
      l.each do |e|
        str << "#{e.key}#{e == l.last ? "." : ", "}"
      end
      puts str
    end
  end

private

  def random_level   
    l = 1
    while Random.rand(2) > 0
      l += 1
    end
    return l
  end

  def add_in_each_level(level, key)
    level.times do |i|
      get_index = nil
      @list[i].each.with_index do |e, d|
        if e.key > key
          get_index = d
          break
        end
      end

      if get_index == nil
        @list[i].push(SkipNode.new(key))
      else
        @list[i].insert(get_index, SkipNode.new(key))
      end
    end
  end
end