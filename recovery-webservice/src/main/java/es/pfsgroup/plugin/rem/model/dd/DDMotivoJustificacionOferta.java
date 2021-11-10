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
 * Modelo que gestiona el diccionario de motivos de justificacion de oferta
 * 
 * @author Cristian Montoya
 *
 */
@Entity
@Table(name = "DD_MJO_MOT_JUSTIF_OFR", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDMotivoJustificacionOferta implements Auditable, Dictionary {
	
	public static final String CODIGO_PRECIO = "01";
	public static final String CODIGO_OCUPACION_ILEGAL = "02";
	public static final String CODIGO_BAJO_ESTADO_CONSERVACION = "03";
	public static final String CODIGO_TAPIADO = "04";
	public static final String CODIGO_ZONA_RIESGO_OCUPACION = "05";
	public static final String CODIGO_ZONA_SIN_DEMANDA = "06";
	public static final String CODIGO_LOTE = "07";
	public static final String CODIGO_OTRO = "08";
    
	/**
	 * 
	 */
	private static final long serialVersionUID = 177982694053390946L;

	@Id
	@Column(name = "DD_MJO_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDMotivoJustificacionOfertaGenerator")
	@SequenceGenerator(name = "DDMotivoJustificacionOfertaGenerator", sequenceName = "S_DD_MJO_MOT_JUSTIF_OFR")
	private Long id;
	 
	@Column(name = "DD_MJO_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_MJO_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_MJO_DESCRIPCION_LARGA")   
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
