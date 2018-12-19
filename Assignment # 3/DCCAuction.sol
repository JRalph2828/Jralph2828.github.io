pragma solidity ^0.4.24;

contract dccAuction {
    
    struct auctioneer {
        address auctioneerAddress;
        uint tokenBought;
		mapping (bytes32 => uint) myBid; // 경매자들의 각 물품별 입찰가
    }
    
    mapping (address => auctioneer) public auctioneers; // 경매자들의 주소
    mapping (bytes32 => uint) public highest; // 각 물품별 경매 최고가
    
    bytes32[] public candidateNames; // 물품 배열
    
    uint public tokenPrice; // 토큰 가격 ex) 0.01 ether
    
    constructor(uint _tokenPrice) public // Tx 생성시 호출자
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
        
        require(tokenCountForAuction <= auctioneers[msg.sender].tokenBought); // 본인이 가진 토큰이 경매 토큰 이상인지 검사
        		
		if(auctioneers[msg.sender].myBid[candidateName] == 0) // 해당 물품에 최초 입찰
		    auctioneers[msg.sender].myBid[candidateName] = tokenCountForAuction;
		else // 기존 입찰 금액이 존재시, 기존 토큰에 입찰가를 추가
		    auctioneers[msg.sender].myBid[candidateName] += tokenCountForAuction;
		    
		if(highest[candidateName] < auctioneers[msg.sender].myBid[candidateName]) // 본인 입찰가가 최고 경매가 일시 본인 입찰 가격으로 대체
			highest[candidateName] = auctioneers[msg.sender].myBid[candidateName];

        auctioneers[msg.sender].tokenBought -= tokenCountForAuction; // 경매하는데 소비한 토큰만큼 삭감 
    }
    
    function getCandidateIndex(bytes32 candidate) view public returns (uint) // 해당 물품의 index 반환
    {
        for(uint i=0; i < candidateNames.length; i++)
        {
            if(candidateNames[i] == candidate)
            {
                return i;
            }
        }
        
        return uint(-1); // 후보자가 없는 경우 -1 반환
    }
    
    function getCandidatesInfo() view public returns (bytes32[]) // 후보자 이름들 반환
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