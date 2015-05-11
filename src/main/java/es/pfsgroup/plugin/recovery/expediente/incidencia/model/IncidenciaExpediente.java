package es.pfsgroup.plugin.recovery.expediente.incidencia.model;

import java.io.Serializable;

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

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.users.domain.Usuario;

@Entity
@Table(name = "IEX_INCIDENCIA_EXPEDIENTE", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class IncidenciaExpediente implements Auditable, Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 4210879643103597576L;

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "iexGenerator")
    @SequenceGenerator(name = "iexGenerator", sequenceName = "S_IEX_INCIDENCIA_EXPEDIENTE")
	@Column(name = "IEX_ID")
	private Long id;

	@ManyToOne
	@JoinColumn(name = "PER_ID")
	private Persona persona;

	@ManyToOne
	@JoinColumn(name = "CNT_ID")
	private Contrato contrato;

	@ManyToOne
	@JoinColumn(name = "DD_TII_ID")
	private TipoIncidencia tipoIncidencia;

	@Column(name = "IEX_OBSERVACIONES")
	private String observaciones;

	@ManyToOne
	@JoinColumn(name = "DD_SII_ID")
	private SituacionIncidencia situacionIncidencia;

	@ManyToOne
	@JoinColumn(name = "USU_ID")
	private Usuario usuario;

	@ManyToOne
	@JoinColumn(name = "DES_ID")
	private DespachoExterno despachoExterno;
	
	@ManyToOne
	@JoinColumn(name = "EXP_ID")
	private Expediente expediente;
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Persona getPersona() {
		return persona;
	}

	public void setPersona(Persona persona) {
		this.persona = persona;
	}

	public Contrato getContrato() {
		return contrato;
	}

	public void setContrato(Contrato contrato) {
		this.contrato = contrato;
	}

	public TipoIncidencia getTipoIncidencia() {
		return tipoIncidencia;
	}

	public void setTipoIncidencia(TipoIncidencia tipoIncidencia) {
		this.tipoIncidencia = tipoIncidencia;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}

	public SituacionIncidencia getSituacionIncidencia() {
		return situacionIncidencia;
	}

	public void setSituacionIncidencia(SituacionIncidencia situacionIncidencia) {
		this.situacionIncidencia = situacionIncidencia;
	}

	public Usuario getUsuario() {
		return usuario;
	}

	public void setUsuario(Usuario usuario) {
		this.usuario = usuario;
	}

	public DespachoExterno getDespachoExterno() {
		return despachoExterno;
	}

	public void setDespachoExterno(DespachoExterno despachoExterno) {
		this.despachoExterno = despachoExterno;
	}

	@Embedded
	private Auditoria auditoria;

	@Version
	private Integer version;

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

	/**
	 * Retorna el atributo version.
	 * 
	 * @return version
	 */
	public Integer getVersion() {
		return version;
	}

	/**
	 * Setea el atributo version.
	 * 
	 * @param version
	 *            Integer
	 */
	public void setVersion(Integer version) {
		this.version = version;
	}

	public Expediente getExpediente() {
		return expediente;
	}

	public void setExpediente(Expediente expediente) {
		this.expediente = expediente;
	}

}
