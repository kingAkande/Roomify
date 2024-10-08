
# Hotel Booking Management Smart Contract

This smart contract allows users to interact with a decentralized hotel booking system, enabling room creation, booking, and cancellation. The contract manages the availability of hotel rooms, handles payments, and provides a transparent and immutable record of bookings using the Ethereum blockchain.

# Features

1. Create Room (For Owners Only)

    The contract owner (hotel manager) can create rooms with specific characteristics.
    Each room has:
        ID: A unique identifier for each room.
        Price: Set by the owner.
        Room Type: Defined as Basic, Standard, or Premium through an enum (RoomStandard).
        Availability: Initially set to true, indicating the room is available for booking.

2. Book a Room

    Users can book available rooms by calling the bookRoom function.
    Requirements for booking:
        The room must be available.
        The user must send the required Ether to cover the room's price.
        A check-in and check-out date are specified by the user.
    Once booked:
        The room is marked as unavailable.
        The booking is stored, linked to the user's address.
        The user's booking is marked as active.

3. Cancel a Booking

    Users can cancel an existing booking if they no longer need the room.
    Upon cancellation:
        The room is marked as available.
        The booking is deactivated.
        The user is refunded the amount paid for the booking.

4. View All Rooms

    Users can retrieve a list of all rooms created, along with their details (availability, price, type).

5. Get All Bookings

    Users can retrieve all active bookings they have made.

6. Refund Mechanism

    Upon booking cancellation, the contract automatically transfers the paid Ether back to the user.

# Contract Functions

Owner Functions

    createRoom(): Allows the owner to create a new room, specifying the price and room type.
    onlyOwner modifier: Ensures that certain functions, like creating rooms, are only accessible to the contract owner.

User Functions

    bookRoom(): Allows users to book an available room by sending Ether and specifying their check-in/check-out dates.
    cancelBooking(): Enables users to cancel their booking and receive a refund.
    getAllRooms(): Retrieves the details of all created rooms.
    getAllBookings(): Provides users with their active bookings.

# Usage

    Deploy the Contract:
        The contract owner deploys the contract on the Ethereum network.

    Create Rooms:
        The owner creates rooms by specifying room details, such as price and type.

    Book a Room:
        Users can interact with the contract by sending Ether to book a room for a specific period.

    Cancel a Booking:
        Users can cancel their active bookings and receive a refund.

# Prerequisites

    Solidity ^0.8.24
    Hardhat or Truffle (for local testing and deployment)
    Node.js and npm (for package management)
    Ethereum wallet (e.g., MetaMask) for interaction

# Installation

    Clone the repository:

    bash

git clone https://github.com/your-username/your-repo.git

Navigate to the project directory:

bash

cd your-repo

Install dependencies:

bash

npm install

Compile the smart contract:

bash

npx hardhat compile

Deploy the smart contract to a local network:

bash

    npx hardhat run scripts/deploy.js --network localhost

# Testing

You can test the contract using Hardhat's testing framework:

bash

npx hardhat test

Future Improvements

    Dynamic Pricing: Allow dynamic room pricing based on demand or season.
    Multi-room Booking: Enable users to book multiple rooms at once.
    Loyalty Rewards: Implement a reward system for frequent users.

# License

This project is licensed under the MIT License.
