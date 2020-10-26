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
 * Modelo para gestionar el diccionario de tipo de observación del activo.
 */
@Entity
@Table(name = "DD_TOB_TIPO_OBSERVACION", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDTipoObservacionActivo implements Auditable, Dictionary {
	
	public static final String CODIGO_STOCK = "01";
	public static final String CODIGO_POSESION = "02";
	public static final String CODIGO_INSCRIPCION = "03";
	public static final String CODIGO_CARGAS = "04";
	public static final String CODIGO_LLAVES = "05";
	public static final String CODIGO_SANEAMIENTO = "06";
	public static final String CODIGO_REVISION_TITULO = "07";
	public static final String CODIGO_TRABAJOS = "08";
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "DD_TOB_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDTipoObservacionActivo")
	@SequenceGenerator(name = "DDTipoObservacionActivo", sequenceName = "S_DD_TOB_TIPO_OBSERVACION")
	private Long id;
	 
	@Column(name = "DD_TOB_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_TOB_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_TOB_DESCRIPCION_LARGA")   
	private String descripcionLarga;
	    
	
	    
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


}
