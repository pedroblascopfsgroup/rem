package es.capgemini.pfs.asunto.dto;

import java.util.Set;

import es.capgemini.devon.pagination.PaginationParamsImpl;

/**
 * Clase para enviar los filtros de la Búsqueda de asuntos al servidor.
 * @author pamuller
 *
 */
public class DtoBusquedaAsunto extends PaginationParamsImpl {

    private static final long serialVersionUID = -5162347915032431558L;

    private Long codigoAsunto;
    private Long idComite;
    private Long idSesionComite;
    private String nombre;
    private String comboDespachos;
    private String comboGestor;
    private String comboEstados;
    private String comboSupervisor;
    private String estadoAnalisis;
    private Float minSaldoTotalContratos;
    private Float maxSaldoTotalContratos;
    private Double minImporteEstimado;
    private Double maxImporteEstimado;
    private String filtroContrato;
    private String fechaCreacionDesde;
    private String fechaCreacionHasta;
    private String jerarquia;
    private String codigoZona;
    private String estadoItinerario;
    private Set<String> codigoZonas;
    private String tipoSalida;
    private String tipoProcedimiento;
    private Set<String> tiposProcedimiento;
    private String codigoProcedimientoEnJuzgado;

    public static final String SALIDA_XLS = "xls";
    public static final String SALIDA_LISTADO = "listado";

    
    

	/**
     * @return the jerarquia
     */
    public String getJerarquia() {
        return jerarquia;
    }

    /**
     * @param jerarquia the jerarquia to set
     */
    public void setJerarquia(String jerarquia) {
        this.jerarquia = jerarquia;
    }

    /**
     * @return the codigoZona
     */
    public String getCodigoZona() {
        return codigoZona;
    }

    /**
     * @param codigoZona the codigoZona to set
     */
    public void setCodigoZona(String codigoZona) {
        this.codigoZona = codigoZona;
    }

    /**
     * @return the codigoAsunto
     */
    public Long getCodigoAsunto() {
        return codigoAsunto;
    }

