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
 * Modelo que gestiona el diccionario de acción de gastos
 */
@Entity
@Table(name = "DD_TAS_TIPO_AGENDA_SAN", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDTipoAgendaSaneamiento implements Auditable, Dictionary {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "DD_TAS_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDTipoAgendaSaneamientoGenerator")
	@SequenceGenerator(name = "DDTipoAgendaSaneamientoGenerator", sequenceName = "S_DD_TAS_TIPO_AGENDA_SAN")
	private Long id;
	    
	@Column(name = "DD_TAS_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_TAS_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_TAS_DESCRIPCION_LARGA")   
	private String descripcionLarga;
	
	public static final String CODIGO_PENDIENTE_INSCRIPCION = "PIN";
	public static final String CODIGO_INCIDENCIA_INSCRIPCION = "INI";
	public static final String CODIGO_PENDIENTE_CARGAS = "PCA";
	public static final String CODIGO_CONCURSO_ACREEDORES = "CAC";
	public static final String CODIGO_SANEADO_REGISTRALMENTE = "SAR";
	    
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

	public String getCodigo() {
		return codigo;
	}

	public void setCodigo(String codigo) {
		this.codigo = codigo;
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

}



