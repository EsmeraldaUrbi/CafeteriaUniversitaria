<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
    String mensaje = "";

    if(request.getParameter("btnLogin") != null){

        String correo = request.getParameter("correo");
        String contra = request.getParameter("contra");

        try{
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3307/cafeteria?useSSL=false",
                "root",
                ""
            );

            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM usuario WHERE correo=? AND contrasenia=?"
            );
            ps.setString(1, correo);
            ps.setString(2, contra);

            ResultSet rs = ps.executeQuery();

            if(rs.next()){

                String tipo = rs.getString("tipo");

                // GUARDAR SESIÓN
                session.setAttribute("idUsuario", rs.getInt("idUsuario"));
                session.setAttribute("nombre", rs.getString("nombre"));
                session.setAttribute("tipo", tipo);

                // REDIRECCIÓN SEGÚN TIPO
                if(tipo.equalsIgnoreCase("empleado") || tipo.equalsIgnoreCase("personal") || tipo.equalsIgnoreCase("admin")){
                    response.sendRedirect("panelEmpleado.jsp");
                } else {
                    response.sendRedirect("indexCliente.jsp");
                }

                return;
            } else {
                mensaje = "Correo o contraseña incorrectos.";
            }

            con.close();

        }catch(Exception e){
            mensaje = "Error: " + e.getMessage();
        }
    }
%>


<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Iniciar Sesión - DonMeow</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/estilos.css">
</head>

<body class="registro-body">

<div class="registro-wrapper">

    <!-- IZQUIERDA: FORMULARIO -->
    <div class="registro-form">
        <h1>Iniciar Sesión</h1>

        <% if(!mensaje.equals("")){ %>
            <div class="mensaje"><%= mensaje %></div>
        <% } %>

        <form method="post">

            <label>Correo</label>
            <input type="email" name="correo" required>

            <label>Contraseña</label>
            <input type="password" name="contra" required>

            <button type="submit" name="btnLogin" class="btn-registrar">
                Iniciar Sesión
            </button>

        </form>

        <p class="ya-cuenta">
            ¿No tienes cuenta? <a href="registro.jsp">Regístrate aquí</a>
        </p>
    </div>

    <!-- DERECHA: LOGO -->
    <div class="registro-logo">
        <img src="img/logo.png" alt="DonMeow">
    </div>

</div>

</body>
</html>
