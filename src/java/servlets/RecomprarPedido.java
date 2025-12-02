package servlets;

import classes.Carrito;
import classes.ItemCarrito;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/RecomprarPedido")
public class RecomprarPedido extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws IOException {

        HttpSession sesion = request.getSession();

        Integer idUsuario = (Integer) sesion.getAttribute("idUsuario");
        if (idUsuario == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int idPedido = Integer.parseInt(request.getParameter("idPedido"));

        
        Carrito carrito = (Carrito) sesion.getAttribute("carrito");
        if (carrito == null) {
            carrito = new Carrito();
            carrito.setIdUsuario(idUsuario);
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3307/cafeteria?useSSL=false",
                "root", ""
            );

            
            PreparedStatement psPed = con.prepareStatement(
                "SELECT idCarrito FROM pedido WHERE idPedido=?"
            );
            psPed.setInt(1, idPedido);
            ResultSet rsPed = psPed.executeQuery();

            int idCarritoOriginal = 0;
            if (rsPed.next()) {
                idCarritoOriginal = rsPed.getInt("idCarrito");
            }

            PreparedStatement psItems = con.prepareStatement(
                "SELECT * FROM item_carrito WHERE idCarrito=?"
            );
            psItems.setInt(1, idCarritoOriginal);

            ResultSet rsItems = psItems.executeQuery();

            while (rsItems.next()) {

                int idProducto = rsItems.getInt("idProducto");
                int cantidad = rsItems.getInt("cantidad");
                double precio = rsItems.getDouble("subtotal") / cantidad;

                boolean existe = false;

                for (ItemCarrito item : carrito.getItems()) {
                    if (item.getIdProducto() == idProducto) {
                        item.setCantidad(item.getCantidad() + cantidad);
                        item.setSubtotal(item.getCantidad() * item.getPrecioUnitario());
                        existe = true;
                        break;
                    }
                }

                if (!existe) {
                    ItemCarrito nuevo = new ItemCarrito();
                    nuevo.setIdProducto(idProducto);
                    nuevo.setCantidad(cantidad);
                    nuevo.setPrecioUnitario(precio);
                    nuevo.setSubtotal(precio * cantidad);

                    carrito.getItems().add(nuevo);
                }
            }

            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        sesion.setAttribute("carrito", carrito);

        response.sendRedirect("misPedidos.jsp?msg=recomprado");
    }
}
