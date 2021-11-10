package es.pfsgroup.plugin.rem.model.dd;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
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
    public static final String CODIGO_CONTRATO_AMPLIACION_ARRAS= "24";
    public static final String CODIGO_CONTRATO_ALQUILER_2= "25";
    public static final String CODIGO_INFORME_JURIDICO= "26";
    public static final String CODIGO_CATASTRO= "27";
    public static final String CODIGO_SUBSANACION= "28";
    public static final String CODIGO_CLIENTE_DNI= "29";
    public static final String CODIGO_CLIENTE_NIF= "30";
    public static final String CODIGO_PODER_REPRESENTANTE= "31";
    public static final String CODIGO_SOLICITUD_VISITA= "32";
    public static final String CODIGO_AUTORIZACION_VENTA_VPO= "33";
    public static final String CODIGO_COMUNIDAD_PROPIETARIOS= "34";
    public static final String CODIGO_RETROCESION_VENTA= "35";
    public static final String CODIGO_PLANTILLA_PROPUESTA= "36";
    public static final String CODIGO_FICHA_CLIENTE= "37";
    public static final String CODIGO_APROBACION_PBC= "38";
    public static final String CODIGO_ESTUDIO_MERCADO= "39";
    public static final String CODIGO_FICHA_TECNICA= "40";
    public static final String CODIGO_INFORME_FISCAL= "41";
    public static final String CODIGO_CORREO_ELECTRONICO= "42";
    public static final String CODIGO_SCORING= "43";
    public static final String CODIGO_SEGURO_RENTAS= "44";
    public static final String CODIGO_SANCION_OFERTA= "45";
    public static final String CODIGO_RENOVACION_CONTRATO= "46";
    public static final String CODIGO_PRE_CONTRATO= "47";
    public static final String CODIGO_PRE_LIQUIDACION_ITP= "48";
    public static final String CODIGO_CONTRATO= "49";
    public static final String CODIGO_LIQUIDACION_ITP= "50";
    public static final String CODIGO_FIANZA= "51";
    public static final String CODIGO_AVAL_BANCARIO= "52";
    public static final String CODIGO_JUSTIFICANTE_INGRESOS= "53";
    public static final String CODIGO_ALQUILER_CON_OPCION_A_COMPRA= "54";
    public static final String MATRICULA_CONTRATO_ALQUILER_CON_OPCION_A_COMPRA = "OP-29-CNCV-05";
    public static final String CODIGO_CONTRATO_ARRAS_PENITENCIALES= "55";
    public static final String CODIGO_DEPOSITO_DESPUBLICACION_ACTIVO= "56";
    public static final String CODIGO_ADVISORY_NOTE= "62";
    public static final String CODIGO_ADVISORY_NOTE_FIRMADO_ADVISORY= "63";
    public static final String CODIGO_ADVISORY_NOTE_FIRMADO_PROPIEDAD= "68";
    public static final String MATRICULA_PRE_CONTRATO = "OP-29-CNCV-86";
    public static final String MATRICULA_CONTRATO = "OP-29-CNCV-04";
    public static final String MATRICULA_CONTRATO_ARRAS_PENITENCIALES= "OP-08-CNCV-90";
    public static final String MATRICULA_DEPOSITO_DESPUBLICACION_ACTIVO= "OP-08-CERA-DE";
    public static final String CODIGO_PROPUESTA_APROBACION_OFERTA= "69";

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
	
	@Column(name= "DD_SDE_VINCULABLE")
	private Integer vinculable;
	    
	@OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name= "DD_SDE_TPD_ID")
	private DDTipoDocumentoActivo tipoDocumentoActivo;
	
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
