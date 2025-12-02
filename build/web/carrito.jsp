<%@ page import="java.sql.*" %>
<%@ page import="classes.Carrito" %>
<%@ page import="classes.ItemCarrito" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<%
    // Verificar login
    if (session.getAttribute("idUsuario") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Carrito carrito = (Carrito) session.getAttribute("carrito");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Mi carrito - DonMeow</title>
    <link rel="stylesheet" href="css/estilos.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>

<body class="principal-body">

<header class="header-cliente">
    <div class="logo-cliente">
        <img src="img/logo.png" alt="Logo DonMeow">
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

    <h1 class="titulo-carrito">Mi carrito de compra</h1>

<%
    if (carrito == null || carrito.getItems().isEmpty()) {
%>

    <div class="carrito-vacio">
        <p>Tu carrito está vacío.</p>
        <a href="indexCliente.jsp" class="regresar-link">Ver menú</a>
    </div>

<%
    } else {

        double total = carrito.calcularSubtotal();

        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3307/cafeteria?useSSL=false",
            "root", ""
        );

        PreparedStatement psProd = con.prepareStatement(
            "SELECT nombre, imagen FROM producto WHERE idProducto=?"
        );
%>

    <div class="carrito-contenido">

        <div class="carrito-lista">

        <%
            for (ItemCarrito it : carrito.getItems()) {

                psProd.setInt(1, it.getIdProducto());
                ResultSet rsP = psProd.executeQuery();

                String nombreProd = "Producto";
                String imagen = "sinimagen.png";

                if (rsP.next()) {
                    nombreProd = rsP.getString("nombre");
                    imagen = rsP.getString("imagen");
                }
        %>

            <div class="item-carrito">
                <img src="img/productos/<%= imagen %>" class="img-producto" alt="<%= nombreProd %>">

                <div class="info-item">
                    <h3><%= nombreProd %></h3>
                    <p>Precio: $<%= it.getPrecioUnitario() %></p>

                    <div class="cantidad-container">
                        <a class="btn-cantidad" href="ActualizarCantidadCarrito?id=<%= it.getIdProducto() %>&accion=-">−</a>
                        <span class="cantidad-num"><%= it.getCantidad() %></span>
                        <a class="btn-cantidad" href="ActualizarCantidadCarrito?id=<%= it.getIdProducto() %>&accion=%2B">+</a>
                    </div>

                    <p>Subtotal: $<%= it.getSubtotal() %></p>
                </div>

                <a href="EliminarItemCarrito?id=<%= it.getIdProducto() %>"
                   class="btn-eliminar">Eliminar</a>
            </div>

        <% } %>
        </div>

        <aside class="carrito-resumen">
            <h2>Total estimado:</h2>
            <p class="total-monto">$<%= total %></p>

            <a href="pago.jsp" class="btn-pago">Continuar con el pago</a>
        </aside>
    </div>

    <div class="carrito-acciones">
        <a href="indexCliente.jsp" class="btn-secundario">
            Seguir comprando
        </a>
    </div>

    <%
        PreparedStatement psRec = con.prepareStatement(
            "SELECT idProducto, nombre, precio, imagen " +
            "FROM producto WHERE activo = 1 ORDER BY RAND() LIMIT 3"
        );
        ResultSet recs = psRec.executeQuery();
    %>

    <h2 class="titulo-reco">Recomendaciones para ti</h2>

    <div class="reco-gato-layout">

        <div class="reco-container">
            <% while (recs.next()) { %>

                <div class="reco-item">
                    <img src="img/productos/<%= recs.getString("imagen") %>" class="reco-img" alt="<%= recs.getString("nombre") %>">
                    <h3><%= recs.getString("nombre") %></h3>
                    <p>$<%= recs.getDouble("precio") %></p>

                    <a class="btn-carrito" href="AgregarCarrito?producto=<%= recs.getInt("idProducto") %>">
                        <i class="fa-solid fa-cart-shopping"></i>
                    </a>
                </div>

            <% } %>
        </div>

        <div class="imagen-gato-carrito">
            <img src="img/gato_carro.png" alt="Gato Carrito">
        </div>
    </div>

<%
        con.close();
    }
%>

</article>

<footer class="footer">
    <p>© 2025 DonMeow - Cafetería Universitaria • Modelos de Desarrollo Web</p>
</footer>

</body>
</html>
