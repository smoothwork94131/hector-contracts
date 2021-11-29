// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.7.5;

library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
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
     *
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
     *
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
     *
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
     *
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
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }
}

library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies in extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain`call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: value }(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }

  /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.3._
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.3._
     */
    function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }

    function addressToString(address _address) internal pure returns(string memory) {
        bytes32 _bytes = bytes32(uint256(_address));
        bytes memory HEX = "0123456789abcdef";
        bytes memory _addr = new bytes(42);

        _addr[0] = '0';
        _addr[1] = 'x';

        for(uint256 i = 0; i < 20; i++) {
            _addr[2+i*2] = HEX[uint8(_bytes[i + 12] >> 4)];
            _addr[3+i*2] = HEX[uint8(_bytes[i + 12] & 0x0f)];
        }

        return string(_addr);

    }
}

interface IOwnable {
  function manager() external view returns (address);

  function renounceManagement() external;
  
  function pushManagement( address newOwner_ ) external;
  
  function pullManagement() external;
}

contract Ownable is IOwnable {

    address internal _owner;
    address internal _newOwner;

    event OwnershipPushed(address indexed previousOwner, address indexed newOwner);
    event OwnershipPulled(address indexed previousOwner, address indexed newOwner);

    constructor () {
        _owner = msg.sender;
        emit OwnershipPushed( address(0), _owner );
    }

    function manager() public view override returns (address) {
        return _owner;
    }

    modifier onlyManager() {
        require( _owner == msg.sender, "Ownable: caller is not the owner" );
        _;
    }

    function renounceManagement() public virtual override onlyManager() {
        emit OwnershipPushed( _owner, address(0) );
        _owner = address(0);
    }

    function pushManagement( address newOwner_ ) public virtual override onlyManager() {
        require( newOwner_ != address(0), "Ownable: new owner is the zero address");
        emit OwnershipPushed( _owner, newOwner_ );
        _newOwner = newOwner_;
    }
    
    function pullManagement() public virtual override {
        require( msg.sender == _newOwner, "Ownable: must be new owner to pull");
        emit OwnershipPulled( _owner, _newOwner );
        _owner = _newOwner;
    }
}

interface IPriceHelperV2{
    function adjustPrice(address bond,uint percent) external;
}

interface IPriceHelper{
    function adjustDaiPriceTo(uint percent) external;
    
    function adjustUsdcPriceTo(uint percent) external;

    function adjustDaiLpPriceTo(uint percent) external;
    
    function adjustUsdcLpPriceTo(uint percent) external;
}

interface IUniV2Pair{
    function getReserves() external view returns (uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast);
}

interface IsHEC{
    function circulatingSupply() external view returns ( uint );
}

interface IStaking{
    function epoch() external view returns (uint length, uint number, uint endBlock, uint distribute);
}

interface IBond{
    function bondPriceInUSD() external view returns ( uint price_ );
}

contract PriceStrategy is Ownable{

    using SafeMath for uint;

    IPriceHelper public helper1;
    IPriceHelperV2 public helper2;
    IUniV2Pair public hecdai;
    IsHEC public sHEC;
    IStaking public staking;

    uint public additionalLp11MinDiscount;//100 = 1%
    uint public additionalLp11MaxDiscount;

    uint public min44Discount;
    uint public max44Discount;

    uint public additionalAsset11MinDiscount;
    uint public additionalAsset11MaxDiscount;

    uint public lastAdjustBlockNumber;
    uint public adjustmentBlockGap;

    mapping( address => bool ) public executors;

    mapping(address=>TYPES) public bondTypes;
    mapping(address=>uint) public usdPriceDecimals;
    address[] public bonds;

    constructor(
        address _helper1,
        address _helper2,
        address _hecdai,
        address _sHEC,
        address _staking,
        uint _adjustmentBlockGap
    ){
        require( _helper1 != address(0) );
        helper1 = IPriceHelper(_helper1);
        require( _helper2 != address(0) );
        helper2 = IPriceHelperV2(_helper2);
        require( _hecdai != address(0) );
        hecdai = IUniV2Pair(_hecdai);
        require( _sHEC != address(0) );
        sHEC = IsHEC(_sHEC);
        require( _staking != address(0) );
        staking = IStaking(_staking);
        require( _adjustmentBlockGap>=600&&_adjustmentBlockGap<=28800,"adjustment block gap must be between 600 and 28800");
        adjustmentBlockGap=_adjustmentBlockGap;
    }

    function setHelper1(address _helper1) external onlyManager{
        require( _helper1 != address(0) );
        helper1 = IPriceHelper(_helper1);
    }

    function setHelper2(address _helper2) external onlyManager{
        require( _helper2 != address(0) );
        helper2 = IPriceHelperV2(_helper2);
    }

    function setHecdai(address _hecdai) external onlyManager{
        require( _hecdai != address(0) );
        hecdai = IUniV2Pair(_hecdai);
    }

    function setSHEC(address _sHEC) external onlyManager{
        require( _sHEC != address(0) );
        sHEC = IsHEC(_sHEC);
    }

    function setStaking(address _staking) external onlyManager{
        require( _staking != address(0) );
        staking = IStaking(_staking);
    }

   function setAdjustmentBlockGap(uint _adjustmentBlockGap) external onlyManager{
        require( _adjustmentBlockGap>=600&&_adjustmentBlockGap<=28800);
        adjustmentBlockGap=_adjustmentBlockGap;
   }

    function addExecutor(address executor) external onlyManager{
        executors[executor]=true;
    }
    
    function removeExecutor(address executor) external onlyManager{
        delete executors[executor];
    }

    enum TYPES { ASSET11,ASSET44,LP11,LP44 }

    function addBond(address bond, TYPES bondType, uint usdPriceDecimal) external onlyManager{
        require(bondType==TYPES.ASSET11||bondType==TYPES.ASSET44||bondType==TYPES.LP11||bondType==TYPES.LP44,"incorrect bond type");
        for( uint i = 0; i < bonds.length; i++ ) {
            if(bonds[i]==bond)return;
        }
        bonds.push( bond );
        bondTypes[bond]=bondType;
        usdPriceDecimals[bond]=usdPriceDecimal;
    }

    function removeBond(address bond) external onlyManager{
        for( uint i = 0; i < bonds.length; i++ ) {
            if(bonds[i]==bond){
                bonds[i]=address(0);
                delete bondTypes[bond];
                delete usdPriceDecimals[bond];
                return;
            }
        }
    }

    //todo
    function runPriceStrategy() external{
        require(lastAdjustBlockNumber+adjustmentBlockGap>block.number,"cool down time not passed yet");
        uint hecPrice=getPrice();//$220 = 22000
        uint roi5day=getRoiForDays(5);//2% = 20000
        for( uint i = 0; i < bonds.length; i++ ) {
            if(bonds[i]!=address(0)){
                uint bondPriceUsd=IBond(bonds[i]).bondPriceInUSD();
                uint bondPrice=bondPriceUsd.mul(100).div(usdPriceDecimals[bonds[i]]);
                executeStrategy(bonds[i],bondTypes[bonds[i]],hecPrice,bondPrice,roi5day);
            }
        }
    }

    function executeStrategy(address bond,TYPES bondType,uint hecPrice,uint bondPrice,uint roi5day) public view returns (uint){
        uint upper=bondPrice;
        uint lower=bondPrice;
        if(bondType==TYPES.LP44||bondType==TYPES.ASSET44){
            upper=hecPrice.mul(uint(10000).sub(min44Discount)).div(10000);
            lower=hecPrice.mul(uint(10000).sub(max44Discount)).div(10000);
        }else if(bondType==TYPES.LP11){
            
        }else if(bondType==TYPES.ASSET11){

        }
        uint targetPrice=bondPrice;
        if(bondPrice>upper)targetPrice=upper;
        else if(bondPrice<lower)targetPrice=lower;
        uint percentage=targetPrice.mul(10000).div(bondPrice);
        return percentage;
    }

    function getRoiForDays(uint numberOfDays) public view returns (uint){
        require(numberOfDays>0);
        uint circulating=sHEC.circulatingSupply();
        uint distribute=0;
        (,,,distribute)=staking.epoch();
        if(distribute==0)return 0;
        uint precision=1e6;
        uint epochBase=distribute.mul(precision).div(circulating).add(precision);
        uint dayBase=epochBase.mul(epochBase).mul(epochBase).div(precision*precision);
        uint total=dayBase;
        for(uint i=0;i<numberOfDays-1;i++){
            total=total.mul(dayBase).div(precision);
        }
        return total.sub(precision).div(100);
    }

    function getPrice() public view returns (uint){
        uint112 _reserve0=0;
        uint112 _reserve1=0;
        (_reserve0,_reserve1,)=hecdai.getReserves();
        uint reserve0=uint(_reserve0);
        uint reserve1=uint(_reserve1);
        return reserve1.div(reserve0).div(1e7);//$220 = 22000
    }

}
