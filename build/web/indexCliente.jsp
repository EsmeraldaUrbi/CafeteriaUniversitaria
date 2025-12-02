<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="classes.Producto" %>
<%@ page import="classes.Categoria" %>
<%@ page contentType="text/html;charset=UTF-8"%>

<%!

ArrayList<Producto> obtenerProductos(Connection con, int idCat, int limite)
throws Exception {
    String sql = "SELECT * FROM producto WHERE idCategoria=? AND activo=1";
    if(limite > 0) sql += " LIMIT " + limite;

    PreparedStatement ps = con.prepareStatement(sql);
    ps.setInt(1, idCat);

    ResultSet rs = ps.executeQuery();
    ArrayList<Producto> lista = new ArrayList<>();

    while(rs.next()){
        Producto p = new Producto(
            rs.getInt("idProducto"),
            rs.getString("nombre"),
            rs.getString("descripcion"),
            rs.getDouble("precio"),
            rs.getString("imagen"),
            rs.getInt("idCategoria")
        );
        lista.add(p);
    }
    return lista;
}


ArrayList<Categoria> obtenerCategorias(Connection con) throws Exception {
    ArrayList<Categoria> lista = new ArrayList<>();

    PreparedStatement ps = con.prepareStatement("SELECT * FROM categoria");
    ResultSet rs = ps.executeQuery();

    while(rs.next()){
        Categoria c = new Categoria(
            rs.getInt("idCategoria"),
            rs.getString("nombre")
        );
        lista.add(c);
    }
    return lista;
}

%>

<%
    
    if(session.getAttribute("idUsuario") == null){
        response.sendRedirect("login.jsp");
        return;
    }

    String idCat = request.getParameter("cat");

    
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3307/cafeteria?useSSL=false",
        "root", ""
    );

    ArrayList<Categoria> categorias = obtenerCategorias(con);
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>DonMeow - Menú</title>
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

    <section class="categorias-section">
        <h2 class="titulo-cat">Categorías:</h2>
        <div class="categorias">
            <% for(Categoria c : categorias) { %>
                <a class="btn-cat" href="indexCliente.jsp?cat=<%= c.getIdCategoria() %>">
                    <%= c.getNombre() %>
                </a>
            <% } %>
        </div>
    </section>

    <%
    if(idCat == null){

        ArrayList<Producto> bebidas = obtenerProductos(con, 1, 4);
        ArrayList<Producto> snacks  = obtenerProductos(con, 2, 4);
        ArrayList<Producto> comidas = obtenerProductos(con, 3, 4);
    %>

    <section class="productos-section">
        <h2>Bebidas</h2>
        <div class="productos">
            <% for(Producto p : bebidas){ %>
                <div class="producto">
                    <a href="producto.jsp?id=<%= p.getIdProducto() %>">
                        <img src="img/productos/<%= p.getImagen() %>">
                        <h3><%= p.getNombre() %></h3>
                        <p class="precio">$<%= p.getPrecio() %></p>
                    </a>
                    <a class="btn-carrito" href="AgregarCarrito?producto=<%= p.getIdProducto() %>">
                        <i class="fa-solid fa-cart-shopping"></i>
                    </a>

                </div>
            <% } %>
        </div>
    </section>


    <section class="productos-section">
        <h2>Snacks</h2>
        <div class="productos">
            <% for(Producto p : snacks){ %>
                <div class="producto">
                    <a href="producto.jsp?id=<%= p.getIdProducto() %>">
                        <img src="img/productos/<%= p.getImagen() %>">
                        <h3><%= p.getNombre() %></h3>
                        <p class="precio">$<%= p.getPrecio() %></p>
                    </a>
                    <a class="btn-carrito" href="AgregarCarrito?producto=<%= p.getIdProducto() %>">
                        <i class="fa-solid fa-cart-shopping"></i>
                    </a>
                </div>
            <% } %>
        </div>
    </section>


    <section class="productos-section">
        <h2>Comidas</h2>
        <div class="productos">
            <% for(Producto p : comidas){ %>
                <div class="producto">
                    <a href="producto.jsp?id=<%= p.getIdProducto() %>">
                        <img src="img/productos/<%= p.getImagen() %>">
                        <h3><%= p.getNombre() %></h3>
                        <p class="precio">$<%= p.getPrecio() %></p>
                    </a>
                    <a class="btn-carrito" href="AgregarCarrito?producto=<%= p.getIdProducto() %>">
                        <i class="fa-solid fa-cart-shopping"></i>
                    </a>
                </div>
            <% } %>
        </div>
    </section>

    <%
    } // FIN SIN CATEGORÍA
    %>

    <%
    if(idCat != null){

        ArrayList<Producto> lista = obtenerProductos(con, Integer.parseInt(idCat), 0);
    %>

    <section class="productos-section">
        <h2>Productos</h2>
        <div class="productos">
            <% for(Producto p : lista){ %>
                <div class="producto">
                    <a href="producto.jsp?id=<%= p.getIdProducto() %>">
                        <img src="img/productos/<%= p.getImagen() %>">
                        <h3><%= p.getNombre() %></h3>
                        <p class="precio">$<%= p.getPrecio() %></p>
                    </a>
                    <a class="btn-carrito" href="AgregarCarrito?producto=<%= p.getIdProducto() %>">
                        <i class="fa-solid fa-cart-shopping"></i>
                    </a>
                </div>
            <% } %>
        </div>
    </section>

    <%
    } // FIN CON CATEGORÍA
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
</article>

<footer class="footer">
    <p>© 2025 DonMeow - Cafetería Universitaria • Modelos de Desarrollo Web</p>
</footer>
</body>
</html>
