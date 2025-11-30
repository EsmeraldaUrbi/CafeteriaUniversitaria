package servlets;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/AgregarCarrito")

public class AgregarCarrito extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession sesion = request.getSession();

        // Validar sesión
        Integer idUsuario = (Integer) sesion.getAttribute("idUsuario");
        if(idUsuario == null){
            response.sendRedirect("login.jsp");
            return;
        }

        int idProducto = Integer.parseInt(request.getParameter("producto"));

        try{
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3307/cafeteria?useSSL=false",
                "root", ""
            );

            // 1. Ver si ya existe un carrito del usuario
            PreparedStatement psCar = con.prepareStatement(
                "SELECT idCarrito FROM carrito WHERE idUsuario=?"
            );
            psCar.setInt(1, idUsuario);
            ResultSet rsCar = psCar.executeQuery();

            int idCarrito = 0;

            if(rsCar.next()){
                idCarrito = rsCar.getInt("idCarrito");
            } else {
                // 2. Crear el carrito si no existe
                PreparedStatement psNew = con.prepareStatement(
                    "INSERT INTO carrito(idUsuario, fechaCreacion) VALUES (?, NOW())",
                    Statement.RETURN_GENERATED_KEYS
                );
                psNew.setInt(1, idUsuario);
                psNew.executeUpdate();

                ResultSet gen = psNew.getGeneratedKeys();
                if(gen.next()){
                    idCarrito = gen.getInt(1);
                }
            }

            // 3. Ver si ese producto YA está en el carrito
            PreparedStatement psItem = con.prepareStatement(
                "SELECT * FROM item_carrito WHERE idCarrito=? AND idProducto=?"
            );
            psItem.setInt(1, idCarrito);
            psItem.setInt(2, idProducto);

            ResultSet rsItem = psItem.executeQuery();

            if(rsItem.next()){
                // YA existe → aumentar cantidad
                int nuevaCantidad = rsItem.getInt("cantidad") + 1;
                double precioUnit = rsItem.getDouble("precioUnitario");
                double nuevoSubtotal = nuevaCantidad * precioUnit;

                PreparedStatement psUpdate = con.prepareStatement(
                    "UPDATE item_carrito SET cantidad=?, subtotal=? WHERE idItem=?"
                );
                psUpdate.setInt(1, nuevaCantidad);
                psUpdate.setDouble(2, nuevoSubtotal);
                psUpdate.setInt(3, rsItem.getInt("idItem"));
                psUpdate.executeUpdate();
            }
            else {
                // NO existe → obtener precio
                PreparedStatement psProd = con.prepareStatement(
                    "SELECT precio FROM producto WHERE idProducto=?"
                );
                psProd.setInt(1, idProducto);
                ResultSet rsProd = psProd.executeQuery();

                double precio = 0;
                if(rsProd.next()){
                    precio = rsProd.getDouble("precio");
                }

                // Insertar item nuevo
                PreparedStatement psInsert = con.prepareStatement(
                    "INSERT INTO item_carrito(idCarrito, idProducto, cantidad, precioUnitario, subtotal) VALUES (?, ?, 1, ?, ?)"
                );
                psInsert.setInt(1, idCarrito);
                psInsert.setInt(2, idProducto);
                psInsert.setDouble(3, precio);
                psInsert.setDouble(4, precio);
                psInsert.executeUpdate();
            }

            con.close();

            // Regresar al menú
            response.sendRedirect("indexCliente.jsp?add=1");


        }catch(Exception e){
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
