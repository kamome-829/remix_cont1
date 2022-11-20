// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

import "@openzeppelin/contracts@4.6.0/token/ERC721/ERC721.sol";

contract OnlyOwnerMintWithModifier is ERC721{


    /**
    * @dev
    * -このコントラクトをデプロイしたアドレス用変数owner
    *
    */
    address public owner;

    constructor() ERC721("OnlyOwnerMintWithModifier", "OwNFTMOD"){
        owner = _msgSender();
    }

    /**
    * @dev
    * -このコントラクトをデプロイしたアドレスだけmint可能 require
    * モディファイヤー
    */
    modifier onlyOwner{
        require(owner == _msgSender(), "Caller is not the owner.");
        _;
    }

    /**
    * @dev
    * -このコントラクトをデプロイしたアドレスだけmint可能 require
    * -nftMint関数の実行アドレスにtokenIdを紐づけ
    */
    function nftMint(uint256 tokenId)public onlyOwner{
        _mint(_msgSender(), tokenId);
    }

    function nftMint()public{}
} 