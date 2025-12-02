<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>

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
        "SELECT p.idPedido, p.fecha, p.estado, c.idCarrito, p.total " +
        "FROM pedido p " +
        "JOIN carrito c ON p.idCarrito = c.idCarrito " +
        "WHERE c.idUsuario=? AND p.estado <> 'Entregado' " +
        "ORDER BY p.fecha DESC"
    );
    ps.setInt(1, idUser);
    ResultSet pedidos = ps.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
    <title>Pendientes - DonMeow</title>
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
        <div class="menu-pedidos" data-dropdown>
            <span class="menu-trigger" data-trigger>Mis pedidos</span>

            <ul class="menu-list" data-menu>
                <li><a href="misPedidos.jsp">Historial</a></li>
                <li><a href="pendientes.jsp">Pendientes</a></li>
            </ul>
        </div>


        <a href="carrito.jsp"><i class="fa-solid fa-cart-shopping"></i> Carrito</a>
        <a href="CerrarSesion">Cerrar sesión</a>
    </nav>
</header>

<article class="contenido">
    <a href="javascript:history.back()" class="regresar-link">⟵ Regresar</a>


    <h1 class="titulo-pagina">Pendientes</h1>

    <div class="pendientes-container">

    <%
        while(pedidos.next()){
            int idPedido = pedidos.getInt("idPedido");
            int idCarrito = pedidos.getInt("idCarrito");
            String estado = pedidos.getString("estado");
            double totalPedido = pedidos.getDouble("total");

            
            PreparedStatement psItems = con.prepareStatement(
                "SELECT pr.nombre, pr.imagen, pr.precio, ic.cantidad " +
                "FROM item_carrito ic " +
                "JOIN producto pr ON pr.idProducto = ic.idProducto " +
                "WHERE ic.idCarrito=?"
            );
            psItems.setInt(1, idCarrito);
            ResultSet items = psItems.executeQuery();
    %>

        <div class="tarjeta-pendiente">

            <p class="fecha-pedido">
                Fecha: <%= pedidos.getTimestamp("fecha") %>
            </p>

           
            <div class="lista-productos-pendiente">

            <% while(items.next()) { %>

                <div class="producto-info">
                    <img src="img/productos/<%= items.getString("imagen") %>" class="img-pendiente">

                    <div class="info-datos">
                        <h2><%= items.getString("nombre") %></h2>
                        <p>$<%= items.getDouble("precio") %></p>
                        <p>Cantidad: <%= items.getInt("cantidad") %></p>
                    </div>
                </div>

            <% } %>

            </div>

            <h2 class="estado-titulo">Estado del pedido</h2>

            <div class="estado-contenedor">

                <div class="estado-box <%= estado.equals("Pendiente") ? "activo" : "" %>">
                    <img src="img/gato_pendiente.png" class="icon-estado">
                    <p>Pendiente</p>
                </div>

                <div class="estado-box <%= estado.equals("Preparando") ? "activo" : "" %>">
                    <img src="img/gato_preparando.png" class="icon-estado">
                    <p>Preparando</p>
                </div>

                <div class="estado-box <%= estado.equals("Listo para recoger") ? "activo" : "" %>">
                    <img src="img/gato_listo.png" class="icon-estado">
                    <p>Listo para recoger</p>
                </div>

            </div>



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
