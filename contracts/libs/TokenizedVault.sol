// SPDX-License-Identifier: AGPL-3.0-or-later



pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TokenizeVault is ERC20, Ownable {

	address private _asset;
	uint256 private _totalAssets;
	
	event Deposit(address caller, address receiver, uint256 assets, uint256 shares);
	event Withdraw(address caller, address receiver, uint256 assets, uint256 shares);
	
    constructor(
		string memory namePrefix, 
		string memory symbolPrefix, 
		address underlyingAsset
	) ERC20( 
		string(abi.encodePacked(namePrefix, ERC20(underlyingAsset).name())),
		string(abi.encodePacked(symbolPrefix, ERC20(underlyingAsset).symbol()))
	) {
		_asset = underlyingAsset;
    }
	
	function decimals() public view virtual override returns (uint8) {
        return ERC20(_asset).decimals();
    }
	
	function asset() public view returns (address) {
        return _asset;
    }
	
	function totalAssets() public view returns (uint256) {
        return _totalAssets;
    }
	
	function convertToShares(uint256 assets) public view returns (uint256 shares) {
		shares = assets * totalSupply() / _totalAssets;
    }
	
	function convertToAssets(uint256 shares) public view returns (uint256 assets) {
		assets = shares * _totalAssets / totalSupply();
    }

	function maxDeposit(address reciver) public view returns (uint256 maxAssets){
		maxAssets = 2 ** 256 - 1;
	}
	
	function previewDeposit(uint256 assets) public view returns(uint256 shares){
		shares = convertToShares(assets);
	}
	
	function deposit(uint256 assets, address receiver) public returns(uint256 shares){
		IERC20(_asset).transferFrom(msg.sender, address(this), assets);
		
		shares = previewDeposit(assets);
		_mint(receiver, shares);
		
		emit Deposit(msg.sender, receiver, assets, shares);
	}
	
	function maxWithdraw(address user) public view returns(uint256 maxShares){
		maxShares = 2 ** 256 - 1;
	}
	
	function previewWithdraw(uint256 shares) public view returns(uint256 assets){
		assets = convertToAssets(shares);
	}
	
	function withdraw(uint256 shares, address receiver) public returns(uint256 assets){
		_burn(msg.sender, shares);
		
		assets = previewWithdraw(shares);
		IERC20(_asset).transfer(receiver, assets);
		
		emit Withdraw(msg.sender, receiver, assets, shares);
	}
	
}
