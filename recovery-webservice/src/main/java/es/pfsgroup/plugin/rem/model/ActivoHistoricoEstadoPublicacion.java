package es.pfsgroup.plugin.rem.model;

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
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPublicacion;
import es.pfsgroup.plugin.rem.model.dd.DDPortal;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPublicacion;

/**
 * Modelo que gestiona los distintos estados de publicación por los que pasa el activo.
 * 
 * @author Daniel Gutiérrez
 *
 */
@Entity
@Table(name = "ACT_HEP_HIST_EST_PUBLICACION", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoHistoricoEstadoPublicacion implements Serializable, Auditable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
    @Column(name = "HEP_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoHistoricoEstadoPublicacionGenerator")
    @SequenceGenerator(name = "ActivoHistoricoEstadoPublicacionGenerator", sequenceName = "S_HEP_HIST_EST_PUBLICACION")
    private Long id;

	@ManyToOne
    @JoinColumn(name = "ACT_ID")
    private Activo activo; 
	
	@Column(name = "HEP_FECHA_DESDE")
	private Date fechaDesde;
	
	@Column(name = "HEP_FECHA_HASTA")
	private Date fechaHasta;
	
	@Column(name = "DD_POR_ID")
	private DDPortal portal;
	
	@Column(name = "DD_TPU_ID")
	private DDTipoPublicacion tipoPublicacion;
	
	@Column(name = "DD_EPU_ID")
	private DDEstadoPublicacion estadoPublicacion;
	
	@Column(name = "HEP_MOTIVO")
	private String motivo;
		
	@Version   
	private Long version;
	
	@Embedded
	private Auditoria auditoria;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Activo getActivo() {
		return activo;
	}

	public void setActivo(Activo activo) {
		this.activo = activo;
	}

	public Date getFechaDesde() {
		return fechaDesde;
	}

	public void setFechaDesde(Date fechaDesde) {
		this.fechaDesde = fechaDesde;
	}

	public Date getFechaHasta() {
		return fechaHasta;
	}

	public void setFechaHasta(Date fechaHasta) {
		this.fechaHasta = fechaHasta;
	}

	public DDPortal getPortal() {
		return portal;
	}

	public void setPortal(DDPortal portal) {
		this.portal = portal;
	}

	public DDTipoPublicacion getTipoPublicacion() {
		return tipoPublicacion;
	}

	public void setTipoPublicacion(DDTipoPublicacion tipoPublicacion) {
		this.tipoPublicacion = tipoPublicacion;
	}

	public DDEstadoPublicacion getEstadoPublicacion() {
		return estadoPublicacion;
	}

	public void setEstadoPublicacion(DDEstadoPublicacion estadoPublicacion) {
		this.estadoPublicacion = estadoPublicacion;
	}

	public String getMotivo() {
		return motivo;
	}

	public void setMotivo(String motivo) {
		this.motivo = motivo;
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

}
