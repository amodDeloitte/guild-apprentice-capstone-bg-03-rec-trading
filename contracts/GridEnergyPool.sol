// SPDX-License-Identifier: GPL-3.0
    
pragma solidity >=0.4.22 <0.9.0;



// contract for maintaining energy data at Grid 
contract GridEnergyPool{

    // setting the sequence for a energy ID and REC Id
    int32 energyIdSeq = 100;
    int32 recTokenIdSeq = 1000;

    // set the fixed price of an REC
    uint256 recPrice = 1;

    // structure for details of the energy available in pool
    struct EnergyDetail {
        int32 energyId; // unique identifier for particular Energy
        address payable contributor; // address of the energy contributor
        int32 energyQuantity; // quantity of Energy
    }

    // struct for REC info
    struct RECDetail {
        // unique Identifier for REC
        int32 recTokenId;
        // energy Token Id for which the REC is generated
        // would behave like a forgien key to the EnergyDetail struct
        int32 energyId;
        // details on the contributor
        address payable owner;
        // flag to indicate if its available for trading
        // 0 --> not available; 1 --> available
        int32 availForTrade;
    }

    // creating an Array of EnergyDetails
    EnergyDetail[] public energyPool;
    // creating an Array of RECs
    RECDetail[] public recPool;

    // adds the energy contributed to the pool
    function contributeEnergy(address payable _contributor, 
                                int32 _energyQuantity) public  {

            
        EnergyDetail memory energyDetailsObj;
        energyDetailsObj.energyId = energyIdSeq;
        energyDetailsObj.contributor = _contributor;
        energyDetailsObj.energyQuantity = _energyQuantity;

        // add Energy to the pool along with all the details
        energyPool.push(energyDetailsObj);

        // increment the energy token sequence
        incrementEnergySeq();

    }

    // increment energy sequence
    function incrementEnergySeq() public {
        energyIdSeq = energyIdSeq + 100;
    }

    // increment REC sequence
    function incrementRecTokenSeq() public {
        recTokenIdSeq = recTokenIdSeq + 100;
    }

    // issue RECs based on the energy contributed
    function issueREC() public {

        // defining variables to be returned in array
        int32[] memory energyTokenIdList = new int32[](energyPool.length);
        address payable[] memory contributorAddress = new address payable[](energyPool.length);
        int32[] memory energyQuantity = new int32[](energyPool.length);

        // looping through all the Energy contributed in the pool
        for (uint i = 0; i < energyPool.length; i++) {
            //saving the data in memory array
            energyTokenIdList[i] = energyPool[i].energyId;
            contributorAddress[i] = energyPool[i].contributor;
            energyQuantity[i] = energyPool[i].energyQuantity;

            // issue REC; 1 REC per 1MWatt of Energy
            for(int32 j = 0; j < energyQuantity[i]; j++) {
                // create a REC and add it to the pool
                RECDetail memory recDetailObj;
                recDetailObj.recTokenId = recTokenIdSeq;
                recDetailObj.energyId = energyTokenIdList[i];
                recDetailObj.owner = contributorAddress[i];
                recDetailObj.availForTrade = 0;

                // add it to the REC pool
                recPool.push(recDetailObj);

                // increment the REC token sequence
                incrementRecTokenSeq();
            }

        }

    }

    // set the REC available for trade
    function setRECAvailForTrade(int32 _recTokenId) public {

        // loop through the REC list and update the available flag for requested REC token
        for(uint j = 0; j < recPool.length; j++) {
            
            // check if the recToken Id matches
            if(recPool[j].recTokenId == _recTokenId) {
                recPool[j].availForTrade = 1;
                break;
            }

            // no flag updated
            // add logs to let user know
        }
    }

    // display the available RECs for trading
    function displayAvailableREC() public view returns (int32[] memory) {

        int32[] memory recTokenIdList = new int32[](recPool.length);
        // loop through the REC list and get those which are available for Trading
        for(uint j = 0; j < recPool.length; j++) {
            
            // filter out all RECs available for trading
            if(recPool[j].availForTrade == 1) {
                recTokenIdList[j] = recPool[j].recTokenId;
            } else {
                recTokenIdList[j] = 0;
            }

        }

         // return the list of available RECs
        return (recTokenIdList);
    }

    // process to purchase REC
    function purchaseREC(address payable recOwner, uint256 amount) payable external{

        // transfer the price of REC to the owner
        // recOwner.transfer(amount);
        // recOwner.call{gas: 292810, value: 1}(data)

        // update the owner of the REC
        // for(uint j = 0; j < recPool.length; j++) {
            
        //     // get the REC with respect to token
        //     if(recPool[j].recTokenId == _recTokenId) {
        //         recPool[j].owner = buyer;
        //     }

        // }
    }

    function getEnergyPoolSize() public view returns (uint256) {
        return energyPool.length;
    }

    function getRECPoolSize() public view returns (uint256) {
        return recPool.length;
    }

}

contract EtherReceiver {

    function () public payable {}
}



