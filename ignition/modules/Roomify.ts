// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";


const HotelManagementModule = buildModule("HotelManagementModule", (m) => {

  const hotelManagement = m.contract("HotelManagement");

  return { hotelManagement };
});

export default HotelManagementModule;
