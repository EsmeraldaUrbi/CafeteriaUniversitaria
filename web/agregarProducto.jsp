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

<!-- ======= HEADER EMPLEADO ======= -->
<header class="header-cliente">

    <div class="logo-cliente">
        <img src="img/logo.png">
        <span>DonMeow</span>
    </div>

    <input type="text" class="buscar" placeholder="Buscar productos…">

    <nav class="nav-cliente">
        <a href="panelEmpleado.jsp" class="nav-link-emp">🍽️ Pedidos</a>
        <a href="gestionMenu.jsp" class="nav-link-emp">📋 Gestión de Menú</a>
        <a href="logout.jsp" class="nav-link-emp">Cerrar Sesión</a>
    </nav>

</header>

<!-- ======= REGRESAR ======= -->
<a href="gestionMenu.jsp" class="regresar-link">⟵ Regresar</a>

<!-- ======= CONTENEDOR GENERAL ======= -->
<div class="agregar-container">

    <!-- FORMULARIO -->
    <div class="agregar-form">

        <h1>Agregar nuevo producto</h1>

        <form action="AgregarProducto" method="post" enctype="multipart/form-data">

            <div class="fila-inputs">
                <input type="text" name="nombre" placeholder="Nombre" required>
                <input type="number" name="precio" placeholder="Precio" step="0.01" required>
            </div>

            <textarea name="descripcion" placeholder="Descripción" required></textarea>

            <div class="fila-inputs">

                <!-- Categoría -->
                <select name="categoria" required>
                    <option value="">Categoría</option>
                    <% while(rsCat.next()){ %>
                        <option value="<%= rsCat.getInt("idCategoria") %>">
                            <%= rsCat.getString("nombre") %>
                        </option>
                    <% } %>
                </select>

                <!-- Imagen -->
                <input type="file" name="imagen" required>
            </div>

            <!-- Activo -->
            <label class="checkbox-activo">
                <input type="checkbox" name="activo" checked>
                Producto Activo
            </label>

            <button type="submit" class="btn-guardar">Guardar cambios</button>

        </form>

    </div>

    <!-- IMAGEN DEL GATO -->
    <div class="agregar-gato">
        <img src="img/gato_editar.png" alt="gato">
    </div>

</div>

</body>
</html>

<%
con.close();
%>
