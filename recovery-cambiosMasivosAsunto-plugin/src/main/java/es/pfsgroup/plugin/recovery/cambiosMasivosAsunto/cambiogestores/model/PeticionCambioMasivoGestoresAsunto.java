package es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.cambiogestores.model;

import java.io.Serializable;
import java.text.ParseException;
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

import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.DateFormat;

@Entity
@Table(name = "CMA_CAMBIOS_MASIVOS_ASUNTOS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class PeticionCambioMasivoGestoresAsunto implements Auditable, Serializable{

	private static final long serialVersionUID = 791878307687623085L;

	@Id
	@Column(name = "CMA_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "PeticionCambioMasivoGestoresAsuntoGenerator")
	@SequenceGenerator(name = "PeticionCambioMasivoGestoresAsuntoGenerator", sequenceName = "S_CMA_CAMBIOS_MASIVOS_ASUNTOS")
	private Long id;

	@ManyToOne(fetch = FetchType.EAGER)
	@JoinColumn(name = "SOL_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private Usuario solicitante;

	@ManyToOne(fetch = FetchType.EAGER)
	@JoinColumn(name = "ASU_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private Asunto asunto;

	@ManyToOne(fetch = FetchType.EAGER)
	@JoinColumn(name = "DD_TGE_ID") // pendiente cambiar por DD_TGE_ID
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private EXTDDTipoGestor tipoGestor;
	/*
	@Column(name = "COD_TIPO_GESTOR")
	private String codTipoGestor;
	 */
	@ManyToOne(fetch = FetchType.EAGER)
	@JoinColumn(name = "USD_ID_ORIGINAL")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private GestorDespacho gestorActual;

	@ManyToOne(fetch = FetchType.EAGER)
	@JoinColumn(name = "USD_ID_NUEVO")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private GestorDespacho nuevoGestor;

	@Column(name = "FECHA_INICIO")
	private Date fechaInicio;

	@Column(name = "FECHA_FIN")
	private Date fechaFin;

	@Column(name = "REASIGNADO")
	private Boolean reasignado;

	@Embedded
	private Auditoria auditoria;

	@Version
	private Integer version;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Usuario getSolicitante() {
		return solicitante;
	}

	public void setSolicitante(Usuario solicitante) {
		this.solicitante = solicitante;
	}

	public Asunto getAsunto() {
		return asunto;
	}

	public void setAsunto(Asunto asunto) {
		this.asunto = asunto;
	}

	public GestorDespacho getGestorActual() {
		return gestorActual;
	}

	public void setGestorActual(GestorDespacho gestorActual) {
		this.gestorActual = gestorActual;
	}

	public GestorDespacho getNuevoGestor() {
		return nuevoGestor;
	}

	public void setNuevoGestor(GestorDespacho nuevoGestor) {
		this.nuevoGestor = nuevoGestor;
	}

	public Date getFechaInicio() {
		return fechaInicio;
	}

	public void setFechaInicio(Date fechaInicio) {
		this.fechaInicio = fechaInicio;
	}

	public Date getFechaFin() {
		if (fechaFin != null){
			try {
				if (fechaFin.after(DateFormat.toDate("01/12/9999"))){
					return null;
				}
			} catch (ParseException e) {
				return fechaFin;
			}
		}
		return fechaFin;
	}

	public void setFechaFin(Date fechaFin) {
		this.fechaFin = fechaFin;
	}

	public Boolean getReasignado() {
		return reasignado;
	}

	public void setReasignado(Boolean reasignado) {
		this.reasignado = reasignado;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public EXTDDTipoGestor getTipoGestor() {
		return tipoGestor;
	}

	public void setTipoGestor(EXTDDTipoGestor tipoGestor) {
		this.tipoGestor = tipoGestor;
	}

}
