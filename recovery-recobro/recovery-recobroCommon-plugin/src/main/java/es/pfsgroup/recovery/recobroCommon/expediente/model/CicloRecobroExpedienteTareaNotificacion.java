package es.pfsgroup.recovery.recobroCommon.expediente.model;

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
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;

@Entity
@Table(name = "CRT_CICLO_RECOBRO_TAREA_NOTI", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause= Auditoria.UNDELETED_RESTICTION)
public class CicloRecobroExpedienteTareaNotificacion implements Serializable, Auditable {

	private static final long serialVersionUID = 6181558253172712194L;

	@Id
	@Column(name = "CRT_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "CicloTareaNotificacionGenerator")
	@SequenceGenerator(name = "CicloTareaNotificacionGenerator", sequenceName = "S_CRT_CICLO_RECOBRO_TAREA_NOTI")
	private Long id;

	@ManyToOne
	@JoinColumn(name = "CRE_ID")
	private CicloRecobroExpediente cicloRecobroExpediente;
	
	@ManyToOne
	@JoinColumn(name = "TAR_ID")
	private TareaNotificacion tareaNotificacion;

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

	public CicloRecobroExpediente getCicloRecobroExpediente() {
		return cicloRecobroExpediente;
	}

	public void setCicloRecobroExpediente(
			CicloRecobroExpediente cicloRecobroExpediente) {
		this.cicloRecobroExpediente = cicloRecobroExpediente;
	}

	public TareaNotificacion getTareaNotificacion() {
		return tareaNotificacion;
	}

	public void setTareaNotificacion(TareaNotificacion tareaNotificacion) {
		this.tareaNotificacion = tareaNotificacion;
	}		

}
