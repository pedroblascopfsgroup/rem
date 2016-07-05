package es.pfsgroup.plugin.recovery.coreextension.subasta.dto;

import java.util.StringTokenizer;

import es.capgemini.devon.dto.WebDto;

/**
 * Clase que transfiere informaciï¿½n desde la vista hacia el modelo.
 *
 */
public class NMBDtoBuscarSubastas extends WebDto {

    private static final long serialVersionUID = 6015680735564006220L;

    private Long id;
       
    //Pestaï¿½a Subasta
    private String numAutos;
	private String fechaSolicitudDesde;	
	private String fechaSolicitudHasta;	
	private String fechaAnuncioDesde;	
	private String fechaAnuncioHasta;	
	private String fechaSenyalamientoDesde;	
	private String fechaSenyalamientoHasta;		
	private String totalCargasAnterioresDesde;
	private String totalCargasAnterioresHasta;		
	private String totalImporteAdjudicadoDesde;
	private String totalImporteAdjudicadoHasta;		
	private String idComboTasacionCompletada;				
	private String idComboEmbargo;
	private String embargo;	
	private String idComboInfLetradoCompleto;		
	private String idComboInstruccionesCompletadas;		
	private String idComboSubastaRevisada;			
	private String comboFiltroEstadoDeGestion;	
	private String comboFiltroTareasSubastaBankia;
	private String comboFiltroTareasSubastaSareb;	
	private String idComboEntidad;
	private String tramitacion;
	
	//Pestaï¿½a Contrato
	private String nroContrato;	
	private String stringEstadosContrato;	
	private String tiposProductoEntidad;	
    private String codRecibo;    
    private String codEfecto;    
    private String codDisposicion;
    
    //Pestaï¿½a Jerarquï¿½a
    private String codigoZona;    
    private String jerarquia;    
    private String codigoZonaAdm;    
    private String jerarquiaAdm;
    
    //Pestaï¿½a Cliente
    private String tipoPersona;
    private String nombre;
    private String apellidos;
    private String nif;
    private String codigoCliente;
    
    //Pestaña asunto
    private String gestion;
    private String propiedad;
	
	public String getNumAutos() {
		return numAutos;
	}

	public void setNumAutos(String numAutos) {
		this.numAutos = numAutos;
	}

	public String getFechaAnuncioDesde() {
		return fechaAnuncioDesde;
	}

	public void setFechaAnuncioDesde(String fechaAnuncioDesde) {
		this.fechaAnuncioDesde = formatearFecha(fechaAnuncioDesde);
	}

	public String getFechaAnuncioHasta() {
		return fechaAnuncioHasta;
	}

	public void setFechaAnuncioHasta(String fechaAnuncioHasta) {
		this.fechaAnuncioHasta = formatearFecha(fechaAnuncioHasta);
	}

	public String getFechaSenyalamientoDesde() {
		return fechaSenyalamientoDesde;
	}

	public void setFechaSenyalamientoDesde(String fechaSenyalamientoDesde) {
		this.fechaSenyalamientoDesde = formatearFecha(fechaSenyalamientoDesde);
	}

	public String getFechaSenyalamientoHasta() {
		return fechaSenyalamientoHasta;
	}

	public void setFechaSenyalamientoHasta(String fechaSenyalamientoHasta) {
		this.fechaSenyalamientoHasta = formatearFecha(fechaSenyalamientoHasta);
	}

	public String getTotalCargasAnterioresDesde() {
		return totalCargasAnterioresDesde;
	}

	public void setTotalCargasAnterioresDesde(String totalCargasAnterioresDesde) {
		this.totalCargasAnterioresDesde = totalCargasAnterioresDesde;
	}

	public String getTotalCargasAnterioresHasta() {
		return totalCargasAnterioresHasta;
	}

	public void setTotalCargasAnterioresHasta(String totalCargasAnterioresHasta) {
		this.totalCargasAnterioresHasta = totalCargasAnterioresHasta;
	}

	public String getTotalImporteAdjudicadoDesde() {
		return totalImporteAdjudicadoDesde;
	}

	public void setTotalImporteAdjudicadoDesde(String totalImporteAdjudicadoDesde) {
		this.totalImporteAdjudicadoDesde = totalImporteAdjudicadoDesde;
	}

	public String getTotalImporteAdjudicadoHasta() {
		return totalImporteAdjudicadoHasta;
	}

	public void setTotalImporteAdjudicadoHasta(String totalImporteAdjudicadoHasta) {
		this.totalImporteAdjudicadoHasta = totalImporteAdjudicadoHasta;
	}

	public String getIdComboTasacionCompletada() {
		return idComboTasacionCompletada;
	}

	public void setIdComboTasacionCompletada(String idComboTasacionCompletada) {
		this.idComboTasacionCompletada = idComboTasacionCompletada;
	}

	public String getIdComboEmbargo() {
		return idComboEmbargo;
	}

	public void setIdComboEmbargo(String idComboEmbargo) {
		this.idComboEmbargo = idComboEmbargo;
	}

	public String getIdComboInfLetradoCompleto() {
		return idComboInfLetradoCompleto;
	}

	public void setIdComboInfLetradoCompleto(String idComboInfLetradoCompleto) {
		this.idComboInfLetradoCompleto = idComboInfLetradoCompleto;
	}

	public String getIdComboInstruccionesCompletadas() {
		return idComboInstruccionesCompletadas;
	}

	public void setIdComboInstruccionesCompletadas(String idComboInstruccionesCompletadas) {
		this.idComboInstruccionesCompletadas = idComboInstruccionesCompletadas;
	}

	public String getIdComboSubastaRevisada() {
		return idComboSubastaRevisada;
	}

