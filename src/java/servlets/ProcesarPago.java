package servlets;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("ProcesarPago")
public class ProcesarPago extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        if (session.getAttribute("idUsuario") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int idUsuario = (int) session.getAttribute("idUsuario");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3307/cafeteria?useSSL=false",
                    "root", ""
            );

            // 1️⃣ Obtener carrito del usuario
            PreparedStatement psCar = con.prepareStatement(
                "SELECT idCarrito FROM carrito WHERE idUsuario=? ORDER BY idCarrito DESC LIMIT 1"
            );
            psCar.setInt(1, idUsuario);
            ResultSet rsCar = psCar.executeQuery();

            int idCarrito = 0;
            if (rsCar.next()) {
                idCarrito = rsCar.getInt("idCarrito");
            } else {
                con.close();
                response.sendRedirect("carrito.jsp?error=NoCarrito");
                return;
            }

            double total = Double.parseDouble(request.getParameter("total"));

            // 2️⃣ Insertar pedido (SIN idUsuario)
            PreparedStatement psPed = con.prepareStatement(
                "INSERT INTO pedido (idCarrito, fecha, estado, total) VALUES (?, NOW(), 'Pendiente', ?)"
            );
            psPed.setInt(1, idCarrito);
            psPed.setDouble(2, total);
            psPed.executeUpdate();

            con.close();

            // 3️⃣ Redirigir a pantalla de éxito
            response.sendRedirect("pagoRealizado.jsp");

        } catch (Exception e) {
            response.getWriter().println("Error: " + e);
        }
    }
}
