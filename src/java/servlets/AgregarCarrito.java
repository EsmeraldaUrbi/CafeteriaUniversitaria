package servlets;

import classes.Carrito;
import classes.ItemCarrito;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/AgregarCarrito")
public class AgregarCarrito extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession sesion = request.getSession();

        Integer idUsuario = (Integer) sesion.getAttribute("idUsuario");

        if (idUsuario == null) {
            // Guardamos intento de agregar producto (opcional)
            String idProd = request.getParameter("producto");
            sesion.setAttribute("ultimoProductoIntentado", idProd);

            response.sendRedirect("login.jsp?from=index");
            return;
        }

        int idProducto = Integer.parseInt(request.getParameter("producto"));

        int cantidad = 1;
        if (request.getParameter("cantidad") != null) {
            cantidad = Math.max(1, Integer.parseInt(request.getParameter("cantidad")));
        }

        Carrito carrito = (Carrito) sesion.getAttribute("carrito");
        if (carrito == null) {
            carrito = new Carrito();
            carrito.setIdUsuario(idUsuario);
        }

        ItemCarrito itemExistente = null;

        for (ItemCarrito it : carrito.getItems()) {
            if (it.getIdProducto() == idProducto) {
                itemExistente = it;
                break;
            }
        }

        double precioBD = 0;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3307/cafeteria?useSSL=false",
                    "root", ""
            );

            PreparedStatement ps = con.prepareStatement(
                    "SELECT precio FROM producto WHERE idProducto=?"
            );
            ps.setInt(1, idProducto);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) precioBD = rs.getDouble("precio");

            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        if (itemExistente != null) {
            itemExistente.setCantidad(itemExistente.getCantidad() + cantidad);
            itemExistente.setSubtotal(itemExistente.getCantidad() * itemExistente.getPrecioUnitario());
        } else {
            ItemCarrito nuevo = new ItemCarrito();
            nuevo.setIdProducto(idProducto);
            nuevo.setCantidad(cantidad);
            nuevo.setPrecioUnitario(precioBD);
            nuevo.setSubtotal(precioBD * cantidad);

            carrito.getItems().add(nuevo);
        }


        sesion.setAttribute("carrito", carrito);

        String origen = request.getHeader("referer");

        if (origen != null && origen.contains("producto.jsp")) {
            response.sendRedirect("producto.jsp?id=" + idProducto + "&agregado=1");
        } else {
            response.sendRedirect("indexCliente.jsp?add=1");
        }
    }
}
