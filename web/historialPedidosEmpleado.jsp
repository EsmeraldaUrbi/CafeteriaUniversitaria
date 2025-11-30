<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8"%>

<%
    // Verificar que es empleado
    if(session.getAttribute("tipo") == null ||
       !session.getAttribute("tipo").equals("empleado")){
        response.sendRedirect("login.jsp");
        return;
    }

    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3307/cafeteria?useSSL=false", "root", ""
    );

    // Obtener todas las fechas donde hubo pedidos (ordenadas)
    PreparedStatement psFechas = con.prepareStatement(
        "SELECT DISTINCT fecha FROM pedido ORDER BY fecha DESC"
    );
    ResultSet fechas = psFechas.executeQuery();
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Historial de pedidos - DonMeow</title>
    <link rel="stylesheet" href="css/estilos.css">
</head>

<body class="principal-body">

<!-- HEADER -->
<header class="header-cliente">
    <div class="logo-cliente">
        <img src="img/logo.png">
        <span>DonMeow</span>
    </div>

    <input type="text" class="buscar" placeholder="Buscar pedidos…">

    <nav class="nav-cliente">
        <div class="menu-pedidos-emp">
            <span class="menu-trigger-emp">🍽️ Pedidos</span>
            <ul class="menu-list-emp">
                <li><a href="panelEmpleado.jsp">Historial</a></li>
                <li><a href="gestionMenu.jsp">Gestión</a></li>
            </ul>
            <a href="gestionMenu.jsp">📋 Gestión de Menú</a>
        </div>
        <a href="logout.jsp">Cerrar Sesión</a>
    </nav>
</header>

<!-- TÍTULO -->
<h1 class="titulo-historial">Historial de pedidos de la cafetería</h1>

<div class="historial-container">

    <!-- Imagen decorativa -->
    <div class="historial-dibujo">
        <img src="img/gato_caja.png" alt="gato">
    </div>

    <div class="historial-lista">

    <%
        while(fechas.next()){
            String fecha = fechas.getString("fecha");

            // Consultar pedidos de esa fecha
            PreparedStatement psPedidos = con.prepareStatement(
                "SELECT * FROM pedido WHERE fecha=? ORDER BY idPedido DESC"
            );
            psPedidos.setString(1, fecha);
            ResultSet pedidos = psPedidos.executeQuery();

            double totalVenta = 0;
    %>

        <!-- Encabezado del día -->
        <h2 class="fecha-titulo"><%= fecha %> ▼</h2>

        <!-- Lista de pedidos -->
        <%
            while(pedidos.next()){
                int idPedido = pedidos.getInt("idPedido");
                double totalPedido = pedidos.getDouble("total");

                totalVenta += totalPedido;

                // Obtener productos del pedido
                PreparedStatement psItems = con.prepareStatement(
                    "SELECT p.nombre, p.precio, p.imagen, i.cantidad " +
                    "FROM producto p " +
                    "JOIN item_carrito i ON p.idProducto = i.idProducto " +
                    "JOIN carrito c ON i.idCarrito = c.idCarrito " +
                    "JOIN pedido pe ON pe.idCarrito = c.idCarrito " +
                    "WHERE pe.idPedido=?"
                );
                psItems.setInt(1, idPedido);
                ResultSet items = psItems.executeQuery();
        %>

        <div class="pedido-historial">

            <% if(items.next()) { %>

                <!-- Imagen del primer producto -->
                <img src="img/<%= items.getString("imagen") %>" class="img-pedido">

                <div class="info-pedido">
                    <h3><%= items.getString("nombre") %></h3>
                    <p>$<%= items.getDouble("precio") %></p>
                    <p>Cantidad: <%= items.getInt("cantidad") %></p>
                </div>

                <div class="total-pedido">
                    Total: <span>$<%= totalPedido %></span>
                </div>

            <% } %>

        </div>

        <% } // fin while pedidos %>

        <!-- Total de la venta del día -->
        <div class="total-dia">
            Total de la venta: <span>$<%= totalVenta %></span>
        </div>

    <% } // fin while fechas %>

    </div>

</div>

</body>
</html>

<%
con.close();
%>
