package modelo;

public class Pago {

    private int idPago;
    private int idPedido;
    private String metodo;
    private String numeroTarjeta;
    private double monto;

    public Pago() {}

    public Pago(int idPago, int idPedido, String metodo, String numeroTarjeta, double monto) {
        this.idPago = idPago;
        this.idPedido = idPedido;
        this.metodo = metodo;
        this.numeroTarjeta = numeroTarjeta;
        this.monto = monto;
    }

    public int getIdPago() {
        return idPago;
    }

    public void setIdPago(int idPago) {
        this.idPago = idPago;
    }

    public int getIdPedido() {
        return idPedido;
    }

    public void setIdPedido(int idPedido) {
        this.idPedido = idPedido;
    }

    public String getMetodo() {
        return metodo;
    }

    public void setMetodo(String metodo) {
        this.metodo = metodo;
    }

    public String getNumeroTarjeta() {
        return numeroTarjeta;
    }

    public void setNumeroTarjeta(String numeroTarjeta) {
        this.numeroTarjeta = numeroTarjeta;
    }

    public double getMonto() {
        return monto;
    }

    public void setMonto(double monto) {
        this.monto = monto;
    }
}
