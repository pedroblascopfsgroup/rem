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
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;

@Entity
@Table(name = "TTM_TAP_TIMER", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class TimerTareaActivo implements Serializable, Auditable{

	private static final long serialVersionUID = 4434859632883698449L;

	@Id
    @Column(name = "TTM_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "TimerTareaGenerator")
    @SequenceGenerator(name = "TimerTareaGenerator", sequenceName = "S_TTM_TAP_TIMER")
    private Long id;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "TAP_ID")
    private TareaProcedimiento tareaProcedimiento ;
	
	@Column(name="TTM_NOMBRE")
	private String nombreTimer;
	
	@Column(name="TTM_TRANSICION")
	private String nombreTransicion;
	
	@Column(name="TTM_PLAZO_SCRIPT")
	private String scriptPlazo;
	
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

	public TareaProcedimiento getTareaProcedimiento() {
		return tareaProcedimiento;
	}

	public void setTareaProcedimiento(TareaProcedimiento tareaProcedimiento) {
		this.tareaProcedimiento = tareaProcedimiento;
	}

	public String getNombreTimer() {
		return nombreTimer;
	}

	public void setNombreTimer(String nombreTimer) {
		this.nombreTimer = nombreTimer;
	}

	public String getNombreTransicion() {
		return nombreTransicion;
	}

	public void setNombreTransicion(String nombreTransicion) {
		this.nombreTransicion = nombreTransicion;
	}

	public String getScriptPlazo() {
		return scriptPlazo;
	}

	public void setScriptPlazo(String scriptPlazo) {
		this.scriptPlazo = scriptPlazo;
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
    
    
}
