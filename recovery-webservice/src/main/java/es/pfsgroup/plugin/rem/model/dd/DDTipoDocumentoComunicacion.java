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

/**
 * Modelo que gestiona el diccionario de los tipos de documentos
 * 
 * @author Anahuac de Vicente
 *
 */
@Entity
@Table(name = "DD_TDC_TIPO_DOC_COM", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDTipoDocumentoComunicacion implements Auditable, Dictionary {

    public static final String CODIGO_COMUNICACION_GENCAT = "01";
    public static final String CODIGO_SOLICITUD_VISITA_GENCAT = "02";
    public static final String CODIGO_COMPARECENCIA_GENCAT = "03";
    public static final String CODIGO_RESPUESTA_SANCION_GENCAT = "04";
    public static final String CODIGO_ANULACION_OFERTA_GENCAT = "05";
    public static final String CODIGO_NOTIFICACION_VARIACIONES_DATOS_GENCAT = "06";
    public static final String CODIGO_SANCION_NOTIFICACION_GENCAT = "07";
    public static final String CODIGO_RECLAMACION_GENCAT = "08";
    
    public static final String MATRICULA_COMUNICACION_GENCAT = "OP-31-COMU-86";
    public static final String MATRICULA_SOLICITUD_VISITA_GENCAT = "OP-31-COMU-87";
    public static final String MATRICULA_COMPARECENCIA_GENCAT = "OP-31-CERJ-AC";
    public static final String MATRICULA_RESPUESTA_SANCION_GENCAT = "OP-31-ACUE-15";
    public static final String MATRICULA_ANULACION_OFERTA_GENCAT = "OP-31-COMU-88";
    public static final String MATRICULA_NOTIFICACION_VARIACIONES_DATOS_GENCAT = "OP-31-COMU-89";
    public static final String MATRICULA_SANCION_NOTIFICACION_GENCAT = "OP-31-ACUE-16";
    public static final String MATRICULA_RECLAMACION_GENCAT = "OP-31-COMU-90";
    
	/**
	 * 
	 */
	private static final long serialVersionUID = -4760202568628965576L;

	@Id
	@Column(name = "DD_TDC_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDTipoDocumentoActivoGenerator")
	@SequenceGenerator(name = "DDTipoDocumentoActivoGenerator", sequenceName = "S_DD_TPD_TIPO_DOCUMENTO")
	private Long id;
	 
	@Column(name = "DD_TDC_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_TDC_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_TDC_DESCRIPCION_LARGA")   
	private String descripcionLarga;
	    
	@Column(name = "DD_TDC_MATRICULA_GD")   
	private String matricula;
	
	@Column(name= "DD_TDC_VINCULABLE")
	private Integer vinculable;
	    
	@OneToOne
    @JoinColumn(name= "DD_TPD_ID")
	private DDTipoDocumentoActivo tipoDocumentoActivo;
	
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
	
	public String getMatricula() {
		return matricula;
	}
	
	public void setMatricula(String matricula) {
		this.matricula = matricula;
	}

	public Integer getVinculable() {
		return vinculable;
	}

	public void setVinculable(Integer vinculable) {
		this.vinculable = vinculable;
	}

	public DDTipoDocumentoActivo getTipoDocumentoActivo() {
		return tipoDocumentoActivo;
	}

	public void setTipoDocumentoActivo(DDTipoDocumentoActivo tipoDocumentoActivo) {
		this.tipoDocumentoActivo = tipoDocumentoActivo;
	}

}
