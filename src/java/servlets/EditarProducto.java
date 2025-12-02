package servlets;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/EditarProducto")
@MultipartConfig
public class EditarProducto extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
                          throws ServletException, java.io.IOException {

        request.setCharacterEncoding("UTF-8");

        String id = request.getParameter("id");
        String nombre = request.getParameter("nombre");
        String precio = request.getParameter("precio");
        String descripcion = request.getParameter("descripcion");
        String categoria = request.getParameter("categoria");
        String activo = request.getParameter("activo") != null ? "1" : "0";

        Part imagenPart = request.getPart("imagen");
        String nuevaImagen = imagenPart.getSubmittedFileName();

        String imagenFinal = "";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3307/cafeteria?useSSL=false", "root", ""
            );

            if(nuevaImagen == null || nuevaImagen.trim().isEmpty()){

                PreparedStatement psOld = con.prepareStatement(
                    "SELECT imagen FROM producto WHERE idProducto=?"
                );
                psOld.setInt(1, Integer.parseInt(id));
                ResultSet rsOld = psOld.executeQuery();
                if(rsOld.next()) imagenFinal = rsOld.getString("imagen");

            } else {
                imagenFinal = nuevaImagen;

                String ruta = request.getServletContext().getRealPath("/img/");
                File f = new File(ruta);
                if(!f.exists()) f.mkdir();

                try (InputStream is = imagenPart.getInputStream()) {
                    FileOutputStream fos = new FileOutputStream(ruta + File.separator + nuevaImagen);
                    byte[] buffer = new byte[1024];
                    int bytes;
                    while((bytes = is.read(buffer)) != -1){
                        fos.write(buffer, 0, bytes);
                    }
                    fos.close();
                }
            }

            PreparedStatement ps = con.prepareStatement(
                "UPDATE producto SET nombre=?, precio=?, descripcion=?, idCategoria=?, imagen=?, activo=? WHERE idProducto=?"
            );

            ps.setString(1, nombre);
            ps.setDouble(2, Double.parseDouble(precio));
            ps.setString(3, descripcion);
            ps.setInt(4, Integer.parseInt(categoria));
            ps.setString(5, imagenFinal);
            ps.setInt(6, Integer.parseInt(activo));
            ps.setInt(7, Integer.parseInt(id));

            ps.executeUpdate();
            con.close();

        } catch (Exception e) {
            response.getWriter().println("Error: " + e.getMessage());
            return;
        }

        response.sendRedirect("editarProducto.jsp?id=" + id + "&guardado=1");

    }
}
