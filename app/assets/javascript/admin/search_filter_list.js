/*
 * This file is used for searching and filtering a list in form.
 * Example : in form 'registration', search filter the list of users to find the one we're looking for.
 */

document.addEventListener('DOMContentLoaded', (_) => {

    const data_models = document.querySelectorAll('[data-model]')
    for (let data_model of data_models) {
        const model_name = data_model.getAttribute('data-model')
        const can_select_multiple = data_model.getAttribute('data-multiple')
        init_filtering(model_name, can_select_multiple)
        // let obj = init_filtering(model_name)
        // console.log(obj['search_input'])
        // console.log(obj['list_results'])
        // console.log(obj['search_chosen'])
        // console.log(obj['list_ids'])
    }


    function init_filtering (model, can_select_multiple) {
        const search_input = document.getElementById(`search-input-${model}`)
        const list_results = document.querySelectorAll(`.result-item-${model}`)
        const list_ids = document.getElementById(`list-${model}_ids`)
        const search_chosen = document.getElementById(`search-chosen-${model}`)
        const children = search_chosen.childNodes[1]
        if (can_select_multiple && children) setup_preexisting_choice(search_chosen, list_ids)
        add_search_listener(search_input, list_results)
        add_results_listener(search_input, list_results, list_ids, search_chosen, model, can_select_multiple)
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

    function add_results_listener (search_input, list_results, list_ids, search_chosen, model, can_select_multiple) {
        list_results.forEach((r) => {
            r.addEventListener('click', (_) => {
                const id = r.getAttribute('id')
                let txt = r.innerText
                txt.innerText = txt.replace('<span class="highlight-search">', '')
                txt.innerText = txt.replace('</span>', '')
                if (!list_ids.value.includes(id.split('-')[1]))
                    add_to_result(search_chosen, txt, id, list_ids, model, can_select_multiple)
                search_input.value = ''
                hides_all(list_results)
            })
        })
    }

    function add_to_result(search_chosen, txt, id, list_ids, model, can_select_multiple) {
        const sub_cont = document.createElement('div')
        sub_cont.id = `for-${id}`
        const id_num = id.split('-')[1]
        sub_cont.className = 'item-selected'
        const text = document.createElement('div')
        text.innerText = txt
        if (can_select_multiple) {
            add_delete_btn(sub_cont, model, id_num, list_ids)
            sub_cont.appendChild(text)
            list_ids.value += `${id_num},`
            search_chosen.appendChild(sub_cont)
        } else {
            sub_cont.appendChild(text)
            list_ids.value = `${id_num},`
            const child = search_chosen.childNodes[1]
            if (child) { search_chosen.replaceChild(sub_cont, child) }
            else { search_chosen.appendChild(sub_cont) }
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

})
