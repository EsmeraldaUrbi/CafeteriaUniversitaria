<%@ page import="java.util.*" %>
<%@ page import="classes.Producto" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
    List<Producto> resultados = (List<Producto>) request.getAttribute("resultados");
    String q = (String) request.getAttribute("busqueda");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Resultados de búsqueda - DonMeow</title>
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
        <input type="text" name="q" class="buscar" placeholder="Buscar productos…" value="<%= q %>">
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

<article class="productos-section">
    
    <a href="javascript:history.back()" class="regresar-link">⟵ Regresar</a>


<h1>Resultados para: "<%= q %>"</h1>

<div class="productos">
    <% if (resultados == null || resultados.isEmpty()) { %>

        <p>No se encontraron productos.</p>

    <% } else { 
        for (Producto p : resultados) { %>

        <div class="producto">
            <a href="producto.jsp?id=<%= p.getIdProducto() %>">
                <img src="img/<%= p.getImagen() %>">
                <h3><%= p.getNombre() %></h3>
                <p class="precio">$<%= p.getPrecio() %></p>
            </a>

            <a class="btn-carrito"
               href="AgregarCarrito?producto=<%= p.getIdProducto() %>">🛒</a>
        </div>

    <% } } %>
</div>

</article>

<footer class="footer">
    <p>© 2025 DonMeow - Cafetería Universitaria • Modelos de Desarrollo Web</p>
</footer>

</body>
</html>
