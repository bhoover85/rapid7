require 'format_time'

class CalculateTimes
  include FormatTime

  # Sets up environment before scanning parsed json response
  # @file = Raw json file
  # @response = Parsed json file
  # @total_runs = Total number of scans (used for overall avg)
  # @total_elapsed = Total time of all scans (used for overall avg)
  def initialize(file, response)
    @file = file
    @response = response
    @total_runs = 0
    @total_elapsed = 0

    scan_entries
    avg_scan_time
    avg_fastest_longest_scan
    output_results
  end

  # Scans parsed json file and collects run times
  # @run_times = Scans grouped by asset (used for fastest/longest asset avg)
  def scan_entries
    @run_times = Hash.new {|h,k| h[k]=[]}

    puts "Scanning #{@file}"

    @response.each do |response|
      @node_id = response['node_id']
      @ip = response['ip']
      start_time = response['start']
      end_time = response['end']

      # Discard entries that are missing start/end times
      if start_time.empty? | end_time.empty?
        puts "Skipping node_id #{@node_id} - missing start/end time"
        next
      end

      # Discard entries whose end time <= start time
      if end_time <= start_time
        puts "Skipping node_id #{@node_id} - end time (#{end_time}) <= start time (#{start_time})"
        next
      end

      # Calculate elapsed time for this scan
      @elapsed = DateTime.parse(end_time).to_time - DateTime.parse(start_time).to_time

      # Increment run count, track total elapsed time and group times by asset
      @total_runs += 1
      @total_elapsed += @elapsed
      @run_times[@ip] << @elapsed
      
      # Check whether this run had the fastest or longest scan time
      fastest_longest_scan
    end
  end

  # Calculates overall avg scan time for an asset
  def avg_scan_time
    @avg = ((@total_elapsed/@total_runs)/60).round(1)
  end

  # Tracks which assets had the fastest and longest scan time
  def fastest_longest_scan
    if @fastest_time.nil? || @elapsed < @fastest_time
      @fastest_time = @elapsed
      @fastest_asset = @ip
      @fastest_node_id = @node_id
      puts "New fastest time: #{@fastest_node_id} - #{@fastest_asset} (#{@fastest_time} seconds)"
    end

    if @longest_time.nil? || @elapsed > @longest_time
      @longest_time = @elapsed
      @longest_asset = @ip
      @longest_node_id = @node_id
      puts "New longest time: #{@longest_node_id} - #{@longest_asset} (#{@longest_time} seconds)"
    end
  end

  # Tracks which assets had the fastest and longest average scan times
  # Calculates avg time for all runs of a given asset and tracks fastest/longest time
  def avg_fastest_longest_scan
    @run_times.each do |key, array|
      sum = @run_times[key].inject(:+)
      size = @run_times[key].size
      avg = sum/size

      if @avg_fastest_time.nil? || avg < @avg_fastest_time
        @avg_fastest_time = avg
        @avg_fastest_asset = key
        puts "New avg fastest time: #{@avg_fastest_asset} (#{@avg_fastest_time} seconds)"
      end

      if @avg_longest_time.nil? || avg > @avg_longest_time
        @avg_longest_time = avg
        @avg_longest_asset = key
        puts "New avg longest time: #{@avg_longest_asset} (#{@avg_longest_time} seconds)"
      end
    end
  end

  # Outputs results of scan
  # Uses FormatTime module to convert longest times to a more readable format
  def output_results
    @longest_time = FormatTime.time(@longest_time)
    @avg_longest_time = FormatTime.time(@avg_longest_time)

    puts "\nAverage scan time per asset: #{@avg} mins"
    puts "Fastest scan: #{@fastest_node_id} - #{@fastest_asset} (#{@fastest_time} seconds)"
    puts "Longest scan: #{@longest_node_id} - #{@longest_asset} (#{@longest_time})"
    puts "Average fastest scan: #{@avg_fastest_asset} (#{@avg_fastest_time} seconds)"
    puts "Average longest scan: #{@avg_longest_asset} (#{@avg_longest_time})"
  end

end
