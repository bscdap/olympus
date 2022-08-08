// File: contracts/libs/IBEP20.sol

pragma solidity 0.5.12;

interface IBEP20 {
  /**
   * @dev Returns the amount of tokens in existence.
   */
  function totalSupply() external view returns (uint256);

  /**
   * @dev Returns the token decimals.
   */
  function decimals() external view returns (uint8);

  /**
   * @dev Returns the token symbol.
   */
  function symbol() external view returns (string memory);

  /**
  * @dev Returns the token name.
  */
  function name() external view returns (string memory);

  /**
   * @dev Returns the amount of tokens owned by `account`.
   */
  function balanceOf(address account) external view returns (uint256);

  /**
   * @dev Moves `amount` tokens from the caller's account to `recipient`.
   *
   * Returns a boolean value indicating whether the operation succeeded.
   *
   * Emits a {Transfer} event.
   */
  function transfer(address recipient, uint256 amount) external returns (bool);

  /**
   * @dev Returns the remaining number of tokens that `spender` will be
   * allowed to spend on behalf of `owner` through {transferFrom}. This is
   * zero by default.
   *
   * This value changes when {approve} or {transferFrom} are called.
   */
  function allowance(address _owner, address spender) external view returns (uint256);

  /**
   * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
   *
   * Returns a boolean value indicating whether the operation succeeded.
   *
   * IMPORTANT: Beware that changing an allowance with this method brings the risk
   * that someone may use both the old and the new allowance by unfortunate
   * transaction ordering. One possible solution to mitigate this race
   * condition is to first reduce the spender's allowance to 0 and set the
   * desired value afterwards:
   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
   *
   * Emits an {Approval} event.
   */
  function approve(address spender, uint256 amount) external returns (bool);

  /**
   * @dev Moves `amount` tokens from `sender` to `recipient` using the
   * allowance mechanism. `amount` is then deducted from the caller's
   * allowance.
   *
   * Returns a boolean value indicating whether the operation succeeded.
   *
   * Emits a {Transfer} event.
   */
  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

  /**
   * @dev Emitted when `value` tokens are moved from one account (`from`) to
   * another (`to`).
   *
   * Note that `value` may be zero.
   */
  event Transfer(address indexed from, address indexed to, uint256 value);

  /**
   * @dev Emitted when the allowance of a `spender` for an `owner` is set by
   * a call to {approve}. `value` is the new allowance.
   */
  event Approval(address indexed owner, address indexed spender, uint256 value);
}

// File: contracts/libs/Context.sol

