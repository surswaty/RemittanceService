pragma solidity ^0.5.0;

contract RemittanceService{
    struct RemittanceData{
        address agent;
        uint value;
        bytes32 secretHash;
    }
    mapping (bytes32 => RemittanceData) secretData;
   
    event RemittanceTransfered(address sender, uint amount, address agent);
    event AgentWithdrawDone(address agent, uint amount);
    
    function transferRemmittance(address _agent, string memory _secretSrting)public payable returns(bool){
        require(msg.value > 0);
        bytes32 secretHash = keccak256(abi.encodePacked(_secretSrting));
        RemittanceData memory myRem = RemittanceData(_agent, msg.value, secretHash);
        secretData[secretHash] = myRem;
        return true;
    }
    
    function agentWithdraw(string memory _secretSrting, uint _amount)public returns(bool){
        bytes32 secretHash = keccak256(abi.encodePacked(_secretSrting));
        require(_amount > 0);
        require(secretData[secretHash].agent == msg.sender, "Not the agent");
        require(_amount <= secretData[secretHash].value, "Insufficient Balance");
        emit AgentWithdrawDone(msg.sender, _amount);
        msg.sender.transfer(_amount);
        secretData[secretHash].value -= _amount;
        return true;
    }
}
