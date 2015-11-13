module TestHelpers
  def stub_env_var(name, value)
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with(name.to_s.upcase).and_return value.to_s
  end
end