pragma solidity 0.5.12;

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
contract Context {
    // Empty internal constructor, to prevent people from mistakenly deploying
    // an instance of this contract, which should be used via inheritance.
    constructor() internal {}

    function _msgSender() internal view returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

// File: contracts/libs/Ownable.sol

pragma solidity 0.5.12;


/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() internal {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// File: contracts/libs/SafeMath.sol

pragma solidity 0.5.12;


/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
  /**
   * @dev Returns the addition of two unsigned integers, reverting on
   * overflow.
   *
   * Counterpart to Solidity's `+` operator.
   *
   * Requirements:
   * - Addition cannot overflow.
   */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a, "SafeMath: addition overflow");

    return c;
  }

  /**
   * @dev Returns the subtraction of two unsigned integers, reverting on
   * overflow (when the result is negative).
   *
   * Counterpart to Solidity's `-` operator.
   *
   * Requirements:
   * - Subtraction cannot overflow.
   */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    return sub(a, b, "SafeMath: subtraction overflow");
  }

  /**
   * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
   * overflow (when the result is negative).
   *
   * Counterpart to Solidity's `-` operator.
   *
   * Requirements:
   * - Subtraction cannot overflow.
   */
  function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    require(b <= a, errorMessage);
    uint256 c = a - b;

    return c;
  }

  /**
   * @dev Returns the multiplication of two unsigned integers, reverting on
   * overflow.
   *
   * Counterpart to Solidity's `*` operator.
   *
   * Requirements:
   * - Multiplication cannot overflow.
   */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
    if (a == 0) {
      return 0;
    }

    uint256 c = a * b;
    require(c / a == b, "SafeMath: multiplication overflow");

    return c;
  }

  /**
   * @dev Returns the integer division of two unsigned integers. Reverts on
   * division by zero. The result is rounded towards zero.
   *
   * Counterpart to Solidity's `/` operator. Note: this function uses a
   * `revert` opcode (which leaves remaining gas untouched) while Solidity
   * uses an invalid opcode to revert (consuming all remaining gas).
   *
   * Requirements:
   * - The divisor cannot be zero.
   */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    return div(a, b, "SafeMath: division by zero");
  }

  /**
   * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
   * division by zero. The result is rounded towards zero.
   *
   * Counterpart to Solidity's `/` operator. Note: this function uses a
   * `revert` opcode (which leaves remaining gas untouched) while Solidity
   * uses an invalid opcode to revert (consuming all remaining gas).
   *
   * Requirements:
   * - The divisor cannot be zero.
   */
  function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    // Solidity only automatically asserts when dividing by 0
    require(b > 0, errorMessage);
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold

    return c;
  }

  /**
   * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
   * Reverts when dividing by zero.
   *
   * Counterpart to Solidity's `%` operator. This function uses a `revert`
   * opcode (which leaves remaining gas untouched) while Solidity uses an
   * invalid opcode to revert (consuming all remaining gas).
   *
   * Requirements:
   * - The divisor cannot be zero.
   */
  function mod(uint256 a, uint256 b) internal pure returns (uint256) {
    return mod(a, b, "SafeMath: modulo by zero");
  }

  /**
   * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
   * Reverts with custom message when dividing by zero.
   *
   * Counterpart to Solidity's `%` operator. This function uses a `revert`
   * opcode (which leaves remaining gas untouched) while Solidity uses an
   * invalid opcode to revert (consuming all remaining gas).
   *
   * Requirements:
   * - The divisor cannot be zero.
   */
  function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    require(b != 0, errorMessage);
    return a % b;
  }
}

// File: contracts/libs/BaseOLY.sol

pragma solidity 0.5.12;

contract BaseOLY {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function dividendTotal() external view returns (uint256);

    function mint(address _uid, uint256 _tokens) external returns (bool);

    function isUser(address _uid) external view returns (bool);

    function getInviter(address _uid) external returns (address);

    function defaultInvite() external returns (address);

    function getSwapTime() external view returns (uint256);

    function setPerformanceIDO(address _uid, uint256 _amount) external {}

    function setPerformanceShare(address _uid, uint256 _amount) external {}
}

// File: contracts/libs/BaseNFT.sol

pragma solidity 0.5.12;

contract BaseNFT {
    function mintOLY(address _to) external payable returns (uint256);

    function balanceOf(address _uid) external view returns (uint256);

    function totalSupply() external view returns (uint256);
}

// File: contracts/Action.sol

pragma solidity 0.5.12;






