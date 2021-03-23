/*
 * This file is meant for the form in the section 'CRUD event'
 */

document.addEventListener('DOMContentLoaded', (event) => {
    const select_location = document.getElementById('event_location_id')
    let location_id = select_location.value
    const event_id = document.getElementById('event_id').value
    if (event_id == 0) {
        set_available_activities(location_id, 'all')
    }
    const sim_ac = document.getElementById('event_event_activities_attributes_0_simultaneous_activities').value
    if (sim_ac == '') set_available_activities(location_id, 'all')
    select_location.addEventListener('change', (e) => {
        location_id = e.target.value
        set_available_activities(location_id, 'all')
    })

    document.querySelector('.link_add_activity').addEventListener('click', (e)=>{
        setTimeout((action) => {
            set_available_activities(location_id, 'last')
        }, 200)
    })
})

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
