package servlets;

import classes.Usuario;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/Login")
public class Login extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String correo = request.getParameter("correo");
        String contra = request.getParameter("contra");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3307/cafeteria?useSSL=false",
                "root", ""
            );

            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM usuario WHERE correo=? AND contrasenia=?"
            );
            ps.setString(1, correo);
            ps.setString(2, contra);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                
                Usuario u = new Usuario(
                    rs.getInt("idUsuario"),
                    rs.getString("nombre"),
                    rs.getString("correo"),
                    rs.getString("contrasenia"),
                    rs.getString("tipo")    
                );

                HttpSession sesion = request.getSession();
                sesion.setAttribute("usuario", u);
                sesion.setAttribute("idUsuario", u.getIdUsuario());
                sesion.setAttribute("nombre", u.getNombre());
                sesion.setAttribute("tipo", u.getTipo());

                String tipo = u.getTipo();

                switch (tipo.toLowerCase()) {

                    case "empleado":
                        response.sendRedirect("gestionMenu.jsp");
                        break;

                    case "profesor":
                    case "estudiante":
                        response.sendRedirect("indexCliente.jsp");
                        break;

                    default:
                        response.sendRedirect("indexCliente.jsp"); // fallback
                        break;
                }

            } else {
                response.sendRedirect("login.jsp?error=1");
            }

            con.close();

        } catch (Exception e) {
            response.getWriter().println("ERROR: " + e.getMessage());
        }
    }
}
