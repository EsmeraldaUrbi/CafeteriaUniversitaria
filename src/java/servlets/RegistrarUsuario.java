package servlets;

import classes.Usuario;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/RegistrarUsuario")
public class RegistrarUsuario extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String nombre = request.getParameter("nombre");
        String correo = request.getParameter("correo");
        String matricula = request.getParameter("matricula");
        String contra = request.getParameter("contra");
        String contra2 = request.getParameter("contra2");
        String tipo = request.getParameter("tipo");

        if (!contra.equals(contra2)) {
            response.sendRedirect("registro.jsp?error=Las contraseñas no coinciden");
            return;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3307/cafeteria?useSSL=false",
                    "root", ""
            );

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO usuario (nombre, correo, contrasenia, tipo) VALUES (?,?,?,?)",
                Statement.RETURN_GENERATED_KEYS
            );

            ps.setString(1, nombre);
            ps.setString(2, correo);
            ps.setString(3, contra);
            ps.setString(4, tipo);

            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            int idUsuario = 0;

            if (rs.next()) {
                idUsuario = rs.getInt(1);
            }

            if (tipo.equals("estudiante")) {

                PreparedStatement p2 = con.prepareStatement(
                    "INSERT INTO estudiante(idUsuario, matricula) VALUES (?,?)"
                );
                p2.setInt(1, idUsuario);
                p2.setString(2, matricula);
                p2.executeUpdate();

            } else if (tipo.equals("profesor")) {

                PreparedStatement p2 = con.prepareStatement(
                    "INSERT INTO profesor(idUsuario, noTrabajador) VALUES (?,?)"
                );
                p2.setInt(1, idUsuario);
                p2.setString(2, matricula);
                p2.executeUpdate();

            } else if (tipo.equals("empleado")) {

                PreparedStatement p2 = con.prepareStatement(
                    "INSERT INTO personal_cafeteria(idUsuario, noEmpleado) VALUES (?,?)"
                );
                p2.setInt(1, idUsuario);
                p2.setString(2, matricula);
                p2.executeUpdate();
            }

            con.close();

            response.sendRedirect("registro.jsp?ok=1");

        } catch (Exception e) {
            response.sendRedirect("registro.jsp?error=Error: " + e.getMessage());
        }
    }
}
