package es.capgemini.pfs.asunto.model;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;

/**
 * Clase que representa la entidad tipo actuacion.
 * @author jpbosnjak
 *
 */
@Entity
@Table(name = "DD_TAC_TIPO_ACTUACION", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class DDTipoActuacion implements Dictionary, Auditable {
	
	
	public static final String TIPO_ACTUACION_PRECONTENCIOSO = "PCO";
	public static final String TIPO_ACTUACION_CNT_BLOQUEADOS = "04";
	public static final String TIPO_ACTUACION_EJECUTIVO_CAMBIARIO = "EJ";

    /**
     * serialVersionUID.
     */
    private static final long serialVersionUID = -8961132998182577279L;

    @Id
    @Column(name = "DD_TAC_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "DDTipoActuacionGenerator")
    @SequenceGenerator(name = "DDTipoActuacionGenerator", sequenceName = "S_DD_TAC_TIPO_ACTUACION")
    private Long id;

    @Column(name = "DD_TAC_CODIGO")
    private String codigo;

    @Column(name = "DD_TAC_DESCRIPCION")
    private String descripcion;

    @Column(name = "DD_TAC_DESCRIPCION_LARGA")
    private String descripcionLarga;
    
	@ManyToOne
	@JoinColumn(name = "DD_TAS_ID")
	private DDTiposAsunto tipoAsunto;

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
     * @param id the id to set
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
     * @param codigo the codigo to set
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
     * @param descripcion the descripcion to set
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
     * @param descripcionLarga the descripcionLarga to set
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
    
    public DDTiposAsunto getTipoAsunto() {
		return tipoAsunto;
	}

	public void setTipoAsunto(DDTiposAsunto tipoAsunto) {
		this.tipoAsunto = tipoAsunto;
	}

}
