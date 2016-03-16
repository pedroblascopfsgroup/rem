package es.capgemini.pfs.expediente.model;

import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Set;

import javax.persistence.Basic;
import javax.persistence.CascadeType;
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
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Cascade;
import org.hibernate.annotations.Formula;
import org.hibernate.annotations.Where;

import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.APPConstants;
import es.capgemini.pfs.actitudAptitudActuacion.model.ActitudAptitudActuacion;
import es.capgemini.pfs.acuerdo.model.Acuerdo;
import es.capgemini.pfs.arquetipo.model.Arquetipo;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.DDEstadoAsunto;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.comite.model.Comite;
import es.capgemini.pfs.comite.model.DecisionComite;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.exclusionexpedientecliente.model.ExclusionExpedienteCliente;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.capgemini.pfs.itinerario.model.Estado;
import es.capgemini.pfs.movimiento.model.Movimiento;
import es.capgemini.pfs.oficina.model.Oficina;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.utils.Describible;

/**
 * Clase que representa la entidad Expediente.
 */

@Entity
@Table(name = "EXP_EXPEDIENTES", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Inheritance(strategy=InheritanceType.JOINED)
public class Expediente implements Serializable, Auditable, Describible {
    private static final long serialVersionUID = -1353637087467504894L;

    @Id
    @Column(name = "EXP_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ExpedienteGenerator")
    @SequenceGenerator(name = "ExpedienteGenerator", sequenceName = "S_EXP_EXPEDIENTES")
    private Long id;

    @OneToOne(targetEntity = DDEstadoItinerario.class, fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_EST_ID")
    private DDEstadoItinerario estadoItinerario;

    @OneToOne(targetEntity = ActitudAptitudActuacion.class, cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "AAA_ID")
    private ActitudAptitudActuacion aaa;

    @OneToOne(targetEntity = Arquetipo.class, cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "ARQ_ID")
    private Arquetipo arquetipo;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "OFI_ID")
    private Oficina oficina;

    @OneToOne(targetEntity = DDEstadoExpediente.class, fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_EEX_ID")
    private DDEstadoExpediente estadoExpediente;
    
    @OneToOne(targetEntity = DDTipoExpediente.class, fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TPX_ID")
    private DDTipoExpediente tipoExpediente;

	@Column(name = "EXP_PROCESS_BPM")
    private Long processBpm;

    @Column(name = "EXP_MANUAL")
    private boolean manual;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "COM_ID")
    private Comite comite;

    @OneToMany(mappedBy = "expediente", fetch = FetchType.LAZY)
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<Acuerdo> acuerdos;

    @OneToMany(mappedBy = "expediente", fetch = FetchType.LAZY)
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<Asunto> asuntos;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DCO_ID")
    private DecisionComite decisionComite;

    @OneToOne(mappedBy = "expediente", fetch = FetchType.LAZY)
    @JoinColumn(name = "EXP_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private ExclusionExpedienteCliente exclusionExpedienteCliente;

    @OneToMany(mappedBy = "expediente", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<ExpedienteContrato> contratos;

    @OneToMany(mappedBy = "expediente", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<ExpedientePersona> personas;

    @Column(name = "EXP_FECHA_EST_ID")
    private Date fechaEstado;

    @OneToMany(mappedBy = "expediente", fetch = FetchType.LAZY)
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    @JoinColumn(name = "EXP_ID")
    private Set<TareaNotificacion> tareas;

    @OneToMany(mappedBy = "expediente", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @Cascade( { org.hibernate.annotations.CascadeType.DELETE_ORPHAN })
    private Set<AdjuntoExpediente> adjuntos;

    @Column(name = "EXP_DESCRIPCION")
    private String descripcionExpediente;
    
	@Column(name = "SYS_GUID")
	private String guid;

    @Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;

    @Formula(value = "(select count(*) from asu_asuntos asu "
            + "left join ${master.schema}.DD_EAS_ESTADO_ASUNTOS dd_eas on asu.dd_eas_id = dd_eas.dd_eas_id" + " where "
            + " dd_eas.dd_eas_codigo in ('" + DDEstadoAsunto.ESTADO_ASUNTO_ACEPTADO + "','" + DDEstadoAsunto.ESTADO_ASUNTO_CONFIRMADO + "','"
            + DDEstadoAsunto.ESTADO_ASUNTO_PROPUESTO + "') " + " and asu.borrado = 0 and asu.exp_id = exp_id)")
    private Long cantidadAsuntos;

    @Formula(value = "(Select NVL(sum(m.mov_pos_viva_vencida), 0)"
            + " from mov_movimientos m, cex_contratos_expediente cex, cnt_contratos cnt, DD_TPE_TIPO_PROD_ENTIDAD tpe"
            + " where cex.borrado = 0 and m.cnt_id = cex.cnt_id" + " and cex.exp_id = exp_id AND cnt.cnt_id = cex.cnt_id"
            + " and m.mov_fecha_extraccion = cnt.CNT_FECHA_EXTRACCION" + " and cnt.dd_tpe_id = tpe.dd_tpe_id" + " and m.mov_riesgo > 0)")
    @Basic(fetch = FetchType.LAZY)
    private Double volumenRiesgoVencido;
    
    
    @Formula(value = "(Select NVL(sum(m.mov_deuda_irregular), 0)"
            + " from mov_movimientos m, cex_contratos_expediente cex, cnt_contratos cnt, DD_TPE_TIPO_PROD_ENTIDAD tpe"
            + " where cex.borrado = 0 and m.cnt_id = cex.cnt_id" + " and cex.exp_id = exp_id AND cnt.cnt_id = cex.cnt_id"
            + " and m.mov_fecha_extraccion = cnt.CNT_FECHA_EXTRACCION" + " and cnt.dd_tpe_id = tpe.dd_tpe_id" + " and m.mov_riesgo > 0)")
    @Basic(fetch = FetchType.LAZY)
    private Double dispuestoVencido;

    //La fecha de vencimiento se calculaba antes así
//    @Formula(value = "(select tar.tar_fecha_venc from tar_tareas_notificaciones tar, ${master.schema}.DD_STA_SUBTIPO_TAREA_BASE dd_sta "
//            + " where tar.exp_id = exp_id and tar.borrado = 0 and tar.DD_STA_ID = dd_sta.DD_STA_ID " + " and dd_sta.dd_sta_codigo in ('"
//            + SubtipoTarea.CODIGO_COMPLETAR_EXPEDIENTE + "','" + SubtipoTarea.CODIGO_REVISAR_EXPEDIENE + "','" + SubtipoTarea.CODIGO_DECISION_COMITE
//            + "') )")
//    
    @Formula(value = "(SELECT min(M.MOV_FECHA_POS_VENCIDA) "
    		+ " FROM mov_movimientos m, cex_contratos_expediente cex, cnt_contratos cnt "
    		+ " WHERE cex.borrado = 0 AND m.borrado = 0 AND cnt.borrado = 0 "
    		+ " AND m.cnt_id = cex.cnt_id AND cex.exp_id = exp_id " 
    		+ " AND cnt.cnt_id = cex.cnt_id AND m.mov_fecha_extraccion = cnt.CNT_FECHA_EXTRACCION)")
    private Date fechaVencimiento;

    /**
     * devuelve el volumen de riesgo de este expediente.
     * Sumatoria de la suma de posicion viva vencida y no venciada de cada contrato
     * @return el monto del riesgo del expediente.
     */
    public Double getVolumenRiesgo() {
    	
    	Double volumenRiesgo = 0.0;
    	Double riesgo = 0.0;
    	
    	
    	for (ExpedienteContrato expedienteContrato : contratos) {
    		Date fechaExtraccion = null;
    		Contrato contrato = expedienteContrato.getContrato();
    		for(Movimiento movimiento : contrato.getMovimientos()) {
    			if(contrato.getFechaExtraccion().equals(movimiento.getFechaExtraccion())) {
    				
    				if(fechaExtraccion == null || fechaExtraccion.before(movimiento.getFechaExtraccion())) {
    					fechaExtraccion = movimiento.getFechaExtraccion();
    					riesgo = new Double(movimiento.getRiesgo());
    					
    				}
    			}
    		}
    		volumenRiesgo = volumenRiesgo +  riesgo;
    	}
    	
    	return volumenRiesgo;
    }
    
    /**
     * devuelve el volumen de riesgo de este expediente.
     * Sumatoria de la suma de posicion viva vencida y no venciada de cada contrato
     * @return el monto del riesgo del expediente.
     */
    public Double getDispuestoTotal() {
    	
    	Double dispuestoTotal = 0.0;
    	Double dispuesto = 0.0;
    	
    	
    	for (ExpedienteContrato expedienteContrato : contratos) {
    		Date fechaExtraccion = null;
    		Contrato contrato = expedienteContrato.getContrato();
    		for(Movimiento movimiento : contrato.getMovimientos()) {
    			if(contrato.getFechaExtraccion().equals(movimiento.getFechaExtraccion())) {
    				
    				if(fechaExtraccion == null || fechaExtraccion.before(movimiento.getFechaExtraccion())) {
    					fechaExtraccion = movimiento.getFechaExtraccion();
    					dispuesto = new Double(movimiento.getDispuesto());
    					
    				}
    			}
    		}
    		dispuestoTotal = dispuestoTotal +  dispuesto;
    	}
    	
    	return dispuestoTotal;
    }

    /**
     * devuelve el volumen de riesgo vencido de este expediente.
     * Sumatoria de la posicion viva venciada de cada contrato.
     * @return el monto del riesgo vencido del expediente.
     */
    public Double getVolumenRiesgoVencido() {
        return volumenRiesgoVencido;
    }

    /**
     * Retorna el contrato que gener� el expediente.
     * De no existir retorna null
     * @return Contrato
     */
    public Contrato getContratoPase() {
        for (ExpedienteContrato expContrato : contratos) {
            if (expContrato.getCexPase() == 1) { return expContrato.getContrato(); }
        }
        return null;
    }

    /**
     * Retorna el contrato que gener� el expediente.
     * De no existir retorna null
     * @return Contrato
     */
    public ExpedienteContrato getExpedienteContratoPase() {
        for (ExpedienteContrato expContrato : contratos) {
            if (expContrato.getCexPase() == 1) { return expContrato; }
        }
        return null;
    }

    /**
     * Devuelve el contrato de pase como lista.
     * @return la lista
     */
    public List<Contrato> getListaContratoPase() {
        Contrato c = getContratoPase();
        List<Contrato> l = new ArrayList<Contrato>();
        if (c != null) {
            l.add(c);
        }
        return l;
    }

    /**
     * Devuelve la lista de contratos que no provocaron el pase.
     * @return los contratos que no generaron el pase.
     */
    public List<Contrato> getContratosNoPase() {
        List<Contrato> contratosNoPase = new ArrayList<Contrato>();
        for (ExpedienteContrato expContrato : contratos) {
            if (expContrato.getCexPase() != 1) {
                contratosNoPase.add(expContrato.getContrato());
            }
        }
        return contratosNoPase;
    }

    /**
     * Devuelve la lista de contratos que no provocaron el pase y que sean activos o pasivos negativos.
     * @return los contratos que no generaron el pase.
     */
    public List<Contrato> getContratosNoPaseActivos() {
        List<Contrato> contratosNoPase = new ArrayList<Contrato>();
        //TODO queda filtrar por activos y pasivos negativos
        for (ExpedienteContrato expContrato : contratos) {
            if (expContrato.getCexPase() != 1) {
                contratosNoPase.add(expContrato.getContrato());
            }
        }
        return contratosNoPase;
    }

    /**
     * Devuelve los contratos vencidos del expediente.
     * @return los contratos vencidos.
     */
    public List<Contrato> getContratosVencidos() {
        List<Contrato> contratosVencidos = new ArrayList<Contrato>();
        for (ExpedienteContrato expContrato : contratos) {
            if (expContrato.getContrato().isVencido()) {
                contratosVencidos.add(expContrato.getContrato());
            }
        }
        return contratosVencidos;
    }

    /**
     * Devuelve los contratos no vencidos del expediente.
     * @return los contratos no vencidos.
     */
    public List<Contrato> getContratosNoVencidos() {
        List<Contrato> contratosNoVencidos = new ArrayList<Contrato>();
        for (ExpedienteContrato expContrato : contratos) {
            if (!expContrato.getContrato().isVencido()) {
                contratosNoVencidos.add(expContrato.getContrato());
            }
        }
        return contratosNoVencidos;
    }

    /**
     * Retorna los contratos activos y los pasivos-vencidos.
     * @return lista de contratos activos y los pasivos-vencidos
     */
    public List<Contrato> getContratosVisibles() {
        List<Contrato> contratosTotal = new ArrayList<Contrato>();
        for (ExpedienteContrato expContrato : contratos) {
            if (expContrato.getContrato() != null && expContrato.getContrato().getLastMovimiento() != null
                    && expContrato.getContrato().getLastMovimiento().getRiesgo() > 0) contratosTotal.add(expContrato.getContrato());
        }
        return contratosTotal;
    }

    /**
     * Obtiene el gestor Actual.
     * @return descripcion del gestor actual
     */
    public String getGestorActual() {
    	
    	Estado estadoActual= null;
    	
    	if(arquetipo != null && arquetipo.getItinerario() != null){
    		estadoActual = arquetipo.getItinerario().getEstado(this.getEstadoItinerario().getCodigo());
    	}
    	
        
        if (estadoActual != null && estadoActual.getGestorPerfil() != null) { return estadoActual.getGestorPerfil().getDescripcion(); }
        return "";
    }

    /**
     * Obtiene el id del gestor Actual.
     * @return id del gestor actual
     */
    public Long getIdGestorActual() {
        Long idEstado = null;
        Estado estadoActual = arquetipo.getItinerario().getEstado(this.getEstadoItinerario().getCodigo());
        if (estadoActual != null && estadoActual.getGestorPerfil() != null) {
            idEstado = estadoActual.getGestorPerfil().getId();
        }
        return idEstado;
    }

    /**
     * Obtiene el supervisor Actual.
     * @return supervisor actual
     */
    public String getSupervisorActual() {
        Estado estadoActual = arquetipo.getItinerario().getEstado(this.getEstadoItinerario().getCodigo());
        if (estadoActual != null && estadoActual.getSupervisor() != null) { return estadoActual.getSupervisor().getDescripcion(); }
        return "";
    }

    /**
     * Obtiene el id del supervisor Actual.
     * @return id del supervisor actual
     */
    public Long getIdSupervisorActual() {
        Long idEstado = null;
        Estado estadoActual = arquetipo.getItinerario().getEstado(this.getEstadoItinerario().getCodigo());
        if (estadoActual != null && estadoActual.getSupervisor() != null) {
            idEstado = estadoActual.getSupervisor().getId();
        }
        return idEstado;
    }

    /**
     * obtiene la fecha de creacion formateada.
     * @return fecha
     */
    public String getFechaCreacionFormateada() {
        SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy");
        return df.format(auditoria.getFechaCrear());
    }

    /**
     * Devuelve la lista de contratos del expediente.
     * @return la lista de contratos del expediente
     */
    public List<Contrato> getTodosLosContratos() {
        List<Contrato> lista = new ArrayList<Contrato>();
        for (ExpedienteContrato expCnt : contratos) {
            if (expCnt.getCexPase() == 1) {
                lista.add(0, expCnt.getContrato());
            } else {
                lista.add(expCnt.getContrato());
            }
        }
        return lista;
    }

    /**
     * Retorna el atributo id.
     * @return id
     */
    public Long getId() {
        return id;
    }

    /**
     * Setea el atributo id.
     * @param id Long
     */
    public void setExpId(Long id) {
        this.id = id;
    }

    /**
     * Retorna el atributo processBpm.
     * @return processBpm
     */
    public Long getProcessBpm() {
        return processBpm;
    }

    /**
     * Setea el atributo processBpm.
     * @param processBpm Long
     */
    public void setExpProcessBpm(Long processBpm) {
        this.processBpm = processBpm;
    }

    /**
     * Retorna el atributo auditoria.
     * @return auditoria
     */
    public Auditoria getAuditoria() {
        return auditoria;
    }

    /**
     * Setea el atributo auditoria.
     * @param auditoria Auditoria
     */
    public void setAuditoria(Auditoria auditoria) {
        this.auditoria = auditoria;
    }

    /**
      * Retorna el atributo version.
      * @return version
      */
    public Integer getVersion() {
        return version;
    }

    /**
     * Setea el atributo version.
     * @param version Integer
     */
    public void setVersion(Integer version) {
        this.version = version;
    }

    /**
      * Retorna el atributo estadoItinerario.
      * @return estadoItinerario
      */
    public DDEstadoItinerario getEstadoItinerario() {
        return estadoItinerario;
    }

    /**
      * Setea el atributo version.
      * @param estadoItinerario DDEstadoItinerario
      */
    public void setEstadoItinerario(DDEstadoItinerario estadoItinerario) {
        this.estadoItinerario = estadoItinerario;
    }

    /**
     * @return the contratos
     */
    public List<ExpedienteContrato> getContratos() {
        return contratos;
    }

    /**
     * @param contratos the contratos to set
     */
    public void setContratos(List<ExpedienteContrato> contratos) {
        this.contratos = contratos;
    }

    /**
     * @return the personas
     */
    public List<ExpedientePersona> getPersonas() {
        return personas;
    }

    /**
     * @param personas the personas to set
     */
    public void setPersonas(List<ExpedientePersona> personas) {
        this.personas = personas;
    }

    /**
     * @param id the id to set
     */
    public void setId(Long id) {
        this.id = id;
    }

    /**
     * @param processBpm the processBpm to set
     */
    public void setProcessBpm(Long processBpm) {
        this.processBpm = processBpm;
    }

    /**
     * @return the aaa
     */
    public ActitudAptitudActuacion getAaa() {
        return aaa;
    }

    /**
     * @param aaa the aaa to set
     */
    public void setAaa(ActitudAptitudActuacion aaa) {
        this.aaa = aaa;
    }

    /**
     * Retorna el atributo oficina.
     * @return oficina
     */
    public Oficina getOficina() {
        return oficina;
    }

    /**
     * Setea el atributo oficina.
     * @param oficina la oficina
     */
    public void setOficina(Oficina oficina) {
        this.oficina = oficina;
    }

    /**
     * @return the arquetipo
     */
    public Arquetipo getArquetipo() {
        return arquetipo;
    }

    /**
     * @param arquetipo the arquetipo to set
     */
    public void setArquetipo(Arquetipo arquetipo) {
        this.arquetipo = arquetipo;
    }

    /**
     * @return the fechaEstado
     */
    public Date getFechaEstado() {
        return fechaEstado;
    }

    /**
     * @param fechaEstado the fechaEstado to set
     */
    public void setFechaEstado(Date fechaEstado) {
        this.fechaEstado = fechaEstado;
    }

    /**
     * @return the manual
     */
    public boolean isManual() {
        return manual;
    }

    /**
     * @param manual the manual to set
     */
    public void setManual(boolean manual) {
        this.manual = manual;
    }

    /**
     * @return boolean: <code>true</code> si el itineario del expediente es de seguimiento
     */
    public boolean getSeguimiento() {
    	
    	if(arquetipo != null && arquetipo.getItinerario() != null && arquetipo.getItinerario().getdDtipoItinerario() != null){
    		return arquetipo.getItinerario().getdDtipoItinerario().getItinerarioSeguimiento();
    	}
    	else{
    		return false;
    	}
        
    }
    
    /**
     * @return boolean: <code>true</code> si el itineario del expediente es de recuperacion
     */
    public boolean getRecuperacion() {
    	
    	if(arquetipo != null && arquetipo.getItinerario() != null && arquetipo.getItinerario().getdDtipoItinerario() != null){
            return arquetipo.getItinerario().getdDtipoItinerario().getItinerarioRecuperacion();

    	}
    	else{
    		return false;
    	}
    }

    /**
     * @return String: Descripci�n del itinerario del expediente
     */
    public String getTipoItinerario() {
    	
    	if(arquetipo != null && arquetipo.getItinerario() != null && arquetipo.getItinerario().getdDtipoItinerario() != null){
    		return arquetipo.getItinerario().getdDtipoItinerario().getDescripcion();
    	}
    	else{
    		return null;
    	}

        
    }

    /**
     * @return the decisionComite
     */
    public DecisionComite getDecisionComite() {
        return decisionComite;
    }

    /**
     * @param decisionComite the decisionComite to set
     */
    public void setDecisionComite(DecisionComite decisionComite) {
        this.decisionComite = decisionComite;
    }

    /**
     * @return the comite
     */
    public Comite getComite() {
        return comite;
    }

    /**
     * @param comite the comite to set
     */
    public void setComite(Comite comite) {
        this.comite = comite;
    }

    /**
     * obtiene las fechas a comites.
     * @return fecha
     */
    public Date getFechaAComite() {
        if (DDEstadoItinerario.ESTADO_DECISION_COMIT.equals(this.getEstadoItinerario().getCodigo())) { return getFechaEstado(); }
        return null;
    }

    /**
     * Retorna la cantidad de asuntos que tiene el expediente.
     * @return int cantidad de asuntos
     */
    public Long getCantidadAsuntos() {
        //if (getAsuntos() != null) { return getAsuntos().size(); }
        //return 0;
        return cantidadAsuntos;
    }

    /**
     * Retorna los asuntos relacionados al expediente.
     * @return lista de asuntos
     */
    public List<Asunto> getAsuntos() {
        return asuntos;
    }

    /**
     * Retorna la cantidad de contratos que tiene el expediente.
     * @return int
     */
    public int getCantidadContratos() {
        return getContratos().size();
    }

    /**
     * Retorna los ExpedienteContrato de los cuales se tomo la decisiónde no hacer nada.
     * @return lista de ExpedienteContrato
     */
    public List<ExpedienteContrato> getContratosDescartados() {
        List<ExpedienteContrato> expCnts = new ArrayList<ExpedienteContrato>();
        for (ExpedienteContrato expCnt : contratos) {
            if (expCnt.getSinActuacion() != null && expCnt.getSinActuacion() && !expCnt.getContrato().getAuditoria().isBorrado()) {
                expCnts.add(expCnt);
            }
        }
        return expCnts;
    }

    /**
     * Retorna los ExpedienteContrato de los cuales se tomo la decisiónde no hacer nada y son de riesgo
     * @return lista de ExpedienteContrato
     */
    public List<ExpedienteContrato> getContratosDescartadosRiesgo() {
        List<ExpedienteContrato> expCnts = new ArrayList<ExpedienteContrato>();
        for (ExpedienteContrato expCnt : getContratosDescartados()) {
            if (expCnt.getContrato().getRiesgo() > 0) {
                expCnts.add(expCnt);
            }
        }
        return expCnts;
    }

    /**
     * Retorna la fecha de fin de la tarea actual.
     * @return fecha de fin
     */
    public Date getFechaVencimiento() {
        /*if (getFechaAComite()!=null){
        	return getFechaAComite();
        }*/
        /*for (TareaNotificacion tarea : tareas) {
            if (estadoItinerario.getCodigo().equals(tarea.getEstadoItinerario().getCodigo())
            	&&(SubtipoTarea.CODIGO_COMPLETAR_EXPEDIENTE.equals(tarea.getSubtipoTarea().getCodigoSubtarea())
          		   || SubtipoTarea.CODIGO_REVISAR_EXPEDIENE.equals(tarea.getSubtipoTarea().getCodigoSubtarea())
            	   || SubtipoTarea.CODIGO_DECISION_COMITE.equals(tarea.getSubtipoTarea().getCodigoSubtarea()))
            	){
            return tarea.getFechaVenc();
            }
        }*/
        return fechaVencimiento;
        //return null;
    }

    /**
     * Devuelve los días que tiene vencido el Expediente.
     * @return los días que tiene vencido o null si no está vencido
     */
    public Long getDiasVencido() {
        SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy");

        if (getFechaVencimiento() == null) { return 0L; }
        try {
            Date fechaHoy = sdf1.parse(sdf1.format(new Date()));
            Date fechaVence = sdf1.parse(sdf1.format(getFechaVencimiento()));
            if (fechaHoy.after(fechaVence)) {
                Long dias = (fechaHoy.getTime() - fechaVence.getTime()) / APPConstants.MILISEGUNDOS_DIA;
                return dias;
            }
        } catch (Exception e) {
            return 0L;
        }
        return 0L;

    }

    /**
     * Indica si el expediente esta decidido.
     * @return boolean
     */
    public boolean getEstaDecidido() {
        return DDEstadoExpediente.ESTADO_EXPEDIENTE_DECIDIDO.equals(getEstadoExpediente().getCodigo());
    }

    /**
     * Agrega un adjunto al expediente, tomando los datos de un FileItem.
     *
     * @param fileItem file
     */
    public void addAdjunto(FileItem fileItem) {
        AdjuntoExpediente adjuntoExpediente = new AdjuntoExpediente(fileItem);
        adjuntoExpediente.setExpediente(this);
        Auditoria.save(adjuntoExpediente);
        getAdjuntos().add(adjuntoExpediente);
    }

    /**
     * @return the tareas
     */
    public Set<TareaNotificacion> getTareas() {
        return tareas;
    }

    /**
     * @param tareas the tareas to set
     */
    public void setTareas(Set<TareaNotificacion> tareas) {
        this.tareas = tareas;
    }

    /**
     * @param asuntos the asuntos to set
     */
    public void setAsuntos(List<Asunto> asuntos) {
        this.asuntos = asuntos;
    }

    /**
     * @return the adjuntos
     */
    public Set<AdjuntoExpediente> getAdjuntos() {
        return adjuntos;
    }

    /**
     * setter.
     * @param adjuntoExpedientes the adjuntos to set
     */
    public void setAdjuntos(Set<AdjuntoExpediente> adjuntoExpedientes) {
        this.adjuntos = adjuntoExpedientes;
    }

    /**
     * Devuelve los adjuntos (que est�n en un Set) como una lista
     * para que pueda ser accedido aleatoreamente.
     * @return List AdjuntoPersona
     */
    public List<AdjuntoExpediente> getAdjuntosAsList() {
        return new ArrayList<AdjuntoExpediente>(adjuntos);
    }

    /**
     * devuelve el adjunto por Id.
     * @param id id
     * @return adjunto
     */
    public AdjuntoExpediente getAdjunto(Long id) {
        for (AdjuntoExpediente adj : getAdjuntos()) {
            if (adj.getId().equals(id)) { return adj; }
        }
        return null;
    }

    /**
     * @return the estadoExpediente
     */
    public DDEstadoExpediente getEstadoExpediente() {
        return estadoExpediente;
    }

    /**
     * Indica si el expediente est� congelado.
     * @return true si est� congelado
     */
    public boolean getEstaCongelado() {
        return DDEstadoExpediente.ESTADO_EXPEDIENTE_CONGELADO.equals(estadoExpediente.getCodigo());
    }

    /**
     * Indica si el expediente est� bloqueado.
     * @return true si est� bloqueado
     */
    public boolean getEstaBloqueado() {
        return DDEstadoExpediente.ESTADO_EXPEDIENTE_BLOQUEADO.equals(estadoExpediente.getCodigo());
    }

    /**
     * Indica si el expediente está en estado activo.
     * @return true si está Activo
     */
    public boolean getEstaEstadoActivo() {
        return DDEstadoExpediente.ESTADO_EXPEDIENTE_ACTIVO.equals(estadoExpediente.getCodigo());
    }
    
    /**
     * Indica si el expediente está en estado cancelado.
     * @return true si está cancelado
     */
    public boolean getEstaCancelado() {
        return DDEstadoExpediente.ESTADO_EXPEDIENTE_CANCELADO.equals(estadoExpediente.getCodigo());
    }

    /**
     * @param estado the estadoExpediente to set
     */
    public void setEstadoExpediente(DDEstadoExpediente estado) {
        this.estadoExpediente = estado;
    }

    /**
     * @return the descripcionExpediente
     */
    public String getDescripcionExpediente() {
        return descripcionExpediente;
    }

    /**
     * @param descripcionExpediente the descripcionExpediente to set
     */
    public void setDescripcionExpediente(String descripcionExpediente) {
        this.descripcionExpediente = descripcionExpediente;
    }

    /**
     * @return the exclusionExpedienteCliente
     */
    public ExclusionExpedienteCliente getExclusionExpedienteCliente() {
        return exclusionExpedienteCliente;
    }

    /**
     * @param exclusionExpedienteCliente the exclusionExpedienteCliente to set
     */
    public void setExclusionExpedienteCliente(ExclusionExpedienteCliente exclusionExpedienteCliente) {
        this.exclusionExpedienteCliente = exclusionExpedienteCliente;
    }

    /**
     * @return el volumen de riesgo en valor absoluto.
     */
    public Double getVolumenRiesgoAbsoluto() {
        if (getVolumenRiesgo() == null) { return 0D; }
        return Math.abs(getVolumenRiesgo());
    }

    /**
     * @return el volumen de riesgo vencido en valor absoluto.
     */
    public Double getVolumenRiesgoVencidoAbsoluto() {
        if (volumenRiesgoVencido == null) { return 0D; }
        return Math.abs(volumenRiesgoVencido);
    }
    
    
    /**
     * @return el volumen de riesgo en valor absoluto.
     */
    public Double getDispuestoAbsoluto() {
        if (getVolumenRiesgo() == null) { return 0D; }
        return Math.abs(getDispuestoTotal());
    }

    /**
     * @return el volumen de riesgo vencido en valor absoluto.
     */
    public Double getDispuestoVencidoAbsoluto() {
        if (dispuestoVencido == null) { return 0D; }
        return Math.abs(dispuestoVencido);
    }

    /**
     * obtiene el id de la tarea asociada al expediente si existe.
     * @return id
     */
    public Long getIdTareaExpediente() {
        for (TareaNotificacion tarea : getTareas()) {
            if (estadoItinerario.getCodigo().equals(tarea.getEstadoItinerario().getCodigo())
                    && (SubtipoTarea.CODIGO_COMPLETAR_EXPEDIENTE.equals(tarea.getSubtipoTarea().getCodigoSubtarea())
                            || SubtipoTarea.CODIGO_REVISAR_EXPEDIENE.equals(tarea.getSubtipoTarea().getCodigoSubtarea()) || SubtipoTarea.CODIGO_DECISION_COMITE
                            .equals(tarea.getSubtipoTarea().getCodigoSubtarea())
                            || SubtipoTarea.CODIGO_FORMALIZAR_PROPUESTA.equals(tarea.getSubtipoTarea().getCodigoSubtarea()) )) { return tarea.getId(); }
        }
        return null;
    }

    /**
     * {@inheritDoc}
     */
    public String getDescripcion() {
        return getDescripcionExpediente();
    }

    /**
     * Indica la cantidad de d�as que faltan para el vencimiento del expediente.
     * @return la cantidad de d�as o null si est� vencido
     */
    public Long getDiasParaVencimiento() {
        if (fechaVencimiento == null) { return null; }
        Long diferencia = fechaVencimiento.getTime() - System.currentTimeMillis();
        if (diferencia < 0) { return null; }
        return diferencia / APPConstants.MILISEGUNDOS_DIA;
    }

    /**
     * Devuelve el conjunto de personas solicitado en funci�n del �mbito.
     * @param ambitoExpediente �mbito de solicitud de personas
     * @return Listado de personas
     */
    public List<ExpedientePersona> getPersonas(DDAmbitoExpediente ambitoExpediente) {
        String codigoAmbitoExpediente = ambitoExpediente.getCodigo();
        HashMap<String, String> map = new HashMap<String, String>(3);

        //Si pide todas las personas, no comprobamos, directamente le devolvemos todas
        if (DDAmbitoExpediente.PERSONAS_SEGUNDA_GENERACION.equals(codigoAmbitoExpediente)) { return getPersonas(); }

        if (DDAmbitoExpediente.PERSONAS_PRIMERA_GENERACION.equals(codigoAmbitoExpediente)) {
            map.put(DDAmbitoExpediente.PERSONAS_PRIMERA_GENERACION, "");
            map.put(DDAmbitoExpediente.PERSONAS_GRUPO, "");
            map.put(DDAmbitoExpediente.PERSONA_PASE, "");
        } else {
            if (DDAmbitoExpediente.PERSONAS_GRUPO.equals(codigoAmbitoExpediente)) {
                map.put(DDAmbitoExpediente.PERSONAS_GRUPO, "");
                map.put(DDAmbitoExpediente.PERSONA_PASE, "");
            } else {
                if (DDAmbitoExpediente.PERSONA_PASE.equals(codigoAmbitoExpediente)) {
                    map.put(DDAmbitoExpediente.PERSONA_PASE, "");
                }
            }
        }

        List<ExpedientePersona> listado = new ArrayList<ExpedientePersona>();

        for (ExpedientePersona persona : getPersonas()) {
            String codigoPersona = persona.getAmbitoExpediente().getCodigo();

            if (map.containsKey(codigoPersona)) {
                listado.add(persona);
            }
        }

        return listado;
    }

    /**
     * Devuelve el conjunto de contratos solicitado en funci�n del �mbito.
     * @param ambitoExpediente �mbito de solicitud de personas
     * @return Listado de contratos
     */
    public List<ExpedienteContrato> getContratos(DDAmbitoExpediente ambitoExpediente) {
        String codigoAmbitoExpediente = ambitoExpediente.getCodigo();
        HashMap<String, String> map = new HashMap<String, String>(3);

        //Si pide todos los contratos, no comprobamos, directamente le devolvemos todos
        if (DDAmbitoExpediente.CONTRATOS_SEGUNDA_GENERACION.equals(codigoAmbitoExpediente)) { return getContratos(); }
        if (DDAmbitoExpediente.CONTRATOS_PRIMERA_GENERACION.equals(codigoAmbitoExpediente)) {
            map.put(DDAmbitoExpediente.CONTRATOS_PRIMERA_GENERACION, "");
            map.put(DDAmbitoExpediente.CONTRATOS_GRUPO, "");
            map.put(DDAmbitoExpediente.CONTRATO_PASE, "");
        } else {
            if (DDAmbitoExpediente.CONTRATOS_GRUPO.equals(codigoAmbitoExpediente)) {
                map.put(DDAmbitoExpediente.CONTRATOS_GRUPO, "");
                map.put(DDAmbitoExpediente.CONTRATO_PASE, "");
            } else {
                if (DDAmbitoExpediente.CONTRATO_PASE.equals(codigoAmbitoExpediente)) {
                    map.put(DDAmbitoExpediente.CONTRATO_PASE, "");
                }
            }
        }

        List<ExpedienteContrato> listado = new ArrayList<ExpedienteContrato>();

        for (ExpedienteContrato contrato : getContratos()) {
            String codigoContrato = contrato.getAmbitoExpediente().getCodigo();

            if (map.containsKey(codigoContrato)) {
                listado.add(contrato);
            }
        }

        return listado;
    }
    
    public DDTipoExpediente getTipoExpediente() {
		return tipoExpediente;
	}

	public void setTipoExpediente(DDTipoExpediente tipoExpediente) {
		this.tipoExpediente = tipoExpediente;
	}

	public String getGuid() {
		return guid;
	}

	public void setGuid(String guid) {
		this.guid = guid;
	}
}
