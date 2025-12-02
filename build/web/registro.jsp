<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Registro - DonMeow</title>
    <link rel="stylesheet" href="css/estilos.css">
</head>

<body class="registro-body">
<header class="header-simple">
    <h1>Registro</h1>
</header>

<article class="contenido">
    <div class="registro-wrapper">

        <div class="registro-form">
            <% if (request.getParameter("error") != null) { %>
                <div class="mensaje"><%= request.getParameter("error") %></div>
            <% } %>

            <% if (request.getParameter("ok") != null) { %>
                <div class="mensaje" style="background:#4CAF50;color:white;">
                    ¡Registro exitoso! Ahora puedes iniciar sesión.
                </div>
            <% } %>

            <form method="post" action="RegistrarUsuario">
                
                <label>Nombre Completo</label>
                <input type="text" name="nombre" required>

                <label>Correo</label>
                <input type="email" name="correo" required>

                <label>Matrícula / No. empleado / No. Trabajador</label>
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

                <button type="submit" class="btn-pago">Registrarse</button>

            </form>

            <p class="ya-cuenta">¿Ya tienes cuenta? <a href="login.jsp">Inicia sesión</a></p>

        </div>

        <div class="registro-logo">
            <img src="img/logo.png" alt="Don Meow">
        </div>

    </div>
</article>

<footer class="footer">
    <p>© 2025 DonMeow - Cafetería Universitaria • Modelos de Desarrollo Web</p>
</footer>
<script src="js/validaciones.js"></script>

</body>
</html>
