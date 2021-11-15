package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.asunto.model.DDTipoActuacion;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.pfsgroup.commons.utils.Checks;

/**
 * Clase que representa la entidad trámite de activo.
 *
 * @author Daniel Gutiérrez
 *
 */
@Entity
@Table(name = "ACT_TRA_TRAMITE", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class ActivoTramite implements Serializable, Auditable{


	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "TRA_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "TramiteGenerator")
	@SequenceGenerator(name = "TramiteGenerator", sequenceName = "S_ACT_TRA_TRAMITE")
	private Long id;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "TRA_TRA_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private ActivoTramite tramitePadre;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ACT_ID")
	private Activo activo;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "TBJ_ID")
	private Trabajo trabajo;
	
    @Column(name = "TRA_PROCESS_BPM")
    private Long processBPM;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TPO_ID")
    private TipoProcedimiento tipoTramite;
    
    @Column(name = "TRA_DECIDIDO")
    private boolean decidido;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_EPR_ID")
    private DDEstadoProcedimiento estadoTramite;
    
	@Column(name="TRA_PARALIZADO")
	private boolean estaParalizado;
	
	@Column(name="TRA_FECHA_PARALIZADO")
	private Date fechaUltimaParalizacion;
	
	@Column(name="TRA_PLAZO_PARALIZ_MILS")
	private Long plazoParalizacion;
	
	@Column(name="TRA_FECHA_INICIO")
	private Date fechaInicio;
	
	@Column(name="TRA_FECHA_FIN")
	private Date fechaFin;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TAC_ID")
    private DDTipoActuacion tipoActuacion;

	@OneToMany(mappedBy = "tramite", fetch = FetchType.LAZY)
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    @JoinColumn(name = "TRA_ID")
    private Set<TareaActivo> tareas;
    
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

	public ActivoTramite getTramitePadre() {
		return tramitePadre;
	}

	public void setTramitePadre(ActivoTramite tramitePadre) {
		this.tramitePadre = tramitePadre;
	}

	public Activo getActivo() {
		//return activo;
		if(!Checks.estaVacio(getActivos()))
			return getActivos().get(0);
		else
			return null;
	}
	
	public List<Activo> getActivos(){
		List<Activo> listaActivos = new ArrayList<Activo>();
		if(!Checks.esNulo(activo)) {
			listaActivos.add(activo);
		} else {
			
			if(!Checks.esNulo(trabajo)) {
				for(ActivoTrabajo activotrabajo : trabajo.getActivosTrabajo())
					listaActivos.add(activotrabajo.getActivo());
			}
		}
			
		return listaActivos;
	}	

	public void setActivo(Activo activo) {
		this.activo = activo;
	}

	public Trabajo getTrabajo() {
		return trabajo;
	}

	public void setTrabajo(Trabajo trabajo) {
		this.trabajo = trabajo;
	}

	public Long getProcessBPM() {
		return processBPM;
	}

	public void setProcessBPM(Long processBPM) {
		this.processBPM = processBPM;
	}

	public TipoProcedimiento getTipoTramite() {
		return tipoTramite;
	}

	public void setTipoTramite(TipoProcedimiento tipoTramite) {
		this.tipoTramite = tipoTramite;
	}

	public boolean isDecidido() {
		return decidido;
	}

	public void setDecidido(boolean decidido) {
		this.decidido = decidido;
	}

	public DDEstadoProcedimiento getEstadoTramite() {
		return estadoTramite;
	}

	public void setEstadoTramite(DDEstadoProcedimiento estadoTramite) {
		this.estadoTramite = estadoTramite;
	}

	public boolean isEstaParalizado() {
		return estaParalizado;
	}

	public void setEstaParalizado(boolean estaParalizado) {
		this.estaParalizado = estaParalizado;
	}

	public Date getFechaUltimaParalizacion() {
		return fechaUltimaParalizacion;
	}

	public void setFechaUltimaParalizacion(Date fechaUltimaParalizacion) {
		this.fechaUltimaParalizacion = fechaUltimaParalizacion;
	}

	public Long getPlazoParalizacion() {
		return plazoParalizacion;
	}

	public void setPlazoParalizacion(Long plazoParalizacion) {
		this.plazoParalizacion = plazoParalizacion;
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
    
	public DDTipoActuacion getTipoActuacion() {
		return tipoActuacion;
	}

	public void setTipoActuacion(DDTipoActuacion tipoActuacion) {
		this.tipoActuacion = tipoActuacion;
	}
	
    public Set<TareaActivo> getTareas() {
		return tareas;
	}

	public void setTareas(Set<TareaActivo> tareas) {
		this.tareas = tareas;
	}
	
	public Date getFechaInicio(){
		return fechaInicio;
	}
	
	public void setFechaInicio(Date fechaInicio){
		this.fechaInicio = fechaInicio;
	}
	
	public Date getFechaFin(){
		return fechaFin;
	}
	
	public void setFechaFin(Date fechaFin){
		this.fechaFin = fechaFin;
	}
	
	public Set<TareaExterna> getTareasExternasActivas() {
		Set<TareaExterna> tareasActivas = new HashSet<TareaExterna>();
		 for (TareaActivo tareaActivo : tareas) {
			if(!tareaActivo.getTareaFinalizada()) {
				tareasActivas.add(tareaActivo.getTareaExterna());
			}
		}
		return tareasActivas;
	}

		
}