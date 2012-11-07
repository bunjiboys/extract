#

SUPPORTED_TYPES = ['tar.gz', 'tgz', 'tar', 'tar.bz2', 'tbz', 'tbz2', 'zip']

action :extract do

   archive = @new_resource.filename
   clobber = @new_resource.clobber
   filetype = nil

   path, sep, filename = archive.rpartition(::File::SEPARATOR)
   
   unless ::File.exists?(archive)
      raise "The archive does not exist: #{archive}"
   end

   unless @new_resource.target.nil?
      unless ::File::directory?(@new_resource.target)
         raise "The target folder does not exist: #{@new_resource.target}"
      end
   end

   SUPPORTED_TYPES.each do |type|
      if filename[/#{type}$/i]
         filetype = type
         break
      end
   end

   if not filetype
      raise "Unsupported filetype for #{filename}"
   end

   if ['tar.gz', 'tgz'].include?(filetype)
      extract_tar(archive, path, true, false)

   elsif ['tar.bz2', 'tbz', 'tbz2'].include?(filetype)
   elsif filetype == "tar"
      extract_tar(archive, path, false, false)

   elsif filetype == "zip"
      extract_zip(archive, path)
   end
end

private

def extract_tar(filename, target, isGz, isBz)
   options = [ "-x" ]
   
   if isGz
      options.push("-z")
   elsif isBz
      options.push("-j")
   end

   if @new_resource.target.nil?
      options.push("-C #{target}")
   else
      options.push("-C #{@new_resource.target}")
   end

   options.push("-f #{filename}")
   opts = options.join(' ')

   Chef::Log.info("Running command: tar #{opts}")
   execute "Extracting archive" do
      command "tar #{opts}"
   end
end

def extract_zip(filename, target)
   options = [ ]
   
   if @new_resource.target.nil?
      options.push("-d #{target}")
   else
      options.push("-d #{@new_resource.target}")
   end

   if @new_resource.clobber
      options.push("-o")
   end

   options.push("#{filename}")
   opts = options.join(' ')

   Chef::Log.info("Running command: unzip #{opts}")
   execute "Extracting archive" do
      command "unzip #{opts}"
   end
end
