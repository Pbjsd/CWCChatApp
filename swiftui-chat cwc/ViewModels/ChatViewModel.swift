//
//  ChatViewModel.swift
//  swiftui-chat cwc
//
//  Created by Panchi on 2/7/23.
//

import Foundation
import SwiftUI

class ChatViewModel: ObservableObject {
    
    @Published var chats = [Chat]()
    
    @Published var selectedChat: Chat?
    
    @Published var messages = [ChatMessage]()
    
    var databaseService = DatabaseService()
    
    init() {
        
        // Retrieve chats when ChatViewModel is created
        getChats()
    }
    
    func getChats() {
        
        // Use the database service to retrieve the chats
        databaseService.getAllChats { chats in
            
            // Set the retrieved data to the chats property
            self.chats = chats
        }
    }
    
    /// Search for chat with passed in user. If found, set as selected chat. If not found, create a new chat
    func getChatFor(contact: User) {
     
        // Check the user
        guard contact.id != nil else {
            return
        }
        
        let foundChat = chats.filter { chat in
            
            return chat.numparticipants == 2 && chat.participantids.contains(contact.id!)
        }
        
        // Found a chat between the user and the contact
        if !foundChat.isEmpty {
            self.selectedChat = foundChat.first!
        }
        else {
            // No chat was found, create a new one
            var newChat = Chat(id: nil,
                               numparticipants: 2,
                               participantids: [AuthViewModel.getLoggedInUserId(), contact.id!],
                               lastmsg: nil, updated: nil, msgs: nil)
            
            // Save new chat to the database
            databaseService.createChat(chat: newChat) { docId in
                
                // Set doc id from the auto generated document in the database
                newChat.id = docId
                
                // Set as selected chat
                self.selectedChat = newChat
            }
            
           
        }
    }
    
    func getMessages() {
        
        // Check that there's a selected chat
        guard selectedChat != nil else {
            return
        }
        
        databaseService.getAllMessages(chat: selectedChat!) { msgs in
            
            // Set returned messages to property
            self.messages = msgs
        }
        
    }
    
    func sendMessage(msg: String) {
        
        // Check that we have a selected chat
        guard selectedChat != nil else {
            return
        }
        
        databaseService.sendMessage(msg: msg, chat: selectedChat!)
        
    }
    
    // MARK: - Helper Methods
    
    /// Tasks in a list of user ids, removes the user from that list and returns the remaining ids
    func getParticipantIds() -> [String] {
        
        // Check that we have a selected chat
        guard selectedChat != nil else {
            return [String]()
        }
        
        // Filter out the user's id 
        let ids = selectedChat!.participantids.filter { id in
            id != AuthViewModel.getLoggedInUserId()
        }
        
        return ids
    }
    
}
