<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
    String mensaje = "";

    if(request.getParameter("btnRegistrar") != null){

        String tipo = request.getParameter("tipo");
        String matricula = request.getParameter("matricula");
        String nombre = request.getParameter("nombre");
        String correo = request.getParameter("correo");
        String contra = request.getParameter("contra");
        String contra2 = request.getParameter("contra2");

        if(!contra.equals(contra2)){
            mensaje = "Las contraseñas no coinciden.";
        } else {

            try{
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = DriverManager.getConnection(
                        "jdbc:mysql://localhost:3307/cafeteria?useSSL=false",
                        "root",
                        ""
                );

                // INSERTAR EN TABLA usuario
                PreparedStatement ps = con.prepareStatement(
                    "INSERT INTO usuario(nombre, correo, contrasenia, tipo) VALUES (?,?,?,?)",
                    Statement.RETURN_GENERATED_KEYS
                );

                ps.setString(1, nombre);
                ps.setString(2, correo);
                ps.setString(3, contra);
                ps.setString(4, tipo);

                ps.executeUpdate();

                ResultSet rs = ps.getGeneratedKeys();
                int idUsuario = 0;
                if(rs.next()){
                    idUsuario = rs.getInt(1);
                }

                // INSERTAR EN TABLA SEGÚN EL TIPO
                if(tipo.equals("estudiante")){
                    PreparedStatement ps2 = con.prepareStatement(
                        "INSERT INTO estudiante(idUsuario, matricula) VALUES (?,?)"
                    );
                    ps2.setInt(1, idUsuario);
                    ps2.setString(2, matricula);
                    ps2.executeUpdate();
                }

                if(tipo.equals("profesor")){
                    PreparedStatement ps2 = con.prepareStatement(
                        "INSERT INTO profesor(idUsuario, noTrabajador) VALUES (?,?)"
                    );
                    ps2.setInt(1, idUsuario);
                    ps2.setString(2, matricula);
                    ps2.executeUpdate();
                }

                if(tipo.equals("empleado")){
                    PreparedStatement ps2 = con.prepareStatement(
                        "INSERT INTO personal_cafeteria(idUsuario, noEmpleado) VALUES (?,?)"
                    );
                    ps2.setInt(1, idUsuario);
                    ps2.setString(2, matricula);
                    ps2.executeUpdate();
                }

                mensaje = "¡Registro exitoso!";

                con.close();

            }catch(Exception e){
                mensaje = "Error: " + e.getMessage();
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Registro - DonMeow</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/estilos.css">
</head>

<body class="registro-body">

<div class="registro-wrapper">

    <!-- IZQUIERDA: FORMULARIO -->
    <div class="registro-form">
        <h1>Registro</h1>

        <% if(!mensaje.equals("")){ %>
            <div class="mensaje"><%= mensaje %></div>
        <% } %>

        <form method="post">

            <label>Nombre Completo</label>
            <input type="text" name="nombre" required>

            <label>Correo</label>
            <input type="email" name="correo" required>

            <label>Matrícula / No. empleado</label>
            <input type="text" name="matricula" required>

            <label>Contraseña</label>
            <input type="password" name="contra" required>

            <label>Confirmar Contraseña</label>
            <input type="password" name="contra2" required>

            <label>Tipo de usuario</label>
            <select name="tipo">
                <option value="estudiante">Estudiante</option>
                <option value="profesor">Profesor</option>
                <option value="empleado">Empleado</option>
            </select>

            <button type="submit" name="btnRegistrar" class="btn-registrar">Registrarse</button>

        </form>

        <p class="ya-cuenta">¿Ya tienes cuenta? <a href="login.jsp">Inicia sesión</a></p>

    </div>

    <!-- DERECHA: LOGO -->
    <div class="registro-logo">
        <img src="img/logo.png" alt="Don Meow">
    </div>

</div>

</body>

</html>
