package servlets;

import java.sql.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/ActualizarEstadoPedido")
public class ActualizarEstadoPedido extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response) {
        String id = request.getParameter("id");
        String estado = request.getParameter("estado");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3307/cafeteria?useSSL=false",
                "root", ""
            );

            PreparedStatement ps = con.prepareStatement(
                "UPDATE pedido SET estado=? WHERE idPedido=?"
            );
            ps.setString(1, estado);
            ps.setInt(2, Integer.parseInt(id));
            ps.executeUpdate();

            con.close();

            if (estado.equals("Entregado")) {
            response.sendRedirect("verPedido.jsp?id=" + id + "&entregado=1");}
            else {
                response.sendRedirect("verPedido.jsp?id=" + id);
            }

        } catch (Exception e) {
            try {
                response.getWriter().println("Error: " + e.getMessage());
            } catch(Exception ex){}
        }
    }
}
