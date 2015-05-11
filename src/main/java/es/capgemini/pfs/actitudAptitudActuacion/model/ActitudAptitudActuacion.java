package es.capgemini.pfs.actitudAptitudActuacion.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

/**
 * Clase que representa a la entidad Actitud Aptitud Actuacion.
 * @author mtorrado
 *
 */
@Entity
@Table(name = "AAA_ACTITUD_APTITUD_ACTUACION", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class ActitudAptitudActuacion implements Serializable,Auditable {

    private static final long serialVersionUID = 2135734595791904737L;

    @Id
    @Column(name = "AAA_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "AAAGenerator")
    @SequenceGenerator(name = "AAAGenerator", sequenceName = "S_AAA_ACT_APT_ACT")
    private Long id;

    @OneToOne
    @JoinColumn(name="DD_PRA_ID")
    private DDPropuestaActuacion tipoPropuestaActuacion;

    @Column(name="AAA_GESTIONES")
    private String gestiones;

    @Column(name="AAA_COMETARIOS_SITUACION")
    private String comentariosSituacion;

    @Column(name="AAA_PROPUESTA_ACTUACION")
    private String propuestaActuacion;

    @ManyToOne
    @JoinColumn(name="DD_CIM_ID")
    private DDCausaImpago causaImpago;

    @ManyToOne
    @JoinColumn(name="DD_TAA_ID")
    private DDTipoAyudaActuacion tipoAyudaActuacion;

    @Column(name="AAA_TIPO_AYUDA_ACTUACION")
    private String descripcionTipoAyudaActuacion;

    @Column(name="AAA_REVISION")
    private String revision;

    @Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;


    /**
     * Retorna el atributo id.
     * @return id
     */
    public Long getId() {
        return id;
    }

    /**
     * Setea el atributo id.
     * @param id Long
     */
    public void setId(Long id) {
        this.id = id;
    }

     /**
     * Retorna el atributo auditoria.
     * @return auditoria
     */
    public Auditoria getAuditoria() {
        return auditoria;
    }

    /**
     * Setea el atributo auditoria.
     * @param auditoria Auditoria
     */
    public void setAuditoria(Auditoria auditoria) {
        this.auditoria = auditoria;
    }

     /**
     * Retorna el atributo version.
     * @return version
     */
    public Integer getVersion() {
        return version;
    }

    /**
     * Setea el atributo version.
     * @param version Integer
     */
    public void setVersion(Integer version) {
        this.version = version;
    }

    /**
     * @return the gestiones
     */
    public String getGestiones() {
        return gestiones;
    }

    /**
     * @param gestiones the gestiones to set
     */
    public void setGestiones(String gestiones) {
        this.gestiones = gestiones;
    }

    /**
     * @return the comentariosSituacion
     */
    public String getComentariosSituacion() {
        return comentariosSituacion;
    }

    /**
     * @param comentariosSituacion the comentariosSituacion to set
     */
    public void setComentariosSituacion(String comentariosSituacion) {
        this.comentariosSituacion = comentariosSituacion;
    }

    /**
     * @return the propuestaActuacion
     */
    public String getPropuestaActuacion() {
        return propuestaActuacion;
    }

    /**
     * @param propuestaActuacion the propuestaActuacion to set
     */
    public void setPropuestaActuacion(String propuestaActuacion) {
        this.propuestaActuacion = propuestaActuacion;
    }

    /**
     * @return the tipoAyudaActuacion
     */
    public DDTipoAyudaActuacion getTipoAyudaActuacion() {
        return tipoAyudaActuacion;
    }

    /**
     * @param tipoAyudaActuacion the tipoAyudaActuacion to set
     */
    public void setTipoAyudaActuacion(DDTipoAyudaActuacion tipoAyudaActuacion) {
        this.tipoAyudaActuacion = tipoAyudaActuacion;
    }

    /**
     * @return the descripcionTipoAyudaActuacion
     */
    public String getDescripcionTipoAyudaActuacion() {
        return descripcionTipoAyudaActuacion;
    }

    /**
     * @param descripcionTipoAyudaActuacion the descripcionTipoAyudaActuacion to set
     */
    public void setDescripcionTipoAyudaActuacion(
            String descripcionTipoAyudaActuacion) {
        this.descripcionTipoAyudaActuacion = descripcionTipoAyudaActuacion;
    }

    /**
     * @return the causaImpago
     */
    public DDCausaImpago getCausaImpago() {
        return causaImpago;
    }

    /**
     * @param causaImpago the causaImpago to set
     */
    public void setCausaImpago(DDCausaImpago causaImpago) {
        this.causaImpago = causaImpago;
    }

    /**
     * @return the tipoPropuestaActuacion
     */
    public DDPropuestaActuacion getTipoPropuestaActuacion() {
        return tipoPropuestaActuacion;
    }

    /**
     * @param tipoPropuestaActuacion the tipoPropuestaActuacion to set
     */
    public void setTipoPropuestaActuacion(DDPropuestaActuacion tipoPropuestaActuacion) {
        this.tipoPropuestaActuacion = tipoPropuestaActuacion;
    }

    /**
     * @param revision the revision to set
     */
    public void setRevision(String revision) {
        this.revision = revision;
    }

    /**
     * @return the revision
     */
    public String getRevision() {
        return revision;
    }
}