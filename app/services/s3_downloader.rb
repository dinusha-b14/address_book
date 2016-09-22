class S3Downloader
  attr_accessor :s3_file, :destination_file_path

  def initialize(s3_file, destination_file_path)
    @s3_file = s3_file
    @destination_file_path = destination_file_path
  end

  def download
    file_saved = File.open(destination_file_path, 'wb') do |file|
      file.write(s3_file.read)
    end

    return nil unless file_saved
    destination_file_path
  end
end
