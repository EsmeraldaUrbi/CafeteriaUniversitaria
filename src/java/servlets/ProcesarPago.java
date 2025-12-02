package servlets;

import classes.Carrito;
import classes.ItemCarrito;
import classes.Pago;
import classes.Pedido;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/ProcesarPago")
public class ProcesarPago extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        if (session.getAttribute("idUsuario") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int idUsuario = (int) session.getAttribute("idUsuario");

        Carrito carrito = (Carrito) session.getAttribute("carrito");

        if (carrito == null || carrito.getItems().isEmpty()) {
            response.sendRedirect("carrito.jsp?error=CarritoVacio");
            return;
        }

        double monto = carrito.calcularSubtotal();
        String numeroTarjeta = request.getParameter("tarjeta");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3307/cafeteria?useSSL=false",
                    "root", ""
            );

            PreparedStatement psCar = con.prepareStatement(
                    "INSERT INTO carrito (idUsuario, fechaCreacion) VALUES (?, NOW())",
                    Statement.RETURN_GENERATED_KEYS
            );
            psCar.setInt(1, idUsuario);
            psCar.executeUpdate();

            ResultSet genCar = psCar.getGeneratedKeys();
            int idCarritoBD = 0;

            if (genCar.next()) {
                idCarritoBD = genCar.getInt(1);
            }

            PreparedStatement psItem = con.prepareStatement(
                    "INSERT INTO item_carrito (idCarrito, idProducto, cantidad, precioUnitario, subtotal) " +
                            "VALUES (?, ?, ?, ?, ?)"
            );

            for (ItemCarrito it : carrito.getItems()) {
                psItem.setInt(1, idCarritoBD);
                psItem.setInt(2, it.getIdProducto());
                psItem.setInt(3, it.getCantidad());
                psItem.setDouble(4, it.getPrecioUnitario());
                psItem.setDouble(5, it.getSubtotal());
                psItem.executeUpdate();
            }

            PreparedStatement psPed = con.prepareStatement(
                    "INSERT INTO pedido (idCarrito, fecha, estado, total) VALUES (?, NOW(), 'Pendiente', ?)",
                    Statement.RETURN_GENERATED_KEYS
            );
            psPed.setInt(1, idCarritoBD);
            psPed.setDouble(2, monto);
            psPed.executeUpdate();

            ResultSet genPed = psPed.getGeneratedKeys();
            int idPedido = 0;
            if (genPed.next()) {
                idPedido = genPed.getInt(1);
            }

            PreparedStatement psPago = con.prepareStatement(
                    "INSERT INTO pago (idPedido, metodo, numeroTarjeta, monto) VALUES (?, ?, ?, ?)"
            );
            psPago.setInt(1, idPedido);
            psPago.setString(2, "Tarjeta");
            psPago.setString(3, numeroTarjeta);
            psPago.setDouble(4, monto);
            psPago.executeUpdate();

            con.close();

            session.removeAttribute("carrito");

            response.sendRedirect("pagoRealizado.jsp");

        } catch (Exception e) {
            response.getWriter().println("ERROR: " + e.getMessage());
        }
    }
}
