package es.pfsgroup.plugin.rem.model.dd;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
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
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;


@Entity
@Table(name = "DD_CMS_CESION_COM_SANEAMIENTO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDCesionSaneamiento implements Auditable, Dictionary {

	public static final String CODIGO_CMS_COMERCIALIZADO_ALTAMIRA = "AAM_C";
	public static final String CODIGO_CMS_SANEADO_ALTAMIRA = "AAM_S";
	public static final String CODIGO_CMS_SANEADO_Y_COMERCIALIZADO_ALTAMIRA = "AAM_CS";
	public static final String CODIGO_CMS_COMERCIALIZADO_INTRUM = "INTRUM_C";
	public static final String CODIGO_CMS_SANEADO_INTRUM = "INTRUM_S";
	public static final String CODIGO_CMS_SANEADO_Y_COMERCIALIZADO_INTRUM = "INTRUM_CS";
	public static final String CODIGO_CMS_SANEADO_Y_COMERCIALIZADO_HAYA = "HAYA";
	
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "DD_CMS_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDCesionSaneamientoGenerator")
	@SequenceGenerator(name = "DDCesionSaneamientoGenerator", sequenceName = "S_DD_CMS_CESION_COM_SANEAMIENTO")
	private Long id;
	 
	@Column(name = "DD_CMS_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_CMS_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_CMS_DESCRIPCION_LARGA")   
	private String descripcionLarga;
	    
	@Version   
	private Long version;

	@Embedded
	private Auditoria auditoria;
	
	@OneToOne
	@JoinColumn(name = "DD_SRA_ID")
	private DDServicerActivo servicer;

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

	public DDServicerActivo getServicer() {
		return servicer;
	}

	public void setServicer(DDServicerActivo servicer) {
		this.servicer = servicer;
	}

}
