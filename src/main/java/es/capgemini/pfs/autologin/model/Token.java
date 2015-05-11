package es.capgemini.pfs.autologin.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.model.Auditoria;

/**
 * Clase form item. Cada instancia es un elemento de un formulario
 * @author omedrano
 *
 */
@Entity
@Table(name = "TKN_TOKEN_AUTOLOGIN", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class Token implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @Column(name = "TKN_ID")
    private Long id;

    @Column(name = "TKN_VALOR")
    private String valor;

    @Column(name = "TKN_FECHA_INICIO")
    private Date fechaInicioValidez;

    @Column(name = "TKN_FECHA_FIN")
    private Date fechaFinValidez;

    @Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;

    @Column(name = "TKN_TOKEN")
    private String token;

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

    /**
     * @return the valor
     */
    public String getValor() {
        return valor;
    }

    /**
     * @param valor the valor to set
     */
    public void setValor(String valor) {
        this.valor = valor;
    }

    /**
     * @return the fechaInicioValidez
     */
    public Date getFechaInicioValidez() {
        return fechaInicioValidez;
    }

    /**
     * @param fechaInicioValidez the fechaInicioValidez to set
     */
    public void setFechaInicioValidez(Date fechaInicioValidez) {
        this.fechaInicioValidez = fechaInicioValidez;
    }

    /**
     * @return the fechaFinValidez
     */
    public Date getFechaFinValidez() {
        return fechaFinValidez;
    }

    /**
     * @param fechaFinValidez the fechaFinValidez to set
     */
    public void setFechaFinValidez(Date fechaFinValidez) {
        this.fechaFinValidez = fechaFinValidez;
    }

    /**
     * @return the auditoria
     */
    public Auditoria getAuditoria() {
        return auditoria;
    }

    /**
     * @param auditoria the auditoria to set
     */
    public void setAuditoria(Auditoria auditoria) {
        this.auditoria = auditoria;
    }

    /**
     * @return the version
     */
    public Integer getVersion() {
        return version;
    }

    /**
     * @param version the version to set
     */
    public void setVersion(Integer version) {
        this.version = version;
    }

    /**
     * @return the token
     */
    public String getToken() {
        return token;
    }

    /**
     * @param token the token to set
     */
    public void setToken(String token) {
        this.token = token;
    }
}
