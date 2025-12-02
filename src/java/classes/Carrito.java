package classes;

import java.util.ArrayList;

public class Carrito {

    private int idCarrito;
    private int idUsuario;
    private String fechaCreacion;
    private ArrayList<ItemCarrito> items;

    public Carrito() {
        items = new ArrayList<>();
    }

    public Carrito(int idCarrito, int idUsuario, String fechaCreacion) {
        this.idCarrito = idCarrito;
        this.idUsuario = idUsuario;
        this.fechaCreacion = fechaCreacion;
        this.items = new ArrayList<>();
    }

    public int getIdCarrito() {
        return idCarrito;
    }

    public void setIdCarrito(int idCarrito) {
        this.idCarrito = idCarrito;
    }

    public int getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }

    public String getFechaCreacion() {
        return fechaCreacion;
    }

    public void setFechaCreacion(String fechaCreacion) {
        this.fechaCreacion = fechaCreacion;
    }

    public ArrayList<ItemCarrito> getItems() {
        return items;
    }

    public void setItems(ArrayList<ItemCarrito> items) {
        this.items = items;
    }

    
    public double calcularSubtotal() {
        double total = 0;
        for (ItemCarrito it : items) {
            total += it.getSubtotal();
        }
        return total;
    }
}