	public void setIdComboSubastaRevisada(String idComboSubastaRevisada) {
		this.idComboSubastaRevisada = idComboSubastaRevisada;
	}

	public String getComboFiltroEstadoDeGestion() {
		return comboFiltroEstadoDeGestion;
	}

	public void setComboFiltroEstadoDeGestion(String comboFiltroEstadoDeGestion) {
		this.comboFiltroEstadoDeGestion = comboFiltroEstadoDeGestion;
	}

	public String getComboFiltroTareasSubastaBankia() {
		return comboFiltroTareasSubastaBankia;
	}

	public void setComboFiltroTareasSubastaBankia(String comboFiltroTareasSubastaBankia) {
		this.comboFiltroTareasSubastaBankia = comboFiltroTareasSubastaBankia;
	}

	public String getComboFiltroTareasSubastaSareb() {
		return comboFiltroTareasSubastaSareb;
	}

	public void setComboFiltroTareasSubastaSareb(String comboFiltroTareasSubastaSareb) {
		this.comboFiltroTareasSubastaSareb = comboFiltroTareasSubastaSareb;
	}

	public String getIdComboEntidad() {
		return idComboEntidad;
	}

	public void setIdComboEntidad(String idComboEntidad) {
		this.idComboEntidad = idComboEntidad;
	}

	public String getTramitacion() {
		return tramitacion;
	}

	public void setTramitacion(String tramitacion) {
		this.tramitacion = tramitacion;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getFechaSolicitudDesde() {
		return fechaSolicitudDesde;
	}

	public void setFechaSolicitudDesde(String fechaSolicitudDesde) {
		this.fechaSolicitudDesde = formatearFecha(fechaSolicitudDesde);
	}

	public String getFechaSolicitudHasta() {
		return fechaSolicitudHasta;
	}

	public void setFechaSolicitudHasta(String fechaSolicitudHasta) {
		this.fechaSolicitudHasta = formatearFecha(fechaSolicitudHasta);
	}
	
	public String getEmbargo() {
		return embargo;
	}

	public void setEmbargo(String embargo) {
		this.embargo = embargo;
	}		
	
	private String formatearFecha(String fecha){
		if ( (fecha != null) && (!fecha.equalsIgnoreCase("")) ){
			fecha = fecha.substring(3, 5) + "/" + fecha.substring(0, 2)+ "/" + fecha.substring(6, 10);
		}
		return fecha;
	}

	public String getNroContrato() {
		return nroContrato;
	}

	public void setNroContrato(String nroContrato) {
		this.nroContrato = nroContrato;
	}

	public String getStringEstadosContrato() {
		return stringEstadosContrato;
	}

	public void setStringEstadosContrato(String stringEstadosContrato) {
		this.stringEstadosContrato = stringEstadosContrato;
	}

    public String getTiposProductoEntidad() {
        if (tiposProductoEntidad != null && !tiposProductoEntidad.equals("") && tiposProductoEntidad.lastIndexOf("'") == -1) {
            String list = "";
            StringTokenizer tokensTipos = new StringTokenizer(tiposProductoEntidad, ",");
            while (tokensTipos.hasMoreTokens()) {
                if (!list.equals("")) {
                    list += ",";
                }
                list += "'" + tokensTipos.nextElement() + "'";
            }
            tiposProductoEntidad = list;
        }
        return tiposProductoEntidad;
    }

	public void setTiposProductoEntidad(String tiposProductoEntidad) {
		this.tiposProductoEntidad = tiposProductoEntidad;
	}

	public String getCodRecibo() {
		return codRecibo;
	}

	public void setCodRecibo(String codRecibo) {
		this.codRecibo = codRecibo;
	}

	public String getCodEfecto() {
		return codEfecto;
	}

	public void setCodEfecto(String codEfecto) {
		this.codEfecto = codEfecto;
	}

	public String getCodDisposicion() {
		return codDisposicion;
	}

	public void setCodDisposicion(String codDisposicion) {
		this.codDisposicion = codDisposicion;
	}

	public String getCodigoZona() {
		return codigoZona;
	}

	public void setCodigoZona(String codigoZona) {
		this.codigoZona = codigoZona;
	}

	public String getJerarquia() {
		return jerarquia;
	}

	public void setJerarquia(String jerarquia) {
		this.jerarquia = jerarquia;
	}

	public String getCodigoZonaAdm() {
		return codigoZonaAdm;
	}

	public void setCodigoZonaAdm(String codigoZonaAdm) {
		this.codigoZonaAdm = codigoZonaAdm;
	}

	public String getJerarquiaAdm() {
		return jerarquiaAdm;
	}

	public void setJerarquiaAdm(String jerarquiaAdm) {
		this.jerarquiaAdm = jerarquiaAdm;
	}

	public String getTipoPersona() {
		return tipoPersona;
	}

	public void setTipoPersona(String tipoPersona) {
		this.tipoPersona = tipoPersona;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getApellidos() {
		return apellidos;
	}

	public void setApellidos(String apellidos) {
		this.apellidos = apellidos;
	}

	public String getNif() {
		return nif;
	}

	public void setNif(String nif) {
		this.nif = nif;
	}

	public String getCodigoCliente() {
		return codigoCliente;
	}

	public void setCodigoCliente(String codigoCliente) {
		this.codigoCliente = codigoCliente;
	}

	public String getGestion() {
		return gestion;
	}

	public void setGestion(String gestion) {
		this.gestion = gestion;
	}

	public String getPropiedad() {
		return propiedad;
	}

	public void setPropiedad(String propiedad) {
		this.propiedad = propiedad;
	}
			
}