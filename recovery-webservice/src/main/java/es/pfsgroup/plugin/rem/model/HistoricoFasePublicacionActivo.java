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
import es.pfsgroup.plugin.rem.model.dd.DDFasePublicacion;
import es.pfsgroup.plugin.rem.model.dd.DDSubfasePublicacion;

/**
 *  Clase que mapea la tabla en la que se registra cada alteración de la Fase/subfase de publicación.
 * @author Ivan Rubio
 *
 */
@Entity
@Table(name = "ACT_HAG_HIST_ADECUA_GENCAT", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class HistoricoFasePublicacionActivo implements Serializable, Auditable {

	private static final long serialVersionUID = 5910940035703021446L;
	
	@Id
    @Column(name = "HFP_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "HistoricoFasePublicacionActivoGenerator")
    @SequenceGenerator(name = "HistoricoFasePublicacionActivoGenerator", sequenceName = "S_ACT_HAG_HIST_ADECUA_GENCAT")
    private Long id;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_FSP_ID")
	private DDFasePublicacion fasePublicacion;
	
	@Column(name = "DD_SFP_ID")
	private DDSubfasePublicacion subFasePublicacion;
	
	@Column(name = "UFP_ID")
	private Usuario usuario;
	
	@Column(name = "HFP_FECHA_INI")
	private Date fechaInicio;
	
	@Column(name = "HFP_FECHA_FIN")
	private Date fechaFin;
	
	@Column(name = "HFP_COMENTARIO")
	private Date comentario;
	
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

	public DDFasePublicacion getFasePublicacion() {
		return fasePublicacion;
	}

	public void setFasePublicacion(DDFasePublicacion fasePublicacion) {
		this.fasePublicacion = fasePublicacion;
	}

	public DDSubfasePublicacion getSubFasePublicacion() {
		return subFasePublicacion;
	}

	public void setSubFasePublicacion(DDSubfasePublicacion subFasePublicacion) {
		this.subFasePublicacion = subFasePublicacion;
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

	public Date getComentario() {
		return comentario;
	}

	public void setComentario(Date comentario) {
		this.comentario = comentario;
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
