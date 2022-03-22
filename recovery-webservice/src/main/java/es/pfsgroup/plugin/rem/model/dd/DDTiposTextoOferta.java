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
 * Modelo que gestiona el diccionario de tipos de texto de una oferta
 * 
 * @author Jose Villel
 *
 */
@Entity
@Table(name = "DD_TTX_TIPOS_TEXTO_OFERTA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDTiposTextoOferta implements Auditable, Dictionary {
	
	public final static String TIPOS_TEXTO_OFERTA_INTERES = "01";
	public final static String TIPOS_TEXTO_OFERTA_GESTOR = "02";
	public final static String TIPOS_TEXTO_OFERTA_RATIFICACION = "03";
	public final static String TIPOS_TEXTO_OFERTA_COMITE = "04";	
	public final static String TIPOS_TEXTO_OFERTA_RECOMENDACION_RC = "05";	
	public final static String TIPOS_TEXTO_OFERTA_RECOMENDACION_DC = "06";	
	public final static String TIPOS_TEXTO_OFERTA_DESCUENTO = "07";	
	public final static String TIPOS_TEXTO_OFERTA_JUSTIFICACION = "08";	
	public final static String TIPOS_TEXTO_OFERTA_OBSERVACIONES = "09";	
	public final static String TIPOS_TEXTO_OFERTA_IMPORTE_INICIAL =  "10";
	public final static String TIPOS_TEXTO_OFERTA_IMPORTE_CONTRAOFERTA_RCDC =  "11";
	public final static String TIPOS_TEXTO_OFERTA_IMPORTE_CONTRAOFERTA_PRESCRIPTOR =  "12";
	public final static String TIPOS_TEXTO_OFERTA_RECOMENDACION_INTERNA_REQUERIDA =  "13";
	public final static String TIPOS_TEXTO_OFERTA_RECOMENDACION_CUMPLIMENTADA =  "14";
	public final static String TIPOS_TEXTO_OFERTA_MOT_RECHAZO_RCDC =  "15";
	
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "DD_TTX_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDTiposTextoOfertaGenerator")
	@SequenceGenerator(name = "DDTiposTextoOfertaGenerator", sequenceName = "S_DD_TTX_TIPOS_TEXTO_OFERTA")
	private Long id;
	    
	@Column(name = "DD_TTX_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_TTX_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_TTX_DESCRIPCION_LARGA")   
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