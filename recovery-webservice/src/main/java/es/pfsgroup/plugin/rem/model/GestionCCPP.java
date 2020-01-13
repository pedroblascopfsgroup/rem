package es.pfsgroup.plugin.rem.model;

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
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoLocalizacion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPresentacion;
import es.pfsgroup.plugin.rem.model.dd.DDSubestadoGestion;

@Entity
@Table(name = "ACT_GCP_GESTION_CCPP", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class GestionCCPP implements Serializable, Auditable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 6888318348494911601L;

	@Id
    @Column(name = "GCP_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "GestionCCPPGenerator")
    @SequenceGenerator(name = "GestionCCPPGenerator", sequenceName = "S_ACT_GCP_GESTION_CCPP")
    private Long id;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "CPR_ID")
	ActivoComunidadPropietarios comunidadPropietarios;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_ELO_ID")
	DDEstadoLocalizacion estadoLocalizacion;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_SEG_ID")
	DDSubestadoGestion subestadoGestion;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "USU_ID")
	Usuario usuario;
	
	@Column(name = "GCP_FECHA_INI")
	Date fechaInicio;
	
	@Column(name = "GCP_FECHA_FIN")
	Date fechaFin;
	
	
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

	public ActivoComunidadPropietarios getComunidadPropietarios() {
		return comunidadPropietarios;
	}

	public void setComunidadPropietarios(ActivoComunidadPropietarios comunidadPropietarios) {
		this.comunidadPropietarios = comunidadPropietarios;
	}

	public DDEstadoLocalizacion getEstadoLocalizacion() {
		return estadoLocalizacion;
	}

	public void setEstadoLocalizacion(DDEstadoLocalizacion estadoLocalizacion) {
		this.estadoLocalizacion = estadoLocalizacion;
	}

	public DDSubestadoGestion getSubestadoGestion() {
		return subestadoGestion;
	}

	public void setSubestadoGestion(DDSubestadoGestion subestadoGestion) {
		this.subestadoGestion = subestadoGestion;
	}

	public Usuario getUsuario() {
		return usuario;
	}

	public void setUsuario(Usuario usuario) {
		this.usuario = usuario;
	}

	public Date getFechaInicio() {
		return fechaInicio;
	}

	public void setFechaInicio(Date fechaInicio) {
		this.fechaInicio = fechaInicio;
	}

	public Date getFechaFin() {
		return fechaFin;
	}

	public void setFechaFin(Date fechaFin) {
		this.fechaFin = fechaFin;
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
