package es.pfsgroup.plugin.recovery.comites.comite.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Date;
import java.util.ArrayList;
import java.util.Comparator;
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
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Formula;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.DDEstadoAsunto;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.comite.model.PuestosComite;
import es.capgemini.pfs.comite.model.SesionComite;
import es.capgemini.pfs.expediente.model.DDEstadoExpediente;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.capgemini.pfs.itinerario.model.Itinerario;
import es.capgemini.pfs.tareaNotificacion.model.SubtipoTarea;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.zona.model.DDZona;

@Entity
@Table(name = "COM_COMITES", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class CMTComite implements Serializable, Auditable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 82295443554938568L;
	
    public static final String NO_INICIADO = "No iniciado";
    public static final String CERRADO = "Cerrado";
    public static final String INICIADO = "Iniciado";

    @Id
    @Column(name = "COM_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ComiteGenerator")
    @SequenceGenerator(name = "ComiteGenerator", sequenceName = "S_COM_COMITES")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "ZON_ID")
    private DDZona zona;

	
	
	@Column(name = "COM_NOMBRE")
    private String nombre;

	@Column(name = "COM_ATRIBUCION_MIN")
    private BigDecimal atribucionMinima;

    @Column(name = "COM_ATRIBUCION_MAX")
    private BigDecimal atribucionMaxima;

    @Column(name = "COM_PRIORIDAD")
    private Long prioridad;

    @Column(name = "COM_N_MIEMBROS")
    private Long miembros;

    @Column(name = "COM_N_MIEMBROS_RESTRICT")
    private Long miembrosRestrict;

    @OneToMany(mappedBy = "comite", cascade = CascadeType.ALL)
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private Set<SesionComite> sesiones;

    @OneToMany(mappedBy = "comite", cascade = CascadeType.ALL)
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private Set<Expediente> expedientes;

    @OneToMany(mappedBy = "comite", cascade = CascadeType.ALL)
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private Set<PuestosComite> puestosComites;

    @ManyToMany(fetch=FetchType.EAGER)
    @JoinTable(name = "COM_ITI", joinColumns = { @JoinColumn(name = "COM_ID", unique = true) }, inverseJoinColumns = { @JoinColumn(name = "ITI_ID") })
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<Itinerario> itinerarios;

    @OneToMany(mappedBy = "comite", cascade = CascadeType.ALL)
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private Set<Asunto> asuntos;
   
    @Formula(value = " (select count(*) from exp_expedientes exp, ${master.schema}.DD_EST_ESTADOS_ITINERARIOS dd_est, ${master.schema}.DD_EEX_ESTADO_EXPEDIENTE dd_eex "
        + " where EXP.COM_ID = COM_ID "
        + " and dd_eex.DD_EEX_ID = EXP.DD_EEX_ID "
        + " and dd_eex.DD_EEX_CODIGO = "
        + DDEstadoExpediente.ESTADO_EXPEDIENTE_CONGELADO_STRING
        + " and EXP.DD_EST_ID = dd_est.dd_est_id "
        + " and DD_EST.DD_EST_CODIGO = '"
        + DDEstadoItinerario.ESTADO_DECISION_COMIT + "')")
    private Integer cantidadExpedientes;

    @Formula(value = " (SELECT   MIN (TAR.TAR_FECHA_VENC) " + " FROM   exp_expedientes EXP, "
            + " ${master.schema}.DD_EST_ESTADOS_ITINERARIOS dd_est, " + " TAR_TAREAS_NOTIFICACIONES tar, "
            + " ${master.schema}.DD_STA_SUBTIPO_TAREA_BASE dd_sta, " + " ${master.schema}.DD_EEX_ESTADO_EXPEDIENTE dd_eex "
            + " WHERE       EXP.COM_ID = COM_ID " + " and dd_eex.DD_EEX_ID = EXP.DD_EEX_ID " + " and dd_eex.DD_EEX_CODIGO = "
            + DDEstadoExpediente.ESTADO_EXPEDIENTE_CONGELADO_STRING + " AND EXP.DD_EST_ID = dd_est.dd_est_id " + " and DD_EST.DD_EST_CODIGO = '"
            + DDEstadoItinerario.ESTADO_DECISION_COMIT + "'" + " AND tar.exp_id = EXP.exp_id " + " AND TAR.DD_EST_ID = dd_est.dd_est_id "
            + " AND tar.borrado = 0 " + " AND TAR.DD_STA_ID = DD_STA.DD_STA_ID " + " AND DD_STA.DD_STA_CODIGO = '"
            + SubtipoTarea.CODIGO_DECISION_COMITE + "' )")
    private Date fechaVencimiento;

    @Version
    private Integer version;

    @Embedded
    private Auditoria auditoria;


   
    
    /**
     * @return the id
     */
    public Long getId() {
        return id;
    }

    /**
     * @param id the id to set
     */
    public void setId(Long id) {
        this.id = id;
    }

    /**
     * @return the zona
     */
    public DDZona getZona() {
        return zona;
    }

    /**
     * @param zona the zona to set
     */
    public void setZona(DDZona zona) {
        this.zona = zona;
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
        this.nombre = nombre;
    }

    /**
     * @return the atribucionMinima
     */
    public BigDecimal getAtribucionMinima() {
        return atribucionMinima;
    }

    /**
     * @param atribucionMinima the atribucionMinima to set
     */
    public void setAtribucionMinima(BigDecimal atribucionMinima) {
        this.atribucionMinima = atribucionMinima;
    }

    /**
     * @return the atribucionMaxima
     */
    public BigDecimal getAtribucionMaxima() {
        return atribucionMaxima;
    }

    /**
     * @param atribucionMaxima the atribucionMaxima to set
     */
    public void setAtribucionMaxima(BigDecimal atribucionMaxima) {
        this.atribucionMaxima = atribucionMaxima;
    }

    /**
     * @return the prioridad
     */
    public Long getPrioridad() {
        return prioridad;
    }

    /**
     * @param prioridad the prioridad to set
     */
    public void setPrioridad(Long prioridad) {
        this.prioridad = prioridad;
    }

    /**
     * @return the version
     */
    public Integer getVersion() {
        return version;
    }

    /**
     * @param version the version to set
     */
    public void setVersion(Integer version) {
        this.version = version;
    }

    /**
     * @return the auditoria
     */
    @Override
	public Auditoria getAuditoria() {
		return auditoria;
	}
    

    /**
     * @param auditoria the auditoria to set
     */
    public void setAuditoria(Auditoria auditoria) {
        this.auditoria = auditoria;
    }

    /**
     * Retorna el estado del comit�.
     * Se busca la sesion del comit�:
     * <br> 1) Si no existe sesi�n entonces el estado es NO_INICIADO,
     * <br> 2) Si la tiene fecha de inicio y la fecha de fin es NULL entonces el estado es INICIADO y
     * <br> 3) Si la �ltima sesi�n esta cerrada entonces el estado es CERRADO
     * @return estado
     */
    public String getEstado() {
        return calcularEstado(getUltimaSesion());
    }

    /*
     * El m�todo el publico para que lo uso DtoSesionComite.
     */
    /**
     * Calcula el estado segun la sesi�n.
     * <br> 1) Si no existe sesi�n entonces el estado es NO_INICIADO,
     * <br> 2) Si la tiene fecha de inicio y la fecha de fin es NULL entonces el estado es INICIADO y
     * <br> 3) Si la �ltima sesi�n esta cerrada entonces el estado es CERRADO
     * @return estado
     * @param sesion sesionComite
     * @return
     */
    public static String calcularEstado(SesionComite sesion) {
        if (sesion == null) { return NO_INICIADO; }
        if (sesion.getFechaInicio() != null && sesion.getFechaFin() == null) { return INICIADO; }
        return CERRADO;
    }

    /**
     * Retorna la ultima sesion iniciada.
     * Solo deber�a existir una sesi�n abierta.
     * De no existir returna null.
     * @return SesionComite
     */
    public SesionComite getUltimaSesion() {
        if (sesiones.isEmpty()) { return null; }
        TreeSet<SesionComite> sesionesOrdenadas = new TreeSet<SesionComite>(new Comparator<SesionComite>() {

            /**
             * Ordena primero las sesiones iniciadas
             * @param s1 sesion
             * @param s2 sesion
             * @return int
             */
            @Override
            public int compare(SesionComite s1, SesionComite s2) {
                int compare = s2.getFechaInicio().compareTo(s1.getFechaInicio());
                if (0 == compare) {
                    if (s1.getFechaFin() == null) { return -1; }
                    if (s2.getFechaFin() == null) { return 1; }
                }
                return compare;
            }
        });
        sesionesOrdenadas.addAll(sesiones);
        return sesionesOrdenadas.first();
        // El primero debe ser la ultima sesion iniciada
    }

    /**
     * @return the sesiones
     */
    public Set<SesionComite> getSesiones() {
        return sesiones;
    }

    /**
     * @param sesiones the sesiones to set
     */
    public void setSesiones(Set<SesionComite> sesiones) {
        this.sesiones = sesiones;
    }

    /**
     * @return the expedientes
     */
    public Set<Expediente> getExpedientes() {
        return expedientes;
    }

    /**
     * @param expedientes the expedientes to set
     */
    public void setExpedientes(Set<Expediente> expedientes) {
        this.expedientes = expedientes;
    }

    /**
     * @return the puestosComites
     */
    public Set<PuestosComite> getPuestosComites() {
        return puestosComites;
    }

    /**
     * @param puestosComites the puestosComites to set
     */
    public void setPuestosComites(Set<PuestosComite> puestosComites) {
        this.puestosComites = puestosComites;
    }

    /**
     * @return the itinerarios
     */
    public List<Itinerario> getItinerarios() {
        return itinerarios;
    }

    /**
     * @param itinerarios the itinerarios to set
     */
    public void setItinerarios(List<Itinerario> itinerarios) {
        this.itinerarios = itinerarios;
    }

    /**
     * Agrega un sesion.
     * @param sesion SesionComite
     */
    public void addSesion(SesionComite sesion) {
        this.sesiones.add(sesion);
    }

    /**
     * Retorna la cantidad de expedientes que tiene el comite.
     * @return int
     */
    public int getCantidadExpedientes() {
        //return getExpedientesSinDecision().size();
        return cantidadExpedientes;
    }

    /**
     * Retorna los expedientes que estan para decidir y no estan en el estado DECIDIDO.
     * @return lista de expedientes
     */
    public List<Expediente> getExpedientesSinDecision() {
        List<Expediente> expedientesSinDecision = new ArrayList<Expediente>();
        for (Expediente expediente : getExpedientes()) {
            if (expediente.getEstadoItinerario().getCodigo().equals(DDEstadoItinerario.ESTADO_DECISION_COMIT)
                    && DDEstadoExpediente.ESTADO_EXPEDIENTE_CONGELADO.equals(expediente.getEstadoExpediente().getCodigo())) {
                expedientesSinDecision.add(expediente);
            }
        }
        return expedientesSinDecision;
    }

    /**
     * Retorna la fecha de vencimiento del comit�.
     * La misma es la fecha mas proxima de sus expedientes sin decisi�n.
     * @return date
     */
    public Date getFechaVencimiento() {
        TreeSet<Date> fechas = new TreeSet<Date>();
        if (fechaVencimiento != null) {
            fechas.add(fechaVencimiento);
        }
        for (Asunto asu : getPreasuntos()) {
            if (asu.getFechaVencimiento() != null) {
                fechas.add((Date) asu.getFechaVencimiento());
            }
        }

        if (fechas.isEmpty()) { return null; }
        return fechas.first();
    }

    /**
     * Retorna los perfiles que le corresponde al comit� por su zona y sus puestos.
     * @return lista de perfiles
     */
    public List<Perfil> getPerfiles() {
        List<Perfil> perfiles = new ArrayList<Perfil>();
        for (PuestosComite puesto : puestosComites) {
            if (puesto.getZona().getCodigo().equals(zona.getCodigo())) {
                perfiles.add(puesto.getPerfil());
            }
        }
        return perfiles;
    }

    

    /**
     * Retorna los pre-asuntos del comite.
     * @return List
     */
    public List<Asunto> getPreasuntos() {
        List<Asunto> preasuntos = new ArrayList<Asunto>();
        for (Asunto asunto : asuntos) {
            if (DDEstadoAsunto.ESTADO_ASUNTO_PROPUESTO.equals(asunto.getEstadoAsunto().getCodigo())) {
                preasuntos.add(asunto);
            }
        }
        return preasuntos;
    }

    /**
     * @return the asuntos
     */
    public Set<Asunto> getAsuntos() {
        return asuntos;
    }

    /**
     * @param asuntos the asuntos to set
     */
    public void setAsuntos(Set<Asunto> asuntos) {
        this.asuntos = asuntos;
    }

    /**
     * @param miembros the miembros to set
     */
    public void setMiembros(Long miembros) {
        this.miembros = miembros;
    }

    /**
     * @return the miembros
     */
    public Long getMiembros() {
        return miembros;
    }

    /**
     * @param miembrosRestrict the miembrosRestrict to set
     */
    public void setMiembrosRestrict(Long miembrosRestrict) {
        this.miembrosRestrict = miembrosRestrict;
    }

    /**
     * @return the miembrosRestrict
     */
    public Long getMiembrosRestrict() {
        return miembrosRestrict;
    }

    /**
     * Devuelve el c�digo del comite (id) para poder usarlo como un diccionario.
     * @return String
     */
    public String getCodigo() {
        return getId().toString();
    }

    /**
     * Devuelve la descripci�n del comite (nombre) para poder usarlo como un diccionario.
     * @return String
     */
    public String getDescripcion() {
        return getNombre();
    }

    /**
     * Devuelve la descripci�n del comite (nombre) para poder usarlo como un diccionario.
     * @return String
     */
    public String getDescripcionLarga() {
        return getDescripcion();
    }

    /**
     * @return <code>true</code> si tiene itinerarios de seguimiento
     */
    public boolean isComiteSeguimiento() {
        for (Itinerario iti : itinerarios) {
            if (iti.getdDtipoItinerario().getItinerarioSeguimiento()) { return true; }
        }
        return false;
    }

    /**
     * @return <code>true</code> si tiene itinerarios de recuperaci�n
     */
    public boolean isComiteRecuperacion() {
        for (Itinerario iti : itinerarios) {
            if (iti.getdDtipoItinerario().getItinerarioRecuperacion()) { return true; }
        }
        return false;
    }

    /**
     * @return <code>true</code> si tiene itinerarios de seguimiento y recuperaci�n
     */
    public boolean isComiteMixto() {
        boolean rec = false, seg = false;
        for (Itinerario iti : itinerarios) {
            if (iti.getdDtipoItinerario().getItinerarioSeguimiento()) {
                seg = true;
            } else if (iti.getdDtipoItinerario().getItinerarioRecuperacion()) {
                rec = true;
            }
            if (rec && seg) { return true; }
        }
        return false;
    }
	

}
