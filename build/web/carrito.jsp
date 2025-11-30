<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
    // Validación de sesión
    if(session.getAttribute("idUsuario") == null){
        response.sendRedirect("login.jsp");
        return;
    }

    int idUser = (int) session.getAttribute("idUsuario");

    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3307/cafeteria?useSSL=false", "root", ""
    );

    // Obtener último carrito del usuario
    PreparedStatement psCar = con.prepareStatement(
        "SELECT * FROM carrito WHERE idUsuario=? ORDER BY idCarrito DESC LIMIT 1"
    );
    psCar.setInt(1, idUser);
    ResultSet car = psCar.executeQuery();

    int idCarrito = 0;
    if(car.next()) idCarrito = car.getInt("idCarrito");

    // Obtener items del carrito
    PreparedStatement psItems = con.prepareStatement(
        "SELECT i.*, p.nombre, p.imagen, p.precio FROM item_carrito i " +
        "JOIN producto p ON i.idProducto=p.idProducto " +
        "WHERE idCarrito=?"
    );
    psItems.setInt(1, idCarrito);
    ResultSet items = psItems.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
    <title>Mi carrito - DonMeow</title>
    <link rel="stylesheet" href="css/estilos.css">
</head>

<body class="principal-body">

<!-- HEADER -->
<header class="header-cliente">
    <div class="logo-cliente">
        <img src="img/logo.png">
        <span>DonMeow</span>
    </div>

    <input class="buscar" placeholder="Buscar productos...">

    <nav class="nav-cliente">
        <div class="menu-pedidos">
            <span class="menu-trigger">Mis pedidos ▾</span>
            <ul class="menu-list">
                <li><a href="misPedidos.jsp">Historial</a></li>
                <li><a href="pendientes.jsp">Pendientes</a></li>
            </ul>
        </div>

        <a href="carrito.jsp">🛒 Carrito</a>
        <a href="logout.jsp">Cerrar Sesión</a>
    </nav>
</header>

<!-- TÍTULO -->
<h1 class="titulo-carrito">Mi carrito de compra</h1>

<div class="carrito-contenedor">

    <!-- LISTA DE PRODUCTOS -->
    <div class="carrito-lista">

        <%
            double total = 0;
            boolean hayProductos = false;

            while(items.next()){
                hayProductos = true;
                double sub = items.getInt("cantidad") * items.getDouble("precioUnitario");
                total += sub;
        %>

        <div class="carrito-item">
            <img src="img/<%= items.getString("imagen") %>" class="carrito-img">

            <div class="carrito-info">
                <h3><%= items.getString("nombre") %></h3>
                <p><b>$<%= items.getDouble("precio") %></b></p>
                <p>Cantidad: <%= items.getInt("cantidad") %></p>
            </div>

            <a href="EliminarItemCarrito?id=<%= items.getInt("idItem") %>"
               class="carrito-eliminar">🗑 Eliminar</a>
        </div>

        <% } %>

        <% if(!hayProductos){ %>
            <p class="vacio">Tu carrito está vacío.</p>
        <% } %>

        <a href="indexCliente.jsp" class="btn-seguir">Seguir comprando</a>
    </div>

    <!-- RESUMEN DEL TOTAL -->
    <div class="carrito-total-box">
        <h3>Total estimado:</h3>
        <p class="total-valor">$<%= total %></p>

        <a href="pago.jsp" class="btn-confirmar">Continuar con el pago</a>
    </div>

</div>

<!-- RECOMENDACIONES -->
<h2 class="recomendaciones-titulo">Recomendaciones para ti</h2>

<div class="recomendaciones">

<%
    PreparedStatement psRec = con.prepareStatement(
        "SELECT * FROM producto WHERE activo=1 ORDER BY RAND() LIMIT 3"
    );
    ResultSet recs = psRec.executeQuery();

    while(recs.next()){
%>

    <div class="rec-item">
        <img src="img/<%= recs.getString("imagen") %>" class="rec-img">

        <h4><%= recs.getString("nombre") %></h4>
        <p><b>$<%= recs.getDouble("precio") %></b></p>

        <a href="AgregarCarrito?producto=<%= recs.getInt("idProducto") %>"
           class="rec-agregar">🛒</a>
    </div>

<%
    }
%>

</div>

</body>
</html>

<%
con.close();
%>
