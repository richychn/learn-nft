// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.0;


import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

// We need to import the helper functions from the contract that we copy/pasted.
import { Base64 } from "./libraries/Base64.sol";

contract MyEpicNFT is ERC721URIStorage {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;
  uint256 private _maxTokens = 4;

  string[] images = ["https://scontent-bos3-1.cdninstagram.com/v/t51.2885-15/e35/s1080x1080/272839627_706756147366425_6394671552451317214_n.jpg?_nc_ht=scontent-bos3-1.cdninstagram.com&_nc_cat=109&_nc_ohc=kd33eEmW5QwAX_5GcTz&edm=ALQROFkBAAAA&ccb=7-4&ig_cache_key=Mjc2MjM3MTQwODY1NjYzNTMxMg%3D%3D.2-ccb7-4&oh=00_AT8bJ5R9yoEfUUgmu-N-6MqbHoA9odFW6M0HkF7ZLFbPZg&oe=61FD7A65&_nc_sid=30a2ef",
                     "https://scontent-bos3-1.cdninstagram.com/v/t51.2885-15/e35/s1080x1080/272253623_136912812130260_8528790825786736996_n.jpg?_nc_ht=scontent-bos3-1.cdninstagram.com&_nc_cat=100&_nc_ohc=8KqdHJGOvvQAX8DekuP&edm=ALQROFkBAAAA&ccb=7-4&ig_cache_key=Mjc1NzMyNzM2NzY0MTI3NDM3MQ%3D%3D.2-ccb7-4&oh=00_AT_t1_6ZQ8jIr81yFo37BmZX2lSoQi98Fcj0kdgwwxux2g&oe=61FE155F&_nc_sid=30a2ef",
                     "https://scontent-bos3-1.cdninstagram.com/v/t51.2885-15/e35/s1080x1080/271678253_332789765197032_4908156288644405118_n.jpg?_nc_ht=scontent-bos3-1.cdninstagram.com&_nc_cat=100&_nc_ohc=dMW2dVcDxMgAX_zZPPd&edm=ALQROFkBAAAA&ccb=7-4&ig_cache_key=Mjc0Nzg0NTAyMzM4NDg2NjgwOA%3D%3D.2-ccb7-4&oh=00_AT_aPpHg2R21MbKUutWbc2rI-cJQWguoTLtLDrUg5vnWLw&oe=61FDC5C1&_nc_sid=30a2ef",
                     "https://scontent-bos3-1.cdninstagram.com/v/t51.2885-15/e35/s1080x1080/271992638_460086472442489_676010937326160445_n.jpg?_nc_ht=scontent-bos3-1.cdninstagram.com&_nc_cat=105&_nc_ohc=DVmPkqG44LMAX9tihzD&edm=ALQROFkBAAAA&ccb=7-4&ig_cache_key=Mjc1MzY4MjYyODgyMzM2MjQ4NQ%3D%3D.2-ccb7-4&oh=00_AT8GTUFqSQD50qi4EqJAtc1HS9hrcgKHMrzq1Z2l3CJoUg&oe=61FD7DFA&_nc_sid=30a2ef"];

  event NewEpicNFTMinted(address sender, uint256 tokenId);
  event ReachedMaxNFTs(address sender, uint256 tokenId);

  constructor() ERC721 ("SquareNFT", "SQUARE") {
    console.log("This is my NFT contract. Woah!");
  }

  function pickRandomPhoto(uint256 tokenId) public view returns (string memory) {
    return images[tokenId];
  }

  function countTokens() public view returns (uint256) {
    return _tokenIds.current();
  }

  function makeAnEpicNFT() public {
    uint256 newItemId = _tokenIds.current();
    if (newItemId >= _maxTokens) {
      emit ReachedMaxNFTs(msg.sender, newItemId);
      console.log('Max NFT reached');
      return;
    }

    string memory image = pickRandomPhoto(newItemId);

    // Get all the JSON metadata in place and base64 encode it.
    string memory json = Base64.encode(
        bytes(
            string(
                abi.encodePacked(
                    '{"name": "',
                    // We set the title of our NFT as the generated word.
                    Strings.toString(newItemId),
                    '", "description": "Photos taken by an anonymous photographer.", "image": "',
                    image,
                    '"}'
                )
            )
        )
    );

    // Just like before, we prepend data:application/json;base64, to our data.
    string memory finalTokenUri = string(
        abi.encodePacked("data:application/json;base64,", json)
    );

    console.log("\n--------------------");
    console.log(finalTokenUri);
    console.log("--------------------\n");

    _safeMint(msg.sender, newItemId);
    
    // Update your URI!!!
    _setTokenURI(newItemId, finalTokenUri);
  
    _tokenIds.increment();
    console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);
    
    emit NewEpicNFTMinted(msg.sender, newItemId);
  }
}