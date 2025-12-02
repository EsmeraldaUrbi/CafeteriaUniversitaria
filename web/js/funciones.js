document.addEventListener("DOMContentLoaded", () => {

    const modalConfirmar = document.getElementById("modalConfirmar");
    const modalEliminado = document.getElementById("modalEliminado");
    const modalGuardado = document.getElementById("modalGuardado");
    const btnEliminar = document.getElementById("btnEliminar");
    if (btnEliminar) {
        btnEliminar.onclick = () => {
            modalConfirmar.style.display = "flex";
        };
    }

    const btnCancelar = document.getElementById("btnCancelarEliminar");
    if (btnCancelar) {
        btnCancelar.onclick = () => {
            modalConfirmar.style.display = "none";
        };
    }

    const btnConfirmarEliminar = document.getElementById("btnConfirmarEliminar");
    if (btnConfirmarEliminar) {
        btnConfirmarEliminar.onclick = () => {
            const id = new URLSearchParams(window.location.search).get("id");
            window.location.href = "EliminarProducto?id=" + id;
        };
    }

    if (window.location.search.includes("eliminado=1")) {
        modalEliminado.style.display = "flex";
    }

    if (window.location.search.includes("guardado=1")) {
        modalGuardado.style.display = "flex";
    }
});

document.addEventListener("DOMContentLoaded", function () {
    const agregado = document.body.dataset.agregado;
    if (agregado === "1") {
        const popup = document.getElementById("popupCarrito");
        if (popup) popup.style.display = "flex";
    }
});

function cerrarPopup() {
    const popup = document.getElementById("popupCarrito");
    if (popup) popup.style.display = "none";
}


function cambiarCantidad(delta) {
    const input = document.getElementById("cantidadInput");
    const hidden = document.getElementById("cantidadForm");

    let val = parseInt(input.value) + delta;
    if (val < 1) val = 1;

    input.value = val;
    hidden.value = val;
}

function comprarAhora(id) {
    const cantidad = document.getElementById("cantidadInput").value;
    window.location.href = "ComprarAhora?id=" + id + "&cantidad=" + cantidad;
}

function cerrarPopup() {
    document.getElementById("popupCarrito").style.display = "none";
}


