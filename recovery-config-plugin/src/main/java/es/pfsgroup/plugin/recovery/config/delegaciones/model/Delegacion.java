package es.pfsgroup.plugin.recovery.config.delegaciones.model;

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
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.users.domain.Usuario;

@Entity
@Table(name="DEL_DELEGACIONES", schema="${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
@Where(clause= Auditoria.UNDELETED_RESTICTION)
public class Delegacion implements Serializable, Auditable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -3875490540451172845L;
	
	@Id
	@Column(name="DEL_ID")
	@GeneratedValue(strategy=GenerationType.AUTO, generator="DelegacionGenerator")
	@SequenceGenerator(name="DelegacionGenerator", sequenceName = "S_DEL_DELEGACIONES")
	private Long id;
	
	@ManyToOne
	@JoinColumn(name="USU_ORIGEN")
	private Usuario usuarioOrigen;
	
	@ManyToOne
	@JoinColumn(name="USU_DESTINO")
	private Usuario usuarioDestino;
	
	@Column(name="FECHA_INI_VIGENCIA")
	private Date fechaIniVigencia;
	
	@Column(name="FECHA_FIN_VIGENCIA")
	private Date fechaFinVigencia;
	
	@ManyToOne
	@JoinColumn(name="DD_EDL_ID")
	DDEstadoDelegaciones estado;
	
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

	public Usuario getUsuarioOrigen() {
		return usuarioOrigen;
	}

	public void setUsuarioOrigen(Usuario usuarioOrigen) {
		this.usuarioOrigen = usuarioOrigen;
	}

	public Usuario getUsuarioDestino() {
		return usuarioDestino;
	}

	public void setUsuarioDestino(Usuario usuarioDestino) {
		this.usuarioDestino = usuarioDestino;
	}

	public Date getFechaIniVigencia() {
		return fechaIniVigencia;
	}

	public void setFechaIniVigencia(Date fechaIniVigencia) {
		this.fechaIniVigencia = fechaIniVigencia;
	}

	public Date getFechaFinVigencia() {
		return fechaFinVigencia;
	}

	public void setFechaFinVigencia(Date fechaFinVigencia) {
		this.fechaFinVigencia = fechaFinVigencia;
	}

	public DDEstadoDelegaciones getEstado() {
		return estado;
	}

	public void setEstado(DDEstadoDelegaciones estado) {
		this.estado = estado;
	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	@Override
	public Auditoria getAuditoria() {
		return this.auditoria;
	}

	@Override
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

}
