<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8"%>

<%
    if(session.getAttribute("idUsuario") == null){
        response.sendRedirect("login.jsp");
        return;
    }

    int idUser = (int) session.getAttribute("idUsuario");

    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3307/cafeteria?useSSL=false",
        "root", ""
    );

    PreparedStatement ps = con.prepareStatement(
    "SELECT p.* FROM pedido p " +
    "JOIN carrito c ON p.idCarrito = c.idCarrito " +
    "WHERE c.idUsuario = ? " +
    "AND p.estado <> 'Listo' " +
    "ORDER BY p.fecha DESC"
    );
    ps.setInt(1, idUser);
    ResultSet rs = ps.executeQuery();

%>

<!DOCTYPE html>
<html>
<head>
    <title>Pendientes</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/estilos.css">
</head>

<body class="principal-body">

<a href="indexCliente.jsp" class="volver">< Regresar</a>
<h1>Pendientes</h1>

<div class="contenedor-pendiente">

<%
    if(rs.next()){
%>

    <div class="pendiente-card">

        <p class="fecha">Fecha: <%= rs.getString("fecha") %></p>

        <div class="producto-pendiente">
            <img src="img/TU_IMAGEN.png">
            <div>
                <h3>Nombre</h3>
                <p>$$$</p>
                <p>Cantidad: 1</p>
                <p>Total: $$$</p>
            </div>
        </div>

        <!-- ESTADO DEL PEDIDO -->
        <div class="estado-pedido">

            <div class="estado">
                <img src="img/pendiente.png">
                <p>Pendiente</p>
            </div>

            <div class="estado">
                <img src="img/preparando.png">
                <p>Preparando</p>
            </div>

            <div class="estado">
                <img src="img/listo.png">
                <p>Listo para recoger</p>
            </div>

        </div>

    </div>

<% } else { %>
    <p>No tienes pedidos pendientes.</p>
<% } %>

</div>

</body>
</html>
