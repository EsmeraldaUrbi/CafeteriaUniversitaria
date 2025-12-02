<%@ page import="classes.Carrito" %>
<%@ page import="classes.ItemCarrito" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
    
    if (session.getAttribute("idUsuario") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    
    Carrito carrito = (Carrito) session.getAttribute("carrito");

    
    if (carrito == null || carrito.getItems().isEmpty()) {
        response.sendRedirect("carrito.jsp");
        return;
    }

    double total = carrito.calcularSubtotal();
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Pagar pedido - DonMeow</title>
    <link rel="stylesheet" href="css/estilos.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>

<body class="principal-body">

<header class="header-cliente">
    <div class="logo-cliente">
        <img src="img/logo.png">
        <span>DonMeow</span>
    </div>

    <form action="BuscarProducto" method="GET" class="form-buscar">
        <input type="text" name="q" class="buscar" placeholder="Buscar productos…">
    </form>

    <nav class="nav-cliente">
        <div class="menu-pedidos" data-dropdown>
            <span class="menu-trigger" data-trigger>Mis pedidos</span>

            <ul class="menu-list" data-menu>
                <li><a href="misPedidos.jsp">Historial</a></li>
                <li><a href="pendientes.jsp">Pendientes</a></li>
            </ul>
        </div>

        <a href="carrito.jsp"><i class="fa-solid fa-cart-shopping"></i> Carrito</a>
        <a href="CerrarSesion">Cerrar Sesión</a>
    </nav>
</header>
<article class="contenido">
    <a href="javascript:history.back()" class="regresar-link">⟵ Regresar</a>

    <div class="pago-container">
        <div class="pago-form">

            <h2>Total a pagar</h2>

            <div class="total-box">
                $<%= String.format("%.2f", total) %>
            </div>

            <h3>Método de pago</h3>

            <form action="ProcesarPago" method="post">

                <input type="hidden" name="monto" value="<%= total %>">

                <label>Número de tarjeta:</label>
                <input type="text" class="input-pago" name="tarjeta" required maxlength="16">

                <label>Nombre en la tarjeta:</label>
                <input type="text" class="input-pago" name="nombreTarjeta" required>

                <div class="fila">
                    <input type="text" class="input-fecha" name="fecha" placeholder="MM/AA" required maxlength="5">
                    <input type="text" class="input-cvv" name="cvv" placeholder="CVV" required maxlength="3">
                </div>

                <label class="checkbox-info">
                    <input type="checkbox"> Guardar información para futuras compras
                </label>

                <button type="submit" class="btn-pago">Pagar pedido</button>

            </form>

        </div>

        <div class="pago-gato">
            <img src="img/gato_cafe.png">
        </div>
    </div>
</article>

<footer class="footer">
    <p>© 2025 DonMeow - Cafetería Universitaria • Modelos de Desarrollo Web</p>
</footer>
<script src="js/validaciones.js"></script>

</body>
</html>
