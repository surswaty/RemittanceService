pragma solidity ^0.5.0;

contract RemittanceService{
    struct RemittanceData{
        address agent;
        uint value;
        uint secretNum;
    }
    mapping (uint => RemittanceData) secretData;
   
    event RemittanceTransfered(address sender, uint amount, address agent);
    event AgentWithdrawDone(address agent, uint amount, uint Fees);
    
    function transferRemmittance(address _agent, uint _secretNum)public payable returns(bool){
        require(msg.value > 0);
        uint secretNum = _secretNum;
        RemittanceData memory _secretNum = RemittanceData(_agent, msg.value, _secretNum);
        secretData[secretNum] = _secretNum;
        return true;
    }
    
    function agentWithdraw(uint _secretNum, uint _amount)public returns(bool){
       require(secretData[_secretNum].agent == msg.sender, "Not the agent");
       require(secretData[_secretNum].value <= _amount, "Insufficient Balance");
        uint agentFee = (_amount * 1)/100; // 1% agent fee
        emit AgentWithdrawDone(msg.sender,_amount, agentFee);
        msg.sender.transfer(_amount);
        secretData[_secretNum].value -= (_amount + agentFee);
        return true;
    }
}
