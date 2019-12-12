# frozen_string_literal: true

class Fingerprint < ActiveRecord::Base
  belongs_to :user

  def self.matches
    select(
      :name,
      :value,
      'ARRAY_AGG(user_id ORDER BY user_id) user_ids'
    )
      .group(:value, :name)
      .having('COUNT(*) > 1')
  end

  def self.create_or_touch!(attributes)
    if fingerprint = Fingerprint.find_by(attributes.slice(:user, :user_id, :value))
      fingerprint.touch
      return fingerprint
    end

    create!(attributes)
  end
end

# == Schema Information
#
# Table name: fingerprints
#
#  id         :bigint           not null, primary key
#  user_id    :integer          not null
#  name       :string           not null
#  value      :string           not null
#  data       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_fingerprints_on_user_id  (user_id)
#  index_fingerprints_on_value    (value)
#