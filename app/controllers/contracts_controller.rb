# frozen_string_literal: true

class ContractsController < ApplicationController
  def new; end

  def create
    issuer_did = Did.first.short_form

    # brandへ契約リクエストを送る
    json = {
      name: 'tapyrus_issuer',
      did: issuer_did,
    }.to_json
    response = Net::HTTP.post(
    URI('http://localhost:3001/contracts/agreement/issuer'),
    json,
    'Content-Type' => 'application/json'
    )
    body = JSON.parse(response.body)

    # 返答を受け取る
    brand_did_short_form = body['brand_did']
    color_id = body['color_id']
    redeem_script = body['redeem_script']
    script_pubkey = body['script_pubkey']
    contracted_at = body['contracted_at']
    effect_at = body['effect_at']
    expire_at = body['expire_at']

    brand_did = Did.create(short_form: brand_did_short_form)
    contract_with_brand = Contract.create(did: brand_did, redeem_script:, script_pubkey:, brand_did:, issuer_did:, contracted_at:, effect_at:, expire_at:)
    StableCoin.create(contract: contract_with_brand, color_id:)
    redirect_to root_path
  end
end