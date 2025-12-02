package servlets;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;


@WebServlet("/AgregarProducto")
@MultipartConfig
public class AgregarProducto extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
                          throws ServletException, java.io.IOException {

        request.setCharacterEncoding("UTF-8");

        String nombre = request.getParameter("nombre");
        String precio = request.getParameter("precio");
        String descripcion = request.getParameter("descripcion");
        String categoria = request.getParameter("categoria");
        String activo = request.getParameter("activo") != null ? "1" : "0";

        Part imagenPart = request.getPart("imagen");
        String nombreImagen = imagenPart.getSubmittedFileName();

        String rutaImg = request.getServletContext().getRealPath("/img/");
        File uploadDir = new File(rutaImg);
        if (!uploadDir.exists()) uploadDir.mkdir();

        try (InputStream is = imagenPart.getInputStream()) {
            FileOutputStream fos = new FileOutputStream(rutaImg + File.separator + nombreImagen);
            byte[] buffer = new byte[1024];
            int bytesLeidos;
            while ((bytesLeidos = is.read(buffer)) != -1) {
                fos.write(buffer, 0, bytesLeidos);
            }
            fos.close();
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3307/cafeteria?useSSL=false", "root", ""
            );

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO producto (nombre, precio, descripcion, idCategoria, imagen, activo) " +
                "VALUES (?, ?, ?, ?, ?, ?)"
            );

            ps.setString(1, nombre);
            ps.setDouble(2, Double.parseDouble(precio));
            ps.setString(3, descripcion);
            ps.setInt(4, Integer.parseInt(categoria));
            ps.setString(5, nombreImagen);
            ps.setInt(6, Integer.parseInt(activo));

            ps.executeUpdate();
            con.close();

        } catch (Exception e) {
            response.getWriter().println("Error al guardar: " + e.getMessage());
            return;
        }

        response.sendRedirect("agregarProducto.jsp?agregado=1");
    }
}
