import $ from 'jquery'

import consumer from './consumer'

const createRoomChannel = function(name, connection) {
    return consumer.subscriptions.create({channel: "RoomChannel", name}, {
        connected() {
            console.log("room channel connected")
        },

        disconnected() {
            console.log("room channel disconnected")
        },

        received(data) {
            console.log(data)
            data.mention && alert("You have a new mention") 
            if (data.message) $('#messages-table').append(data.message)
        }
    });
}

export default createRoomChannel;
