/*
 * This script is related to 'index' users
 */

document.addEventListener('DOMContentLoaded', (_) => {

    const cb_select_all = document.getElementById('select-all-user')
    const list_cb_user_id = document.querySelectorAll('[name="list_user_ids[]"]')
    cb_select_all.addEventListener('change', (cb) => {
        if (cb.target.checked === true) {
            list_cb_user_id.forEach(el => {
                el.checked = true
            })
        } else {
            list_cb_user_id.forEach(el => {
                el.checked = false
            })
        }
    })

})
