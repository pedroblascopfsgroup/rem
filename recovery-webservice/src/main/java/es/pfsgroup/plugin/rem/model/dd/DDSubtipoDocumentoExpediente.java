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
import javax.persistence.Transient;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;

/**
 * Modelo que gestiona el diccionario de los subtipos de documentos adjuntados al expediente comercial
 * @author jros
 *
 */
@Entity
@Table(name = "DD_SDE_SUBTIPO_DOC_EXP", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDSubtipoDocumentoExpediente implements Auditable, Dictionary {
	
    public static final String CODIGO_DNI = "01";
    public static final String CODIGO_CIF = "02";
    public static final String CODIGO_NIF = "03";
    public static final String CODIGO_VALORACION_ESTADO_CONSERVACION = "04";
    public static final String CODIGO_RESOLUCION_TANTEO = "05";
    public static final String CODIGO_CONTRATO_RESERVA = "06";
    public static final String CODIGO_MINUTA = "07";
    public static final String CODIGO_RESOL_COMITE = "08";
    public static final String CODIGO_CONTRATO_ALQUILER = "09";
    public static final String CODIGO_FICHA_LEGAL = "10";
    //public static final String CODIGO_CONTRATO_RESERVA = "11";
    public static final String CODIGO_JUSTIFICANTE_RESERVA = "12";
    public static final String CODIGO_COMUNICACION_A_HABITATGE_RESERVA = "13";
    public static final String CODIGO_RESPUESTA_A_HABITATGE = "14";
    public static final String CODIGO_FICHA_ESCRITURA_INMUEBLE = "15";
    public static final String CODIGO_ESCRITURA_COMPRAVENTA = "16";
    public static final String CODIGO_JUSTIFICANTE_COMPRAVENTA = "17";
    public static final String CODIGO_RECIBI_ENTREGA_LLAVES = "18";
    public static final String CODIGO_COPIA_SIMPLE = "19";
    public static final String CODIGO_LIQUIDACION_PLUSVALIA = "20";
    public static final String CODIGO_AUTORIZACION_VENTA = "21";
    public static final String CODIGO_CONTRAOFERTA= "22";
    public static final String CODIGO_APROBACION= "23";
    
	/**
	 * 
	 */
	private static final long serialVersionUID = 5218121084059952387L;

	@Id
	@Column(name = "DD_SDE_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDSubtipoDocumentoExpedienteGenerator")
	@SequenceGenerator(name = "DDSubtipoDocumentoExpedienteGenerator", sequenceName = "S_DD_SDE_SUBTIPO_DOC_EXP")
	private Long id;
	
	@ManyToOne
    @JoinColumn(name = "DD_TDE_ID")
    private DDTipoDocumentoExpediente tipoDocumentoExpediente; 
	 
	@Column(name = "DD_SDE_CODIGO")   
	private String codigo;
	 
	@Column(name = "DD_SDE_DESCRIPCION")   
	private String descripcion;
	    
	@Column(name = "DD_SDE_DESCRIPCION_LARGA")   
	private String descripcionLarga;
	
	@Column(name = "DD_SDE_MATRICULA_GD")   
	private String matricula;
	    
	@Version   
	private Long version;

	@Embedded
	private Auditoria auditoria;
	
	@Transient
	private String codigoTipoDocExpediente;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public DDTipoDocumentoExpediente getTipoDocumentoExpediente() {
		return tipoDocumentoExpediente;
	}

	public void setTipoDocumentoExpediente(
			DDTipoDocumentoExpediente tipoDocumentoExpediente) {
		this.tipoDocumentoExpediente = tipoDocumentoExpediente;
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
	
	public String getCodigoTipoDocExpediente() {
		return tipoDocumentoExpediente.getCodigo();
	}
	
	public void setCodigoTipoDocExpediente(String codigoTipoDocExpediente) {
		this.codigoTipoDocExpediente = tipoDocumentoExpediente.getCodigo();
	}

	public String getMatricula() {
		return matricula;
	}

	public void setMatricula(String matricula) {
		this.matricula = matricula;
	}
	

}
