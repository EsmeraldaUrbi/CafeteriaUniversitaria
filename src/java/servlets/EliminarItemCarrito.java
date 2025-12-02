package servlets;

import classes.Carrito;
import classes.ItemCarrito;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/EliminarItemCarrito")
public class EliminarItemCarrito extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession sesion = request.getSession();

        Carrito carrito = (Carrito) sesion.getAttribute("carrito");
        if (carrito == null) {
            response.sendRedirect("carrito.jsp");
            return;
        }

        int idProducto = Integer.parseInt(request.getParameter("id"));

        carrito.getItems().removeIf(item -> item.getIdProducto() == idProducto);

        sesion.setAttribute("carrito", carrito);

        response.sendRedirect("carrito.jsp");
    }
}
