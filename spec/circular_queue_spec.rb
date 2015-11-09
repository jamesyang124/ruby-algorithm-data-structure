require 'spec_helper'
require_relative '../circular_queue'

describe 'CircularQueue' do
  context "Circular queue with zero size." do
    let(:queue) do
      CircularQueue.new 0
    end

    it 'dequeue in empty queue' do
      expect(queue.dequeue).to equal nil
    end

    it 'enqueue in empty queue' do
      expect(queue.enqueue(1)).to equal nil
    end

    it 'sequeutial enqueue' do
      queue.enqueue(1)
      queue.enqueue(2)
      queue.enqueue(3)
      expect(queue.front).to equal 0
      expect(queue.rear).to equal 0
    end
  end

  context "Circular queue with size 1." do
    let(:queue) do
      CircularQueue.new 1
    end

    it 'dequeue in empty queue' do
      expect(queue.dequeue).to equal nil
    end

    it 'enqueue in empty queue' do
      queue.enqueue(1)
      expect(queue.front).to equal 1
      expect(queue.rear).to equal 1
    end

    it 'sequential enqueue' do
      queue.enqueue(1)
      queue.enqueue(2)
      queue.enqueue(3)
      expect(queue.front).to equal 1
      expect(queue.rear).to equal queue.size
    end

    it 'sequential enqueue then sequential dequeue' do
      queue.enqueue(1)
      queue.enqueue(2)
      queue.enqueue(3)
      queue.dequeue
      queue.dequeue
      queue.dequeue
      expect(queue.front).to equal 0
      expect(queue.rear).to equal 0
    end
  end

  context "Circular queue with odd size." do
    let(:queue) do
      CircularQueue.new 5
    end

    it 'dequeue in empty queue' do
      expect(queue.dequeue).to equal nil
    end

    it 'enqueue in empty queue' do
      queue.enqueue(1)
      expect(queue.front).to equal 1
      expect(queue.rear).to equal 1
    end

    it 'sequential enqueue' do
      queue.enqueue(1)
      queue.enqueue(2)
      queue.enqueue(3)
      queue.enqueue(4)
      expect(queue.front).to equal 1
      expect(queue.rear).to equal 4
    end

    it 'over-the-cap sequential enqueue' do
      queue.enqueue(1)
      queue.enqueue(2)
      queue.enqueue(3)
      queue.enqueue(4)
      queue.enqueue(5)
      queue.enqueue(6)
      expect(queue.front).to equal 1
      expect(queue.rear).to equal queue.size
    end

    it 'dequeue in one-element/empty queue after sequential enqueue' do
      queue.enqueue(1)
      queue.enqueue(2)
      queue.enqueue(3)
      queue.enqueue(4)
      queue.enqueue(5)
      queue.dequeue
      queue.dequeue
      queue.dequeue
      queue.dequeue
      queue.dequeue
      expect(queue.front).to equal 0
      expect(queue.rear).to equal 0

      queue.dequeue
      expect(queue.front).to equal 0
      expect(queue.rear).to equal 0
    end

    it 'enqueue in empty queue after sequential dequeue' do
      queue.dequeue
      queue.dequeue
      queue.dequeue
      queue.dequeue
      queue.dequeue
      queue.enqueue(1)
      queue.enqueue(2)
      queue.enqueue(3)
      queue.enqueue(4)
      queue.enqueue(5)
      expect(queue.front).to equal 1
      expect(queue.rear).to equal 5

      queue.enqueue(6)
      expect(queue.front).to equal 1
      expect(queue.rear).to equal queue.size
    end

    it 'sequential enqueue then interfered by sequential dequeue' do
      queue.enqueue(1)
      queue.enqueue(2)
      queue.enqueue(3)
      queue.enqueue(4)
      queue.enqueue(5)
      expect(queue.front).to equal 1
      expect(queue.rear).to equal 5

      queue.dequeue
      queue.enqueue(6)
      expect(queue.front).to equal 2
      expect(queue.rear).to equal 1

      queue.enqueue(7)
      expect(queue.front).to equal 2
      expect(queue.rear).to equal 1

      queue.dequeue
      queue.dequeue
      queue.enqueue(8)
      expect(queue.front).to equal 4
      expect(queue.rear).to equal 2

      queue.dequeue
      queue.dequeue
      queue.enqueue(9)
      expect(queue.front).to equal 1
      expect(queue.rear).to equal 3

      queue.dequeue
      queue.dequeue
      expect(queue.front).to equal 3
      expect(queue.rear).to equal 3

      queue.dequeue
      expect(queue.front).to equal 0
      expect(queue.rear).to equal 0

      queue.dequeue
      expect(queue.front).to equal 0
      expect(queue.rear).to equal 0
    end
  end

  context "Circular queue with even size." do
    let(:queue) do
      CircularQueue.new 4
    end

    it 'dequeue in empty queue' do
      expect(queue.dequeue).to equal nil
    end

    it 'enqueue in empty queue' do
      queue.enqueue(1)
      expect(queue.front).to equal 1
      expect(queue.rear).to equal 1
    end

    it 'sequential enqueue' do
      queue.enqueue(1)
      queue.enqueue(2)
      queue.enqueue(3)
      queue.enqueue(4)
      expect(queue.front).to equal 1
      expect(queue.rear).to equal 4
    end

    it 'over-the-cap sequential enqueue' do
      queue.enqueue(1)
      queue.enqueue(2)
      queue.enqueue(3)
      queue.enqueue(4)
      queue.enqueue(5)
      queue.enqueue(6)
      expect(queue.front).to equal 1
      expect(queue.rear).to equal queue.size
    end

    it 'dequeue in one-element/empty queue after sequential enqueue' do
      queue.enqueue(1)
      queue.enqueue(2)
      queue.enqueue(3)
      queue.enqueue(4)
      queue.enqueue(5)
      queue.dequeue
      queue.dequeue
      queue.dequeue
      queue.dequeue
      expect(queue.front).to equal 0
      expect(queue.rear).to equal 0

      queue.dequeue
      expect(queue.front).to equal 0
      expect(queue.rear).to equal 0
    end

    it 'enqueue in empty queue after sequential dequeue' do
      queue.dequeue
      queue.dequeue
      queue.dequeue
      queue.dequeue
      queue.dequeue
      queue.enqueue(1)
      queue.enqueue(2)
      queue.enqueue(3)
      queue.enqueue(4)
      expect(queue.front).to equal 1
      expect(queue.rear).to equal 4

      queue.enqueue(5)
      expect(queue.front).to equal 1
      expect(queue.rear).to equal queue.size
    end

    it 'sequential enqueue then interfered by sequential dequeue' do
      queue.enqueue(1)
      queue.enqueue(2)
      queue.enqueue(3)
      queue.enqueue(4)
      queue.enqueue(5)
      expect(queue.front).to equal 1
      expect(queue.rear).to equal 4

      queue.dequeue
      queue.enqueue(6)
      expect(queue.front).to equal 2
      expect(queue.rear).to equal 1

      queue.enqueue(7)
      expect(queue.front).to equal 2
      expect(queue.rear).to equal 1

      queue.dequeue
      queue.dequeue
      queue.enqueue(8)
      expect(queue.front).to equal 4
      expect(queue.rear).to equal 2

      queue.enqueue(9)
      queue.enqueue(10)
      expect(queue.front).to equal 4
      expect(queue.rear).to equal 3
    end
  end
end