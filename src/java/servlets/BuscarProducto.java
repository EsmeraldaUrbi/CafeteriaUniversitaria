package servlets;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import classes.Producto;

@WebServlet("/BuscarProducto")
public class BuscarProducto extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
                         throws ServletException, IOException {

        String q = request.getParameter("q");

        ArrayList<Producto> resultados = new ArrayList<>();

        if (q != null && !q.trim().isEmpty()) {

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3307/cafeteria?useSSL=false",
                    "root", ""
                );

                PreparedStatement ps = con.prepareStatement(
                    "SELECT * FROM producto WHERE activo = 1 AND nombre LIKE ?"
                );
                ps.setString(1, "%" + q + "%");

                ResultSet rs = ps.executeQuery();

                while (rs.next()) {
                    Producto p = new Producto(
                        rs.getInt("idProducto"),
                        rs.getString("nombre"),
                        rs.getString("descripcion"),
                        rs.getDouble("precio"),
                        rs.getString("imagen"),
                        rs.getInt("idCategoria")
                    );
                    resultados.add(p);
                }

                con.close();

            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        request.setAttribute("resultados", resultados);
        request.setAttribute("busqueda", q);

        request.getRequestDispatcher("busqueda.jsp").forward(request, response);
    }
}
