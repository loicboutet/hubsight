class Mockups::ExportsController < ApplicationController
  def contracts
    # Handle contracts export
    send_data "contracts export", filename: "contracts.csv"
  end

  def equipment
    # Handle equipment export
    send_data "equipment export", filename: "equipment.csv"
  end

  def sites
    # Handle sites export
    send_data "sites export", filename: "sites.csv"
  end
end
