/*
 * This script is related to 'index' registrations
 */

document.addEventListener('DOMContentLoaded', (_) => {
    const cb_select_all = document.querySelectorAll('[r-for-event]')
    cb_select_all.forEach(el => {
        const event_id = el.getAttribute('r-for-event')
        const list_cb = document.querySelectorAll(`.r-for-event-${event_id}`)
        el.addEventListener('change', (e) => {
            if (el.checked === true) {
                list_cb.forEach(cb => {
                    cb.checked = true
                })
            } else {
                list_cb.forEach(cb => {
                    cb.checked = false
                })
            }
        })
    })
})
