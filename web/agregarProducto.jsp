<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8"%>

<%
    // Validar rol
    if(session.getAttribute("tipo") == null ||
       !session.getAttribute("tipo").equals("empleado")){
        response.sendRedirect("login.jsp");
        return;
    }

    // Cargar categorías desde BD
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3307/cafeteria?useSSL=false", "root", ""
    );

    PreparedStatement psCat = con.prepareStatement("SELECT * FROM categoria");
    ResultSet rsCat = psCat.executeQuery();
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Agregar Producto - DonMeow</title>
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

        <a href="gestionMenu.jsp" class="nav-link-emp">Gestión de Menú</a>
        <a href="CerrarSesion" class="nav-link-emp">Cerrar Sesión</a>
    </nav>

</header>

<article class="contenido">
    <a href="javascript:history.back()" class="regresar-link">⟵ Regresar</a>


    <div class="agregar-container">

        <div class="agregar-form">

            <h1>Agregar nuevo producto</h1>

            <form action="AgregarProducto" method="post" enctype="multipart/form-data">

                <div class="fila-inputs">
                    <input type="text" name="nombre" placeholder="Nombre" required>
                    <input type="number" name="precio" placeholder="Precio" step="0.01" required>
                </div>

                <textarea name="descripcion" placeholder="Descripción" required></textarea>

                <div class="fila-inputs">

                    <select name="categoria" required>
                        <option value="">Categoría</option>
                        <% while(rsCat.next()){ %>
                            <option value="<%= rsCat.getInt("idCategoria") %>">
                                <%= rsCat.getString("nombre") %>
                            </option>
                        <% } %>
                    </select>

                    <input type="file" name="imagen" required>
                </div>

                <label class="checkbox-activo">
                    <input type="checkbox" name="activo" checked>
                    Producto Activo
                </label>

                <button type="submit" class="btn-guardar">Guardar cambios</button>

            </form>

        </div>

        <div class="agregar-gato">
            <img src="img/gato_editar.png" alt="gato">
        </div>

    </div>
    <% if("1".equals(request.getParameter("agregado"))) { %>
    <div class="modal-bg" style="display:flex">
        <div class="modal">
            <p>¡El producto ha sido agregado con éxito!</p>
            <button class="btn-confirmar" onclick="location.href='gestionMenu.jsp'">
                Volver a la gestión del menú
            </button>
        </div>
    </div>
    <% } %>

</article>

<footer class="footer">
    <p>© 2025 DonMeow - Cafetería Universitaria • Modelos de Desarrollo Web</p>
</footer>
<script src="js/validaciones.js"></script>

</body>
</html>

<%
con.close();
%>
