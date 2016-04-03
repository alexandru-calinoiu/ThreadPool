# pool = ThreadPool.new(size: 5)
# pool.schedule { do_work }
# pool.shutdown

class ThreadPool
	attr_reader :pool

	def initialize(size:)
		@pool = []
	end

	def schedule(*args, &block)
		@pool << Thread.new { block.call(args) }
	end

	def shutdown
		@pool.map(&:join)
	end
end
