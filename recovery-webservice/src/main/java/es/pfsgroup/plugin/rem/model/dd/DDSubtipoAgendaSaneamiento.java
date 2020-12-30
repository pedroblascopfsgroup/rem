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
 * Modelo que gestiona el diccionario de acción de gastos
 */
@Entity
@Table(name = "DD_SAS_SUBTIPO_AGENDA_SAN", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDSubtipoAgendaSaneamiento implements Auditable, Dictionary {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "DD_SAS_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDSubtipoAgendaSaneamientoGenerator")
	@SequenceGenerator(name = "DDSubtipoAgendaSaneamientoGenerator", sequenceName = "S_DD_SAS_SUBTIPO_AGENDA_SAN")
	private Long id;
	
	@ManyToOne
	@JoinColumn(name = "DD_TAS_ID")   
	private DDTipoAgendaSaneamiento tipoAgendaSaneamiento;
	    
	@Column(name = "DD_SAS_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_SAS_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_SAS_DESCRIPCION_LARGA")   
	private String descripcionLarga;
	
	public static final String CODIGO_EN_TRAMITE_INSCRIPCION = "ETI";
	public static final String CODIGO_CALIFICACION_NEGATIVA = "CAN";
	public static final String CODIGO_EN_GESTION_INI = "EGE";
	public static final String CODIGO_DEFECTO_SANEADO = "DSA";
	public static final String CODIGO_PENDIENTE_INDICIO = "PEI";
	public static final String CODIGO_EN_GESTION_PCA = "EGC";
	public static final String CODIGO_CARGAS_CANCELADAS = "CCA";
	public static final String CODIGO_EN_TRAMITE_CAC = "ETC";
	public static final String CODIGO_INSCRITO_LIBRE_CARGAS = "ILC";
	    
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

	public DDTipoAgendaSaneamiento getTipoAgendaSaneamiento() {
		return tipoAgendaSaneamiento;
	}

	public void setTipoAgendaSaneamiento(DDTipoAgendaSaneamiento tipoAgendaSaneamiento) {
		this.tipoAgendaSaneamiento = tipoAgendaSaneamiento;
	}

}