contract Action is Ownable {
    using SafeMath for uint256;

    BaseOLY internal _OLY;
    BaseNFT internal _NFT;
    address internal _USDT;
    address internal _RECEIPT = 0xE753D7ba0ac5E88B68FAECa98abd2964C813b060;

    uint256 internal _totalNumIDO;
    uint256 internal _totalNumShare;

    uint256 internal _totalAmountIDO;
    uint256 internal _totalAmountShare;

    struct Record {
        uint256 amount;
        uint256 time;
        bool isWithdraw;
    }

    mapping(address => Record) internal _recordIDO;
    mapping(address => Record) internal _recordShare;

    mapping(address => uint256) internal _invites;
    mapping(address => bool) internal _giveNft;

    constructor(
        address _oly,
        address _nft,
        address _usdt
    ) public {
        _OLY = BaseOLY(_oly);
        _NFT = BaseNFT(_nft);
        _USDT = _usdt;
        address _default = _OLY.defaultInvite();
        _recordIDO[_default].amount = 1e22;
        _recordIDO[_default].time = block.timestamp;
        _recordShare[_default].amount = 3e22;
        _recordShare[_default].time = block.timestamp;
    }

    function transfer(
        address token,
        address recipient,
        uint256 amount
    ) public onlyOwner {
        IBEP20(token).transfer(recipient, amount);
    }

    function buyIDO() public payable {
        require(_OLY.isUser(msg.sender));
        require(_OLY.getSwapTime() > block.timestamp);
        require(_recordIDO[msg.sender].amount == 0);
        require(IBEP20(_USDT).transferFrom(msg.sender, _RECEIPT, 100e18));
        _recordIDO[msg.sender].amount = 10000e18;
        _recordIDO[msg.sender].time = block.timestamp;
        _totalNumIDO += 1;
        _totalAmountIDO += 100e18;

        _assignBonus(msg.sender);

        _OLY.setPerformanceIDO(msg.sender, 100e18);
        address _pid = _OLY.getInviter(msg.sender);
        if (_pid == address(0)) return;
        if (_recordShare[_pid].time > 0) {
            _invites[_pid] += 1;
        }

        if (_invites[_pid] >= 5 && !_giveNft[_pid]) {
            _giveNft[_pid] = true;
            _NFT.mintOLY(_pid);
        }
    }

    function buyShare() public {
        require(_OLY.isUser(msg.sender));
        require(_OLY.getSwapTime() > block.timestamp);
        require(_recordShare[msg.sender].amount == 0);
        require(IBEP20(_USDT).transferFrom(msg.sender, _RECEIPT, 300e18));
        _recordShare[msg.sender].amount = 30000e18;
        _recordShare[msg.sender].time = block.timestamp;
        _totalNumShare += 1;
        _totalAmountShare += 300e18;
        _OLY.setPerformanceShare(msg.sender, 300e18);
    }

    function _assignBonus(address _uid) internal {
        address _pid = _OLY.getInviter(_uid);
        if (_pid == address(0)) return;
        if (_recordIDO[_pid].amount > 0 && _recordShare[_pid].amount > 0) {
            _recordIDO[_pid].amount += 1000e18;
        }

        _pid = _OLY.getInviter(_pid);
        if (_pid == address(0)) return;
        if (_recordIDO[_pid].amount > 0 && _recordShare[_pid].amount > 0) {
            _recordIDO[_pid].amount += 300e18;
        }

        _pid = _OLY.getInviter(_pid);
        if (_pid == address(0)) return;
        if (_recordIDO[_pid].amount > 0 && _recordShare[_pid].amount > 0) {
            _recordIDO[_pid].amount += 200e18;
        }
    }

    function withdrawIDO() public {
        uint256 _time = _OLY.getSwapTime();
        require(_time > 0 && _time < block.timestamp);
        require(_recordIDO[msg.sender].amount > 0);
        require(_recordIDO[msg.sender].isWithdraw == false);
        require(_OLY.mint(msg.sender, _recordIDO[msg.sender].amount));
        _recordIDO[msg.sender].isWithdraw = true;
    }

    function withdrawShare() public {
        uint256 _time = _OLY.getSwapTime();
        require(_time > 0 && _time < block.timestamp);
        require(_recordShare[msg.sender].amount > 0);
        require(_recordShare[msg.sender].isWithdraw == false);
        require(_OLY.mint(msg.sender, _recordShare[msg.sender].amount));
        _recordShare[msg.sender].isWithdraw = true;
    }

    function getRecordIDO(address _uid)
        public
        view
        returns (
            address uid,
            uint256 amount,
            uint256 time,
            bool isWithdraw
        )
    {
        return (
            _uid,
            _recordIDO[_uid].amount,
            _recordIDO[_uid].time,
            _recordIDO[_uid].isWithdraw
        );
    }

    function getRecordShare(address _uid)
        public
        view
        returns (
            address uid,
            uint256 amount,
            uint256 time,
            bool isWithdraw
        )
    {
        return (
            _uid,
            _recordShare[_uid].amount,
            _recordShare[_uid].time,
            _recordShare[_uid].isWithdraw
        );
    }

    function getInfoData()
        public
        view
        returns (
            uint256 totalNumIDO,
            uint256 totalNumShare,
            uint256 totalAmountIDO,
            uint256 totalAmountShare,
            bool hasWithdraw
        )
    {
        uint256 _swapTime = _OLY.getSwapTime();
        bool _hasWithdraw = _swapTime > 0 && _swapTime < block.timestamp;
        return (
            _totalNumIDO,
            _totalNumShare,
            _totalAmountIDO,
            _totalAmountShare,
            _hasWithdraw
        );
    }

    function setNFT(address _nft) public onlyOwner {
        _NFT = BaseNFT(_nft);
    }

    function setOLY(address _oly) public onlyOwner {
        _OLY = BaseOLY(_oly);
    }
}
