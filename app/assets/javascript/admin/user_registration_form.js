/*
 * This file is here to show the user form if a user has not been found when saving a location, event, or supplier
 */

document.addEventListener('DOMContentLoaded', (_) => {
    const elements = {
        user_form: document.getElementById('user-model-form'),
        // We change the value for the one below if we add a new user
        // So in the controller, we know if we discard empty fields for user form or if we validates them
        creating_new_user: document.getElementById('creating-new-user'),
        btn_add_user: document.querySelector('.btn-add_user'),
        btn_delete_form: document.querySelector('.btn-delete-add_user')
    }
    let user_form_empty = true
    const required_fields = elements['user_form'].querySelectorAll('.form-control.required')
    required_fields.forEach(field => {
        const parent = field.parentElement
        if (parent.className === 'field_with_errors') user_form_empty = false
        if (field.value) user_form_empty = false
    })
    if (!user_form_empty) show_user_form(elements)

    elements['btn_add_user'].addEventListener('click', (_) => {
        show_user_form(elements)
    })

    elements['btn_delete_form'].addEventListener('click', (_) => {
        hide_user_form(elements, required_fields)
    })
})

function show_user_form (elements) {
    elements['user_form'].classList.remove('hidden')
    elements['creating_new_user'].value = '1'
    elements['btn_add_user'].classList.add('hidden')
    elements['btn_delete_form'].classList.remove('hidden')
}

function hide_user_form (elements, required_fields) {
    elements['user_form'].classList.add('hidden')
    elements['creating_new_user'].value = '0'
    elements['btn_add_user'].classList.remove('hidden')
    elements['btn_delete_form'].classList.add('hidden')
    required_fields.forEach(field => {
        field.value = null
    })
}
