// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
//pragma abicoder v2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol"; 

contract AtosNFT is ERC721, ERC721Enumerable, Ownable {
    using Counters for Counters.Counter;
    using Strings for uint256;

    Counters.Counter private _tokenIdCounter;
    uint128 public constant PRICE = 1 ether;
    uint128 public constant MAX_SUPPLY = 100;

    constructor() ERC721("web3builders", "W3B") {
    }

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://QmTu5YUToSxhubGY4yQKtSr76M3osKTF92GSfFMU2Xva9n/";
    }

    function safeMint() public payable {
        require(totalSupply() <= MAX_SUPPLY, "no NFT left for you, sorry!"); //total supply of tokens have already been minted so far
        (bool success, ) = payable(msg.sender).call{value: PRICE}("please pay the exact mint price");
        require(success);
        uint256 tokenId = _tokenIdCounter.current(); //adding extra logic to the basic _safeMint () in the OpenZeppelin library
        _tokenIdCounter.increment();
        _safeMint(msg.sender, tokenId);
    }

    function withdraw(address _addr) external onlyOwner {
        payable(_addr).transfer(address(this).balance);
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        _requireMinted(tokenId);
        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
    }

}