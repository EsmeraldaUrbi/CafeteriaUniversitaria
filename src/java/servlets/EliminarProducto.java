package servlets;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/EliminarProducto")
public class EliminarProducto extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");

        if(idParam == null){
            response.sendRedirect("gestionMenu.jsp");
            return;
        }

        int id = Integer.parseInt(idParam);

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3307/cafeteria?useSSL=false",
                "root", ""
            );

            
            PreparedStatement ps = con.prepareStatement(
                "UPDATE producto SET activo = 0 WHERE idProducto = ?"
            );

            ps.setInt(1, id);
            ps.executeUpdate();

            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

       
        response.sendRedirect("editarProducto.jsp?id=" + id + "&eliminado=1");
    }
}
