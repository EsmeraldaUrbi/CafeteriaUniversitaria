<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8"%>

<%
    // Validar rol empleado
    if(session.getAttribute("tipo") == null ||
       !session.getAttribute("tipo").equals("empleado")){

        response.sendRedirect("login.jsp");
        return;
    }

    // Conexión BD
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3307/cafeteria?useSSL=false", "root", ""
    );

    // Obtener categorías
    PreparedStatement psCat = con.prepareStatement("SELECT * FROM categoria");
    ResultSet rsCat = psCat.executeQuery();

    // Categoría seleccionada
    String idCat = request.getParameter("cat");
    if(idCat == null) idCat = "1"; // Por defecto Bebidas

    // Obtener productos por categoría
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
</head>

<body class="principal-body">

<!-- ================= HEADER ================= -->
<header class="header-cliente">
    <div class="logo-cliente">
        <img src="img/logo.png">
        <span>DonMeow</span>
    </div>

    <input type="text" class="buscar" placeholder="Buscar productos…">

    <nav class="nav-cliente">

        <!-- Menú desplegable Pedidos -->
        <div class="menu-pedidos-emp">
            <span class="menu-trigger-emp">🍽️ Pedidos</span>
            <ul class="menu-list-emp">
                <li><a href="panelEmpleado.jsp">Historial</a></li>
                <li><a href="panelEmpleado.jsp">Gestión</a></li>
            </ul>
            <a href="gestionMenu.jsp">📋 Gestión de Menú</a>
        </div>

        <a href="logout.jsp">Cerrar Sesión</a>
    </nav>
</header>


<!-- ================= CATEGORÍAS ================= -->
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


<!-- ================= TÍTULO DE SECCIÓN ================= -->
<h2 style="margin-left:40px; margin-top:10px;">

    <%= 
        idCat.equals("1") ? "Bebidas" :
        idCat.equals("2") ? "Snacks" :
        "Comidas"
    %>

</h2>


<!-- ================= PRODUCTOS ================= -->
<div class="productos-admin">

<%
    while(rsProd.next()){
%>

    <div class="producto-card">
        <img src="img/<%= rsProd.getString("imagen") %>">
        <h3><%= rsProd.getString("nombre") %></h3>
        <p class="precio">$<%= rsProd.getDouble("precio") %></p>

        <a href="editarProducto.jsp?id=<%= rsProd.getInt("idProducto") %>" class="editar">✏️</a>
    </div>

<% } %>

</div>

</body>
</html>

<%
con.close();
%>
