shared_examples_for "API Successful request" do
  it 'returns 200 status code' do
    expect(response).to be_successful
  end
end