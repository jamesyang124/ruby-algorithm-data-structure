# http://www.sanfoundry.com/cpp-program-implement-circular-queue/
# test: ./spec/circular_queue_spec.rb

# algorithm:
# init: @front, @rear = -1
# @front or @rear hit n - 1 => reset to 0
#
# enq:
#       (front == 0 and rear == n - 1)
#               or (front == rear + 1) => full
#       (front == -1) => front, rear = 0
# deq:
#       (front == -1) => empty
#       (front == rear) => front, rear = -1
#
# reset front or rear by:
# @front = (@front + 1) mod n
#

class CircularQueue

  attr_reader :size, :front, :rear

  def initialize(n)
    @queue = []
    @size = n <= 0 ? 0 : n
    @front, @rear = 0, 0
  end

  def enqueue(item)
    return if size == 0

    if (front == 1 && rear == size) or (front == rear + 1)
      #puts "Queue is overflow"
      return
    end

    self.front += 1 if front == 0 and rear == 0
    self.rear = (rear == size) ? 1 : rear + 1

    queue[rear - 1] = item

    #puts "Enqueue Front: #{front}"
    #puts "Enqueue Rear: #{rear}"
    #p queue
  end

  def dequeue
    if front == 0
      #puts "Queue is empty"
      return
    end

    item = queue[front - 1]
    if front == rear
      self.front = 0
      self.rear = 0
    else
      if front == size
        self.front = 1
      else
        self.front += 1
      end
    end

    #puts "Dequeue Front: #{front}"
    #puts "Dequeue Rear: #{rear}"
    #p queue

    return item
  end

private

  def queue
    @queue
  end

  def front=(index)
    @front = index
  end

  def rear=(index)
    @rear = index
  end
end

class CircularQueueRewrite

  attr_reader :front, :rear, :size

  def initialize(n)
    @queue = []
    @size = n
    @front, @rear = -1, -1
  end

  def enqueue(item)
    if (front == 0 and rear == size - 1) || (front == rear + 1)
      puts "Queue is overflow"
      return
    end

    if front == -1
      self.front = 0
      self.rear = 0
    else
      if rear == size - 1
        self.rear = 0
      else
        self.rear += 1
      end
    end

    queue[rear] = item

    puts "Enqueue Front: #{front}"
    puts "Enqueue Rear: #{rear}"
    p queue
  end

  def dequeue
    if front == -1
      puts "Queue is empty"
      return
    end

    item = queue[front]

    if front == rear
      self.front = -1
      self.rear = -1
    else
      if front == size - 1
        self.front = 0
      else
        self.front += 1
      end
    end

    return item
  end

private

  def queue
    @queue
  end

  def front=(index)
    @front = index
  end

  def rear=(index)
    @rear = index
  end
end