package classes;

public class Pedido {

    private int idPedido;
    private int idCarrito;
    private String fecha;
    private String estado;
    private double total;

    public Pedido() {}

    public Pedido(int idPedido, int idCarrito, String fecha, String estado, double total) {
        this.idPedido = idPedido;
        this.idCarrito = idCarrito;
        this.fecha = fecha;
        this.estado = estado;
        this.total = total;
    }

    public int getIdPedido() {
        return idPedido;
    }

    public void setIdPedido(int idPedido) {
        this.idPedido = idPedido;
    }

    public int getIdCarrito() {
        return idCarrito;
    }

    public void setIdCarrito(int idCarrito) {
        this.idCarrito = idCarrito;
    }

    public String getFecha() {
        return fecha;
    }

    public void setFecha(String fecha) {
        this.fecha = fecha;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public double getTotal() {
        return total;
    }

    public void setTotal(double total) {
        this.total = total;
    }
}
