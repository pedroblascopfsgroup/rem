package es.pfsgroup.recovery.recobroCommon.accionesExtrajudiciales.model;

import java.io.Serializable;
import java.math.BigInteger;
import java.util.Date;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.UniqueConstraint;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.direccion.model.Direccion;
import es.capgemini.pfs.persona.model.Persona;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.recovery.recobroCommon.agenciasRecobro.model.RecobroAgencia;

/**
 * Clase que mapea las acciones extrajudiciales de las agencias
 * @author Guillem
 *
 */
@Entity
@Table(name = "ACE_ACCIONES_EXTRAJUDICIALES", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause= Auditoria.UNDELETED_RESTICTION)
public class RecobroAccionesExtrajudiciales implements Serializable, Auditable  {

	private static final long serialVersionUID = -7619703257423812427L;
	
	@Id
	@Column(name="ACE_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "RecobroAccionesExtrajudicialesGenerator")
	@SequenceGenerator(name = "RecobroAccionesExtrajudicialesGenerator", sequenceName = "S_ACE_ACCIONES_EXTRAJUDICIALES")
	private Long id;
	
	@Column(name="ACE_FECHA_EXTRACCION",nullable=false)
	private Date fechaExtraccion;
	
	@Column(name="ACE_CODIGO_ACCION", nullable = false)
	private String codigoAccion;
	
	@Column(name="ACE_ENVIO_ID", nullable = false)
	private BigInteger idEnvio;
	
	@ManyToOne
	@JoinColumn(name="DD_PRO_ID", nullable=false)
	private RecobroDDPropietarios propietarios;
	
	@ManyToOne
	@JoinColumn(name = "RCF_AGE_ID", nullable = false)
	private RecobroAgencia agencia;
	
	@ManyToOne
	@JoinColumn(name="PER_ID",nullable=false)
	private Persona persona;
	
	@Column(name="ACE_PER_COD_CLI_ENTIDAD")
	private Long codigoEntidadPersona;
	
	@ManyToOne
	@JoinColumn(name="CNT_ID", nullable=false)
	private Contrato contrato;
	
	@Column(name="ACE_CNT_CONTRATO")
	private String codigoContrato;
	
	//@ManyToOne
	//@JoinColumn(name="DD_PPE_ID")
	//private DDPalanacasPermitidas palancasPermitidas;
	
	@Column(name="ACE_FECHA_GESTION", nullable=false)
	private Date fechaGestion;
	
	@Column(name="ACE_HORA_GESTION", nullable=false)
	private String horaGestion;
	
	@ManyToOne
	@JoinColumn(name="DD_TGE_ID", nullable=false)
	private RecobroDDTipoGestion tipoGestion;
	
	@Column(name="ACE_TELEFONO")
	private String telefono;
	
	@ManyToOne
	@JoinColumn(name="DIR_ID")
	private Direccion direccion;	
	
	@Column(name="ACE_CODIGO_DIR")
	private String codigoDir;
	
	@Column(name="ACE_OBS_GESTOR")
	private String observacionesGestor;
	
	@ManyToOne
	@JoinColumn(name="DD_RGT_ID", nullable=true)
	private RecobroDDResultadoGestionTelefonica resultadoGestionTelefonica;
	
	@Column(name="ACE_IMPORTE_COMPROMETIDO")
	private Float importeComprometido;
	
	@Column(name="ACE_FECHA_PAGO_COMPROMETIDO")
	private Date fechaPagoComprometido;
	
	@Column(name="ACE_IMP_PROPUESTO")
	private Float importePropuesto;
	
	@Column(name="ACE_IMP_ACEPTADO")
	private Float importeAceptado;
	
	@ManyToOne
	@JoinColumn(name="DD_DRO_ID")
	private RecobroDDDatoNuevoOrigen datoNuevoOrigen;
	
	@Column(name="ACE_BBDD_ORIGEN_NUEVO_DATO")
	private String bbddOrigenNuevoDato;
	
	@ManyToOne
	@JoinColumn(name="DD_DRS_ID")
	private RecobroDDDatoNuevoConfirmado datoNuevoConfirmado;
	
	//@ManyToOne
	//@JoinColumn(name="DD_PRE_ID")
	//private DDPre preXXX;
	
	@Column(name="ACE_NUEVO_TELEFONO")
	private String nuevoTelefono;
	
	@Column(name="ACE_NUEVO_DOMICILIO")
	private String nuevoDomicilio;
	
	@Column(name="ACE_EXTRAFECHA1")
	private Date fechaExtra1;
	
	@Column(name="ACE_EXTRAFECHA2")
	private Date fechaExtra2;
	
	@Column(name="ACE_EXTRAFECHA3")
	private Date fechaExtra3;
	
	@Column(name="ACE_EXTRAFECHA4")
	private Date fechaExtra4;
	
	@Column(name="ACE_EXTRAFECHA5")
	private Date fechaExtra5;
	
	@Column(name="ACE_EXTRANUMERO1")
	private Float numeroExtra1;
	
	@Column(name="ACE_EXTRANUMERO2")
	private Float numeroExtra2;

	@Column(name="ACE_EXTRANUMERO3")
	private Float numeroExtra3;

	@Column(name="ACE_EXTRANUMERO4")
	private Float numeroExtra4;
	
	@Column(name="ACE_EXTRANUMERO5")
	private Float numeroExtra5;
	
	@Column(name="ACE_EXTRATEXTO1")
	private String textoExtra1;
	
	@Column(name="ACE_EXTRATEXTO2")
	private String textoExtra2;
	
	@Column(name="ACE_EXTRATEXTO3")
	private String textoExtra3;
	
	@Column(name="ACE_EXTRATEXTO4")
	private String textoExtra4;
	
	@Column(name="ACE_EXTRATEXTO5")
	private String textoExtra5;
	
	@OneToMany(cascade = CascadeType.ALL)
	@JoinColumn(name="ACE_ID")
	@Where(clause=Auditoria.UNDELETED_RESTICTION)
	private List<ResultadoMensajeria> resultadosMensajeria;
	
	@Version
	private Integer version;
	
	@Embedded
	private Auditoria auditoria;

	/**
	 * Retorna el atributo auditoria.
	 * 
	 * @return auditoria
	 */
	public Auditoria getAuditoria() {
		return auditoria;
	}

	/**
	 * Setea el atributo auditoria.
	 * 
	 * @param auditoria
	 *            Auditoria
	 */
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public Integer getVersion() {
		return version;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Date getFechaExtraccion() {
		return fechaExtraccion;
	}

	public void setFechaExtraccion(Date fechaExtraccion) {
		this.fechaExtraccion = fechaExtraccion;
	}

	public BigInteger getIdEnvio() {
		return idEnvio;
	}

	public void setIdEnvio(BigInteger idEnvio) {
		this.idEnvio = idEnvio;
	}

	public RecobroDDPropietarios getPropietarios() {
		return propietarios;
	}

	public void setPropietarios(RecobroDDPropietarios propietarios) {
		this.propietarios = propietarios;
	}

	public RecobroAgencia getAgencia() {
		return agencia;
	}

	public void setAgencia(RecobroAgencia agencia) {
		this.agencia = agencia;
	}

	public Persona getPersona() {
		return persona;
	}

	public void setPersona(Persona persona) {
		this.persona = persona;
	}

	public Long getCodigoEntidadPersona() {
		return codigoEntidadPersona;
	}

	public void setCodigoEntidadPersona(Long codigoEntidadPersona) {
		this.codigoEntidadPersona = codigoEntidadPersona;
	}

	public Contrato getContrato() {
		return contrato;
	}

	public void setContrato(Contrato contrato) {
		this.contrato = contrato;
	}

	public String getCodigoContrato() {
		return codigoContrato;
	}

	public void setCodigoContrato(String codigoContrato) {
		this.codigoContrato = codigoContrato;
	}

	public Date getFechaGestion() {
		return fechaGestion;
	}

	public void setFechaGestion(Date fechaGestion) {
		this.fechaGestion = fechaGestion;
	}

	public String getHoraGestion() {
		return horaGestion;
	}

	public void setHoraGestion(String horaGestion) {
		this.horaGestion = horaGestion;
	}

	public RecobroDDTipoGestion getTipoGestion() {
		return tipoGestion;
	}

	public void setTipoGestion(RecobroDDTipoGestion tipoGestion) {
		this.tipoGestion = tipoGestion;
	}

	public String getTelefono() {
		return telefono;
	}

	public void setTelefono(String telefono) {
		this.telefono = telefono;
	}

	public Direccion getDireccion() {
		return direccion;
	}

	public void setDireccion(Direccion direccion) {
		this.direccion = direccion;
	}

	public String getCodigoDir() {
		return codigoDir;
	}

	public void setCodigoDir(String codigoDir) {
		this.codigoDir = codigoDir;
	}

	public String getObservacionesGestor() {
		return observacionesGestor;
	}

	public void setObservacionesGestor(String observacionesGestor) {
		this.observacionesGestor = observacionesGestor;
	}

	public RecobroDDResultadoGestionTelefonica getResultadoGestionTelefonica() {
		return resultadoGestionTelefonica;
	}

	public void setResultadoGestionTelefonica(
			RecobroDDResultadoGestionTelefonica resultadoGestionTelefonica) {
		this.resultadoGestionTelefonica = resultadoGestionTelefonica;
	}

	public Float getImporteComprometido() {
		return importeComprometido;
	}

	public void setImporteComprometido(Float importeComprometido) {
		this.importeComprometido = importeComprometido;
	}

	public Date getFechaPagoComprometido() {
		return fechaPagoComprometido;
	}

	public void setFechaPagoComprometido(Date fechaPagoComprometido) {
		this.fechaPagoComprometido = fechaPagoComprometido;
	}

	public Float getImportePropuesto() {
		return importePropuesto;
	}

	public void setImportePropuesto(Float importePropuesto) {
		this.importePropuesto = importePropuesto;
	}

	public Float getImporteAceptado() {
		return importeAceptado;
	}

	public void setImporteAceptado(Float importeAceptado) {
		this.importeAceptado = importeAceptado;
	}

	public RecobroDDDatoNuevoOrigen getDatoNuevoOrigen() {
		return datoNuevoOrigen;
	}

	public void setDatoNuevoOrigen(RecobroDDDatoNuevoOrigen datoNuevoOrigen) {
		this.datoNuevoOrigen = datoNuevoOrigen;
	}

	public String getBbddOrigenNuevoDato() {
		return bbddOrigenNuevoDato;
	}

	public void setBbddOrigenNuevoDato(String bbddOrigenNuevoDato) {
		this.bbddOrigenNuevoDato = bbddOrigenNuevoDato;
	}

	public RecobroDDDatoNuevoConfirmado getDatoNuevoConfirmado() {
		return datoNuevoConfirmado;
	}

	public void setDatoNuevoConfirmado(
			RecobroDDDatoNuevoConfirmado datoNuevoConfirmado) {
		this.datoNuevoConfirmado = datoNuevoConfirmado;
	}

	public String getNuevoTelefono() {
		return nuevoTelefono;
	}

	public void setNuevoTelefono(String nuevoTelefono) {
		this.nuevoTelefono = nuevoTelefono;
	}

	public String getNuevoDomicilio() {
		return nuevoDomicilio;
	}

	public void setNuevoDomicilio(String nuevoDomicilio) {
		this.nuevoDomicilio = nuevoDomicilio;
	}

	public Date getFechaExtra1() {
		return fechaExtra1;
	}

	public void setFechaExtra1(Date fechaExtra1) {
		this.fechaExtra1 = fechaExtra1;
	}

	public Date getFechaExtra2() {
		return fechaExtra2;
	}

	public void setFechaExtra2(Date fechaExtra2) {
		this.fechaExtra2 = fechaExtra2;
	}

	public Date getFechaExtra3() {
		return fechaExtra3;
	}

	public void setFechaExtra3(Date fechaExtra3) {
		this.fechaExtra3 = fechaExtra3;
	}

	public Date getFechaExtra4() {
		return fechaExtra4;
	}

	public void setFechaExtra4(Date fechaExtra4) {
		this.fechaExtra4 = fechaExtra4;
	}

	public Date getFechaExtra5() {
		return fechaExtra5;
	}

	public void setFechaExtra5(Date fechaExtra5) {
		this.fechaExtra5 = fechaExtra5;
	}

	public Float getNumeroExtra1() {
		return numeroExtra1;
	}

	public void setNumeroExtra1(Float numeroExtra1) {
		this.numeroExtra1 = numeroExtra1;
	}

	public Float getNumeroExtra2() {
		return numeroExtra2;
	}

	public void setNumeroExtra2(Float numeroExtra2) {
		this.numeroExtra2 = numeroExtra2;
	}

	public Float getNumeroExtra3() {
		return numeroExtra3;
	}

	public void setNumeroExtra3(Float numeroExtra3) {
		this.numeroExtra3 = numeroExtra3;
	}

	public Float getNumeroExtra4() {
		return numeroExtra4;
	}

	public void setNumeroExtra4(Float numeroExtra4) {
		this.numeroExtra4 = numeroExtra4;
	}

	public Float getNumeroExtra5() {
		return numeroExtra5;
	}

	public void setNumeroExtra5(Float numeroExtra5) {
		this.numeroExtra5 = numeroExtra5;
	}

	public String getTextoExtra1() {
		return textoExtra1;
	}

	public void setTextoExtra1(String textoExtra1) {
		this.textoExtra1 = textoExtra1;
	}

	public String getTextoExtra2() {
		return textoExtra2;
	}

	public void setTextoExtra2(String textoExtra2) {
		this.textoExtra2 = textoExtra2;
	}

	public String getTextoExtra3() {
		return textoExtra3;
	}

	public void setTextoExtra3(String textoExtra3) {
		this.textoExtra3 = textoExtra3;
	}

	public String getTextoExtra4() {
		return textoExtra4;
	}

	public void setTextoExtra4(String textoExtra4) {
		this.textoExtra4 = textoExtra4;
	}

	public String getTextoExtra5() {
		return textoExtra5;
	}

	public void setTextoExtra5(String textoExtra5) {
		this.textoExtra5 = textoExtra5;
	}

	public List<ResultadoMensajeria> getResultadosMensajeria() {
		return resultadosMensajeria;
	}

	public void setResultadosMensajeria(List<ResultadoMensajeria> resultadosMensajeria) {
		this.resultadosMensajeria = resultadosMensajeria;
	}
	
	public ResultadoMensajeria getResultadoMensajeria(){
		ResultadoMensajeria resultado = null;
		if (!Checks.esNulo(resultadosMensajeria) && !Checks.estaVacio(resultadosMensajeria)){
			for (ResultadoMensajeria r : resultadosMensajeria){
				if (Checks.esNulo(resultado)){
					resultado=r;
				}else {
					if(resultado.getId()<r.getId()){
						resultado=r;
					}
				}
			}
		}
		return resultado;
	}

	public String getCodigoAccion() {
		return codigoAccion;
	}

	public void setCodigoAccion(String codigoAccion) {
		this.codigoAccion = codigoAccion;
	}

}

