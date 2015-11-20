class Photo < ActiveRecord::Base

  belongs_to        :user
  belongs_to        :restaurant
  belongs_to        :stash
  has_one           :photo_pricetag
  has_one           :pricetag, through: :photo_pricetag
  has_many          :foodtags, through: :foodtag_photos
  has_many          :foodtag_photos

  has_attached_file :image,
                    #url: "/system/:hash.:extension",
                    #hash_secret: "abc123",
                    #preserve_files: "true",
                    styles: { thumb: ["64x64#", :jpg],
                              original: ['500x500>', :jpg] },
                    convert_options: { thumb: "-quality 75 -strip",
                                       original: "-quality 85 -strip" },
                    storage: :s3,
                    s3_credentials: {access_key_id: ENV["AWS_KEY"], secret_access_key: ENV["AWS_SECRET"]},
                    bucket: "bodrov_sitepoint"

  validates_attachment :image, presence: true,
                       content_type: { content_type: ["image/jpeg", "image/gif", "image/png"] },
                       size: { in: 0..500.kilobytes }
end
