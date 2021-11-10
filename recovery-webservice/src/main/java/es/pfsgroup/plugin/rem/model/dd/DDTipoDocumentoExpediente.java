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
 * Modelo que gestiona el diccionario de los tipos de documentos adjuntados al expediente comercial
 * @author jros
 *
 */
@Entity
@Table(name = "DD_TDE_TIPO_DOC_EXP", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDTipoDocumentoExpediente implements Auditable, Dictionary {
	
	public static final String CODIGO_IDENTIFICACION= "01";
    public static final String CODIGO_TANTEO = "02";
    public static final String CODIGO_RESERVA = "03";
    public static final String CODIGO_FORMALIZACION = "04";
    public static final String CODIGO_SANCION = "05";
    public static final String CODIGO_DOCUMENTO_ALQUILER = "06";
    public static final String CODIGO_DOCUMENTO_ALQUILER_NO_COMERCIAL = "09";
    public static final String CODIGO_DOCUMENTOS_COMPRADORES = "08";
	    
	/**
	 * 
	 */
	private static final long serialVersionUID = 4995317294002266864L;

	@Id
	@Column(name = "DD_TDE_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDTipoDocumentoExpedienteGenerator")
	@SequenceGenerator(name = "DDTipoDocumentoExpedienteGenerator", sequenceName = "S_DD_TDE_TIPO_DOC_EXP")
	private Long id;
	 
	@Column(name = "DD_TDE_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_TDE_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_TDE_DESCRIPCION_LARGA")   
	private String descripcionLarga;
	
	@ManyToOne
	@JoinColumn(name = "DD_TOF_ID")
	private DDTipoOferta tipoOferta; 
	    
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

	public DDTipoOferta getTipoOferta() {
		return tipoOferta;
	}

	public void setTipoOferta(DDTipoOferta tipoOferta) {
		this.tipoOferta = tipoOferta;
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
