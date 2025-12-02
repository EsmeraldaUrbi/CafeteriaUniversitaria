<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8"%>

<%
    
    if(session.getAttribute("tipo") == null || 
       !session.getAttribute("tipo").equals("empleado")) {

        response.sendRedirect("login.jsp");
        return;
    }

    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3307/cafeteria?useSSL=false", "root", ""
    );

    
    PreparedStatement psPend = con.prepareStatement(
        "SELECT * FROM pedido WHERE estado='Pendiente' ORDER BY fecha DESC"
    );
    ResultSet pend = psPend.executeQuery();

    PreparedStatement psPrep = con.prepareStatement(
        "SELECT * FROM pedido WHERE estado='Preparando' ORDER BY fecha DESC"
    );
    ResultSet prep = psPrep.executeQuery();

    PreparedStatement psListo = con.prepareStatement(
        "SELECT * FROM pedido WHERE estado='Listo para recoger' ORDER BY fecha DESC"
    );
    ResultSet listo = psListo.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Pedidos - DonMeow</title>
    <link rel="stylesheet" href="css/estilos.css">
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
    <a href="javascript:history.back()" class="regresar-link">⟵ Regresar</a>

    <div class="panel-empleado-container">

        <div class="columna">
            <h2>Pendientes</h2>

            <%
                while(pend.next()){
                    int idPedido = pend.getInt("idPedido");

                    
                    PreparedStatement psImg = con.prepareStatement(
                        "SELECT p.imagen FROM producto p " +
                        "JOIN item_carrito i ON p.idProducto = i.idProducto " +
                        "JOIN carrito c ON i.idCarrito = c.idCarrito " +
                        "JOIN pedido pe ON pe.idCarrito = c.idCarrito " +
                        "WHERE pe.idPedido=? LIMIT 1"
                    );
                    psImg.setInt(1, idPedido);
                    ResultSet img = psImg.executeQuery();

                    String imagen = "sinimagen.png";
                    if(img.next()){
                        imagen = img.getString(1);
                    }
            %>

            <div class="tarjeta-pedido">
                <img src="img/productos/<%= imagen %>">
                <div>
                    <p><b>Pedido #<%= idPedido %></b></p>
                    <a href="verPedido.jsp?id=<%= idPedido %>" class="btn-ver">Ver pedido</a>
                </div>
            </div>

            <% } %>
        </div>

        <div class="columna">
            <h2>En preparación</h2>

            <%
                while(prep.next()){
                    int idPedido = prep.getInt("idPedido");

                    PreparedStatement psImg = con.prepareStatement(
                        "SELECT p.imagen FROM producto p " +
                        "JOIN item_carrito i ON p.idProducto = i.idProducto " +
                        "JOIN carrito c ON i.idCarrito = c.idCarrito " +
                        "JOIN pedido pe ON pe.idCarrito = c.idCarrito " +
                        "WHERE pe.idPedido=? LIMIT 1"
                    );
                    psImg.setInt(1, idPedido);
                    ResultSet img = psImg.executeQuery();

                    String imagen = "sinimagen.png";
                    if(img.next()){
                        imagen = img.getString(1);
                    }
            %>

            <div class="tarjeta-pedido">
                <img src="img/productos/<%= imagen %>">
                <div>
                    <p><b>Pedido #<%= idPedido %></b></p>
                    <a href="verPedido.jsp?id=<%= idPedido %>" class="btn-ver">Ver pedido</a>
                </div>
            </div>

            <% } %>
        </div>

        <div class="columna">
            <h2>Listos para recoger</h2>

            <%
                while(listo.next()){
                    int idPedido = listo.getInt("idPedido");

                    PreparedStatement psImg = con.prepareStatement(
                        "SELECT p.imagen FROM producto p " +
                        "JOIN item_carrito i ON p.idProducto = i.idProducto " +
                        "JOIN carrito c ON i.idCarrito = c.idCarrito " +
                        "JOIN pedido pe ON pe.idCarrito = c.idCarrito " +
                        "WHERE pe.idPedido=? LIMIT 1"
                    );
                    psImg.setInt(1, idPedido);
                    ResultSet img = psImg.executeQuery();

                    String imagen = "sinimagen.png";
                    if(img.next()){
                        imagen = img.getString(1);
                    }
            %>

            <div class="tarjeta-pedido">
                <img src="img/productos/<%= imagen %>">
                <div>
                    <p><b>Pedido #<%= idPedido %></b></p>
                    <a href="verPedido.jsp?id=<%= idPedido %>" class="btn-ver">Ver pedido</a>
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
