const Ricer = artifacts.require('Ricer');

contract('Ricer', async accounts => {
  let ricer;
  beforeEach(async () => {
    ricer = await Ricer.deployed();
  });

  it('should deploy ricer instance', async () => {
    let address = await ricer.address;
    assert.notEqual(address, '0x0', 'ricer is not at zero address');
    assert.notEqual(address, null, 'address is not null');
    assert.notEqual(address, 'undefined', 'address is not undefined');
  });

  it('mintToken() should mint a new token', async () => {
    let mintedToken = await ricer.mintToken(accounts[0], 'no data', {from: accounts[0]});
    let tokenId = mintedToken.logs[0].args.tokenId.toString();
    assert.equal(tokenId, '1', 'tokenId is 1');
  });
});
