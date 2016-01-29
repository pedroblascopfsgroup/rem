package es.pfsgroup.plugin.recovery.plazosExterna.plazoTareaExternaPlaza.model;

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

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TipoJuzgado;
import es.capgemini.pfs.procesosJudiciales.model.TipoPlaza;


@Entity
@Table(name = "DD_PTP_PLAZOS_TAREAS_PLAZAS", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class PTEPlazoTareaExternaPlaza implements Serializable, Auditable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 5506681289423818835L;

	@Id
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "PlazoTareaExternaPlazaGenerator")
    @SequenceGenerator(name = "PlazoTareaExternaPlazaGenerator", sequenceName = "S_DD_PTP_PLAZOS_TAREAS_PLAZAS")
    @Column(name = "DD_PTP_ID")
    private Long id;
	
	@ManyToOne
    @JoinColumn(name ="TAP_ID")
	private TareaProcedimiento tareaProcedimiento;
	
	@ManyToOne
    @JoinColumn(name = "DD_JUZ_ID")
	private TipoJuzgado tipoJuzgado;
	
	@ManyToOne
    @JoinColumn(name = "DD_PLA_ID")
	private TipoPlaza tipoPlaza;
	
	@Column(name = "DD_PTP_PLAZO_SCRIPT")
    private String scriptPlazo;
	
	@Column(name="DD_PTP_ABSOLUTO")
	private Boolean absoluto;
	
	@Column(name="DD_PTP_OBSERVACIONES")
	private String observaciones;
	
	@Embedded
	private Auditoria auditoria;

	    /**
	     * Objeto versión.
	     */
	@Version
	private Integer version;
	
	

	public void setId(Long id) {
		this.id = id;
	}

	public Long getId() {
		return id;
	}

	public void setTareaProcedimiento(TareaProcedimiento tareaProcedimiento) {
		this.tareaProcedimiento = tareaProcedimiento;
	}

	public TareaProcedimiento getTareaProcedimiento() {
		return tareaProcedimiento;
	}

	public void setTipoJuzgado(TipoJuzgado tipoJuzgado) {
		this.tipoJuzgado = tipoJuzgado;
	}

	public TipoJuzgado getTipoJuzgado() {
		return tipoJuzgado;
	}

	public void setTipoPlaza(TipoPlaza tipoPlaza) {
		this.tipoPlaza = tipoPlaza;
	}

	public TipoPlaza getTipoPlaza() {
		return tipoPlaza;
	}

	public void setScriptPlazo(String scriptPlazo) {
		this.scriptPlazo = scriptPlazo;
	}

	public String getScriptPlazo() {
		return scriptPlazo;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public Integer getVersion() {
		return version;
	}

	@Override
	public Auditoria getAuditoria() {
		return auditoria;
	}

	@Override
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria=auditoria;
		
	}

	public void setAbsoluto(Boolean absoluto) {
		this.absoluto = absoluto;
	}

	public Boolean getAbsoluto() {
		return absoluto;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}

	public String getObservaciones() {
		return observaciones;
	}

}
