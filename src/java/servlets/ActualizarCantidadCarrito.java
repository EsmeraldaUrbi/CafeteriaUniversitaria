package servlets;

import classes.Carrito;
import classes.ItemCarrito;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/ActualizarCantidadCarrito")
public class ActualizarCantidadCarrito extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws IOException {

        HttpSession sesion = request.getSession();

        Carrito carrito = (Carrito) sesion.getAttribute("carrito");
        if (carrito == null) {
            response.sendRedirect("carrito.jsp");
            return;
        }

        int idProducto = Integer.parseInt(request.getParameter("id"));
        String accion = request.getParameter("accion"); // "+" o "-"

        for (ItemCarrito item : carrito.getItems()) {

            if (item.getIdProducto() == idProducto) {

                if ("+".equals(accion)) {
                    item.setCantidad(item.getCantidad() + 1);

                } else if ("-".equals(accion)) {
                    if (item.getCantidad() > 1) {
                        item.setCantidad(item.getCantidad() - 1);
                    }
                }

             
                item.setSubtotal(item.getCantidad() * item.getPrecioUnitario());
                break;
            }
        }

        sesion.setAttribute("carrito", carrito);
        response.sendRedirect("carrito.jsp");
    }
}
