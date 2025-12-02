<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8"%>

<%
    // Validar empleado
    if(session.getAttribute("tipo") == null ||
       !session.getAttribute("tipo").equals("empleado")){
        response.sendRedirect("login.jsp");
        return;
    }

    String id = request.getParameter("id");
    if(id == null){
        response.sendRedirect("gestionMenu.jsp");
        return;
    }

    // Cargar producto
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3307/cafeteria?useSSL=false", "root", ""
    );

    PreparedStatement psProd = con.prepareStatement(
        "SELECT * FROM producto WHERE idProducto=?"
    );
    psProd.setInt(1, Integer.parseInt(id));
    ResultSet prod = psProd.executeQuery();

    if(!prod.next()){
        response.sendRedirect("gestionMenu.jsp");
        return;
    }

    // Cargar categorías
    PreparedStatement psCat = con.prepareStatement("SELECT * FROM categoria");
    ResultSet rsCat = psCat.executeQuery();
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Editar Producto - DonMeow</title>
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
            <span class="menu-trigger-emp" data-trigger>️Pedidos</span>

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

            <h1>Modificar producto</h1>

            <form action="EditarProducto" method="post" enctype="multipart/form-data">

                <input type="hidden" name="id" value="<%= id %>">

                <div class="fila-inputs">
                    <input type="text" name="nombre" value="<%= prod.getString("nombre") %>" required>
                    <input type="number" step="0.01" name="precio" value="<%= prod.getDouble("precio") %>" required>
                </div>

                <textarea name="descripcion" required><%= prod.getString("descripcion") %></textarea>

                <div class="fila-inputs">

                    <select name="categoria" required>
                        <% while(rsCat.next()){ %>
                        <option value="<%= rsCat.getInt("idCategoria") %>"
                            <%= (rsCat.getInt("idCategoria") == prod.getInt("idCategoria")) ? "selected" : "" %>>
                            <%= rsCat.getString("nombre") %>
                        </option>
                        <% } %>
                    </select>

                    <input type="file" name="imagen">
                </div>

                <p>Imagen actual:</p>
                <img src="img/productos/<%= prod.getString("imagen") %>" class="img-editar">

                <label class="checkbox-activo">
                    <input type="checkbox" name="activo"
                           <%= prod.getInt("activo") == 1 ? "checked" : "" %> >
                    Producto Activo
                </label>

                <div class="botones-editar">
                    <button type="button" id="btnEliminar" class="btn-eliminar">Eliminar producto</button>
                    <button type="submit" class="btn-guardar">Guardar cambios</button>
                </div>

            </form>

        </div>

        <div class="agregar-gato">
            <img src="img/gato_editar.png" alt="gato">
        </div>

    </div>

    <div id="modalConfirmar" class="modal-bg">
        <div class="modal">
            <p>¿Estás seguro de querer eliminar el producto?</p>

            <div class="modal-buttons">
                <button class="btn-cancelar" id="btnCancelarEliminar">No lo elimines</button>
                <button class="btn-confirmar" id="btnConfirmarEliminar">¡Sí, eliminarlo!</button>
            </div>
        </div>
    </div>

    <div id="modalEliminado" class="modal-bg">
        <div class="modal">
            <p>¡El producto ha sido eliminado con éxito!</p>
            <button class="btn-confirmar" onclick="location.href='gestionMenu.jsp'">
                Volver a la gestión del menú
            </button>
        </div>
    </div>

    <div id="modalGuardado" class="modal-bg">
        <div class="modal">
            <p>¡Cambios guardados con éxito!</p>
            <button class="btn-confirmar" onclick="location.href='gestionMenu.jsp'">
                Volver a la gestión del menú
            </button>
        </div>
    </div>

</article>


<script src="js/funciones.js"></script>
<footer class="footer">
    <p>© 2025 DonMeow - Cafetería Universitaria • Modelos de Desarrollo Web</p>
</footer>

</body>
</html>

<%
con.close();
%>
