<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<%
    if (session.getAttribute("idUsuario") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String id = request.getParameter("id");
    if (id == null) {
        response.sendRedirect("indexCliente.jsp");
        return;
    }

    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3307/cafeteria?useSSL=false",
            "root", ""
    );

    PreparedStatement ps = con.prepareStatement(
            "SELECT * FROM producto WHERE idProducto=?"
    );
    ps.setInt(1, Integer.parseInt(id));
    ResultSet prod = ps.executeQuery();

    if (!prod.next()) {
        response.sendRedirect("indexCliente.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title><%= prod.getString("nombre") %> - DonMeow</title>
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

    <div class="producto-detalle-container">

        <div class="detalle-img">
            <img src="img/productos/<%= prod.getString("imagen") %>">
        </div>

        <div class="detalle-info">
            <h1><%= prod.getString("nombre") %></h1>
            <h2>$<%= prod.getDouble("precio") %></h2>
            <p><%= prod.getString("descripcion") %></p>
        </div>

        <div class="detalle-opciones">

            <label class="cant-label">Cantidad:</label>

            <div class="cant-control">
                <button type="button" class="btn-cant" onclick="cambiarCantidad(-1)">−</button>

                <input type="number" id="cantidadInput" name="cantidad"
                       value="1" min="1" class="input-cant">

                <button type="button" class="btn-cant" onclick="cambiarCantidad(1)">+</button>
            </div>

            <button class="btn-prod" onclick="comprarAhora(<%= id %>)">
                Comprar ahora
            </button>

            <form action="AgregarCarrito" method="POST">
                <input type="hidden" name="producto" value="<%= id %>">
                <input type="hidden" id="cantidadForm" name="cantidad" value="1">

                <button type="submit" class="btn-prod btn-agregar">
                    Agregar al carrito <i class="fa-solid fa-cart-shopping"></i>
                </button>
            </form>

        </div>

    </div>

    <div id="popupCarrito" class="modal-bg" style="display:none;">
        <div class="modal">
            <p>¡Producto añadido al carrito con éxito!</p>
            <div class="modal-buttons">
                <button class="btn-cancelar" onclick="cerrarPopup()">Seguir comprando</button>
                <button class="btn-confirmar" onclick="location.href='carrito.jsp'">Ir al carrito</button>
            </div>
        </div>
    </div>

</article>

<footer class="footer">
    <p>© 2025 DonMeow - Cafetería Universitaria • Modelos de Desarrollo Web</p>
</footer>

<script src="js/funciones.js"></script>

</body>
</html>

<%
    con.close();
%>
