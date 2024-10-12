// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;


contract Hotelmgt {

    uint8 roomNumber;
    address owner;

    constructor(){
        owner = msg.sender;
    }

    struct Room {

    uint8 id;
    uint256 price;
    string roomType;
    bool isAvailable;

    }

    struct Booking {
    address user;
    uint256 amount;
    string checkInDate;
    string checkOutDate;
    bool isActive;

}


    enum RoomStandard{
        basic,
        standard,
        premium
    }

    //RoomStandard standard;

    modifier onlyOwner(){

        require(msg.sender == owner , "not owner");
        _;
    }

    mapping (uint => Room) roomInfo; 
    mapping (uint => bool) booked;
    mapping(uint => mapping(address => Booking)) public bookings;


    uint[]private roomIds;
    mapping(uint => address[])private usersPerRoom;

    function createRoom(RoomStandard _standard ) external onlyOwner {

        require(msg.sender != address(0), "Zero Address");

        uint8 _id = roomNumber+1;

        Room storage rooM = roomInfo[_id];

        rooM.id = _id;
        rooM.isAvailable = true;
    

        if(_standard == RoomStandard.basic){
            roomInfo[_id].price= 1000;
            rooM.roomType = "Basic";
        }else if (_standard == RoomStandard.standard){
            roomInfo[_id].price = 2000;
             rooM.roomType = "Standard";
        } else {
          roomInfo[_id].price= 3000;
          rooM.roomType = "Premium";
        }

        roomNumber++;
        roomIds.push(_id);

    }


    function getCreatedRooms(uint8 _id)external onlyOwner view returns (Room memory)  {
        require(_id >0 && _id<= roomNumber , "ID is invalid");
        return roomInfo[_id];
    }

    function getAllRooms() external onlyOwner view returns (Room[] memory) {
    
    Room[] memory rooms = new Room[](roomNumber);
    for (uint8 i = 1; i <= roomNumber; i++) {
        rooms[i - 1] = roomInfo[i];
    }
    return rooms;
}


    function bookRoom(uint256 _id,  string memory _checkInDate,  string memory _checkOutDate )external payable  {
        
        require(msg.sender != address(0), "Zero Address");

        require(msg.value >= roomInfo[_id].price, "insufficient Amount");

        require(roomInfo[_id].isAvailable , "not available");
        require(!booked[_id], "Room Already booked");
      

        Booking storage bK = bookings[_id][msg.sender];
        bK.user = msg.sender;
        bK.amount = msg.value;
        bK.checkInDate = _checkInDate;
        bK.checkOutDate = _checkOutDate;
        bK.isActive = true;

      

        booked[_id] = true;
        roomInfo[_id].isAvailable = false;
        usersPerRoom[_id].push(msg.sender); 

    }



    function getAllBookings() external onlyOwner view returns (Booking[] memory) {

        uint totalBookings = 0;

        // First, calculate how many bookings exist
        for (uint i = 0; i < roomIds.length; i++) {
            uint roomId = roomIds[i];
            totalBookings += usersPerRoom[roomId].length;
        }

        // Create an array to hold all bookings
        Booking[] memory allBookings = new Booking[](totalBookings);
        uint bookingIndex = 0;

        // Now, iterate through rooms and users to gather all bookings
        for (uint i = 0; i < roomIds.length; i++) {
            uint roomId = roomIds[i];
            address[] memory users = usersPerRoom[roomId];

        for (uint j = 0; j < users.length; j++) {
                address user = users[j];
                Booking memory booking = bookings[roomId][user];
                allBookings[bookingIndex] = booking;
                bookingIndex++;
            }
        }

        return allBookings;
    }


    
 
    function cancelBooking(uint _id)external payable  {

        require(msg.sender != address(0), "Zero Address");

        require(bookings[_id][msg.sender].isActive,"No bookings");

        require(bookings[_id][msg.sender].amount > 0, "Zero amount");

        bookings[_id][msg.sender].isActive = false;

        roomInfo[_id].isAvailable = true;

        booked[_id] = false;

    
        payable(msg.sender).transfer(bookings[_id][msg.sender].amount);

        bookings[_id][msg.sender].amount = 0;

        
    }


}


