#!/usr/bin/ruby

# This script recursively generates ctags databases and attempts to split
# them based on the expected size of the repository

########################################
# Defines / constants / what-have-you
########################################

# These would be arrays but we define them as hashes because it's quicker than iterating
# through an array all the time
Valid_Commandline_Params = { '--filecount'=>'', '--outputdir'=>'', '--countonly'=>'',
			     '--verbose'=>'', '-v'=>'' }
Ctags_Parseable_Filetypes = { '.asp'=>'', '.awk'=>'', '.asm'=>'', '.c'=>'', '.cpp'=>'', 
			      '.c++'=>'', '.cxx'=>'', '.h'=>'', '.hpp'=>'', '.hxx'=>'', 
			      '.cs'=>'', '.htm'=>'', '.html'=>'', '.java'=>'', '.js'=>'', 
			      '.lisp'=>'', '.clisp'=>'', '.lua'=>'', '.pl'=>'', 
			      '.php'=>'', '.py'=>'', '.rb'=>'', '.sh'=>'', '.vim'=>'' }


########################
# Methods that do stuff
########################

def ParseCommandlineOpts(valid_options)
	params = {}
	current_param = ''
	extra_params = []
	ARGV.each do |current|
		if current.length > 0 and current[0..0] == '-' then
			unless valid_options.has_key?(current) then
				nil;	return
			end
			current_param = current
			params[current_param] = ''
		else
			if current_param.length == 0 then 
				extra_params.push(current) 
			else 
				params[current_param] = current
				current_param = ''
			end
		end
	end
	[params, extra_params]
end


def CountValidFiles(path, exit_on_value = nil)

	# Iterate through the directory
	file_count = 0
	Dir.open(path).each do |entry|

		next if ['.', '..'].include? entry 
		full_path = File.join(path, entry)

		if File.stat(full_path).file? then
			# If the file extension is in our list, add some to the file count
			if Ctags_Parseable_Filetypes.has_key?(/\..*$/.match(entry).to_s) == true then  
				file_count=file_count+1
			end
		end
		if File.stat(full_path).directory? then
			file_count = file_count + CountValidFiles(full_path, exit_on_value - file_count) if exit_on_value
			file_count = file_count + CountValidFiles(full_path) unless exit_on_value
		end

		# We do this so we don't end up counting files we don't need to
		# in TagFilesInPath
		if exit_on_value != nil and file_count > exit_on_value then
			break
		end
	end
	file_count
end

def TagFilesInPath(root_path, output_dir, max_filecount, verbose)
	
	# If this path is small enough, generate a whole file
	puts 'Counting files in ' + root_path if verbose
	if CountValidFiles(root_path, max_filecount) < max_filecount then
		puts 'Generating tags for %s...' % root_path
		dir_name = File.join(output_dir, /[\\, \/][^\\,\/]*$/.match(root_path).to_s[1..-1])
		cmd = 'ctags -R -f %s %s' % [dir_name, root_path]
		puts cmd if verbose
		system cmd
		return	# Returns result of system call
	end

	# It must've been too big. Split it into subdirectories
	Dir.open(root_path).each do |entry|
		next if ['.', '..'].include? entry 
		full_path = File.join(root_path, entry)
		next unless File.stat(full_path).directory?

		puts "Couldn't index %s!" % full_path unless TagFilesInPath(full_path, output_dir, max_filecount, verbose) == true
	end

	# Ok, now index the individual files in this directory non-recursively
	files = Dir.entries(root_path).delete_if {|x| !File.stat(File.join(root_path, x)).file? or 
						       Ctags_Parseable_Filetypes.has_key?(/\..*$/.match(x).to_s) } 
	if files.length > max_filecount then
		puts '%s is too big to be indexed currently (%d entries)' % [root_path, files.length]
	end
	return unless files.length > 0
	dir_name = File.join(output_dir, /[\\, \/][^\\,\/]*$/.match(root_path).to_s[1..-1])
	cmd = 'ctags -f %s %s' % [File.join(output_dir, dir_name), files.join(' ')]
	puts cmd if verbose
	system cmd
end


########
# Main
########

# (somewhat) global variables
max_filecount = 25000
output_dir = Dir.pwd
verbose = false

# Check our commandline params first
(params, extra_params) = ParseCommandlineOpts(Valid_Commandline_Params)
if params == nil or extra_params == nil or extra_params.length != 1 then
	puts "Usage: generate_ctags.rb /path/to/input [--verbose] [--countonly] [--filecount %d] [--outputdir /path/to/dir]"
	exit
end
verbose = params.has_key? '--verbose'
verbose = params.has_key? '-v'
if params.has_key? '--outputdir' and params['--outputdir'].length > 0 then
	output_dir = params['--outputdir']
end
max_filecount = params['--filecount'].to_i if params.has_key? '--filecount'

# If we're in count-only mode, do it up
if params.has_key? '--countonly' then
	puts 'Number of taggable files in %s: %d' % [extra_params[0], CountValidFiles(extra_params[0])]
	exit
end 

# We're in normal mode, start tagging
TagFilesInPath(extra_params[0], output_dir, max_filecount, verbose)
