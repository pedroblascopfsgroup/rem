package es.pfsgroup.plugin.precontencioso.burofax.model;

import java.io.Serializable;
import java.util.Date;

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
import org.hibernate.annotations.Type;

import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

@Entity
@Table(name = "PCO_BUR_ENVIO_INTEGRACION", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class BurofaxEnvioIntegracionPCO implements Serializable, Auditable {

	private static final long serialVersionUID = -5969025352573277783L;

	@Id
	@Column(name = "PCO_ENVIO_INTE_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "BurofaxEnvioIntegracionPCOGenerator")
	@SequenceGenerator(name = "BurofaxEnvioIntegracionPCOGenerator", sequenceName = "S_PCO_BUR_ENVIO_INTEGRACION")
	private Long id;

	
	@Column(name = "PCO_BUR_ID")
	private Long burofaxId;
	
	@Column(name = "PCO_BUR_ENVIO_ID")
	private Long envioId;
	
	@Column(name = "PCO_BUR_DIR_ID")
	private Long direccionId;
	
	@Column(name = "PCO_BUR_PER_ID")
	private Long personaId;
	
	@Column(name = "PCO_BUR_PEM_ID")
	private Long personaManualId;

	@Column(name = "PCO_BUR_CLIENTE")
	private String cliente;
	
	@Column(name = "PCO_BUR_CONTRATO")
	private String contrato;
	
	@Column(name = "PCO_BUR_DIRECCION")
	private String direccion;
	
	@Column(name = "PCO_BUR_TIPO")
	private String tipoBurofax;
	
	@Column(name = "PCO_BUR_FEC_SOLICITUD")
	private Date fechaSolicitud;
	
	@Column(name = "PCO_BUR_FEC_ENVIO")
	private Date fechaEnvio;
	
	@Column(name = "PCO_BUR_FEC_ACUSE")
	private Date fechaAcuse;
	
	@Column(name = "PCO_BUR_CONTENIDO")
	private String contenido;
	
	//@Column(name = "PCO_BUR_FICHERO")
	//@Type(type = "es.capgemini.devon.hibernate.dao.BlobStreamType")
	//private FileItem archivoBurofax;
	
	@Column(name = "PCO_BUR_CERTIFICADO")
	private Boolean certificado ;

	@Column(name = "ID_ASUNTO_RCV")
	private Long idAsunto;
	
	@Column(name = "PCO_BUR_FICHERO_DOC")
	private String nombreFichero;
	
	@Column(name = "ES_PERSONA_MANUAL")
	private boolean esPersonaManual;

	@Version
	private Integer version;

	@Embedded
	private Auditoria auditoria;
	
	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getBurofaxId() {
		return burofaxId;
	}

	public void setBurofaxId(Long burofaxId) {
		this.burofaxId = burofaxId;
	}

	public Long getEnvioId() {
		return envioId;
	}

	public void setEnvioId(Long envioId) {
		this.envioId = envioId;
	}

	public Long getDireccionId() {
		return direccionId;
	}

	public void setDireccionId(Long direccionId) {
		this.direccionId = direccionId;
	}

	public Long getPersonaId() {
		return personaId;
	}

	public void setPersonaId(Long personaId) {
		this.personaId = personaId;
	}

	public String getCliente() {
		return cliente;
	}

	public void setCliente(String cliente) {
		this.cliente = cliente;
	}

	public String getContrato() {
		return contrato;
	}

	public void setContrato(String contrato) {
		this.contrato = contrato;
	}

	public String getTipoBurofax() {
		return tipoBurofax;
	}

	public void setTipoBurofax(String tipoBurofax) {
		this.tipoBurofax = tipoBurofax;
	}

	public Date getFechaSolicitud() {
		return fechaSolicitud;
	}

	public void setFechaSolicitud(Date fechaSolicitud) {
		this.fechaSolicitud = fechaSolicitud;
	}

	public Date getFechaEnvio() {
		return fechaEnvio;
	}

	public void setFechaEnvio(Date fechaEnvio) {
		this.fechaEnvio = fechaEnvio;
	}

	public Date getFechaAcuse() {
		return fechaAcuse;
	}

	public void setFechaAcuse(Date fechaAcuse) {
		this.fechaAcuse = fechaAcuse;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public String getDireccion() {
		return direccion;
	}

	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}

	public Boolean getCertificado() {
		return certificado;
	}

	public void setCertificado(Boolean certificado) {
		this.certificado = certificado;
	}

	public String getContenido() {
		return contenido;
	}

	public void setContenido(String contenido) {
		this.contenido = contenido;
	}

	public Long getIdAsunto() {
		return idAsunto;
	}
	
	public void setIdAsunto(Long idAsunto) {
		this.idAsunto = idAsunto;
	}

	public String getNombreFichero() {
		return nombreFichero;
	}

	public void setNombreFichero(String nombreFichero) {
		this.nombreFichero = nombreFichero;
	}
	
	public Long getPersonaManualId() {
		return personaManualId;
	}

	public void setPersonaManualId(Long personaManualId) {
		this.personaManualId = personaManualId;
	}
	
	public boolean isEsPersonaManual() {
		return esPersonaManual;
	}

	public void setEsPersonaManual(boolean esPersonaManual) {
		this.esPersonaManual = esPersonaManual;
	}
	
}

