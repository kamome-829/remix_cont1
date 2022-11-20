// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

import "@openzeppelin/contracts@4.6.0/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.6.0/access/Ownable.sol";
import "@openzeppelin/contracts@4.6.0/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts@4.6.0/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts@4.6.0/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts@4.6.0/utils/Counters.sol";
import "@openzeppelin/contracts@4.6.0/utils/Strings.sol";
import "@openzeppelin/contracts@4.6.0/utils/Base64.sol";

contract BurnNFT is ERC721Pausable, ERC721Burnable, ERC721URIStorage, Ownable{

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    /**
    * @dev
    * -URI設定時に誰がどのTokenIDに何のURIを設定したか記録する
    */
    event TokenURIChanged(address indexed sender, uint256 indexed tokenId, string uri);


    constructor() ERC721("BurnNFT", "SAMPLE"){
    }

    /**
    * @dev
    * -このコントラクトをデプロイしたアドレスだけmint可能 onlyOwner
    * -tokenIdをインクリメント _tokenIds.increment();
    * -nftMint関数の実行アドレスにtokenIdを紐づけ
    * -Mintの際にURIを設定
    * -イベント発火
    */
    function nftMint()public onlyOwner whenNotPaused(){
        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();

        _mint(_msgSender(), newTokenId);

        string memory jsonFile = string(abi.encodePacked('metadata', Strings.toString(newTokenId), '.json'));

        _setTokenURI(newTokenId,jsonFile);
        emit TokenURIChanged(_msgSender(), newTokenId, jsonFile);
    }

    /**
    * @dev
    * -URIプレフィックスの設定
    */
    function _baseURI() internal pure override returns (string memory){
        return "ipfs://bafybeihmz3jesfpzd7nlwqaq753247l5drantxpuupjfqp2jjeyfcvh6we/";
    }

    /**
    * @dev
    * -NFT停止
    */
    function pause()public onlyOwner{
        _pause();
    }

    /**
    * @dev
    * -NFT停止解除
    */
    function unpause()public onlyOwner{
        _unpause();
    }

    /**
    * @dev
    * -オーバーライド
    */
    function tokenURI(uint256 tokenId) public view virtual override(ERC721, ERC721URIStorage) returns(string memory){
        return super.tokenURI(tokenId);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage){
        super._burn(tokenId);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    )internal override(ERC721,ERC721Pausable){
        super._beforeTokenTransfer(from,to,tokenId);
    }
    
}