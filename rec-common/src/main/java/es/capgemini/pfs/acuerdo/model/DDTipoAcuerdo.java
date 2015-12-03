package es.capgemini.pfs.acuerdo.model;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;
import es.capgemini.pfs.tareaNotificacion.model.DDEntidadAcuerdo;

/**
 * Entidad Tipo Acuerdo.
 *
 * @author jpbosnjak
 *
 */
@Entity
@Table(name = "DD_TPA_TIPO_ACUERDO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class DDTipoAcuerdo implements Dictionary, Auditable {

    private static final long serialVersionUID = -5000987797957822994L;
    
    public static final String CODIGO_PLAN_PAGO = "PLAN_PAGO";
    
    public static final String SIN_PROPUESTA = "-1";
    
    public static final String TIPO_DACION = "DA_CV";
    public static final String TIPO_DACION_EXP = "01";

    @Id
    @Column(name = "DD_TPA_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "DDTipoAcuerdoGenerator")
    @SequenceGenerator(name = "DDTipoAcuerdoGenerator", sequenceName = "S_DD_TPA_TIPO_ACUERDO")
    private Long id;

    @Column(name = "DD_TPA_CODIGO")
    private String codigo;

    @Column(name = "DD_TPA_DESCRIPCION")
    private String descripcion;

    @Column(name = "DD_TPA_DESCRIPCION_LARGA")
    private String descripcionLarga;
    
    @OneToOne(targetEntity = DDEntidadAcuerdo.class, fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_ENT_ACU_ID")
    private DDEntidadAcuerdo tipoEntidad;

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

	public DDEntidadAcuerdo getTipoEntidad() {
		return tipoEntidad;
	}

	public void setTipoEntidad(DDEntidadAcuerdo tipoEntidad) {
		this.tipoEntidad = tipoEntidad;
	}
    
    

}
