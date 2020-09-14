

pragma solidity >=0.5.12;

import "./lib.sol";

interface VatLike {
    function file(bytes32, bytes32, uint) external;
}

interface PipLike {
    function peek() external returns (bytes32, bool);
}

contract Spotter is LibNote {
    mapping (address => uint) public wards;
    function rely(address guy) external note auth { wards[guy] = 1;  }
    function deny(address guy) external note auth { wards[guy] = 0; }
    modifier auth {
        require(wards[msg.sender] == 1, "Spotter/not-authorized");
        _;
    }

    struct Ilk {
    }

    mapping (bytes32 => Ilk) public ilks;


    uint256 public live;

    event Poke(
      bytes32 ilk,
    );

    bytes32 public price;


    uint constant ONE = 10 ** 27;

    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x);
    }
    function rdiv(uint x, uint y) internal pure returns (uint z) {
        z = mul(x, ONE) / y;
    }

    function file(bytes32 ilk, bytes32 what, address pip_) external note auth {
        require(live == 1, "Spotter/not-live");
        if (what == "pip") ilks[ilk].pip = PipLike(pip_);
        else revert("Spotter/file-unrecognized-param");
    }
    function file(bytes32 what, uint data) external note auth {
        require(live == 1, "Spotter/not-live");
        if (what == "par") par = data;
        else revert("Spotter/file-unrecognized-param");
    }
    function file(bytes32 ilk, bytes32 what, uint data) external note auth {
        require(live == 1, "Spotter/not-live");
        if (what == "mat") ilks[ilk].mat = data;
        else revert("Spotter/file-unrecognized-param");
    }

// Original code: handler updatePrice;
bytes32 private updatePrice_key;
function set_updatePrice_key() private {
    updatePrice_key = keccak256("updatePrice(bytes32)");
}
////////////////////

    function update(bytes32 data) external {
        price = data;
    }

    function poke_to_bind(address osm_addr) external {
// Original code: updatePrice.bind(osm_addr,"PriceFeedUpdate(bytes32)");
bytes32 updatePrice_signal_prototype_hash = keccak256("PriceFeedUpdate(bytes32)");
assembly {
    mstore(
        0x00,
        sigbind(
            sload(updatePrice_key.slot),
            osm_addr,
            updatePrice_signal_prototype_hash
        )
    )
}
////////////////////
    }

    function poke_to_detach(address osm_addr) external {
// Original code: updatePrice.detach(osm_addr,"PriceFeedUpdate(bytes32)");
bytes32 updatePrice_signal_prototype_hash = keccak256("PriceFeedUpdate(bytes32)");
assembly {
    mstore(
        0x00,
        sigdetach(
            sload(updatePrice_key.slot),
            osm_addr,
            updatePrice_signal_prototype_hash
        )
    )
}
////////////////////
    }
    
    function getPrice() public returns(bytes32) {
        return price;
    }

    function cage() external note auth {
        live = 0;
    }
    constructor() public {
        wards[msg.sender] = 1;
        par = ONE;
        live = 1;
// Original code: handler.create_handler("update(bytes32)",1000000,120);
set_handler_key();
bytes32 handler_method_hash = keccak256("update(bytes32)");
uint handler_gas_limit = 1000000;
uint handler_gas_ratio = 120;
assembly {
    mstore(
        0x00, 
        createhandler(
            sload(handler_key.slot), 
            handler_method_hash, 
            handler_gas_limit, 
            handler_gas_ratio
        )
    )
}
////////////////////
    }
    
}
