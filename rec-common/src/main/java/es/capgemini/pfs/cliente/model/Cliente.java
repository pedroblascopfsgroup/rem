package es.capgemini.pfs.cliente.model;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

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
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.APPConstants;
import es.capgemini.pfs.arquetipo.model.Arquetipo;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.capgemini.pfs.itinerario.model.Estado;
import es.capgemini.pfs.itinerario.model.EstadoProceso;
import es.capgemini.pfs.oficina.model.Oficina;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.telecobro.model.ProveedorTelecobro;
import es.pfsgroup.commons.utils.Checks;

/**
 * Entidad que represanta un cliente de la tabla CLI_CLIENTES.
 * <br>
 * @author Lisandro Medrano
 *
 */
@Entity
@Table(name = "CLI_CLIENTES", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class Cliente implements Serializable, Auditable {

    private static final long serialVersionUID = 4517386421101200733L;
    public static final String CLIENTE_ID_KEY = "clienteId";

    @Id
    @Column(name = "CLI_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ClienteGenerator")
    @SequenceGenerator(name = "ClienteGenerator", sequenceName = "S_CLI_CLIENTES")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "PER_ID")
    private Persona persona;

    @OneToOne
    @JoinColumn(name = "ARQ_ID")
    private Arquetipo arquetipo;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_EST_ID")
    private DDEstadoItinerario estadoItinerario;

    @Column(name = "CLI_FECHA_EST_ID")
    private Date fechaEstado;

    @Column(name = "CLI_FECHA_CREACION")
    private Date fechaCreacion;

    @Column(name = "CLI_PROCESS_BPM")
    private Long processBPM;

    @OneToOne(targetEntity = EstadoCliente.class, fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_ECL_ID")
    private EstadoCliente estadoCliente;

    @Column(name = "CLI_TELECOBRO")
    private boolean telecobro;

    @OneToMany(mappedBy = "cliente", fetch = FetchType.LAZY)
    private List<EstadoProceso> estadoProceso;

    @Column(name = "CLI_FECHA_GV")
    private Date fechaGestionVencidos;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "PTE_ID")
    private ProveedorTelecobro proveedorTelecobro;

    @Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;

    @OneToMany(mappedBy = "cliente", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private List<ClienteContrato> contratos;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "OFI_ID")
    private Oficina oficina;

    /**
     * @return the id
     */
    public Long getId() {
        return id;
    }

    /**
     * @param id
     *            the id to set
     */
    public void setId(Long id) {
        this.id = id;
    }

    /**
     * @return the persona
     */
    public Persona getPersona() {
        return persona;
    }

    /**
     * @param persona
     *            the persona to set
     */
    public void setPersona(Persona persona) {
        this.persona = persona;
    }

    /**
     * @return the arquetipo
     */
    public Arquetipo getArquetipo() {
        return arquetipo;
    }

    /**
     * @param arquetipo
     *            the arquetipo to set
     */
    public void setArquetipo(Arquetipo arquetipo) {
        this.arquetipo = arquetipo;
    }

    /**
     * @return the estadoItinerario
     */
    public DDEstadoItinerario getEstadoItinerario() {
        return estadoItinerario;
    }

    /**
     * @param estadoItinerario
     *            the estadoItinerario to set
     */
    public void setEstadoItinerario(DDEstadoItinerario estadoItinerario) {
        this.estadoItinerario = estadoItinerario;
    }

    /**
     * @return the processBPM
     */
    public Long getProcessBPM() {
        return processBPM;
    }

    /**
     * @param processBPM
     *            the processBPM to set
     */
    public void setProcessBPM(Long processBPM) {
        this.processBPM = processBPM;
    }

    /**
     * @return the auditoria
     */
    public Auditoria getAuditoria() {
        return auditoria;
    }

    /**
     * @param auditoria
     *            the auditoria to set
     */
    public void setAuditoria(Auditoria auditoria) {
        this.auditoria = auditoria;
    }

    /**
     * Retorna una nueva instancia de Cliente.
     * @return Cliente
     */
    public static Cliente getNewInstance() {
        return new Cliente();
    }

    /**
     * @return the version
     */
    public Integer getVersion() {
        return version;
    }

    /**
     * @param version
     *            the version to set
     */
    public void setVersion(Integer version) {
        this.version = version;
    }

    /**
     * @param contratos
     *            the contratos to set
     */
    public void setContratos(List<ClienteContrato> contratos) {
        this.contratos = contratos;
    }

    /**
     * @return the contratos
     */
    public List<ClienteContrato> getContratos() {
        return contratos;
    }

    /**
     * @return Integer: Número de contratos del cliente
     */
    public Integer getNumContratos() {
        return contratos.size();
    }

    /**
     * @return Float: suma de la posición viva de todos los contratos vencidos
     */
    public Float getTotalDeudaIrregularContratos() {
        float deuda = 0;
        for (ClienteContrato clienteContrato : contratos) {
            Contrato contrato = clienteContrato.getContrato();
            if (contrato.isVencido()) {
                deuda += contrato.getLastMovimiento().getPosVivaNoVencida();
            }
        }
        return deuda;
    }

    /**
     * @return Float: suma de la posición vencida de todos los contratos vencidos
     */
    public Float getTotalPosicionAntiguaContratos() {
        float deuda = 0;
        for (ClienteContrato clienteContrato : contratos) {
            Contrato contrato = clienteContrato.getContrato();
            if (contrato.isVencido()) {
                deuda += contrato.getLastMovimiento().getPosVivaVencida();
            }
        }
        return deuda;
    }

    /**
     * Retora el contrato que generó el cliente.
     * @return contrato
     */
    public Contrato getContratoPrincipal() {
        for (ClienteContrato clienteContrato : contratos) {
            if (clienteContrato.getPase() == 1) { return clienteContrato.getContrato(); }
        }
        return null;
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
     * Obtiene el id del gestor Actual.
     * @return id del gestor actual
     */
    public Long getIdGestorActual() {
        Long idEstado = null;
        Estado estadoActual = arquetipo.getItinerario().getEstado(this.getEstadoItinerario().getCodigo());
        if (estadoActual!=null && estadoActual.getGestorPerfil() != null) {
            idEstado = estadoActual.getGestorPerfil().getId();
        }
        return idEstado;
    }

    /**
     * Obtiene el id del supervisor Actual.
     * @return id del supervisor actual
     */
    public Long getIdSupervisorActual() {
        Long idEstado = null;
        Estado estadoActual = arquetipo.getItinerario().getEstado(this.getEstadoItinerario().getCodigo());
        if (estadoActual!=null && estadoActual.getSupervisor() != null) {
            idEstado = estadoActual.getSupervisor().getId();
        }
        return idEstado;
    }

    /**
     * @return the estadoProceso
     */
    public List<EstadoProceso> getEstadoProceso() {
        return estadoProceso;
    }

    /**
     * @param estadoProceso the estadoProceso to set
     */
    public void setEstadoProceso(List<EstadoProceso> estadoProceso) {
        this.estadoProceso = estadoProceso;
    }

    /**
     * @return the telecobro
     */
    public boolean isTelecobro() {
        return telecobro;
    }

    /**
     * @param telecobro the telecobro to set
     */
    public void setTelecobro(boolean telecobro) {
        this.telecobro = telecobro;
    }

    /**
     * @return the proveedor
     */
    public ProveedorTelecobro getProveedorTelecobro() {
        return proveedorTelecobro;
    }

    /**
     * @param proveedor the proveedor to set
     */
    public void setProveedorTelecobro(ProveedorTelecobro proveedor) {
        this.proveedorTelecobro = proveedor;
    }

    /**
     * @return the estadoCliente
     */
    public EstadoCliente getEstadoCliente() {
        return estadoCliente;
    }

    /**
     * @param estado the estadoCliente to set
     */
    public void setEstadoCliente(EstadoCliente estado) {
        this.estadoCliente = estado;
    }

    /**
     * Retorna el estado actual del cliente.
     * @return Estado
     */
    public Long getPlazoParaPase() {
        Long plazo = 0L;
        if (DDEstadoItinerario.ESTADO_GESTION_VENCIDOS.equals(estadoItinerario.getCodigo())) {
        	if (Checks.esNulo(Checks.esNulo(arquetipo.getItinerario().getEstado(DDEstadoItinerario.ESTADO_GESTION_VENCIDOS_CARENCIA)))
        		|| Checks.esNulo(arquetipo.getItinerario().getEstado(DDEstadoItinerario.ESTADO_GESTION_VENCIDOS)))
        		return 0L;
        		
            Long plazoCAR = arquetipo.getItinerario().getEstado(DDEstadoItinerario.ESTADO_GESTION_VENCIDOS_CARENCIA).getPlazo();
            Long plazoGV = arquetipo.getItinerario().getEstado(DDEstadoItinerario.ESTADO_GESTION_VENCIDOS).getPlazo();
            plazo = plazoCAR + plazoGV;
            
        } else if (DDEstadoItinerario.ESTADO_GESTION_VENCIDOS_CARENCIA.equals(estadoItinerario.getCodigo())) {
        	if (Checks.esNulo(arquetipo.getItinerario().getEstado(DDEstadoItinerario.ESTADO_GESTION_VENCIDOS_CARENCIA)))
        		return 0L;
        	
            plazo = arquetipo.getItinerario().getEstado(DDEstadoItinerario.ESTADO_GESTION_VENCIDOS_CARENCIA).getPlazo();
        }
        return plazo;
    }

    /**
     * Retorna la cantidad de dias para que el cliente cambie de estado.
     * @return int
     */
    public int getDiasParaCambioEstado() {
        return Double.valueOf(Math.floor(getTiempoParaCambioEstado() / APPConstants.MILISEGUNDOS_DIA)).intValue();
    }

    /**
     * Retorna la cantidad de dias para que el cliente cambie de estado.
     * @return int
     */
    public Long getTiempoParaCambioEstado() {

        Long plazo = getPlazoParaPase();
        //OJO!!! ya no se utiliza la fecha de auditoria sino la fecha de crear cliente
        //Long fechaCliente = auditoria.getFechaCrear().getTime();
        Long fechaCliente = fechaCreacion.getTime();

        Long fechaCaducidad = fechaCliente + plazo;
        Long fechaActual = System.currentTimeMillis();

        return fechaCaducidad - fechaActual;
    }

    /**
     * @return the fechaCreacion
     */
    public Date getFechaCreacion() {
        return fechaCreacion;
    }

    /**
     * @param fechaCreacion the fechaCreacion to set
     */
    public void setFechaCreacion(Date fechaCreacion) {
        this.fechaCreacion = fechaCreacion;
    }

    /**
     * Retorna el estado actual del cliente.
     * @return Estado
     */
    public Estado getEstadoActual() {
        return arquetipo.getItinerario().getEstado(estadoItinerario.getCodigo());
    }

    /**
     * @return the codigoOficinaContratoPrincipal
     */
    public Oficina getOficina() {
        return oficina;
    }

    /**
     * @param codigoOficinaContratoPrincipal the codigoOficinaContratoPrincipal to set
     */
    public void setOficina(Oficina oficina) {
        this.oficina = oficina;
    }

    /**
     * @return the fechaGestionVencidos
     */
    public Date getFechaGestionVencidos() {
        return fechaGestionVencidos;
    }

    /**
     * @param fechaGestionVencidos the fechaGestionVencidos to set
     */
    public void setFechaGestionVencidos(Date fechaGestionVencidos) {
        this.fechaGestionVencidos = fechaGestionVencidos;
    }

    /**
     * Indica si este cliente está bajo el umbral para crear el expediente.
     * @return un boolean
     */
    public boolean getBajoUmbral() {
        Date fechaUmbral = persona.getFechaUmbral();
        Float umbral = persona.getImporteUmbral();
        return ((fechaUmbral != null) && (fechaUmbral.getTime() > System.currentTimeMillis()) && (umbral > persona.getRiesgoDirecto()));
    }

    /**
     * @return String: Descripción del itinerario del expediente
     */
    public String getTipoItinerario() {
        return arquetipo.getItinerario().getdDtipoItinerario().getDescripcion();
    }

}
