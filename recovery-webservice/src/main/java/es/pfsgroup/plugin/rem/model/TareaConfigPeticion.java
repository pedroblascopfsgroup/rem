package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.pfsgroup.plugin.rem.model.dd.DDClaseActivoBancario;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpIncorrienteBancario;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoExpRiesgoBancario;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoClaseActivoBancario;
import es.pfsgroup.plugin.rem.model.dd.DDTipoProductoBancario;



/**
 * Modelo que gestiona los datos de activo bancario
 * 
 * @author Bender
 */
@Entity
@Table(name = "TCP_TAREA_CONFIG_PETICION", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class TareaConfigPeticion implements Serializable, Auditable {

	
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "TCP_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "TareaConfigGenerator")
    @SequenceGenerator(name = "TareaConfigGenerator", sequenceName = "S_TCP_TAREA_CONFIG_PETICION")
    private Long id;

	@OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TAP_ID")
    private TareaProcedimiento tarea;
	
	@Column(name = "TCP_ACTIVADA")
	private Boolean activada;
	
	@Column(name = "TCP_PERMITIDA")
	private Boolean permitida;

	
	@Embedded
	private Auditoria auditoria;

	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	
	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public TareaProcedimiento getTarea() {
		return tarea;
	}

	public void setTarea(TareaProcedimiento tarea) {
		this.tarea = tarea;
	}

	public Boolean getActivada() {
		return activada;
	}

	public void setActivada(Boolean activada) {
		this.activada = activada;
	}

	public Boolean getPermitida() {
		return permitida;
	}

	public void setPermitida(Boolean permitida) {
		this.permitida = permitida;
	}
	

}
