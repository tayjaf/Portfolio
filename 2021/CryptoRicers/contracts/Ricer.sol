//SPDX-License-Identifier: MIT;
pragma solidity ^0.7.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Ricer is ERC721{
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  constructor() ERC721("Ricer", "RCR") {
    setBaseURI('ipfs://');
  }

  function mintToken(address racer, string memory rcrMetadata) public returns (uint256){
    _tokenIds.increment();

    uint256 id = _tokenIds.current();
    _safeMint(racer, id);
    _setTokenURI(id, rcrMetadata);

    return id;
  }
}
