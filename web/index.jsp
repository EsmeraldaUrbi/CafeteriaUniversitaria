<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3307/cafeteria", "root", "");

    PreparedStatement psCat = con.prepareStatement("SELECT * FROM categoria");
    ResultSet rsCat = psCat.executeQuery();
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>DonMeow</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/estilos.css">
</head>

<body>

<header class="header">
    <div class="logo">DonMeow</div>

    <input type="text" class="buscar" placeholder="Buscar productos...">

    <nav class="nav">
        <a href="login.jsp">Iniciar Sesión</a>
        <a href="carrito.jsp">Carrito</a>
        <a href="registro.jsp">Registrarme</a>
    </nav>
</header>

<section class="categorias-section">
    <h2>Categorías</h2>

    <div class="categorias">
        <% while(rsCat.next()) { %>
            <a class="btn-cat" href="index.jsp?cat=<%= rsCat.getInt("idCategoria") %>">
                <%= rsCat.getString("nombre") %>
            </a>
        <% } %>
    </div>
</section>

<%
    String idCat = request.getParameter("cat");

    if(idCat == null){
%>

<section class="productos-section">
    <h2>Bebidas</h2>
    <div class="productos">

        <%
            PreparedStatement psBebidas = con.prepareStatement(
                "SELECT * FROM producto WHERE idCategoria = 1 AND activo = 1 LIMIT 4"
            );
            ResultSet rsBebidas = psBebidas.executeQuery();

            while(rsBebidas.next()){
        %>
            <div class="producto">
                <img src="img/<%= rsBebidas.getString("imagen") %>">
                <h3><%= rsBebidas.getString("nombre") %></h3>
                <p class="precio">$<%= rsBebidas.getDouble("precio") %></p>
                <a class="btn-carrito" href="agregarCarrito?producto=<%= rsBebidas.getInt("idProducto") %>">
                    Añadir 🛒
                </a>
            </div>
        <% } %>

    </div>
</section>


<section class="productos-section">
    <h2>Snacks</h2>
    <div class="productos">

        <%
            PreparedStatement psSnacks = con.prepareStatement(
                "SELECT * FROM producto WHERE idCategoria = 2 AND activo = 1 LIMIT 4"
            );
            ResultSet rsSnacks = psSnacks.executeQuery();

            while(rsSnacks.next()){
        %>
            <div class="producto">
                <img src="img/<%= rsSnacks.getString("imagen") %>">
                <h3><%= rsSnacks.getString("nombre") %></h3>
                <p class="precio">$<%= rsSnacks.getDouble("precio") %></p>
                <a class="btn-carrito" href="agregarCarrito?producto=<%= rsSnacks.getInt("idProducto") %>">
                    Añadir 🛒
                </a>
            </div>
        <% } %>

    </div>
</section>


<section class="productos-section">
    <h2>Comidas</h2>
    <div class="productos">

        <%
            PreparedStatement psComidas = con.prepareStatement(
                "SELECT * FROM producto WHERE idCategoria = 3 AND activo = 1 LIMIT 4"
            );
            ResultSet rsComidas = psComidas.executeQuery();

            while(rsComidas.next()){
        %>
            <div class="producto">
                <img src="img/<%= rsComidas.getString("imagen") %>">
                <h3><%= rsComidas.getString("nombre") %></h3>
                <p class="precio">$<%= rsComidas.getDouble("precio") %></p>
                <a class="btn-carrito" href="agregarCarrito?producto=<%= rsComidas.getInt("idProducto") %>">
                    Añadir 🛒
                </a>
            </div>
        <% } %>

    </div>
</section>

<%
    } 
    if(idCat != null){
        PreparedStatement psProd = con.prepareStatement(
            "SELECT * FROM producto WHERE idCategoria = ? AND activo = 1"
        );
        psProd.setInt(1, Integer.parseInt(idCat));
        ResultSet rsProd = psProd.executeQuery();
%>

<section class="productos-section">
    <h2>Productos</h2>
    <div class="productos">

        <%
            while(rsProd.next()){
        %>
            <div class="producto">
                <img src="img/<%= rsProd.getString("imagen") %>">
                <h3><%= rsProd.getString("nombre") %></h3>
                <p class="precio">$<%= rsProd.getDouble("precio") %></p>
                <a class="btn-carrito" href="agregarCarrito?producto=<%= rsProd.getInt("idProducto") %>">
                    Añadir 🛒
                </a>
            </div>
        <% } %>

    </div>
</section>

<%
    } 

    con.close();
%>

</body>
</html>
