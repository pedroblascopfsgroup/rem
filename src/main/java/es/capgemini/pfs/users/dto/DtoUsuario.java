package es.capgemini.pfs.users.dto;

import java.io.Serializable;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto de usuario.
 * @author aesteban
 *
 */
public class DtoUsuario extends WebDto implements Serializable {

    private static final long serialVersionUID = 3414263785853148265L;
    private Long id;
    private String username;
    private String nombre;
    private String apellido1;
    private String apellido2;
    private String password;
    private String passwordNuevo;
    private String passwordNuevoVerificado;
    private String email;
    private String telefono;

    /**
     * @return the username
     */
    public String getUsername() {
        return username;
    }

    /**
     * @param username the username to set
     */
    public void setUsername(String username) {
        this.username = username;
    }

    /**
     * @return the nombre
     */
    public String getNombre() {
        return nombre;
    }

    /**
     * @param nombre the nombre to set
     */
    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    /**
     * @return the apellido1
     */
    public String getApellido1() {
        return apellido1;
    }

    /**
     * @param apellido1 the apellido1 to set
     */
    public void setApellido1(String apellido1) {
        this.apellido1 = apellido1;
    }

    /**
     * @return the apellido2
     */
    public String getApellido2() {
        return apellido2;
    }

    /**
     * @param apellido2 the apellido2 to set
     */
    public void setApellido2(String apellido2) {
        this.apellido2 = apellido2;
    }

    /**
     * @return the password
     */
    public String getPassword() {
        return password;
    }

    /**
     * @param password the password to set
     */
    public void setPassword(String password) {
        this.password = password;
    }

    /**
     * @return the passwordNuevo
     */
    public String getPasswordNuevo() {
        return passwordNuevo;
    }

    /**
     * @param passwordNuevo the passwordNuevo to set
     */
    public void setPasswordNuevo(String passwordNuevo) {
        this.passwordNuevo = passwordNuevo;
    }

    /**
     * @return the passwordNuevoVerificado
     */
    public String getPasswordNuevoVerificado() {
        return passwordNuevoVerificado;
    }

    /**
     * @param passwordNuevoVerificado the passwordNuevoVerificado to set
     */
    public void setPasswordNuevoVerificado(String passwordNuevoVerificado) {
        this.passwordNuevoVerificado = passwordNuevoVerificado;
    }

    /**
     * @return the email
     */
    public String getEmail() {
        return email;
    }

    /**
     * @param email the email to set
     */
    public void setEmail(String email) {
        this.email = email;
    }

    /**
     * @return the telefono
     */
    public String getTelefono() {
        return telefono;
    }

    /**
     * @param telefono the telefono to set
     */
    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    /**
     * @return the id
     */
    public Long getId() {
        return id;
    }

    /**
     * @param id the id to set
     */
    public void setId(Long id) {
        this.id = id;
    }
}
