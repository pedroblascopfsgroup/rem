package es.capgemini.pfs.asunto.model;

import java.io.Serializable;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;

import javax.persistence.CascadeType;
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
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Transient;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Cascade;
import org.hibernate.annotations.Where;

import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.comite.model.Comite;
import es.capgemini.pfs.comite.model.DecisionComite;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.decisionProcedimiento.model.DDCausaDecisionFinalizar;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.expediente.model.ExpedienteContrato;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;

/**
 * Clase que representa la entidad Asunto.
 * @author mtorrado
 *
 */
@Entity
@Table(name = "ASU_ASUNTOS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
//@Inheritance(strategy = InheritanceType.JOINED)
public class Asunto implements Serializable, Auditable {

    private static final long serialVersionUID = -841109912885123217L;
    
    @Id
    @Column(name = "ASU_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "AsuntoGenerator")
    @SequenceGenerator(name = "AsuntoGenerator", sequenceName = "S_ASU_ASUNTOS")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "GAS_ID")
    private GestorDespacho gestor;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "SUP_ID")
    private GestorDespacho supervisor;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "SUP_COM_ID")
    private Usuario supervisorComite;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "COM_ID")
    private Comite comite;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DCO_ID")
    private DecisionComite decisionComite;

    @OneToOne(fetch = FetchType.LAZY)
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    @JoinColumn(name = "DD_EST_ID")
    private DDEstadoItinerario estadoItinerario;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_EAS_ID")
    private DDEstadoAsunto estadoAsunto;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TAS_ID")
    private DDTiposAsunto tipoAsunto;

    @OneToMany(mappedBy = "asunto", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JoinColumn(name = "asu_id")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<Procedimiento> procedimientos;

    @Column(name = "ASU_PROCESS_BPM")
    private Long processBpm;

    @Column(name = "ASU_FECHA_EST_ID")
    private Date fechaEstado;

    @Column(name = "ASU_NOMBRE")
    private String nombre;

    @Column(name = "ASU_FECHA_RECEP_DOC")
    /** Fecha de Recepción de la Documentación	*/
    private Date fechaRecepDoc;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "EXP_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private Expediente expediente;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ASU_ASU_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private Asunto asuntoOrigen;

    @OneToMany(mappedBy = "asunto", fetch = FetchType.LAZY)
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    @JoinColumn(name = "ASU_ID")
    private Set<TareaNotificacion> tareas;

    @Column(name = "ASU_OBSERVACION")
    private String observacion;

    @OneToOne(mappedBy = "asunto", fetch = FetchType.LAZY)
    private FichaAceptacion fichaAceptacion;

    @OneToMany(mappedBy = "asunto", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @Cascade( { org.hibernate.annotations.CascadeType.DELETE_ORPHAN })
    private Set<AdjuntoAsunto> adjuntos;

    @Transient
    private Float volumenRiesgo;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "USD_ID")
    private GestorDespacho procurador;

    @OneToMany(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    @JoinColumn(name = "ASU_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<HistoricoCambiosAsunto> historicoCambios;

    @Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;
    
    @ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_DFI_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private DDCausaDecisionFinalizar causaDecisionFinalizar;
    
	public DDCausaDecisionFinalizar getCausaDecisionFinalizar() {
		return causaDecisionFinalizar;
	}

	public void setCausaDecisionFinalizar(
			DDCausaDecisionFinalizar causaDecisionFinalizar) {
		this.causaDecisionFinalizar = causaDecisionFinalizar;
	}

    /**
     * Indica si el asunto esta en estado propuesto.
     * @return boolean
     */
    public boolean getEstaPropuesto() {
        if (DDEstadoAsunto.ESTADO_ASUNTO_PROPUESTO.equals(estadoAsunto.getCodigo())
                || DDEstadoAsunto.ESTADO_ASUNTO_EN_CONFORMACION.equals(estadoAsunto.getCodigo())
                || DDEstadoAsunto.ESTADO_ASUNTO_VACIO.equals(estadoAsunto.getCodigo())) { return true; }
        return false;
    }

    /**
     * Retorna el gestor del asunto.
     * @return el gestor del asunto
     */
    public GestorDespacho getGestor() {
        return gestor;
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
    public void setId(Long id) {
        this.id = id;
    }

    /**
     * @param gestor the gestor to set
     */
    public void setGestor(GestorDespacho gestor) {
        this.gestor = gestor;
    }

    /**
     * Retorna el atributo estadoItinerario.
     * @return estadoItinerario
     */
    public DDEstadoItinerario getEstadoItinerario() {
        return estadoItinerario;
    }

    /**
     * Setea el atributo estadoItinerario.
     * @param estadoItinerario DDEstadoItinerario
     */
    public void setEstadoItinerario(DDEstadoItinerario estadoItinerario) {
        this.estadoItinerario = estadoItinerario;
    }

    /**
     * Retorna el atributo estadoAsunto.
     * @return estadoAsunto
     */
    public DDEstadoAsunto getEstadoAsunto() {
        return estadoAsunto;
    }

    /**
     * Setea el atributo estadoAsunto.
     * @param estado EstadoAsunto
     */
    public void setEstadoAsunto(DDEstadoAsunto estado) {
        this.estadoAsunto = estado;
    }
     

    public DDTiposAsunto getTipoAsunto() {
		return tipoAsunto;
	}

	public void setTipoAsunto(DDTiposAsunto tipoAsunto) {
		this.tipoAsunto = tipoAsunto;
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
    public void setProcessBpm(Long processBpm) {
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
     * Devuelve un listado de los procedimientos que se utilizan para contabilizar saldos de un asunto (Activos, Cerrados y Derivados)
     * @return
     */
    public List<Procedimiento> getProcedimientosContables() {
        List<Procedimiento> list = new ArrayList<Procedimiento>();

        for (Procedimiento p : procedimientos) {
            if (p.isContable()) list.add(p);
        }

        return list;
    }

    /**
     * @return the procedimientos
     */
    public List<Procedimiento> getProcedimientos() {
        return procedimientos;
    }

    /**
     * @param procedimientos the procedimientos to set
     */
    public void setProcedimientos(List<Procedimiento> procedimientos) {
        this.procedimientos = procedimientos;
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
     * Devuelve el código decodificado según el DT 1.0.
     * @return el código
     **/
    public String getCodigoDecodificado() {
        return estadoAsunto.getDescripcion();
    }

    /**
     * @return the nombre
     */
    public String getNombre() {
        return nombre;
    }

    /**
     * @param nombre the nombre to set
     */
    public void setNombre(String nombre) {
    	if (!Checks.esNulo(nombre))
    		if (nombre.length()>50)
    			nombre=nombre.substring(0,50);
    	
        this.nombre = nombre;
    }

    /**
     * Decuelve la fecha de recepción de la documentación.
     * @return the fechaRecepDoc
     */
    public Date getFechaRecepDoc() {
        return fechaRecepDoc;
    }

    /**
     * Setea la fecha de recepción de la documentación.
     * @param fechaRecepDoc the fechaRecepDoc to set
     */
    public void setFechaRecepDoc(Date fechaRecepDoc) {
        this.fechaRecepDoc = fechaRecepDoc;
    }

    /**
     * @return the expediente
     */
    public Expediente getExpediente() {
        return expediente;
    }

    /**
     * @param expediente the expediente to set
     */
    public void setExpediente(Expediente expediente) {
        this.expediente = expediente;
    }

    /**
     * Retorna los contratos relacionados con el asunto por sus procedimientos.
     * @return lista de contratos
     */
    public Set<Contrato> getContratos() {
        Set<Contrato> contratos = new TreeSet<Contrato>();
        for (Procedimiento procedimiento : procedimientos) {
            for (ExpedienteContrato ec : procedimiento.getExpedienteContratos()) {
                contratos.add(ec.getContrato());
            }
        }
        return contratos;
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
     * @return the decisionComite
     */
    public DecisionComite getDecisionComite() {
        if (decisionComite == null) {
            if (expediente != null) { return expediente.getDecisionComite(); }
        }
        return decisionComite;
    }

    /**
     * @param decisionComite the decisionComite to set
     */
    public void setDecisionComite(DecisionComite decisionComite) {
        this.decisionComite = decisionComite;
    }

    /**
     * Devuelve el saldo total del asunto.
     * Se calcula como la sumatoria del saldo original vencido más el saldo original no vencido
     * de todos los Procedimientos asociados a este Asunto.
     * @return el saldo total del Asunto
     */
    public Double getSaldoTotal() {
        double saldo = 0;
        for (Procedimiento p : getProcedimientosContables()) {
            saldo += Math.abs(p.getSaldoOriginalVencido().doubleValue());
            saldo += Math.abs(p.getSaldoOriginalNoVencido().doubleValue());
        }
        return saldo;
    }

    /**
     * Retorna la fecha de fin para la tarea del subtipo propuesto que es el unico caso (por ahora) que puede vencer.
     * @return fecha de fin
     */
    public Date getFechaVencimiento() {
        TareaNotificacion tarea = getTareaAsuntoPropuesto();
        if (tarea != null) { return getTareaAsuntoPropuesto().getFechaVenc(); }
        return null;
    }

    /**
     * Retorna la cantidad de dias de la fecha de vencimiento tarea de asunto propuesto con el día de hoy.
     * Returna null si se veció o si vence el dia de hoy.
     * @return long
     * @throws ParseException formato fecha
     */
    public Long getCantidadDiasParaVencer() throws ParseException {
        SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy");
        Date fecha = getFechaVencimiento();
        if (fecha == null) {
            //No tiene vencimiento.
            return null;
        }
        String sFechaVen = df.format(fecha);
        Date fechaVen = df.parse(sFechaVen);
        String sHoy = df.format(new Date());
        Date hoy = df.parse(sHoy);
        Long plazo = fechaVen.getTime() - hoy.getTime();
        final long milisegundosEnUnDia = 1000L * 60 * 60 * 24;
        plazo = plazo / milisegundosEnUnDia;
        if (plazo < 1) { return null; }
        return plazo;
    }

    /**
     * Retorna la tarea del subtipo SubtipoTarea.CODIGO_ASUNTO_PROPUESTO del contrato.
     * Si no existe retorna null.
     * @return TareaNotificacion
     */
    private TareaNotificacion getTareaAsuntoPropuesto() {
        for (TareaNotificacion tarea : tareas) {
            if (SubtipoTarea.CODIGO_ASUNTO_PROPUESTO.equalsIgnoreCase(tarea.getSubtipoTarea().getCodigoSubtarea())) { return tarea; }
        }
        return null;
    }

    /**
     * Agrega un adjunto al expediente, tomando los datos de un FileItem.
     *
     * @param fileItem file
     */
    public void addAdjunto(FileItem fileItem) {
        AdjuntoAsunto adjuntoAsunto = new AdjuntoAsunto(fileItem);
        adjuntoAsunto.setAsunto(this);
        Auditoria.save(adjuntoAsunto);
        getAdjuntos().add(adjuntoAsunto);
    }

    /**
     * devuelve el adjunto por Id.
     * @param id id
     * @return adjunto
     */
    public AdjuntoAsunto getAdjunto(Long id) {
        for (AdjuntoAsunto adj : getAdjuntos()) {
            if (adj.getId().equals(id)) { return adj; }
        }
        return null;
    }

    /**
     * Indica si el asunto esta confirmado.
     * @return boolean
     */
    public boolean getEstaConfirmado() {
        return DDEstadoAsunto.ESTADO_ASUNTO_CONFIRMADO.equals(getEstadoAsunto().getCodigo());
    }

    /**
     * Indica si el asunto esta Aceptado.
     * @return boolean
     */
    public boolean getEstaAceptado() {
        return DDEstadoAsunto.ESTADO_ASUNTO_ACEPTADO.equals(getEstadoAsunto().getCodigo());
    }

    /**
     * @return the supervisor
     */
    public GestorDespacho getSupervisor() {
        return supervisor;
    }

    /**
     * @param supervisor the supervisor to set
     */
    public void setSupervisor(GestorDespacho supervisor) {
        this.supervisor = supervisor;
    }

    /**
     * @return the observacion
     */
    public String getObservacion() {
        return observacion;
    }

    /**
     * @param observacion the observacion to set
     */
    public void setObservacion(String observacion) {
        this.observacion = observacion;
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
     * @return the asuntoOrigen
     */
    public Asunto getAsuntoOrigen() {
        return asuntoOrigen;
    }

    /**
     * @param asuntoOrigen the asuntoOrigen to set
     */
    public void setAsuntoOrigen(Asunto asuntoOrigen) {
        this.asuntoOrigen = asuntoOrigen;
    }

    /**
     * @return the fichaAceptacion
     */
    public FichaAceptacion getFichaAceptacion() {
        return fichaAceptacion;
    }

    /**
     * @param fichaAceptacion the fichaAceptacion to set
     */
    public void setFichaAceptacion(FichaAceptacion fichaAceptacion) {
        this.fichaAceptacion = fichaAceptacion;
    }

    /**
     * @return the supervisorComite
     */
    public Usuario getSupervisorComite() {
        return supervisorComite;
    }

    /**
     * @param supervisorComite the supervisorComite to set
     */
    public void setSupervisorComite(Usuario supervisorComite) {
        this.supervisorComite = supervisorComite;
    }

    /**
     * get adjuntos.
     * @return adjuntos
     */
    public Set<AdjuntoAsunto> getAdjuntos() {
        return adjuntos;
    }

    /**
     * Volumen de Riesgo de los procedimientos contenidos en el asunto (suma del principal del procedimiento).
     * @return Float
     */
    public Float getVolumenRiesgo() {
        if (volumenRiesgo == null) {
            volumenRiesgo = new Float(0.0f);
            for (Procedimiento p : getProcedimientosContables()) {

                volumenRiesgo += p.getSaldoRecuperacion().floatValue();
            }
        }
        return volumenRiesgo;
    }

    public GestorDespacho getProcurador() {
        return procurador;
    }

    public void setProcurador(GestorDespacho procurador) {
        this.procurador = procurador;
    }

    public List<HistoricoCambiosAsunto> getHistoricoCambios() {
        return historicoCambios;
    }

    public void setHistoricoCambios(List<HistoricoCambiosAsunto> historicoCambios) {
        this.historicoCambios = historicoCambios;
    }

    /**
     * Agrega un objeto historico al asunto
     * @param historico
     */
    public void addHistorico(HistoricoCambiosAsunto historico) {
        if (historicoCambios == null) historicoCambios = new ArrayList<HistoricoCambiosAsunto>();
        historico.setAsunto(this);
        historicoCambios.add(historico);
    }

    /**
     * Método para conocer si el Asunto ha sido reasignado a otro supervisor temporalmente por ausencia (vacaciones)
     * @return
     */
    public boolean isReasignadoPorVacaciones() {

        HistoricoCambiosAsunto hca = getLastHistoricoCambio();
        if (hca != null && hca.getTemporal()) return true;

        return false;

    }

    /**
     * Obtiene el ultimo movimiento de cambio de supervisor
     * @return
     */
    private HistoricoCambiosAsunto getLastHistoricoCambio() {

        if (historicoCambios != null && historicoCambios.size() > 0) {
            //ordeno el historico por fecha
            Comparator<HistoricoCambiosAsunto> comp = new Comparator<HistoricoCambiosAsunto>() {
                @Override
                public int compare(HistoricoCambiosAsunto o1, HistoricoCambiosAsunto o2) {
                    if (o1.getAuditoria().getFechaCrear().after(o2.getAuditoria().getFechaCrear())) return 1;
                    if (o1.getAuditoria().getFechaCrear().before(o2.getAuditoria().getFechaCrear())) return -1;
                    return 0;
                }
            };
            Collections.sort(historicoCambios, comp);

            HistoricoCambiosAsunto hca = historicoCambios.get(historicoCambios.size() - 1);
            return hca;
        }
        return null;
    }

    /**
     * Obtiene el supervisor que originó un cambio de supervisor por un periodo temporal
     * @return
     */
    public GestorDespacho getSupervisorOriginal() {
        GestorDespacho supervisor = null;
        //        if (getHistoricoCambios() != null) {
        //            for (HistoricoCambiosAsunto hca : getHistoricoCambios()) {
        //                if (hca.getTemporal()) return hca.getSupervisorOrigen();
        //            }
        //        }
        HistoricoCambiosAsunto hca = getLastHistoricoCambio();
        if (hca != null && hca.getTemporal()) supervisor = hca.getSupervisorOrigen();

        return supervisor;
    }
}
