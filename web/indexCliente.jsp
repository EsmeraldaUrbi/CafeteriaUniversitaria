<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8"%>

<%
    // VERIFICAR QUE EL USUARIO ESTÁ LOGUEADO
    if(session.getAttribute("idUsuario") == null){
        response.sendRedirect("login.jsp");
        return;
    }

    String nombreUsuario = (String) session.getAttribute("nombre");

    // CONEXIÓN A BD
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3307/cafeteria?useSSL=false",
            "root",
            ""
    );

    // CONSULTAR CATEGORÍAS
    PreparedStatement psCat = con.prepareStatement("SELECT * FROM categoria");
    ResultSet rsCat = psCat.executeQuery();

    String idCat = request.getParameter("cat");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>DonMeow - Menú</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/estilos.css">
</head>

<body class="principal-body">

<header class="header-cliente">
    
    <div class="logo-cliente">
        <img src="img/logo.png">
        <span>DonMeow</span>
    </div>

    <input type="text" class="buscar" placeholder="Buscar productos…">

    <nav class="nav-cliente">
        <div class="menu-pedidos">
            <span class="menu-trigger">Mis pedidos</span>
            <ul class="menu-list">
                <li><a href="misPedidos.jsp">Historial</a></li>
                <li><a href="pendientes.jsp">Pendientes</a></li>
            </ul>
        </div>
        <a href="carrito.jsp">🛒 Carrito</a>
        <a href="logout.jsp">Cerrar Sesión</a>
    </nav>

</header>


<!-- CATEGORÍAS -->
<section class="categorias-section">
    <h2 class="titulo-cat">Categorías:</h2>
    <div class="categorias">
        <% while(rsCat.next()) { %>
            <a class="btn-cat" href="indexCliente.jsp?cat=<%= rsCat.getInt("idCategoria") %>">
                <%= rsCat.getString("nombre") %>
            </a>
        <% } %>
    </div>
</section>


<!-- ===================================== -->
<!--       PREVIEW SI NO HAY CAT          -->
<!-- ===================================== -->
<%
    if(idCat == null){
%>

<section class="productos-section">
    <h2>Bebidas</h2>
    <div class="productos">
        <%
            PreparedStatement ps1 = con.prepareStatement(
                "SELECT * FROM producto WHERE idCategoria=1 AND activo=1 LIMIT 4"
            );
            ResultSet r1 = ps1.executeQuery();
            while(r1.next()){
        %>
            <div class="producto">
                <img src="img/<%= r1.getString("imagen") %>">
                <h3><%= r1.getString("nombre") %></h3>
                <p class="precio">$<%= r1.getDouble("precio") %></p>
                <a class="btn-carrito" href="AgregarCarrito?producto=<%= r1.getInt("idProducto") %>">🛒</a>
            </div>
        <% } %>
    </div>
</section>


<section class="productos-section">
    <h2>Snacks</h2>
    <div class="productos">
        <%
            PreparedStatement ps2 = con.prepareStatement(
                "SELECT * FROM producto WHERE idCategoria=2 AND activo=1 LIMIT 4"
            );
            ResultSet r2 = ps2.executeQuery();
            while(r2.next()){
        %>
            <div class="producto">
                <img src="img/<%= r2.getString("imagen") %>">
                <h3><%= r2.getString("nombre") %></h3>
                <p class="precio">$<%= r2.getDouble("precio") %></p>
                <a class="btn-carrito" href="agregarCarrito?producto=<%= r2.getInt("idProducto") %>">🛒</a>
            </div>
        <% } %>
    </div>
</section>


<section class="productos-section">
    <h2>Comidas</h2>
    <div class="productos">
        <%
            PreparedStatement ps3 = con.prepareStatement(
                "SELECT * FROM producto WHERE idCategoria=3 AND activo=1 LIMIT 4"
            );
            ResultSet r3 = ps3.executeQuery();
            while(r3.next()){
        %>
            <div class="producto">
                <img src="img/<%= r3.getString("imagen") %>">
                <h3><%= r3.getString("nombre") %></h3>
                <p class="precio">$<%= r3.getDouble("precio") %></p>
                <a class="btn-carrito" href="agregarCarrito?producto=<%= r3.getInt("idProducto") %>">🛒</a>
            </div>
        <% } %>
    </div>
</section>

<%
    } // FIN DE PREVIEW
%>


<!-- ===================================== -->
<!--      PRODUCTOS DE UNA CATEGORÍA      -->
<!-- ===================================== -->
<%
    if(idCat != null){
        PreparedStatement psProd = con.prepareStatement(
            "SELECT * FROM producto WHERE idCategoria=? AND activo=1"
        );
        psProd.setInt(1, Integer.parseInt(idCat));

        ResultSet rsProd = psProd.executeQuery();
%>

<section class="productos-section">
    <h2>Productos</h2>
    <div class="productos">
        <% while(rsProd.next()) { %>
            <div class="producto">
                <img src="img/<%= rsProd.getString("imagen") %>">
                <h3><%= rsProd.getString("nombre") %></h3>
                <p class="precio">$<%= rsProd.getDouble("precio") %></p>
                <a class="btn-carrito" href="agregarCarrito?producto=<%= rsProd.getInt("idProducto") %>">🛒</a>
            </div>
        <% } %>
    </div>
</section>

<%
    } // FIN PRODUCTOS POR CAT

    con.close();
%>

<% if("1".equals(request.getParameter("add"))) { %>

<div class="overlay-alerta">
    <div class="alerta-box">
        <h2>¡Producto añadido<br>al carrito con éxito!</h2>

        <div class="alerta-botones">
            <a href="indexCliente.jsp" class="btn-alerta">Seguir comprando</a>
            <a href="carrito.jsp" class="btn-alerta">Ir al carrito</a>
        </div>
    </div>
</div>

<% } %>


</body>
</html>
