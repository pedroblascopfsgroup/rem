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
@Entity
@Table(name = "DD_ODT_ORIGEN_DATO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDOrigenDato implements Auditable, Dictionary {

	
	/**
	 * 
	 */
	private static final long serialVersionUID = -4623695133475926035L;
	
	public static String CODIGO_REM = "01";
	public static String CODIGO_RECOVERY = "02";
	
	@Id
	@Column(name = "DD_ODT_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDOrigenDatoGenerator")
	@SequenceGenerator(name = "DDOrigenDatoGenerator", sequenceName = "S_DD_ODT_ORIGEN_DATO")
	private Long id;
	
	@Column(name = "DD_ODT_CODIGO")
	private String codigo;
	
	@Column(name = "DD_ODT_DESCRIPCION")
	private String descripcion;
	
	@Column(name = "DD_ODT_DESCRIPCION_LARGA")
	private String descripcionLarga;
	
	@Embedded
	private Auditoria auditoria;
	
	@Version
	private Long version;

	
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

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public Long getVersion() {
		return version;
	}

	public void setVersion(Long version) {
		this.version = version;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	
	

}
