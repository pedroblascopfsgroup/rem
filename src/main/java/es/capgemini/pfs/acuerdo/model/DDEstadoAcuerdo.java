package es.capgemini.pfs.acuerdo.model;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;

/**
 * Entidad Estado Acuerdo.
 *
 * @author jpbosnjak
 *
 */
@Entity
@Table(name = "DD_EAC_ESTADO_ACUERDO", schema = "${master.schema}")
public class DDEstadoAcuerdo implements Dictionary, Auditable {

    public static final String ACUERDO_EN_CONFORMACION = "01";
    public static final String ACUERDO_PROPUESTO = "02";
    public static final String ACUERDO_VIGENTE = "03";
    public static final String ACUERDO_RECHAZADO = "04";
    public static final String ACUERDO_CANCELADO = "05";
    public static final String ACUERDO_FINALIZADO = "06";

    private static final long serialVersionUID = -5000987797957822994L;

    @Id
    @Column(name = "DD_EAC_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "DDEstadoAcuerdoGenerator")
    @SequenceGenerator(name = "DDEstadoAcuerdoGenerator", sequenceName = "${master.schema}.S_DD_EAC_ESTADO_ACUERDO")
    private Long id;

    @Column(name = "DD_EAC_CODIGO")
    private String codigo;

    @Column(name = "DD_EAC_DESCRIPCION")
    private String descripcion;

    @Column(name = "DD_EAC_DESCRIPCION_LARGA")
    private String descripcionLarga;

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
     * @return the descripcionLarga
     */
    public String getDescripcionLarga() {
        return descripcionLarga;
    }

    /**
     * @param descripcionLarga
     *            the descripcionLarga to set
     */
    public void setDescripcionLarga(String descripcionLarga) {
        this.descripcionLarga = descripcionLarga;
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
