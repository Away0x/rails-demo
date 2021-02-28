import { Controller } from "stimulus"

export default class extends Controller {
    static targets = ['usingEmail', 'emailField', 'phoneField', 'switchBtn']

    connect() {
        const initData = this.usingEmailTarget.value
        this._switchFormName(initData === '1')
    }

    switchType(ev) {
        const targetIsEmail = ev.target.getAttribute('data-type') === 'email'
        this._switchFormName(!targetIsEmail)
    }

    _switchFormName(isEmail = true) {
        const showTarget = isEmail ? this.emailFieldTarget : this.phoneFieldTarget
        const hideTarget = !isEmail ? this.emailFieldTarget : this.phoneFieldTarget

        showTarget.classList.remove('disabled_form_field')
        showTarget.querySelector('input').removeAttribute('disabled')

        hideTarget.classList.add('disabled_form_field')
        hideTarget.querySelector('input').setAttribute('disabled', '1')

        this.usingEmailTarget.value = Number(isEmail)
    }
}
