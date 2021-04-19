/*
 * This file is used for searching and filtering a list in form.
 * Example : in form 'registration', search filter the list of users to find the one we're looking for.
 *
 *
 * Set attribute data-multiple = 'true'  if you want to allow multiple selection.
 * Set attribute data-null = 'true'  if you want to allow the data to be null.
 * Set attribute data-location-form-event = 'true' in location input in the event form.
 */

document.addEventListener('DOMContentLoaded', (_) => {

    const data_models = document.querySelectorAll('[data-model]')
    for (let data_model of data_models) {
        const options = {
            model_name: data_model.getAttribute('data-model'),
            can_select_multiple: data_model.getAttribute('data-multiple'),
            can_be_null: data_model.getAttribute('data-null'),
            location_form_event: data_model.getAttribute('data-location-form-event')
        }
        init_filtering(options)
        // let obj = init_filtering(model_name)
        // console.log(obj['search_input'])
        // console.log(obj['list_results'])
        // console.log(obj['search_chosen'])
        // console.log(obj['list_ids'])
    }
    document.querySelector('.link_add_activity').addEventListener('click', (_) => {
        setTimeout((_) => {
            const chosen_location = document.getElementById('search-chosen-Location').childNodes[1]
            if (chosen_location) {
                const location_id = chosen_location.id.split('-')[2]
                set_available_activities(location_id, 'last')
            }
        }, 200)
    })

})


function init_filtering (options) {
    const search_input = document.getElementById(`search-input-${options['model_name']}`)
    const list_results = document.querySelectorAll(`.result-item-${options['model_name']}`)
    const list_ids = document.getElementById(`list-${options['model_name']}_ids`)
    const search_chosen = document.getElementById(`search-chosen-${options['model_name']}`)
    const children = search_chosen.childNodes[1]
    if ((options['can_select_multiple'] || options['can_be_null']) && children)
        setup_preexisting_choice(search_chosen, list_ids)
    add_search_listener(search_input, list_results)
    add_results_listener(search_input, list_results, list_ids, search_chosen, options)
    // return {
    //     search_input: search_input,
    //     list_results: list_results,
    //     search_chosen: search_chosen,
    //     list_ids: list_ids
    // }
}

function add_search_listener (search_input, list_results) {
    search_input.addEventListener('keyup', (e) => {
        const search = e.target.value
        if (search === '') {
            hides_all(list_results)
            return
        }
        const reg = new RegExp(`(${search})`, 'i')
        list_results.forEach((result) => {
            const matched = result.innerText.match(reg)
            result.innerHTML = result.innerHTML.replace('<span class="highlight-search">', '')
            result.innerHTML = result.innerHTML.replace('</span>', '')
            if (matched) {
                result.innerHTML = result.innerHTML.replace(reg, `<span class="highlight-search">${matched[0]}</span>`)
                result.classList.remove('hidden')
            } else {
                result.classList.add('hidden')
            }
        })
    })
}

function add_results_listener (search_input, list_results, list_ids, search_chosen, options) {
    list_results.forEach((r) => {
        r.addEventListener('click', (_) => {
            const id = r.getAttribute('id')
            let txt = r.innerText
            txt.innerText = txt.replace('<span class="highlight-search">', '')
            txt.innerText = txt.replace('</span>', '')
            if (!list_ids.value.includes(id.split('-')[1]))
                add_to_result(search_chosen, txt, id, list_ids, options)
            search_input.value = ''
            hides_all(list_results)
        })
    })
}

function add_to_result(search_chosen, txt, id, list_ids, options) {
    const sub_cont = document.createElement('div')
    sub_cont.id = `for-${id}`
    const id_num = id.split('-')[1]
    sub_cont.className = 'item-selected'
    const text = document.createElement('div')
    text.innerText = txt
    if (options['can_select_multiple']) {
        add_delete_btn(sub_cont, options['model_name'], id_num, list_ids)
        sub_cont.appendChild(text)
        list_ids.value += `${id_num},`
        search_chosen.appendChild(sub_cont)
    } else {
        if (options['can_be_null']) add_delete_btn(sub_cont, options['model_name'], id_num, list_ids)
        sub_cont.appendChild(text)
        list_ids.value = `${id_num},`
        const child = search_chosen.childNodes[1]
        if (child) { search_chosen.replaceChild(sub_cont, child) }
        else { search_chosen.appendChild(sub_cont) }
        if (options['location_form_event']) {
            const location_id = sub_cont.id.split('-')[2]
            set_available_activities(location_id, 'all')
        }
    }
}

function add_delete_btn(parent, model, id, list_ids) {
    const delete_btn = document.createElement('i')
    delete_btn.classList.add('fas', 'fa-ban', 'delete-selected')
    delete_btn.style.color = 'red'
    parent.appendChild(delete_btn)
    delete_btn.addEventListener('click', (_) => {
        document.getElementById(`for-${model}-${id}`).remove()
        list_ids.value = list_ids.value.replace(`${id},`, '')
    })
}

function hides_all(list_results) {
    for (let r of list_results) {
        r.classList.add('hidden')
    }
}

function setup_preexisting_choice(search_chosen, list_ids) {
    list_ids.value = ''
    const list_item_selected = document.querySelectorAll('.item-selected')
    list_item_selected.forEach((selected) => {
        list_ids.value += `${selected.id.split('-')[2]},`
    })
    const list_selected = document.querySelectorAll('.delete-selected')
    list_selected.forEach((selected) => {
        selected.addEventListener('click', (e) => {
            const parent = e.target.parentElement
            const id = parent.getAttribute('id').split('-')[2]
            parent.remove()
            list_ids.value = list_ids.value.replace(`${id},`, '')
        })
    })
}

// ====================================================================================================
//
// ====================================================================================================

/*
 * This function fetches the activities and display them according to the activities available per location.
 * params -
 *   location_id => determines which activities to fetch based on the id of the location
 *   which_select => determines which select field from the form to update  !! EITHER 'all' or 'last' !!
 * exemple: get_available_activities(1, 'last') => will update only the last select field with the activities
 *          available for the location with id = 1
 */
function set_available_activities (location_id, which_select) {
    const all_selects = document.querySelectorAll('.change_with_location')
    let select_to_change
    switch (which_select) {
        case 'all': select_to_change = all_selects; break
        case 'last': select_to_change = []; select_to_change.push(all_selects[all_selects.length - 1]); break
    }
    fetch(`/admin/json/location_activities/${location_id}`)
        .then(result => result.json())
        .then(activities => {
            change_select_option(select_to_change, activities)
        })
}

function change_select_option (select_to_change, activities) {
    for (let select of select_to_change) {
        select.innerHTML = ''
        for (let activity of activities) {
            let option = document.createElement('option')
            option.value = activity['id']
            option.textContent = activity['name']
            select.appendChild(option)
        }
    }
}
