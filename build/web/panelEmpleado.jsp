<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8"%>

<%
    // Validar rol de empleado
    if(session.getAttribute("tipo") == null || 
       !session.getAttribute("tipo").equals("empleado")) {

        response.sendRedirect("login.jsp");
        return;
    }

    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3307/cafeteria?useSSL=false", "root", ""
    );

    // Consultas por estado
    PreparedStatement psPend = con.prepareStatement(
        "SELECT * FROM pedido WHERE estado='Pendiente' ORDER BY fecha DESC"
    );
    ResultSet pend = psPend.executeQuery();

    PreparedStatement psPrep = con.prepareStatement(
        "SELECT * FROM pedido WHERE estado='Preparando' ORDER BY fecha DESC"
    );
    ResultSet prep = psPrep.executeQuery();

    PreparedStatement psListo = con.prepareStatement(
        "SELECT * FROM pedido WHERE estado='Listo para recoger' ORDER BY fecha DESC"
    );
    ResultSet listo = psListo.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Pedidos - DonMeow</title>
    <link rel="stylesheet" href="css/estilos.css">
</head>

<body class="principal-body">

<!-- ================= HEADER ================= -->
<header class="header-cliente">
    <div class="logo-cliente">
        <img src="img/logo.png">
        <span>DonMeow</span>
    </div>

    <input type="text" class="buscar" placeholder="Buscar pedidos…">

    <nav class="nav-cliente">
        <div class="menu-pedidos-emp">
            <span class="menu-trigger-emp">
                <span class="icono">🍽️</span> Pedidos
            </span>

            <ul class="menu-list-emp">
                <li><a href="historialPedidosEmpleado.jsp">Historial</a></li>
                <li><a href="panelEmpleado.jsp">Gestión</a></li>
            </ul>
        </div>

        <a href="gestionMenu.jsp">📋 Gestión de Menú</a>
        <a href="logout.jsp">Cerrar Sesión</a>
    </nav>
</header>

<!-- ================= CUERPO ================= -->
<div class="panel-empleado-container">

    <!-- Pendientes -->
    <div class="columna">
        <h2>Pendientes</h2>

        <%
            while(pend.next()){
                int idPedido = pend.getInt("idPedido");

                // Buscar imagen del primer producto del pedido
                PreparedStatement psImg = con.prepareStatement(
                    "SELECT p.imagen FROM producto p " +
                    "JOIN item_carrito i ON p.idProducto = i.idProducto " +
                    "JOIN carrito c ON i.idCarrito = c.idCarrito " +
                    "JOIN pedido pe ON pe.idCarrito = c.idCarrito " +
                    "WHERE pe.idPedido=? LIMIT 1"
                );
                psImg.setInt(1, idPedido);
                ResultSet img = psImg.executeQuery();
                
                String imagen = "sinimagen.png";
                if(img.next()){
                    imagen = img.getString(1);
                }
        %>

        <div class="tarjeta-pedido">
            <img src="img/<%= imagen %>">
            <div>
                <p><b>Pedido #<%= idPedido %></b></p>
                <a href="verPedido.jsp?id=<%= idPedido %>" class="btn-ver">Ver pedido</a>
            </div>
        </div>

        <% } %>
    </div>

    <!-- En preparación -->
    <div class="columna">
        <h2>En preparación</h2>

        <%
            while(prep.next()){
                int idPedido = prep.getInt("idPedido");

                PreparedStatement psImg = con.prepareStatement(
                    "SELECT p.imagen FROM producto p " +
                    "JOIN item_carrito i ON p.idProducto = i.idProducto " +
                    "JOIN carrito c ON i.idCarrito = c.idCarrito " +
                    "JOIN pedido pe ON pe.idCarrito = c.idCarrito " +
                    "WHERE pe.idPedido=? LIMIT 1"
                );
                psImg.setInt(1, idPedido);
                ResultSet img = psImg.executeQuery();
                
                String imagen = "sinimagen.png";
                if(img.next()){
                    imagen = img.getString(1);
                }
        %>

        <div class="tarjeta-pedido">
            <img src="img/<%= imagen %>">
            <div>
                <p><b>Pedido #<%= idPedido %></b></p>
                <a href="verPedido.jsp?id=<%= idPedido %>" class="btn-ver">Ver pedido</a>
            </div>
        </div>

        <% } %>
    </div>

    <!-- Listos para recoger -->
    <div class="columna">
        <h2>Listos para recoger</h2>

        <%
            while(listo.next()){
                int idPedido = listo.getInt("idPedido");

                PreparedStatement psImg = con.prepareStatement(
                    "SELECT p.imagen FROM producto p " +
                    "JOIN item_carrito i ON p.idProducto = i.idProducto " +
                    "JOIN carrito c ON i.idCarrito = c.idCarrito " +
                    "JOIN pedido pe ON pe.idCarrito = c.idCarrito " +
                    "WHERE pe.idPedido=? LIMIT 1"
                );
                psImg.setInt(1, idPedido);
                ResultSet img = psImg.executeQuery();
                
                String imagen = "sinimagen.png";
                if(img.next()){
                    imagen = img.getString(1);
                }
        %>

        <div class="tarjeta-pedido">
            <img src="img/<%= imagen %>">
            <div>
                <p><b>Pedido #<%= idPedido %></b></p>
                <a href="verPedido.jsp?id=<%= idPedido %>" class="btn-ver">Ver pedido</a>
            </div>
        </div>

        <% } %>
    </div>

</div>

</body>
</html>

<%
con.close();
%>
