<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8"%>

<%
    
    if(session.getAttribute("tipo") == null ||
       !session.getAttribute("tipo").equals("empleado")){
        response.sendRedirect("login.jsp");
        return;
    }

    
    String filtro = request.getParameter("filtro"); 
    boolean soloEntregados = "entregados".equals(filtro);

    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3307/cafeteria?useSSL=false", "root", ""
    );

    
    PreparedStatement psFechas;

    if(soloEntregados){
        
        psFechas = con.prepareStatement(
            "SELECT DISTINCT fecha FROM pedido WHERE estado='Entregado' ORDER BY fecha DESC"
        );
    } else {
        
        psFechas = con.prepareStatement(
            "SELECT DISTINCT fecha FROM pedido ORDER BY fecha DESC"
        );
    }

    ResultSet fechas = psFechas.executeQuery();
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Historial de pedidos - DonMeow</title>
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


    <h1 class="titulo-historial">Historial de pedidos de la cafetería</h1>

    <div style="margin:20px 0; text-align:center;">
        <a href="historialPedidosEmpleado.jsp"
           class="btn-secundario" 
           style="margin-right:10px;
           <%= soloEntregados ? "" : "background:#a4b685; color:white;" %>">
            Todos los pedidos
        </a>

        <a href="historialPedidosEmpleado.jsp?filtro=entregados"
           class="btn-secundario"
           style="<%= soloEntregados ? "background:#a4b685; color:white;" : "" %>">
            Solo entregados
        </a>
    </div>

    <div class="historial-container">

        <div class="historial-dibujo">
            <img src="img/gato_caja.png" alt="gato">
        </div>

        <div class="historial-lista">

        <%
            while(fechas.next()){
                String fecha = fechas.getString("fecha");

                PreparedStatement psPedidos;

                if(soloEntregados){
                    psPedidos = con.prepareStatement(
                        "SELECT * FROM pedido WHERE fecha=? AND estado='Entregado' ORDER BY idPedido DESC"
                    );
                } else {
                    psPedidos = con.prepareStatement(
                        "SELECT * FROM pedido WHERE fecha=? ORDER BY idPedido DESC"
                    );
                }

                psPedidos.setString(1, fecha);
                ResultSet pedidos = psPedidos.executeQuery();

                double totalVenta = 0;
        %>

            <h2 class="fecha-titulo"><%= fecha %> ▼</h2>

            <%
                boolean hayPedidos = false;

                while(pedidos.next()){
                    hayPedidos = true;

                    int idPedido = pedidos.getInt("idPedido");
                    double totalPedido = pedidos.getDouble("total");

                    totalVenta += totalPedido;

                    PreparedStatement psItems = con.prepareStatement(
                        "SELECT p.nombre, p.precio, p.imagen, i.cantidad " +
                        "FROM producto p " +
                        "JOIN item_carrito i ON p.idProducto = i.idProducto " +
                        "JOIN carrito c ON i.idCarrito = c.idCarrito " +
                        "JOIN pedido pe ON pe.idCarrito = c.idCarrito " +
                        "WHERE pe.idPedido=?"
                    );
                    psItems.setInt(1, idPedido);
                    ResultSet items = psItems.executeQuery();
            %>

            <div class="pedido-historial">

                <div class="historial-productos">
                    <% while(items.next()){ %>

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

            </div>

            <% } // fin while pedidos %>

            <% if(!hayPedidos){ %>
            <p style="margin-left:20px; color:#777;">No hay pedidos en esta fecha.</p>
            <% } %>

            <div class="total-dia">
                Total de la venta: <span>$<%= totalVenta %></span>
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
