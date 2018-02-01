pragma solidity ^0.4.18;

contract Location {
  struct House {
    uint id;
    string location;
    address owner;
  }

  address owner;

  function Location() {
    owner = msg.sender;
  }

  modifier onlyContractOwner {
    require(msg.sender == owner);
    _;
  }

  modifier onlyHomeOwner(uint _houseId) {
    require (msg.sender == allHouses[_houseId].owner);
    _;
  }

  mapping (address => House[]) housesHash;
  House[] allHouses;

  function createHouse(string _location) public onlyContractOwner returns (uint) {
    House memory newHouse = House(allHouses.length, _location, msg.sender);
    housesHash[msg.sender].push(newHouse);
    allHouses.push(newHouse);
    return newHouse.id;
  }

  function totalHousesByAddress(address _address) public view returns (uint) {
    uint total;
    address deleted = 0x0000000000000000000000000000000000000000;
    for (uint i = 0; i < housesHash[_address].length; i++) {
      if (housesHash[_address][i].owner != deleted) {
        total ++;
      }
    }
    return total;
  }

  function totalHouses() public view returns (uint) {
    return allHouses.length;
  }

  function sellHouse(uint _houseId, address _currentOwner, address _newOwner) public onlyHomeOwner(_houseId) returns (uint) {
    uint length = totalHousesByAddress(_currentOwner);
    House[] memory currentHouses = housesHash[_currentOwner];
    for (uint i = 0; i < length; i++) {
      if (_houseId == currentHouses[i].id) {
        currentHouses[i].owner = _newOwner;
        housesHash[_newOwner].push(currentHouses[i]);
        allHouses[i].owner = _newOwner;
        housesHash[_currentOwner][i] = housesHash[_currentOwner][length - 1];
        delete housesHash[_currentOwner][length - 1];
      }
    }
    return _houseId;
  }

  //troubleshooting
  function houseInformation (uint _houseId) public view returns (uint, string, address) {
    return (allHouses[_houseId].id, allHouses[_houseId].location, allHouses[_houseId].owner);
  }

  //troubleshooting
  function addressInformation(uint _houseId, address _address) public view returns (uint, string, address) {
    return (housesHash[_address][_houseId].id, housesHash[_address][_houseId].location, housesHash[_address][_houseId].owner);
  }
}

