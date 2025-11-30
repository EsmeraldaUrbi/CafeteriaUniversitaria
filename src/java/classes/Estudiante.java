package classes;

public class Estudiante extends Usuario {

    private String matricula;

    public Estudiante() {}

    public Estudiante(int idUsuario, String nombre, String correo, String contrasenia, String matricula) {
        super(idUsuario, nombre, correo, contrasenia);
        this.matricula = matricula;
    }

    public String getMatricula() {
        return matricula;
    }

    public void setMatricula(String matricula) {
        this.matricula = matricula;
    }
}
