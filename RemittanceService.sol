pragma solidity ^0.5.0;

contract RemittanceService{
    struct RemittanceData{
        address agent;
        uint value;
        bytes32 secretHash;
    }
    mapping (bytes32 => RemittanceData)public secretData;
   
    event RemittanceTransfered(address sender, uint amount, address agent);
    event AgentWithdrawDone(address agent, uint amount);
    
    function hashIt(string memory _string)public pure returns(bytes32){
        return bytes32(keccak256(abi.encodePacked(_string)));
    }
    
    function transferRemmittance(address _agent, bytes32 _hash) public payable returns(bool){
        require(msg.value > 0, "Sends ether to remit.");
        require(_hash != bytes32(0));
        if(secretData[_hash].secretHash == _hash){
            secretData[_hash].value += msg.value;
        }
        RemittanceData memory myRem = RemittanceData(_agent, msg.value, _hash);
        secretData[_hash] = myRem;
        return true;
    }
    
    function agentWithdraw(string memory _secretSrting)public returns(bool){
        bytes32 secretHash = hashIt(_secretSrting);
        require(secretData[secretHash].agent == msg.sender, "Not the agent");
        require(secretData[secretHash].value <= 0, "Have no Funds");
        emit AgentWithdrawDone(msg.sender, secretData[secretHash].value);
        msg.sender.transfer(secretData[secretHash].value);
        delete secretData[secretHash];
        return true;
    }
}
