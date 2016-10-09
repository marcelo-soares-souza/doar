class Projeto < ApplicationRecord
  belongs_to :entidade

  has_attached_file :imagem, styles: { medium: "580x360>", thumb: "150x150>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :imagem, content_type: /\Aimage\/.*\z/
end
