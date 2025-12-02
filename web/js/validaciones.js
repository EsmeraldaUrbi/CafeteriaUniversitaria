document.addEventListener("DOMContentLoaded", () => {

    const inputs = document.querySelectorAll(
        "input[type='text'], input[type='password'], input[type='email']"
    );

    inputs.forEach(input => {
        if (!input.parentElement.classList.contains("campo")) {
            const wrapper = document.createElement("div");
            wrapper.classList.add("campo");

            input.parentNode.insertBefore(wrapper, input);
            wrapper.appendChild(input);
        }

        
        input.addEventListener("blur", () => validar(input));
    });


    function validar(input) {
        limpiarError(input);

        const valor = input.value.trim();
        const nombre = input.name;

        if (valor === "") {
            return mostrarError(input, "Este campo no puede estar vacío.");
        }

        if (nombre === "nombre" || nombre === "nombreTarjeta") {
            if (valor.length < 2) {
                return mostrarError(input, "El nombre debe tener al menos 2 caracteres.");
            }
            if (!/^[a-zA-ZÁÉÍÓÚáéíóúñÑ ]+$/.test(valor)) {
                return mostrarError(input, "El nombre solo puede contener letras.");
            }
        }

        if (nombre === "matricula") {
            if (!/^[a-zA-Z0-9]+$/.test(valor)) {
                return mostrarError(input, "Solo se permiten letras y números.");
            }
        }


        // Número de tarjeta
        if (nombre === "tarjeta") {
            if (!/^[0-9]{16}$/.test(valor)) {
                return mostrarError(input, "La tarjeta debe tener exactamente 16 dígitos.");
            }
        }

        if (nombre === "cvv") {
            if (!/^[0-9]{3}$/.test(valor)) {
                return mostrarError(input, "El CVV debe tener exactamente 3 dígitos.");
            }
        }

        return true;
    }


    const inputFecha = document.querySelector("input[name='fecha']");
    if (inputFecha) {
        inputFecha.addEventListener("input", (e) => {
            let valor = inputFecha.value.replace(/\D/g, "");  // solo números

            if (valor.length >= 3) {
                valor = valor.substring(0, 2) + "/" + valor.substring(2, 4);
            }

            inputFecha.value = valor.substring(0, 5);
        });

        inputFecha.addEventListener("blur", () => {
            limpiarError(inputFecha);

            if (!/^(0[1-9]|1[0-2])\/\d{2}$/.test(inputFecha.value)) {
                mostrarError(inputFecha, "Formato inválido. Usa MM/AA");
            }
        });
    }


    function mostrarError(input, mensaje) {
        input.classList.add("input-error");

        const msg = document.createElement("div");
        msg.classList.add("error-msg");
        msg.textContent = mensaje;

        input.parentElement.appendChild(msg);
        return false;
    }

    function limpiarError(input) {
        input.classList.remove("input-error");

        const err = input.parentElement.querySelector(".error-msg");
        if (err) err.remove();
    }
});
