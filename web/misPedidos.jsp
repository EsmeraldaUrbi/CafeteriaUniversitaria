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
    "ORDER BY p.fecha DESC"
    );
    ps.setInt(1, idUser);
    ResultSet pedidos = ps.executeQuery();

%>

<!DOCTYPE html>
<html>
<head>
    <title>Mis pedidos</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/estilos.css">
</head>

<body class="principal-body">

<h1 class="titulo-mispedidos">Mis pedidos</h1>

<div class="contenedor-pedidos">

<%
    while(pedidos.next()){
%>

    <div class="pedido-card">
        
        <p class="fecha">Fecha: <%= pedidos.getString("fecha") %></p>

        <!-- BLOQUE DE PRODUCTOS -->
        <%
            PreparedStatement psProd = con.prepareStatement(
                "SELECT * FROM item_pedido WHERE idPedido=?"
            );
            psProd.setInt(1, pedidos.getInt("idPedido"));
            ResultSet items = psProd.executeQuery();
        %>

        <div class="items-pedido">
        <% 
            while(items.next()){
        %>
            <div class="item">
                <img src="img/TU_IMAGEN.png" class="img-item">
                
                <div class="info-item">
                    <h3>Nombre</h3>
                    <p>$$$</p>
                    <p>Cantidad: 1</p>
                    <span>🛒</span>
                </div>
            </div>
        <% } %>
        </div>

        <div class="footer-pedido">
            <button class="btn-recomprar">Comprar de nuevo</button>
            <p class="total">Total: $$$</p>
        </div>

    </div>

<% } %>

</div>

</body>
</html>

<%
con.close();
%>
