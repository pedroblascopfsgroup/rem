package es.pfsgroup.plugin.rem.model.dd;

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

/**
 * Modelo que gestiona el diccionario de promociones BBVA
 * 
 * @author Guillem Rey
 *
 */
@Entity
@Table(name = "DD_PBB_PROMOCION_BBVA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDPromocionBBVA implements Auditable, Dictionary {
	

	/**
	 * 
	 */
	private static final long serialVersionUID = -6863803633586359036L;

	
	@Id
	@Column(name = "DD_PBB_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDPromocionBBVAGenerator")
	@SequenceGenerator(name = "DDPromocionBBVAGenerator", sequenceName = "S_DD_PBB_PROMOCION_BBVA")
	private Long id;
	
	@Column(name = "DD_PBB_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_PBB_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_PBB_DESCRIPCION_LARGA")
	private String descripcionLarga;
	
	@Version   
	private Long version;
	
	@Embedded
	private Auditoria auditoria;
	
	
	@Override
	public Long getId() {
		return this.id;
	}

	@Override
	public String getCodigo() {
		return this.codigo;
	}

	@Override
	public String getDescripcion() {
		return this.descripcion;
	}

	@Override
	public String getDescripcionLarga() {
		return this.descripcionLarga;
	}

	@Override
	public Auditoria getAuditoria() {
		return this.auditoria;
	}

	@Override
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public Long getVersion() {
		return version;
	}

	public void setVersion(Long version) {
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
	
}
