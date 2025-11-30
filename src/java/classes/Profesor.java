package classes;

public class Profesor extends Usuario {

    private String noTrabajador;

    public Profesor() {}

    public Profesor(int idUsuario, String nombre, String correo, String contrasenia, String noTrabajador) {
        super(idUsuario, nombre, correo, contrasenia);
        this.noTrabajador = noTrabajador;
    }

    public String getNoTrabajador() {
        return noTrabajador;
    }

    public void setNoTrabajador(String noTrabajador) {
        this.noTrabajador = noTrabajador;
    }
}
