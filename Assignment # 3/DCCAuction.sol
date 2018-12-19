pragma solidity ^0.4.24;

contract dccAuction {
    
    struct auctioneer {
        address auctioneerAddress;
        uint tokenBought;
		mapping (bytes32 => uint) myBid; // ����ڵ��� �� ��ǰ�� ������
    }
    
    mapping (address => auctioneer) public auctioneers; // ����ڵ��� �ּ�
    mapping (bytes32 => uint) public highest; // �� ��ǰ�� ��� �ְ�
    
    bytes32[] public candidateNames; // ��ǰ �迭
    
    uint public tokenPrice; // ��ū ���� ex) 0.01 ether
    
    constructor(uint _tokenPrice) public // Tx ������ ȣ����
    {
        tokenPrice = _tokenPrice;
        
        candidateNames.push("iphone7");
        candidateNames.push("iphone8");
        candidateNames.push("iphoneX");
        candidateNames.push("galaxyS9");
        candidateNames.push("galaxyNote9");
        candidateNames.push("LGG7");
    }
    
    function buy() payable public returns (int) 
    {
        uint tokensToBuy = msg.value / tokenPrice;
        auctioneers[msg.sender].auctioneerAddress = msg.sender;
        auctioneers[msg.sender].tokenBought += tokensToBuy;
    }
    
    function getHighest() view public returns (uint, uint, uint, uint, uint, uint)
    {
        return (highest["iphone7"],
        highest["iphone8"],
        highest["iphoneX"],
        highest["galaxyS9"],
        highest["galaxyNote9"],
        highest["LGG7"]);
    }

	function getMyBid() view public returns (uint, uint, uint, uint, uint, uint)
	{
        return (auctioneers[msg.sender].myBid["iphone7"],
        auctioneers[msg.sender].myBid["iphone8"],
        auctioneers[msg.sender].myBid["iphoneX"],
        auctioneers[msg.sender].myBid["galaxyS9"],
        auctioneers[msg.sender].myBid["galaxyNote9"],
        auctioneers[msg.sender].myBid["LGG7"]);
	}
    
    function auction(bytes32 candidateName, uint tokenCountForAuction) public
    {
        uint index = getCandidateIndex(candidateName);
        require(index != uint(-1));
        
        require(tokenCountForAuction <= auctioneers[msg.sender].tokenBought); // ������ ���� ��ū�� ��� ��ū �̻����� �˻�
        		
		if(auctioneers[msg.sender].myBid[candidateName] == 0) // �ش� ��ǰ�� ���� ����
		    auctioneers[msg.sender].myBid[candidateName] = tokenCountForAuction;
		else // ���� ���� �ݾ��� �����, ���� ��ū�� �������� �߰�
		    auctioneers[msg.sender].myBid[candidateName] += tokenCountForAuction;
		    
		if(highest[candidateName] < auctioneers[msg.sender].myBid[candidateName]) // ���� �������� �ְ� ��Ű� �Ͻ� ���� ���� �������� ��ü
			highest[candidateName] = auctioneers[msg.sender].myBid[candidateName];

        auctioneers[msg.sender].tokenBought -= tokenCountForAuction; // ����ϴµ� �Һ��� ��ū��ŭ �谨 
    }
    
    function getCandidateIndex(bytes32 candidate) view public returns (uint) // �ش� ��ǰ�� index ��ȯ
    {
        for(uint i=0; i < candidateNames.length; i++)
        {
            if(candidateNames[i] == candidate)
            {
                return i;
            }
        }
        
        return uint(-1); // �ĺ��ڰ� ���� ��� -1 ��ȯ
    }
    
    function getCandidatesInfo() view public returns (bytes32[]) // �ĺ��� �̸��� ��ȯ
    {
        return candidateNames;
    }
    
    function getTokenPrice() view public returns(uint)
    {
        return tokenPrice;
    }
    
    function getTokenBought() view public returns(uint)
    {
        return auctioneers[msg.sender].tokenBought;
    }
}