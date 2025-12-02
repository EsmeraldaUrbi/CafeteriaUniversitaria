<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8"%>

<%
    if(session.getAttribute("idUsuario") == null){
        response.sendRedirect("login.jsp");
        return;
    }

    int idUser = (int) session.getAttribute("idUsuario");

    
    String filtro = request.getParameter("filtro");
    boolean soloEntregados = "entregados".equals(filtro);

    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3307/cafeteria?useSSL=false",
        "root", ""
    );

    
    String query = 
        "SELECT p.* FROM pedido p " +
        "JOIN carrito c ON p.idCarrito = c.idCarrito " +
        "WHERE c.idUsuario=? ";

    if(soloEntregados){
        query += " AND p.estado='Entregado' ";
    }

    query += " ORDER BY p.fecha DESC";

    PreparedStatement psPedidos = con.prepareStatement(query);
    psPedidos.setInt(1, idUser);
    ResultSet pedidos = psPedidos.executeQuery();
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Mis pedidos - DonMeow</title>
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
        <a href="CerrarSesion">Cerrar Sesión</a>
    </nav>
</header>


<article class="contenido">

    <a href="javascript:history.back()" class="regresar-link">⟵ Regresar</a>

    <h1 class="titulo-historial">Mis pedidos</h1>

    <div style="margin:20px 0; text-align:center;">
        <a href="misPedidos.jsp"
           class="btn-secundario <%= soloEntregados ? "" : "activo" %>">
           Todos los pedidos
        </a>

        <a href="misPedidos.jsp?filtro=entregados"
           class="btn-secundario <%= soloEntregados ? "activo" : "" %>">
           Solo entregados
        </a>
    </div>


    <div class="historial-container">

        <div class="historial-dibujo">
            <img src="img/gato_caja.png">
        </div>

        <div class="historial-lista">

        <%
            while(pedidos.next()){
                int idCarrito = pedidos.getInt("idCarrito");
                double totalPedido = pedidos.getDouble("total");
                int idPedido = pedidos.getInt("idPedido");
        %>

        <h2 class="fecha-titulo">
            <%= pedidos.getString("fecha") %> ▼
        </h2>

        
        <div class="pedido-historial">

            <div class="pedido-historial-card">

                <div class="historial-productos">
                <%
                    PreparedStatement psItems = con.prepareStatement(
                        "SELECT p.nombre, p.precio, p.imagen, i.cantidad " +
                        "FROM producto p " +
                        "JOIN item_carrito i ON p.idProducto = i.idProducto " +
                        "WHERE i.idCarrito=?"
                    );
                    psItems.setInt(1, idCarrito);
                    ResultSet items = psItems.executeQuery();

                    while(items.next()){
                %>

                    <div class="item-historial">
                        <img src="img/productos/<%= items.getString("imagen") %>" class="img-pedido">

                        <div class="info-pedido">
                            <h3><%= items.getString("nombre") %></h3>
                            <p>$<%= items.getDouble("precio") %></p>
                            <p>Cantidad: <%= items.getInt("cantidad") %></p>
                        </div>
                    </div>

                <% } %>
                </div>

                <div class="total-pedido">
                    Total: <span>$<%= totalPedido %></span>
                </div>

                <div style="margin-top:15px; text-align:right;">
                    <a href="RecomprarPedido?idPedido=<%= idPedido %>" class="btn-recomprar">
                        Comprar de nuevo
                    </a>
                </div>

            </div>

        </div>

        <% } %>

        </div>
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
