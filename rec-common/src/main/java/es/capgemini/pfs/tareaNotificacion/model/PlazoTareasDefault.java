package es.capgemini.pfs.tareaNotificacion.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

/**
 * Representa la tabla pla_plazos_default.
 *
 * @author pamuller
 */
@Entity
@Table(name = "PLA_PLAZOS_DEFAULT", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class PlazoTareasDefault implements Serializable, Auditable {

    public static final String CODIGO_SOLICITUD_EXPEDIENTE_MANUAL = "1";
    public static final String CODIGO_SOLICITUD_PREASUNTO = "2";
    public static final String CODIGO_SOLICITUD_PRORROGA = "3";
    public static final String CODIGO_ACEPTAR_ASUNTO = "4";
    public static final String CODIGO_RECOPILAR_DOCUMENTACION = "5";
    public static final String CODIGO_ASUNTO_PROPUESTO = "6";
    public static final String CODIGO_ACTUALIZAR_ESTADO_RECURSO = "7";
    public static final String CODIGO_ACUERDO_PROPUESTO = "8";
    public static final String CODIGO_CIERRE_ACUERDO = "9";
    public static final String CODIGO_PROPUESTA_DECISION_PROCEDIMIENTO = "10";
    public static final String CODIGO_VERIFICACION_UMBRAL = "11";
    public static final String CODIGO_PLAZO_PRORROGA_DC = "12";
    public static final String CODIGO_PLAZO_PRORROGA_EXTERNA = "13";
    public static final String CODIGO_PLAZO_PRORROGA_DEFAULT = "14";
    public static final String CODIGO_SOLICITUD_EXPEDIENTE_MANUAL_SEG = "15";
    public static final String CODIGO_SOLICITUD_EXPEDIENTE_MANUAL_GESTION_DEUDA = "EXPMGDEUDA";
    public static final String CODIGO_PLAZO_PROPUESTA_OBJETIVO = "16";
    public static final String CODIGO_PLAZO_PROPUESTA_BORRADO_OBJETIVO = "17";
    public static final String CODIGO_PLAZO_PROPUESTA_CUMPLIMIENTO_OBJETIVO = "18";
    public static final String CODIGO_PLAZO_JUSTIFICACION_OBJETIVO = "19";

    private static final long serialVersionUID = -1929265807324971783L;

    @Id
    @Column(name = "PLA_ID")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "DD_STA_ID")
    private SubtipoTarea subTipoTarea;

    @Column(name = "PLA_CODIGO")
    private String codigo;

    @Column(name = "PLA_DESCRIPCION")
    private String descripcion;

    @Column(name = "PLA_PLAZO")
    private Long plazo;

    @Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;

    /**
     * @return the id
     */
    public Long getId() {
        return id;
    }

    /**
     * @param id
     *            the id to set
     */
    public void setId(Long id) {
        this.id = id;
    }

    /**
     * @return the subTipoTarea
     */
    public SubtipoTarea getSubTipoTarea() {
        return subTipoTarea;
    }

    /**
     * @param subTipoTarea
     *            the subTipoTarea to set
     */
    public void setSubTipoTarea(SubtipoTarea subTipoTarea) {
        this.subTipoTarea = subTipoTarea;
    }

    /**
     * @return the codigo
     */
    public String getCodigo() {
        return codigo;
    }

    /**
     * @param codigo
     *            the codigo to set
     */
    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }

    /**
     * @return the descripcion
     */
    public String getDescripcion() {
        return descripcion;
    }

    /**
     * @param descripcion
     *            the descripcion to set
     */
    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    /**
     * @return the plazo
     */
    public Long getPlazo() {
        return plazo;
    }

    /**
     * @param plazo
     *            the plazo to set
     */
    public void setPlazo(Long plazo) {
        this.plazo = plazo;
    }

    /**
     * @return the auditoria
     */
    public Auditoria getAuditoria() {
        return auditoria;
    }

    /**
     * @param auditoria
     *            the auditoria to set
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
     * @param version
     *            the version to set
     */
    public void setVersion(Integer version) {
        this.version = version;
    }

}
