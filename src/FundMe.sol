// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.31;

import {PriceConverter} from "./PriceConverter.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

error NotOwner();
error WithdrawFailed();

contract FundMe {
    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 5e18;
    address[] public s_funders;
    mapping(address funders => uint256 amount) public s_listOfFunders;
    address private immutable I_OWNER;
    AggregatorV3Interface s_priceFeed;

    constructor(address _priceFeed) {
        I_OWNER = msg.sender;
        s_priceFeed = AggregatorV3Interface(_priceFeed);
    }

    function fund() public payable {
        require(
            msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD,
            "Didn't send enough ETH"
        );
        s_funders.push(msg.sender);
        s_listOfFunders[msg.sender] += msg.value;
    }

    function getVersion() public view returns (uint256) {
        return s_priceFeed.version();
    }

    function cheaperWithdraw() external onlyOwner {
        address[] memory m_funders = s_funders;
        uint256 length = m_funders.length;

        for (uint256 i = 0; i < length; ) {
            s_listOfFunders[m_funders[i]] = 0;
            unchecked {
                ++i;
            }
        }

        delete s_funders;

        address owner = msg.sender;
        (bool success, ) = owner.call{value: address(this).balance}("");
        if (!success) revert WithdrawFailed();
    }

    function withdraw() public onlyOwner {
        for (
            uint256 funderIndex = 0;
            funderIndex < s_funders.length;
            funderIndex++
        ) {
            address funder = s_funders[funderIndex];
            s_listOfFunders[funder] = 0;
        }
        s_funders = new address[](0);

        // transfer
        // payable(msg.sender).transfer(address(this).balance);

        // send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed");

        // call
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "Call failed");
    }

    modifier onlyOwner() {
        _onlyOwner();
        _;
    }

    function _onlyOwner() internal view {
        if (msg.sender != I_OWNER) revert NotOwner();
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

    function getAddressToAmountFunded(
        address funder
    ) external view returns (uint256) {
        return s_listOfFunders[funder];
    }

    function getFunder(uint256 index) external view returns (address) {
        return s_funders[index];
    }

    function getOwner() external view returns (address) {
        return I_OWNER;
    }
}
