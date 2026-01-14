// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.31;

contract SimpleStorage {
    uint256 favoriteNumber;

    struct Person {
        uint256 favoriteNumber;
        string name;
    }

    Person[] public listOfPeople;

    mapping(string => uint256) public nameToFavoriteNumber;

    function store(uint256 _favoriteNumber) public virtual {
        favoriteNumber = _favoriteNumber;
    }

    function retrieve() public view returns (uint256) {
        return favoriteNumber;
    }

    function addPerson(uint256 _favoriteNumber, string memory _name) public {
        Person memory newPerson = Person({
            favoriteNumber: _favoriteNumber,
            name: _name
        });

        listOfPeople.push(newPerson);
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }
}
