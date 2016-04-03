require 'minitest/autorun'
require 'minitest/pride'

require_relative './thread_pool'

class TestThreadPool < Minitest::Test
	def test_basic_usage
		pool_size = 5
		pool = ThreadPool.new(size: pool_size)

		mutex = Mutex.new

		iterations = pool_size * 3
		results = Array.new(iterations)

		iterations.times do |i|
			pool.schedule do
				mutex.synchronize do
					results[i] = i + 1
				end
			end
		end
		pool.shutdown

		assert_equal(1.upto(iterations).to_a, results)
	end

	def test_time_taken
		pool_size = 5
		pool = ThreadPool.new(size: pool_size)
		elapsed = time_taken do
			pool_size.times do
				pool.schedule { sleep 1 }
			end
			pool.shutdown
		end

		assert_operator 4.5, :>, elapsed, 'Elapsed time was to long %.1f seconds' % elapsed
	end

	def time_taken
		now = Time.now.to_f
		yield
		Time.now.to_f - now
	end
end
