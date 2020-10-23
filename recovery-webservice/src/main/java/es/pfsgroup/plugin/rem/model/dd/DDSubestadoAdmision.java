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
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;

/**
 * Modelo que gestiona el diccionario de subcarteras.
 * 
 * @author Vicente Martinez
 *
 */
@Entity
@Table(name = "DD_SAA_SUBESTADO_ACT_ADMISION", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDSubestadoAdmision implements Auditable, Dictionary {

	private static final long serialVersionUID = 1L;
	public static final String CODIGO_PENDIENTE_REVISION_ALTAS = "PRA";
	public static final String CODIGO_PENDIENTE_INFORMACION = "PEI";
	public static final String CODIGO_PENDIENTE_DOCUMENTACION = "PDO";
	public static final String CODIGO_PENDIENTE_INSCRIPCION = "PIN";
	public static final String CODIGO_INCIDENCIA_INSC = "IIN";
	public static final String CODIGO_PENDIENTE_CARGAS = "PCA";
	public static final String CODIGO_CONCURSO_ACREEDORES = "CAC";

	@Id
	@Column(name = "DD_SAA_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDSubestadoAdmisionGenerator")
	@SequenceGenerator(name = "DDSubestadoAdmisionGenerator", sequenceName = "S_DD_SAA_SUBESTADO_ACT_ADMISION")
	private Long id;
	
	@ManyToOne
	@JoinColumn(name = "DD_EAA_ID")
	private DDEstadoAdmision estadoAdmision;
	
	@Column(name = "DD_SAA_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_SAA_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_SAA_DESCRIPCION_LARGA")   
	private String descripcionLarga;
	    
	@Version   
	private Long version;

	@Embedded
	private Auditoria auditoria;

	public Long getId() {
		return id;
	}

	public DDEstadoAdmision getEstadoAdmision() {
		return estadoAdmision;
	}

	public String getCodigo() {
		return codigo;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public String getDescripcionLarga() {
		return descripcionLarga;
	}

	public Long getVersion() {
		return version;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public void setEstadoAdmision(DDEstadoAdmision estadoAdmision) {
		this.estadoAdmision = estadoAdmision;
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

	public void setVersion(Long version) {
		this.version = version;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	
}
