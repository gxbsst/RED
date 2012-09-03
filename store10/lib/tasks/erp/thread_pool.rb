class ERP::ThreadPool
  
  attr_reader :queue
  
  def initialize( threads = 5, queue = [] )
    @threads_count = threads
    @queue = Queue.new
    queue.each { |resource| @queue << resource }
  end
  
  # Start all the thread in current pool.
  def start
    @threads = (1..@threads_count).map do |i|
      Thread.new("Thread \##{i}") do |thread_name|
        sleep( i * rand )
        loop do
          break if @queue.empty?
          yield @queue.pop
        end
      end
    end
    
    @threads.each do |thread|
      thread.join
    end
  end
  
end