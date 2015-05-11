package es.capgemini.pfs.comite.model;

import java.io.Serializable;
import java.util.Date;

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
import es.capgemini.pfs.expediente.model.Expediente;

/**
 * Clase que modela el traspaso de un expediente entre comités.
 * @author pamuller
 *
 */
@Entity
@Table(name="HTC_HIST_TRASP_COMITE", schema="${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class TraspasoExpediente implements Auditable,Serializable {


	private static final long serialVersionUID = -7818859681381694835L;

	@Id
	@Column(name="HTC_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "TraspasoExpedienteGenerator")
    @SequenceGenerator(name = "TraspasoExpedienteGenerator", sequenceName = "S_HTC_HIST_TRASP_COMITE")
	private Long id;

	@ManyToOne
	@JoinColumn(name="EXP_ID")
	private Expediente expediente;

	@ManyToOne
	@JoinColumn(name="COM_ID_ORIGEN")
	private Comite comiteOrigen;

	@ManyToOne
	@JoinColumn(name="COM_ID_DESTINO")
	private Comite comiteDestino;

	@Column(name="HTC_FECHA")
	private Date fecha;

	@Version
	private Integer version;

	@Embedded
	private Auditoria auditoria;

	/**
	 * @return the id
	 */
	public Long getId() {
		return id;
	}

	/**
	 * @param id the id to set
	 */
	public void setId(Long id) {
		this.id = id;
	}

	/**
	 * @return the expediente
	 */
	public Expediente getExpediente() {
		return expediente;
	}

	/**
	 * @param expediente the expediente to set
	 */
	public void setExpediente(Expediente expediente) {
		this.expediente = expediente;
	}

	/**
	 * @return the comiteOrigen
	 */
	public Comite getComiteOrigen() {
		return comiteOrigen;
	}

	/**
	 * @param comiteOrigen the comiteOrigen to set
	 */
	public void setComiteOrigen(Comite comiteOrigen) {
		this.comiteOrigen = comiteOrigen;
	}

	/**
	 * @return the comiteDestino
	 */
	public Comite getComiteDestino() {
		return comiteDestino;
	}

	/**
	 * @param comiteDestino the comiteDestino to set
	 */
	public void setComiteDestino(Comite comiteDestino) {
		this.comiteDestino = comiteDestino;
	}

	/**
	 * @return the fecha
	 */
	public Date getFecha() {
		return fecha;
	}

	/**
	 * @param fecha the fecha to set
	 */
	public void setFecha(Date fecha) {
		this.fecha = fecha;
	}

	/**
	 * @return the version
	 */
	public Integer getVersion() {
		return version;
	}

	/**
	 * @param version the version to set
	 */
	public void setVersion(Integer version) {
		this.version = version;
	}

	/**
	 * @return the auditoria
	 */
	public Auditoria getAuditoria() {
		return auditoria;
	}

	/**
	 * @param auditoria the auditoria to set
	 */
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}
}
