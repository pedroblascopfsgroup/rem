package es.capgemini.pfs.efectos.model;

import java.io.Serializable;
import java.util.Date;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
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
import es.capgemini.pfs.persona.model.DDTipoDocumento;
import es.capgemini.pfs.persona.model.DDTipoPersona;
import es.capgemini.pfs.persona.model.Persona;

/**
 * Entidad Efectos de la persona.
 * @author Carlos Pérez
 *
 */

@Entity
@Table(name = "EFP_EFECTOS_PER", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause= Auditoria.UNDELETED_RESTICTION)
public class EfectoPersona implements Auditable, Serializable{

	private static final long serialVersionUID = 2412237704304209221L;

	@Id
	@Column(name = "EFP_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "EfectosPersonaGenerator")
	@SequenceGenerator(name = "EfectosPersonaGenerator", sequenceName = "S_EFP_EFECTOS_PER")
	private Long id;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "EFC_ID")
	private EfectoContrato efectoContrato;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "PER_ID")
	private Persona persona;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_TPE_ID")
	private DDTipoPersona tipoPersona;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_TDI_ID")
	private DDTipoDocumento tipoDocumento;
	
	
	@Column(name = "EFP_FECHA_EXTRACCION")
	private Date fechaExtraccion;
	
	@Column(name = "EFP_FECHA_DATO")
	private Date fechaDato;
	
	@Column(name = "EFP_CODIGO_ENTIDAD")
	private Integer codigoEntidad;
	
	@Column(name = "EFP_NIF_CIF")
	private String nifCif;
	
	@Column(name = "EFP_NOMBRE")
	private String nombre;
	
	@Column(name = "EFP_APELLIDO1")
	private String apellido1;
	
	@Column(name = "EFP_APELLIDO2")
	private String apellido2;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_TIE_ID")
	private DDTipoIntervencionEfecto tipoIntervencionEfecto;
	
	@Column(name = "EFP_ORDEN")
	private Integer orden;
	
	@Column(name ="EFP_OBSERVACIONES")
	private String observaciones;
	
	@Column(name ="EFP_COD_PERSONA")
	private Float codPersona;
	
	@Column(name = "EFP_CHAR_EXTRA1")
	private String charExtra1;
	@Column(name = "EFP_CHAR_EXTRA2")
	private String charExtra2;
	
	@Column(name = "EFP_FLAG_EXTRA1")
	private Boolean flagExtra1;
	@Column(name = "EFP_FLAG_EXTRA2")
	private Boolean flagExtra2;

	@Column(name = "EFP_DATE_EXTRA1")
	private Date dateExtra1;
	@Column(name = "EFP_DATE_EXTRA2")
	private Date dateExtra2;
	
	@Column(name = "EFP_NUM_EXTRA1")
	private Float numExtra1;
	@Column(name = "EFP_NUM_EXTRA2")
	private Float numExtra2;
	
	@Version
	private Integer version;

	@Embedded
	private Auditoria auditoria;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public EfectoContrato getEfectoContrato() {
		return efectoContrato;
	}

	public void setEfectoContrato(EfectoContrato efectoContrato) {
		this.efectoContrato = efectoContrato;
	}

	public Persona getPersona() {
		return persona;
	}

	public void setPersona(Persona persona) {
		this.persona = persona;
	}

	public DDTipoPersona getTipoPersona() {
		return tipoPersona;
	}

	public void setTipoPersona(DDTipoPersona tipoPersona) {
		this.tipoPersona = tipoPersona;
	}

	public DDTipoDocumento getTipoDocumento() {
		return tipoDocumento;
	}

	public void setTipoDocumento(DDTipoDocumento tipoDocumento) {
		this.tipoDocumento = tipoDocumento;
	}

	public Date getFechaExtraccion() {
		return fechaExtraccion;
	}

	public void setFechaExtraccion(Date fechaExtraccion) {
		this.fechaExtraccion = fechaExtraccion;
	}

	public Date getFechaDato() {
		return fechaDato;
	}

	public void setFechaDato(Date fechaDato) {
		this.fechaDato = fechaDato;
	}

	public Integer getCodigoEntidad() {
		return codigoEntidad;
	}

	public void setCodigoEntidad(Integer codigoEntidad) {
		this.codigoEntidad = codigoEntidad;
	}

	public String getNifCif() {
		return nifCif;
	}

	public void setNifCif(String nifCif) {
		this.nifCif = nifCif;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getApellido1() {
		return apellido1;
	}

	public void setApellido1(String apellido1) {
		this.apellido1 = apellido1;
	}

	public String getApellido2() {
		return apellido2;
	}

	public void setApellido2(String apellido2) {
		this.apellido2 = apellido2;
	}

	public DDTipoIntervencionEfecto getTipoIntervencionEfecto() {
		return tipoIntervencionEfecto;
	}

	public void setTipoIntervencionEfecto(
			DDTipoIntervencionEfecto tipoIntervencionEfecto) {
		this.tipoIntervencionEfecto = tipoIntervencionEfecto;
	}

	public Integer getOrden() {
		return orden;
	}

	public void setOrden(Integer orden) {
		this.orden = orden;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}

	public Float getCodPersona() {
		return codPersona;
	}

	public void setCodPersona(Float codPersona) {
		this.codPersona = codPersona;
	}

	public String getCharExtra1() {
		return charExtra1;
	}

	public void setCharExtra1(String charExtra1) {
		this.charExtra1 = charExtra1;
	}

	public String getCharExtra2() {
		return charExtra2;
	}

	public void setCharExtra2(String charExtra2) {
		this.charExtra2 = charExtra2;
	}

	public Boolean getFlagExtra1() {
		return flagExtra1;
	}

	public void setFlagExtra1(Boolean flagExtra1) {
		this.flagExtra1 = flagExtra1;
	}

	public Boolean getFlagExtra2() {
		return flagExtra2;
	}

	public void setFlagExtra2(Boolean flagExtra2) {
		this.flagExtra2 = flagExtra2;
	}

	public Date getDateExtra1() {
		return dateExtra1;
	}

	public void setDateExtra1(Date dateExtra1) {
		this.dateExtra1 = dateExtra1;
	}

	public Date getDateExtra2() {
		return dateExtra2;
	}

	public void setDateExtra2(Date dateExtra2) {
		this.dateExtra2 = dateExtra2;
	}

	public Float getNumExtra1() {
		return numExtra1;
	}

	public void setNumExtra1(Float numExtra1) {
		this.numExtra1 = numExtra1;
	}

	public Float getNumExtra2() {
		return numExtra2;
	}

	public void setNumExtra2(Float numExtra2) {
		this.numExtra2 = numExtra2;
	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}


}

