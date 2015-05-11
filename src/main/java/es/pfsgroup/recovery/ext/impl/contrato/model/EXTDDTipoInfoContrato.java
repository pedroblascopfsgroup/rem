package es.pfsgroup.recovery.ext.impl.contrato.model;

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
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;
import es.pfsgroup.recovery.ext.api.contrato.model.EXTDDTipoInfoContratoInfo;

@Entity
@Table(name="EXT_DD_IFC_INFO_CONTRATO",schema="${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class EXTDDTipoInfoContrato implements EXTDDTipoInfoContratoInfo, Dictionary, Auditable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 319505570168770201L;

	@Id
	@Column(name = "DD_IFC_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "EXTDDTipoInfoContratoGenerator")
	@SequenceGenerator(name = "EXTDDTipoInfoContratoGenerator", sequenceName = "S_EXT_DD_IFC_INFO_CONTRATO")
	private Long id;
	
	@Column(name = "DD_IFC_CODIGO")
	private String codigo;
	
	@Column(name = "DD_IFC_DESCRIPCION")
	private String descripcion;
	
	@Column(name = "DD_IFC_DESCRIPCION_LARGA")
	private String descripcionLarga;
	
	@Column(name = "DD_IFC_PERMITE_BUSQUEDA")
	private Boolean permiteBusqueda;
	
	@Embedded
	private Auditoria auditoria;

	@Version
	private Integer version;
	
	@Override
	public String getCodigo() {
		return codigo;
	}

	@Override
	public String getDescripcion() {
		return descripcion;
	}

	@Override
	public String getDescripcionLarga() {
		return descripcionLarga;
	}

	@Override
	public Long getId() {
		return id;
	}

	@Override
	public Auditoria getAuditoria() {
		return auditoria;
	}

	@Override
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria=auditoria;
		
	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public void setDescripcionLarga(String descripcionLarga) {
		this.descripcionLarga = descripcionLarga;
	}

	public void setPermiteBusqueda(Boolean permiteBusqueda) {
		this.permiteBusqueda = permiteBusqueda;
	}

	public Boolean getPermiteBusqueda() {
		return permiteBusqueda;
	}
	

}
