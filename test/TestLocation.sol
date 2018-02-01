
import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Location.sol";

contract TestLocation {
  Location location = Location(DeployedAddresses.Location());

  //test doesn't work with onlyOwner restriction
  function testAdminCanCreateHouse() public {
    uint returnId = location.createHouse("first house");
    uint expected = 0;

    Assert.equal(returnId, expected, "House 0 successfully created");
  }

}
