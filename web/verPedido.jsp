<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8"%>

<%
    // Validar empleado
    if(session.getAttribute("tipo") == null ||
       !session.getAttribute("tipo").equals("empleado")){
        response.sendRedirect("login.jsp");
        return;
    }

    String idPedido = request.getParameter("id");
    if(idPedido == null){
        response.sendRedirect("panelEmpleado.jsp");
        return;
    }

    // Conexión BD
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3307/cafeteria?useSSL=false", "root", ""
    );

    // Datos del pedido
    PreparedStatement ps = con.prepareStatement(
        "SELECT * FROM pedido WHERE idPedido=?"
    );
    ps.setInt(1, Integer.parseInt(idPedido));
    ResultSet pedido = ps.executeQuery();

    if(!pedido.next()){
        response.sendRedirect("panelEmpleado.jsp");
        return;
    }

    String estado = pedido.getString("estado");

    // Obtener productos del pedido
    PreparedStatement psItems = con.prepareStatement(
        "SELECT p.nombre, p.precio, p.imagen, i.cantidad " +
        "FROM producto p " +
        "JOIN item_carrito i ON p.idProducto = i.idProducto " +
        "JOIN carrito c ON i.idCarrito = c.idCarrito " +
        "JOIN pedido pe ON pe.idCarrito = c.idCarrito " +
        "WHERE pe.idPedido=?"
    );
    psItems.setInt(1, Integer.parseInt(idPedido));
    ResultSet items = psItems.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Pedido <%= idPedido %></title>
    <link rel="stylesheet" href="css/estilos.css">
</head>

<body class="principal-body">

<!-- HEADER -->
<header class="header-cliente">
    <div class="logo-cliente">
        <img src="img/logo.png">
        <span>DonMeow</span>
    </div>

    <input type="text" class="buscar" placeholder="Buscar productos…">

    <nav class="nav-cliente">
        <a href="panelEmpleado.jsp" class="nav-link-emp">🍽️ Pedidos</a>
        <a href="gestionMenu.jsp" class="nav-link-emp">📋 Gestión de Menú</a>
        <a href="logout.jsp" class="nav-link-emp">Cerrar Sesión</a>
    </nav>
</header>

<!-- REGRESAR -->
<a href="panelEmpleado.jsp" class="regresar-link">⟵ Regresar</a>

<h1 style="margin-left:40px;">Pedido #<%= idPedido %></h1>

<div class="pedido-ver-contenedor">

    <!-- INFORMACIÓN DEL PEDIDO -->
    <div class="pedido-box">

        <p><b>Fecha:</b> <%= pedido.getString("fecha") %></p>

        <% if(items.next()) { %>
        <div class="pedido-item">
            <img src="img/<%= items.getString("imagen") %>" class="pedido-img-small">

            <div class="pedido-info">
                <h3><%= items.getString("nombre") %></h3>
                <p>$<%= items.getDouble("precio") %></p>
                <p>Cantidad: <%= items.getInt("cantidad") %></p>
            </div>

            <div class="pedido-total">
                Total: $<%= pedido.getDouble("total") %>
            </div>
        </div>
        <% } %>

    </div>

    <!-- ESTADO DEL PEDIDO -->
    <div class="pedido-estado-box">

        <h2 class="estado-title">Estado del pedido</h2>

        <div class="estados-grid">

            <!-- Pendiente -->
            <a href="ActualizarEstadoPedido?id=<%= idPedido %>&estado=Pendiente"
               class="estado-opcion <%= estado.equals("Pendiente") ? "estado-activo" : "" %>">
                <img src="img/gato_pendiente.png" class="estado-img">
                <p>Pendiente</p>
            </a>

            <!-- Preparando -->
            <a href="ActualizarEstadoPedido?id=<%= idPedido %>&estado=Preparando"
               class="estado-opcion <%= estado.equals("Preparando") ? "estado-activo" : "" %>">
                <img src="img/gato_preparando.png" class="estado-img">
                <p>Preparando</p>
            </a>

            <!-- Listo -->
            <a href="ActualizarEstadoPedido?id=<%= idPedido %>&estado=Listo para recoger"
               class="estado-opcion <%= estado.equals("Listo para recoger") ? "estado-activo" : "" %>">
                <img src="img/gato_listo.png" class="estado-img">
                <p>Listo para recoger</p>
            </a>
        </div>

        <% if(estado.equals("Listo")) { %>
            <a href="ActualizarEstadoPedido?id=<%= idPedido %>&estado=Entregado"
               class="btn-entregado">Pedido Entregado</a>
        <% } %>

    </div>

</div>

<%
    boolean mostrarAlerta = "1".equals(request.getParameter("entregado"));
    if(mostrarAlerta){
%>

<div class="overlay-alerta">
    <div class="alerta-box">
        <h2>¡Se ha entregado<br>el pedido!</h2>

        <div class="alerta-botones">
            <a href="panelEmpleado.jsp" class="btn-alerta">Volver a la gestión de pedidos</a>
            <a href="historialPedidos.jsp" class="btn-alerta">Ir al historial de pedidos entregados</a>
        </div>
    </div>
</div>

<% } %>

        
</body>
</html>
