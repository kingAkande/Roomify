// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract HotelManagement {
    // Struct to store room details
    struct Room {
        uint id;
        uint price;
        string roomType;
        bool isAvailable;
    }

    // Struct to store booking details
    struct Booking {
        address user;
        uint checkInDate;
        uint checkOutDate;
        bool isActive;
    }

    // Mapping to store rooms by room ID
    mapping(uint => Room) public rooms;

    // Nested mapping to store bookings by room ID and user address
    mapping(uint => mapping(address => Booking)) public bookings;

    // Array to store booking history
    Booking[] public bookingHistory;

    // Address of the contract owner (hotel owner)
    address public hotelOwner;

    // Events to log actions
    event RoomAdded(uint roomId, uint price, string roomType);
    event RoomUpdated(uint roomId, uint newPrice, string newRoomType);
    event RoomBooked(uint roomId, address user, uint checkInDate, uint checkOutDate);
    event BookingCancelled(uint roomId, address user);
    event PaymentReceived(uint roomId, address user, uint amount);
    
    constructor() {
        hotelOwner = msg.sender;
    }

    // Modifier to restrict functions to the hotel owner
    modifier onlyOwner() {
        require(msg.sender == hotelOwner, "Not the hotel owner");
        _;
    }

    // Function to add a room
    function addRoom(uint roomId, uint price, string memory roomType) public onlyOwner {
        rooms[roomId] = Room(roomId, price, roomType, true);
        emit RoomAdded(roomId, price, roomType);
    }

    // Function to update room details
    function updateRoom(uint roomId, uint newPrice, string memory newRoomType) public onlyOwner {
        Room storage room = rooms[roomId];
        room.price = newPrice;
        room.roomType = newRoomType;
        emit RoomUpdated(roomId, newPrice, newRoomType);
    }

    // Function to check if a room is available for a given date range
    function isRoomAvailable(uint roomId, uint checkIn, uint checkOut) public view returns (bool) {
        Room memory room = rooms[roomId];
        if (!room.isAvailable) {
            return false;
        }

        // Check against all past bookings for that room
        for (uint i = 0; i < bookingHistory.length; i++) {
            Booking memory booking = bookingHistory[i];
            if (booking.isActive && 
                booking.checkInDate < checkOut && 
                booking.checkOutDate > checkIn) {
                return false; // Overlapping booking found
            }
        }
        return true; // Room is available
    }

    // Function to book a room
    function bookRoom(uint roomId, uint checkIn, uint checkOut) public payable {
        require(rooms[roomId].isAvailable, "Room is not available");
        require(isRoomAvailable(roomId, checkIn, checkOut), "Room is already booked for this period");
        require(msg.value >= rooms[roomId].price, "Insufficient payment");

        bookings[roomId][msg.sender] = Booking(msg.sender, checkIn, checkOut, true);
        bookingHistory.push(Booking(msg.sender, checkIn, checkOut, true));
        
        emit RoomBooked(roomId, msg.sender, checkIn, checkOut);
        emit PaymentReceived(roomId, msg.sender, msg.value);
    }

    // Function to cancel a booking
    function cancelBooking(uint roomId) public {
        Booking storage booking = bookings[roomId][msg.sender];
        require(booking.isActive, "No active booking found");

        booking.isActive = false;
        rooms[roomId].isAvailable = true;

        // Refund the user
        payable(msg.sender).transfer(rooms[roomId].price);

        emit BookingCancelled(roomId, msg.sender);
    }

    // Function to withdraw funds by the hotel owner
    function withdrawFunds() public onlyOwner {
        uint balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");
        payable(hotelOwner).transfer(balance);
    }
}
