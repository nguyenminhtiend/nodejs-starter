const { expect } = require('chai');

const { DISABLE_AUTH, DB_ENGINE } = process.env;
describe('#Run sample test()', () => {
  console.log(`DISABLE_AUTH:${DISABLE_AUTH}`);
  console.log(`DB_ENGINE:${DB_ENGINE}`);
  // test a functionality
  it('Should be true', () => {
    expect(2).to.equal(2);
  });
  it('Should be true 4', () => {
    expect(4).to.equal(4);
  });
});
