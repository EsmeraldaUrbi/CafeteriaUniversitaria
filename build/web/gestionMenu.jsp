<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8"%>

<%
    
    if(session.getAttribute("tipo") == null ||
       !session.getAttribute("tipo").equals("empleado")){

        response.sendRedirect("login.jsp");
        return;
    }

    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3307/cafeteria?useSSL=false", "root", ""
    );

    
    PreparedStatement psCat = con.prepareStatement("SELECT * FROM categoria");
    ResultSet rsCat = psCat.executeQuery();

    
    String idCat = request.getParameter("cat");
    if(idCat == null) idCat = "1"; // Por defecto Bebidas

    
    PreparedStatement psProd = con.prepareStatement(
        "SELECT * FROM producto WHERE idCategoria=? AND activo=1"
    );
    psProd.setInt(1, Integer.parseInt(idCat));
    ResultSet rsProd = psProd.executeQuery();
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Gestión de Menú - DonMeow</title>
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

        
        <div class="menu-pedidos-emp" data-dropdown>
            <span class="menu-trigger-emp" data-trigger>Pedidos</span>

            <ul class="menu-list-emp" data-menu>
                <li><a href="historialPedidosEmpleado.jsp">Historial</a></li>
                <li><a href="panelEmpleado.jsp">Gestión</a></li>
            </ul>
        </div>

        <a href="gestionMenu.jsp">Gestión de Menú</a>

        <a href="CerrarSesion">Cerrar Sesión</a>
    </nav>
</header>

<article class="contenido">
    <h2 style="margin-left:40px; margin-top:30px; color:#4c6b3f;">Categorías:</h2>

    <div class="cats">

        <% 
            // Recargar categorías con un NUEVO ResultSet 
            PreparedStatement psCat2 = con.prepareStatement("SELECT * FROM categoria");
            ResultSet rsCat2 = psCat2.executeQuery();

            while(rsCat2.next()){
                String cid = rsCat2.getString("idCategoria");
        %>

            <a href="gestionMenu.jsp?cat=<%= cid %>"
               class="<%= idCat.equals(cid) ? "activa" : "" %>">
                <%= rsCat2.getString("nombre") %>
            </a>

        <% } %>

        <a href="agregarProducto.jsp" class="btn-agregar">+ Agregar producto</a>

    </div>

    <h2 style="margin-left:40px; margin-top:10px;">

        <%= 
            idCat.equals("1") ? "Bebidas" :
            idCat.equals("2") ? "Snacks" :
            "Comidas"
        %>

    </h2>

    <div class="productos-admin">

    <%
        while(rsProd.next()){
    %>

        <div class="producto-card">
            <img src="img/productos/<%= rsProd.getString("imagen") %>">
            <h3><%= rsProd.getString("nombre") %></h3>
            <p class="precio">$<%= rsProd.getDouble("precio") %></p>

            <a href="editarProducto.jsp?id=<%= rsProd.getInt("idProducto") %>" class="editar">
                <i class="fa-solid fa-pen"></i>
            </a>

        </div>

    <% } %>

    </div>
</article>

<footer class="footer">
    <p>© 2025 DonMeow - Cafetería Universitaria • Modelos de Desarrollo Web</p>
</footer>
</body>
</html>

<%
con.close();
%>
