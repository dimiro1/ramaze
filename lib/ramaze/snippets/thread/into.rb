#          Copyright (c) 2008 Michael Fellinger m.fellinger@gmail.com
# All files in this distribution are subject to the terms of the MIT license.

# Extensions for Thread
class Thread
  # Copy all thread variables into the new thread
  def self.into(*args)
    Thread.new(Thread.current, *args) do |thread, *thread_args|
      thread.keys.each do |k|
        Thread.current[k] = thread[k] unless k.to_s =~ /^__/
      end

      yield(*thread_args)
    end
  end
end # Thread
