package classes;

public class PersonalCafeteria extends Usuario {

    private String noEmpleado;

    public PersonalCafeteria() {}

    public PersonalCafeteria(int idUsuario, String nombre, String correo, String contrasenia, String noEmpleado) {
        super(idUsuario, nombre, correo, contrasenia);
        this.noEmpleado = noEmpleado;
    }

    public String getNoEmpleado() {
        return noEmpleado;
    }

    public void setNoEmpleado(String noEmpleado) {
        this.noEmpleado = noEmpleado;
    }
}
