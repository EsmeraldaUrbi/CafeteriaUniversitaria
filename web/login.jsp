<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Iniciar Sesión - DonMeow</title>
    <link rel="stylesheet" href="css/estilos.css">
</head>

<body class="registro-body">
<header class="header-simple">
    <h1>Iniciar Sesión</h1>
</header>

<article class="contenido">
    <div class="registro-wrapper">

       <div class="registro-form">

           <% if (request.getParameter("error") != null) { %>
               <div class="mensaje">Correo o contraseña incorrectos.</div>
           <% } %>

           <form method="post" action="Login">

               <label>Correo</label>
               <input type="email" name="correo" required>

               <label>Contraseña</label>
               <input type="password" name="contra" required>

               <button type="submit" class="btn-pago">
                   Iniciar Sesión
               </button>

           </form>

           <p class="ya-cuenta">
               ¿No tienes cuenta? <a href="registro.jsp">Regístrate aquí</a>
           </p>
       </div>

       <div class="registro-logo">
           <img src="img/logo.png" alt="DonMeow">
       </div>

   </div>   
</article>
<footer class="footer">
    <p>© 2025 DonMeow - Cafetería Universitaria • Modelos de Desarrollo Web</p>
</footer>
<script src="js/validaciones.js"></script>
</body>
</html>
