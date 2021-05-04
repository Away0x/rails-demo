import $ from 'jquery'

import createRoomChannel from '../channels/room_channel'

$(document).on('turbolinks:load', () => {
    createRoomChannel()
    submit_message()
    scroll_bottom()
})
  
function submit_message() {
    $('#message_content').on('keydown', (event) => {
        if (event.keyCode === 13 && !event.shiftKey) {
            $('input').click()
            event.target.value = ""
            event.preventDefault()
        }
    })
}

function scroll_bottom() {
    $('#messages').scrollTop($('#messages')[0].scrollHeight)
}

