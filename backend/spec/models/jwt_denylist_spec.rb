require 'rails_helper'

RSpec.describe JwtDenylist, type: :model do
  it 'revokes only the matching token identifier' do
    payload = { 'jti' => SecureRandom.uuid, 'exp' => 30.minutes.from_now.to_i }
    expect(described_class.jwt_revoked?(payload, nil)).to be(false)
    described_class.revoke_jwt(payload, nil)
    expect(described_class.jwt_revoked?(payload, nil)).to be(true)
    expect(described_class.jwt_revoked?(payload.merge('jti' => SecureRandom.uuid), nil)).to be(false)
  end
end
