package es.capgemini.pfs.auditoria.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Embeddable;

import es.capgemini.devon.security.SecurityUtils;
import es.capgemini.pfs.auditoria.Auditable;

/**
 *    USUARIOCREAR         VARCHAR(10) NOT NULL,
 *    FECHACREAR           DATE NOT NULL,
 *    USUARIOMODIF         VARCHAR(10),
 *    FECHAMODIF           DATE,
 *    USUARIOBORRAR        VARCHAR(10),
 *    FECHABORRAR          DATE,
 *    BORRADO              NUMERIC(1,0) NOT NULL DEFAULT 0.
 *
 * @author Nicol�s Cornaglia
 */
@Embeddable
public class Auditoria implements Serializable {

    private static final long serialVersionUID = 1L;
    public static final String DEFAULT_USER = "DD";
    public static final String UNDELETED_RESTICTION = "borrado = 0";

    private String usuarioCrear;
    private Date fechaCrear;
    @Column(name = "USUARIOMODIFICAR")
    private String usuarioModificar;
    @Column(name = "FECHAMODIFICAR")
    private Date fechaModificar;
    private String usuarioBorrar;
    private Date fechaBorrar;
    //@Where(clause = "borrado = 0")
    private boolean borrado;

    /**
     * @return the usuarioCrear
     */
    public String getUsuarioCrear() {
        return usuarioCrear;
    }

    /**
     * @param usuarioCrear the usuarioCrear to set
     */
    public void setUsuarioCrear(String usuarioCrear) {
        this.usuarioCrear = usuarioCrear;
    }

    /**
     * @return the fechaCrear
     */
    public Date getFechaCrear() {
        return fechaCrear;
    }

    /**
     * @param fechaCrear the fechaCrear to set
     */
    public void setFechaCrear(Date fechaCrear) {
        this.fechaCrear = fechaCrear;
    }

    /**
     * @return the usuarioModificar
     */
    public String getUsuarioModificar() {
        return usuarioModificar;
    }

    /**
     * @param usuarioModificar the usuarioModificar to set
     */
    public void setUsuarioModificar(String usuarioModificar) {
        this.usuarioModificar = usuarioModificar;
    }

    /**
     * @return the fechaModificar
     */
    public Date getFechaModificar() {
        return fechaModificar;
    }

    /**
     * @param fechaModificar the fechaModificar to set
     */
    public void setFechaModificar(Date fechaModificar) {
        this.fechaModificar = fechaModificar;
    }

    /**
     * @return the usuarioBorrar
     */
    public String getUsuarioBorrar() {
        return usuarioBorrar;
    }

    /**
     * @param usuarioBorrar the usuarioBorrar to set
     */
    public void setUsuarioBorrar(String usuarioBorrar) {
        this.usuarioBorrar = usuarioBorrar;
    }

    /**
     * @return the fechaBorrar
     */
    public Date getFechaBorrar() {
        return fechaBorrar;
    }

    /**
     * @param fechaBorrar the fechaBorrar to set
     */
    public void setFechaBorrar(Date fechaBorrar) {
        this.fechaBorrar = fechaBorrar;
    }

    /**
     * @return the borrado
     */
    public boolean isBorrado() {
        return borrado;
    }

    /**
     * @param borrado the borrado to set
     */
    public void setBorrado(boolean borrado) {
        this.borrado = borrado;
    }

    /** factory method para facilitar la creaci�n de un objeto auditor�a.
     * @return objecto auditable
     */
    public static Auditoria getNewInstance() {
        Auditoria auditoria = new Auditoria();
        //auditoria.setUsuarioCrear(SecurityUtils.getCurrentUser().getUsername());
        auditoria.setUsuarioCrear(getCurrentUserName());
        auditoria.setFechaCrear(new Date());
        return auditoria;
    }

    /**
     * se llama cuando se ejecuta el borrado de un registro.
     * @param auditable objecto auditable
     */
    public static void delete(Auditable auditable) {
        Auditoria auditoria = auditable.getAuditoria();
        auditoria.setFechaBorrar(new Date());
        //auditoria.setUsuarioBorrar(SecurityUtils.getCurrentUser().getUsername());
        auditoria.setUsuarioBorrar(getCurrentUserName());
        auditoria.setBorrado(true);
    }

    /** l�gica que se llamar� al guardar un objeto.
     * @param auditable auditable
     */
    public static void save(Auditable auditable) {
        Auditoria auditoria = auditable.getAuditoria();
        if (auditoria == null) {
            auditoria = Auditoria.getNewInstance();
            auditable.setAuditoria(auditoria);
        } else {
            //auditoria.setUsuarioModificar(SecurityUtils.getCurrentUser().getUsername());
            auditoria.setUsuarioModificar(getCurrentUserName());
            auditoria.setFechaModificar(new Date());
        }
    }

    private static String getCurrentUserName() {
        if (SecurityUtils.getCurrentUser() != null) {
            return SecurityUtils.getCurrentUser().getUsername();
        }
        //Para Bath
        return DEFAULT_USER;
    }

}
