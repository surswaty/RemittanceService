pragma solidity ^0.5.0;

contract RemittanceService{
    mapping (address => uint)private Agent; //stores secret number in agent address
    mapping (uint => uint)private Mony; //stores amount associated with the secret number
    event RemittanceTransfered(address sender, uint amount, address agent);
    event AgentWithdrawDone(address agent, uint amount, uint Fees);
    
    function transferRemmittance(address _agent, uint _secretNum)public payable returns(bool){
        require(msg.value > 0);
        emit RemittanceTransfered(msg.sender, msg.value, _agent);
        Agent[_agent] = _secretNum;
        Mony[_secretNum] = msg.value;
    }
    
    function agentWithdraw(uint _secretNum, uint _amount)public returns(bool){
        require(Agent[msg.sender] == _secretNum, "Not the agent");
        require(Mony[_secretNum] <= _amount, "Insufficient Balance");
        uint agentFee = (_amount * 1)/100; //1% agent fee
        emit AgentWithdrawDone(msg.sender,_amount, agentFee);
        msg.sender.transfer(_amount);
        Mony[_secretNum] -= (_amount + agentFee);
    }
}