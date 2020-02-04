pragma solidity ^0.5.0;

contract RemittanceService{
    struct RemittanceData{
        address agent;
        uint value;
        string secretNum;
    }
    mapping (string => RemittanceData) secretData;
   
    event RemittanceTransfered(address sender, uint amount, address agent);
    event AgentWithdrawDone(address agent, uint amount);
    
    function transferRemmittance(address _agent, string memory _secretSrting)public payable returns(bool){
        require(msg.value > 0);
        RemittanceData memory myRem = RemittanceData(_agent, msg.value, _secretSrting);
        secretData[_secretSrting] = myRem;
        return true;
    }
    
    function agentWithdraw(string memory _secretNum, uint _amount)public returns(bool){
       require(secretData[_secretNum].agent == msg.sender, "Not the agent");
       require(_amount <= secretData[_secretNum].value, "Insufficient Balance");
        emit AgentWithdrawDone(msg.sender, _amount);
        msg.sender.transfer(_amount);
        secretData[_secretNum].value -= _amount;
        return true;
    }
}
