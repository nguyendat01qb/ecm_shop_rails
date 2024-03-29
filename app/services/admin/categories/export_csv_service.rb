require 'csv'

class Admin::Categories::ExportCsvService < ApplicationService
  def initialize(objects, attributes)
    @attributes = attributes
    @objects = objects
    @header = attributes.map { |attr| I18n.t("category_header_csv.#{attr}") }
  end

  def perform
    CSV.generate do |csv|
      csv << header
      objects.each do |object|
        csv << attributes.map { |attr| object.public_send(attr) }
      end
    end
  end

  private

  attr_reader :attributes, :objects, :header
end
