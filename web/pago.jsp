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
        "jdbc:mysql://localhost:3307/cafeteria?useSSL=false", "root", ""
    );

    // Obtener el carrito actual
    PreparedStatement psCar = con.prepareStatement(
        "SELECT * FROM carrito WHERE idUsuario=? ORDER BY idCarrito DESC LIMIT 1"
    );
    psCar.setInt(1, idUser);
    ResultSet car = psCar.executeQuery();

    int idCarrito = 0;
    if(car.next()) idCarrito = car.getInt("idCarrito");

    // Calcular total
    PreparedStatement psTotal = con.prepareStatement(
        "SELECT SUM(subtotal) FROM item_carrito WHERE idCarrito=?"
    );
    psTotal.setInt(1, idCarrito);
    ResultSet rt = psTotal.executeQuery();

    double total = 0;
    if(rt.next()) total = rt.getDouble(1);
%>

<!DOCTYPE html>
<html>
<head>
    <title>Pagar pedido - DonMeow</title>
    <link rel="stylesheet" href="css/estilos.css">
</head>

<body class="principal-body">

<header class="header-cliente">
    <div class="logo-cliente">
        <img src="img/logo.png">
        <span>DonMeow</span>
    </div>

    <input class="buscar" placeholder="Buscar productos...">

    <nav class="nav-cliente">
        <div class="menu-pedidos">
            <span class="menu-trigger">Mis pedidos</span>
            <ul class="menu-list">
                <li><a href="misPedidos.jsp">Historial</a></li>
                <li><a href="pendientes.jsp">Pendientes</a></li>
            </ul>
        </div>
        <a href="carrito.jsp">🛒 Carrito</a>
        <a href="logout.jsp">Cerrar sesión</a>
    </nav>
</header>

<a href="carrito.jsp" class="regresar-link">⟵ Regresar</a>

<div class="pago-container">

    <div class="pago-form">

        <h2>Total a pagar</h2>
        <div class="total-box">
            $<%= String.format("%.2f", total) %>
        </div>

        <h3>Método de pago</h3>

        <form action="ProcesarPago" method="post">

            <input type="hidden" name="total" value="<%= total %>">
            <input type="hidden" name="carrito" value="<%= idCarrito %>">

            <input type="text" class="input-pago" placeholder="Número de la tarjeta" required>
            <input type="text" class="input-pago" placeholder="Nombre en la tarjeta" required>

            <div class="fila">
                <input type="text" class="input-fecha" placeholder="DD/MM/AA" required>
                <input type="text" class="input-cvv" placeholder="CVV" required>
            </div>

            <label class="checkbox-info">
                <input type="checkbox"> Guardar información para futuras compras
            </label>

            <button type="submit" class="btn-pagar">Pagar pedido</button>
        </form>

    </div>

    <div class="pago-gato">
        <img src="img/gato_cafe.png">
    </div>

</div>

</body>
</html>

<%
    con.close();
%>
