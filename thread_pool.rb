# pool = ThreadPool.new(size: 5)
# pool.schedule { do_work }
# pool.shutdown

class ThreadPool
	attr_reader :pool, :jobs, :size

	def initialize(size:)
		@size = size
		@jobs = Queue.new
		@pool = Array.new(size) do
			Thread.new do
				catch(:exit) do
					loop do
						job, args = jobs.pop
						job.call(*args)
					end
				end
			end
		end		
	end

	def schedule(*args, &block)
		@jobs << [block, args]
	end

	def shutdown
		size.times do
			schedule { throw :exit }
		end
		
		@pool.map(&:join)
	end
end
