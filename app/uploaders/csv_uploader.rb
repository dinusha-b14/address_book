class CsvUploader < CarrierWave::Uploader::Base
  storage :aws

  def cache_dir
    "#{Rails.root}/tmp/uploads"
  end

  def extension_white_list
    %w(csv)
  end
end
