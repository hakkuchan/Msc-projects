pragma solidity >=0.7.0;
// SPDX-License-Identifier: MIT
contract CarRental{
    // Data and Data Structures
    address payable customer;

    enum ContractState{rented, completed}
    enum CarState{used, broken, available}
    
    struct Car{ 
    uint carIndex;
    uint rentalPay; //rental cost, per day
    uint fixCost; //damage cost
    CarState currentCarState;
    }
    
    struct Contract{
        uint carIndex;
        address customer;
        ContractState currentContractState;
    }
    
    mapping (uint => Car) public inventoryList; 
    mapping (address => Contract) public contractManagementList; 

    //list of cars of ABC Renting
    constructor() payable{
       Car memory Car1 = Car(1, 100, 2000, CarState.available);
       Car memory Car2 = Car(2, 200, 3000, CarState.available);
       Car memory Car3 = Car(3, 300, 4000, CarState.available);
       inventoryList[Car1.carIndex] = Car1;
       inventoryList[Car2.carIndex] = Car2;
       inventoryList[Car3.carIndex] = Car3;
    }

    //check its availability
    function CheckAvailability(uint carIndex) public view returns(bool){
        return inventoryList[carIndex].currentCarState == CarState.available;
    }
    
    //check customer's balance
    modifier preRentalCheck(uint carIndex) {
        require(inventoryList[carIndex].currentCarState == CarState.available, "This car is unavailable for renting.");
        require(msg.value >= inventoryList[carIndex].rentalPay, "Insufficient money in your account.");
        _;
    }

    //pay the rent
    function applyForRent(uint carIndex) public payable{
        customer.transfer(msg.value);
        inventoryList[carIndex].currentCarState = CarState.used;
        contractManagementList[msg.sender] = Contract (carIndex, msg.sender, ContractState.rented); 
    }
    
    // one can only break the rental car
    modifier isCustomer() {
        require(contractManagementList[msg.sender].currentContractState == ContractState.rented, "You can't operate on cars which are not rented by you!");
        _;
    }

    //if the car is damaged
    function breakMyRentedCar() isCustomer public {
        inventoryList[contractManagementList[msg.sender].carIndex].currentCarState = CarState.broken;
    }
    
    //pay fix cost
    function fixMyRentedCar() isCustomer public payable returns (bool) {
        if(msg.value >=  inventoryList[contractManagementList[msg.sender].carIndex].fixCost) {
            customer.transfer(msg.value);
            inventoryList[contractManagementList[msg.sender].carIndex].currentCarState = CarState.used;
            return true;
          } else {
            return false;
          }
    }

    //check car condition
    modifier preReturnCheck() {
        require(inventoryList[contractManagementList[msg.sender].carIndex].currentCarState != CarState.broken, "Please pay for the damage.");
        _;
    }  
    
    //return the car
    function returnCar() isCustomer preReturnCheck public returns (bool){
        contractManagementList[msg.sender].currentContractState = ContractState.completed;
        inventoryList[contractManagementList[msg.sender].carIndex].currentCarState = CarState.available;
        return true;
    }

}