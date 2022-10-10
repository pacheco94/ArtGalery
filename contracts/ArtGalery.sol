//SPDX-License-Identifier: MIT
 pragma solidity ^0.8.0;
 
 ///@ title ArtGaley

 import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
 import "@openzeppelin/contracts/access/Ownable.sol";

 contract ArtGalery is ERC721, Ownable {
    
    //constructor
    constructor (string memory _name, string memory _symbol)ERC721(_name, _symbol){}

    //NTF token counter
    uint256 counter;

    //Price of NTF token
    uint256 fee = 5 ether;

    //Date struct
    struct Art{
        string name;
        uint256 id;
        uint256 dna;
        uint8 level;
        uint8 rartity;
    }
    //Structure storage for keeping artworks
    Art[] public art_works;

    //Events
    event NewArtWork(address indexed owner,uint256 id, uint256 dna);

    //Creating of random number(require of NFT token properties)
    function _creatingRandomNumber(uint256 _mod) internal view returns(uint256){
        bytes32 has_randomNum = keccak256(abi.encodePacked(block.timestamp,msg.sender));
        uint256 randomNum = uint256(has_randomNum);
        return randomNum % _mod;
    }

    //Creating NFT token
    function _createArtWork(string memory _name) internal {
        uint8 randRarity = uint8(_creatingRandomNumber(1000));
        uint256 randDna = _creatingRandomNumber(10**16);
        Art memory newArtWork = Art(_name, counter, randDna, 1, randRarity);
        art_works.push(newArtWork);
        _safeMint(msg.sender, counter);
        emit NewArtWork(msg.sender, counter, randDna);
        counter++;    
    }

    //Update token price
    function updateFee(uint256 _fee) external onlyOwner {
        fee = _fee;
    }

    //Visualce the balance of the Smat Contract (ethers)
    function infoSmartBalance() public view returns(address, uint256){
        address AdressContract = address(this);
        uint256 money = address(this).balance/10**18; //converting wei in ether
        return(AdressContract, money);
    }

    //Obtening all created NFT tokens
    function getGalery() public view returns(Art[] memory){
        return art_works;
    }

    //Obtening a user's NFT tokens
    function getOwnerArt(address _owner) public view returns(Art[] memory){
        Art[] memory result = new Art[](balanceOf(_owner));
        uint256 counter_owner = 0;
        for(uint256 i = 0; i < art_works.length; ++i){
         if(ownerOf(i) == _owner){
            result[counter_owner] = art_works[i];
            counter_owner++;
         }   
        }
        return result;
    }

    //NFT token development
    //NFT token payment
    function _creatRandomArt(string memory _name) public payable {
        require(msg.value >= fee);
        _createArtWork(_name);
    }

    //Extraction ether from the contract (owner)
    function withdraw() external payable onlyOwner{
        address payable _owner = payable(owner());
        _owner.transfer(address(this).balance);
    }

    //tokens level up
    function levelUp(uint256 _artId) public payable {
        require(ownerOf(_artId) == msg.sender && msg.value >= 1 ether,"YOU DO NOT HAVE PERMISSIONS");
    }
 }