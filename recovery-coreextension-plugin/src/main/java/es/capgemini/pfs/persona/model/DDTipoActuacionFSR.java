package es.capgemini.pfs.persona.model;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;

/**
 * Entidad DD_TAF_TIPO_ACTUACION_FSR
 *
 * @author Jorge Ros	
 *
 */
@Entity
@Table(name = "DD_TAF_TIPO_ACTUACION_FSR", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class DDTipoActuacionFSR implements Dictionary, Auditable  {
	 
	private static final long serialVersionUID = 1L;
	
	@Id
    @Column(name = "DD_TAF_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "DDTipoActuacionFSRGenerator")
    @SequenceGenerator(name = "DDTipoActuacionFSRGenerator", sequenceName = "S_DD_TAF_TIPO_ACTUACION_FSR")
	private Long id; 
	
	@Column(name = "DD_TAF_CODIGO")
	private String codigo;
	
	@Column(name = "DD_TAF_DESCRIPCION")
    private String descripcion;

    @Column(name = "DD_TAF_DESCRIPCION_LARGA")
    private String descripcionLarga;
    
    @Column(name = "DD_TAF_RESTRICTIVA")
    private Boolean restrictiva;
    
    @Version
    private Integer version;
    
    @Embedded
    private Auditoria auditoria;

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
	 * @return the restrictiva
	 */
	public Boolean getRestrictiva() {
		return restrictiva;
	}

	/**
	 * @param restrictiva the restrictiva to set
	 */
	public void setRestrictiva(Boolean restrictiva) {
		this.restrictiva = restrictiva;
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
    
    
}
