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
 * Modelo que gestiona el diccionario de tipos de agrupacion
 * 
 * @author Anahuac de Vicente
 *
 */
@Entity
@Table(name = "DD_TAG_TIPO_AGRUPACION", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDTipoAgrupacion implements Auditable, Dictionary {
	
	public static final String AGRUPACION_OBRA_NUEVA = "01";
	public static final String AGRUPACION_RESTRINGIDA = "02";
	public static final String AGRUPACION_PROYECTO = "04";
	public static final String AGRUPACION_ASISTIDA = "13";
	public static final String AGRUPACION_LOTE_COMERCIAL = "14";
	public static final String AGRUPACION_LOTE_COMERCIAL_VENTA = AGRUPACION_LOTE_COMERCIAL;
	public static final String AGRUPACION_LOTE_COMERCIAL_ALQUILER = "15";
	public static final String AGRUPACION_COMERCIAL_ALQUILER = AGRUPACION_LOTE_COMERCIAL_ALQUILER;
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 4508981007991542156L;

	@Id
	@Column(name = "DD_TAG_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDTipoAgrupacionGenerator")
	@SequenceGenerator(name = "DDTipoAgrupacionGenerator", sequenceName = "S_DD_TAG_TIPO_AGRUPACION")
	private Long id;
	 
	@Column(name = "DD_TAG_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_TAG_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_TAG_DESCRIPCION_LARGA")   
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