    /**
     * @param codigoAsunto the codigoAsunto to set
     */
    public void setCodigoAsunto(Long codigoAsunto) {
        this.codigoAsunto = codigoAsunto;
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
     * @return the comboDespachos
     */
    public String getComboDespachos() {
        return comboDespachos;
    }

    /**
     * @param comboDespachos the comboDespachos to set
     */
    public void setComboDespachos(String comboDespachos) {
        this.comboDespachos = comboDespachos;
    }

    /**
     * @return the comboGestor
     */
    public String getComboGestor() {
        return comboGestor;
    }

    /**
     * @param comboGestor the comboGestor to set
     */
    public void setComboGestor(String comboGestor) {
        this.comboGestor = comboGestor;
    }

    /**
     * @return the comboEstados
     */
    public String getComboEstados() {
        return comboEstados;
    }

    /**
     * @param comboEstados the comboEstados to set
     */
    public void setComboEstados(String comboEstados) {
        this.comboEstados = comboEstados;
    }

    /**
     * @return the comboSupervisor
     */
    public String getComboSupervisor() {
        return comboSupervisor;
    }

    /**
     * @param comboSupervisor the comboSupervisor to set
     */
    public void setComboSupervisor(String comboSupervisor) {
        this.comboSupervisor = comboSupervisor;
    }

    /**
     * @return the estadoAnalisis
     */
    public String getEstadoAnalisis() {
        return estadoAnalisis;
    }

    /**
     * @param estadoAnalisis the estadoAnalisis to set
     */
    public void setEstadoAnalisis(String estadoAnalisis) {
        this.estadoAnalisis = estadoAnalisis;
    }

    /**
     * @return the minSaldoTotalContratos
     */
    public Float getMinSaldoTotalContratos() {
        return minSaldoTotalContratos;
    }

    /**
     * @param minSaldoTotalContratos the minSaldoTotalContratos to set
     */
    public void setMinSaldoTotalContratos(Float minSaldoTotalContratos) {
        this.minSaldoTotalContratos = minSaldoTotalContratos;
    }

    /**
     * @return the maxSaldoTotalContratos
     */
    public Float getMaxSaldoTotalContratos() {
        return maxSaldoTotalContratos;
    }

    /**
     * @param maxSaldoTotalContratos the maxSaldoTotalContratos to set
     */
    public void setMaxSaldoTotalContratos(Float maxSaldoTotalContratos) {
        this.maxSaldoTotalContratos = maxSaldoTotalContratos;
    }

    /**
     * @return the minImporteEstimado
     */
    public Double getMinImporteEstimado() {
        return minImporteEstimado;
    }

    /**
     * @param minImporteEstimado the minImporteEstimado to set
     */
    public void setMinImporteEstimado(Double minImporteEstimado) {
        this.minImporteEstimado = minImporteEstimado;
    }

    /**
     * @return the maxImporteEstimado
     */
    public Double getMaxImporteEstimado() {
        return maxImporteEstimado;
    }

    /**
     * @param maxImporteEstimado the maxImporteEstimado to set
     */
    public void setMaxImporteEstimado(Double maxImporteEstimado) {
        this.maxImporteEstimado = maxImporteEstimado;
    }

    /**
     * @return the filtroContrato
     */
    public String getFiltroContrato() {
        return filtroContrato;
    }

    /**
     * @param filtroContrato the filtroContrato to set
     */
    public void setFiltroContrato(String filtroContrato) {
        this.filtroContrato = filtroContrato;
    }

    /**
     * @return the fechaCreacionDesde
     */
    public String getFechaCreacionDesde() {
        return fechaCreacionDesde;
    }

    /**
     * @param fechaCreacionDesde the fechaCreacionDesde to set
     */
    public void setFechaCreacionDesde(String fechaCreacionDesde) {
        this.fechaCreacionDesde = fechaCreacionDesde;
    }

    /**
     * @return the fechaCreacionHasta
     */
    public String getFechaCreacionHasta() {
        return fechaCreacionHasta;
    }

    /**
     * @param fechaCreacionHasta the fechaCreacionHasta to set
     */
    public void setFechaCreacionHasta(String fechaCreacionHasta) {
        this.fechaCreacionHasta = fechaCreacionHasta;
    }

    /**
     * @return the codigoZonas
     */
    public Set<String> getCodigoZonas() {
        return codigoZonas;
    }

    /**
     * @param codigoZonas the codigoZonas to set
     */
    public void setCodigoZonas(Set<String> codigoZonas) {
        this.codigoZonas = codigoZonas;
    }

    /**
     * @param estadoItinerario the estadoItinerario to set
     */
    public void setEstadoItinerario(String estadoItinerario) {
        this.estadoItinerario = estadoItinerario;
    }

    /**
     * @return the estadoItinerario
     */
    public String getEstadoItinerario() {
        return estadoItinerario;
    }

    /**
     * @return the idComite
     */
    public Long getIdComite() {
        return idComite;
    }

    /**
     * @param idComite the idComite to set
     */
    public void setIdComite(Long idComite) {
        this.idComite = idComite;
    }

    /**
     * @return the idSesionComite
     */
    public Long getIdSesionComite() {
        return idSesionComite;
    }

    /**
     * @param idSesionComite the idSesionComite to set
     */
    public void setIdSesionComite(Long idSesionComite) {
        this.idSesionComite = idSesionComite;
    }

    /**
     * @return the tipoSalida
     */
    public String getTipoSalida() {
        return tipoSalida;
    }

    /**
     * @param tipoSalida the tipoSalida to set
     */
    public void setTipoSalida(String tipoSalida) {
        this.tipoSalida = tipoSalida;
    }

    public Set<String> getTiposProcedimiento() {
        return tiposProcedimiento;
    }

    public void setTiposProcedimiento(Set<String> tiposProcedimiento) {
        this.tiposProcedimiento = tiposProcedimiento;
    }

    public String getCodigoProcedimientoEnJuzgado() {
        return codigoProcedimientoEnJuzgado;
    }

    public void setCodigoProcedimientoEnJuzgado(String codigoProcedimientoEnJuzgado) {
        this.codigoProcedimientoEnJuzgado = codigoProcedimientoEnJuzgado;
    }

    public String getTipoProcedimiento() {
        return tipoProcedimiento;
    }

    public void setTipoProcedimiento(String tipoProcedimiento) {
        this.tipoProcedimiento = tipoProcedimiento;
    }
}
