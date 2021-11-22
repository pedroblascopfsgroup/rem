package es.pfsgroup.plugin.rem.model.dd;

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
import javax.persistence.Transient;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;
import es.pfsgroup.commons.utils.Checks;

/**
 * Modelo que gestiona el diccionario de subcarteras.
 * 
 * @author Lara Pablo
 *
 */
@Entity
@Table(name = "DD_RFC_REGIMEN_FIANZA_CCAA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDRegimenFianzaCCAA implements Auditable, Dictionary {

	private static final long serialVersionUID = 1L;
	public static final String ENTIDAD_FINANCIERA_BANKIA = "01";

	@Id
	@Column(name = "DD_RFC_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDRegimenFianzaCCAAGenerator")
	@SequenceGenerator(name = "DDRegimenFianzaCCAAGenerator", sequenceName = "S_DD_RFC_REGIMEN_FIANZA_CCAA")
	private Long id;
	
	@Column(name = "DD_RFC_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_RFC_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_RFC_DESCRIPCION_LARGA")   
	private String descripcionLarga;	
	
	@Column(name = "DD_RFC_CODIGO_C4C")   
	private String codigoC4C;
	    
	@Version   
	private Long version;

	@Embedded
	private Auditoria auditoria;
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getCodigo() {
		return codigo;
	}

	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public String getDescripcionLarga() {
		return descripcionLarga;
	}

	public void setDescripcionLarga(String descripcionLarga) {
		this.descripcionLarga = descripcionLarga;
	}

	public Long getVersion() {
		return version;
	}

	public void setVersion(Long version) {
		this.version = version;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public String getCodigoC4C() {
		return codigoC4C;
	}

	public void setCodigoC4C(String codigoC4C) {
		this.codigoC4C = codigoC4C;
	}
	
}
