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
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
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
import es.pfsgroup.plugin.rem.model.dd.DDTipoApunte;


/**
 * Modelo que gestiona la informacion de la agenda de un trabajo.
 *  
 * @author Julián Dolz
 *
 */
@Entity
@Table(name = "TBJ_ATJ_AGENDA_TRABAJO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Inheritance(strategy=InheritanceType.JOINED)
public class AgendaTrabajo implements Serializable, Auditable {
	
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
		
	@Id
    @Column(name = "TBJ_ATJ_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "AgendaTrabajoGenerator")
    @SequenceGenerator(name = "AgendaTrabajoGenerator", sequenceName = "S_TBJ_ATJ_AGENDA_TRABAJO")
    private Long id;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "TBJ_ID")
    private Trabajo trabajo;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="USU_ID")
    private Usuario gestor;
	
    @Column(name = "TBJ_ATJ_FECHA")
    private Date fecha;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TAT_ID")
    private DDTipoApunte tipoGestion;
    
    @Column(name = "TBJ_ATJ_OBSERVACION")
    private String observaciones;
       	
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

	public Trabajo getTrabajo() {
		return trabajo;
	}

	public void setTrabajo(Trabajo trabajo) {
		this.trabajo = trabajo;
	}

	public Usuario getGestor() {
		return gestor;
	}

	public void setGestor(Usuario gestor) {
		this.gestor = gestor;
	}

	public Date getFecha() {
		return fecha;
	}

	public void setFecha(Date fecha) {
		this.fecha = fecha;
	}

	public DDTipoApunte getTipoGestion() {
		return tipoGestion;
	}

	public void setTipoGestion(DDTipoApunte tipoGestion) {
		this.tipoGestion = tipoGestion;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
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
