//SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract BID is Ownable {
    uint256 public deadline;
    mapping(address => uint256) bidder;
    uint256  summit;
    address  summitaddress;

    constructor(uint256 _deadline)   {
        deadline = _deadline;
        deadline = (block.timestamp) + (_deadline *1 seconds);
    }
    function setDeadline(uint256 _deadline) public onlyOwner{
        deadline = _deadline;

    }  
    function checkSummit(uint256 _amount) public view returns(bool){
        return _amount>summit;   
    }

    function sendTokenToContract() external checkisEnded payable  {
        require(checkSummit(msg.value),"daha fazla yollandi bro token arttir");
        payTokenBack(summit);
        bidder[msg.sender] = msg.value;
        summit = msg.value;
        summitaddress = msg.sender;

    }
    function showOffer() external view returns(uint){
        return bidder[msg.sender];

    }
    function payTokenBack(uint256 _amount) internal   {
        payable(summitaddress).transfer(_amount);
        bidder[summitaddress] = 0;
    }
    modifier checkisEnded()  {
        require(block.timestamp <= deadline,"ihale bitti"); 
        _;
    }
    function winner() external view returns(address){
        require(block.timestamp >= deadline,"ihale bitmedigi icin kazanan yok");
        return  summitaddress;
    }
}