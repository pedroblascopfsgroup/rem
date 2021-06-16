package es.pfsgroup.plugin.rem.model;

import java.util.Date;
import es.pfsgroup.plugin.rem.model.dd.DDTerritorio;

public class DtoComercialActivo extends DtoTabActivo{

	private static final long serialVersionUID = 1L;

	private String id; // ID de activo.
	private String situacionComercialCodigo;
	private String situacionComercialDescripcion;
	private Date fechaVenta;
	private Boolean expedienteComercialVivo;
	private String observaciones;
	private Double importeVenta;
	private Boolean ventaExterna;
	private Boolean puja;
	private Boolean tramitable;
	private String motivoAutorizacionTramitacionCodigo;
	private String motivoAutorizacionTramitacionDescripcion;
	private String observacionesAutoTram;
	private String direccionComercial;
	private String direccionComercialDescripcion;
	private Boolean ventaSobrePlano;
	private Double importeComunidadMensualSareb;
	private String siniestroSareb;
	private String tipoCorrectivoSareb;
	private Date fechaFinCorrectivoSareb;
	private String tipoCuotaComunidad;
	private String ggaaSareb;
	private String segmentacionSareb;

	private String activoObraNuevaComercializacion;
	private Date activoObraNuevaComercializacionFecha;
	private Boolean necesidadIfActivo;
	private Boolean necesidadArras;
	private String motivoNecesidadArrasCod;
	private String motivoNecesidadArrasDesc;
	private String estadoComercialVentaCodigo;
	private String estadoComercialVentaDescripcion;
	private String estadoComercialAlquilerCodigo;
	private String estadoComercialAlquilerDescripcion;
	private Date fechaEstadoComercialVenta;
	private Date fechaEstadoComercialAlquiler;	
	private String canalPublicacionVentaCodigo;
	private String canalPublicacionAlquilerCodigo;


	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getSituacionComercialCodigo() {
		return situacionComercialCodigo;
	}

	public void setSituacionComercialCodigo(String situacionComercialCodigo) {
		this.situacionComercialCodigo = situacionComercialCodigo;
	}
	
	public String getSituacionComercialDescripcion() {
		return situacionComercialDescripcion;
	}

	public void setSituacionComercialDescripcion(String situacionComercialDescripcion) {
		this.situacionComercialDescripcion = situacionComercialDescripcion;
	}

	public Date getFechaVenta() {
		return fechaVenta;
	}

	public void setFechaVenta(Date fechaVenta) {
		this.fechaVenta = fechaVenta;
	}

	public Boolean getExpedienteComercialVivo() {
		return expedienteComercialVivo;
	}

	public void setExpedienteComercialVivo(Boolean expedienteComercialVivo) {
		this.expedienteComercialVivo = expedienteComercialVivo;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}

	public Double getImporteVenta() {
		return importeVenta;
	}

	public void setImporteVenta(Double importeVenta) {
		this.importeVenta = importeVenta;
	}

	public Boolean getVentaExterna() {
		return ventaExterna;
	}

	public void setVentaExterna(Boolean ventaExterna) {
		this.ventaExterna = ventaExterna;
	}
	
	public Boolean getPuja() {
		return puja;
	}

	public void setPuja(Boolean puja) {
		this.puja = puja;
	}
	
	public String getMotivoAutorizacionTramitacionCodigo() {
		return motivoAutorizacionTramitacionCodigo;
	}

	public void setMotivoAutorizacionTramitacionCodigo(String motivoAutorizacionTramitacionCodigo) {
		this.motivoAutorizacionTramitacionCodigo = motivoAutorizacionTramitacionCodigo;
	}
	
	public String getMotivoAutorizacionTramitacionDescripcion() {
		return motivoAutorizacionTramitacionDescripcion;
	}

	public void setMotivoAutorizacionTramitacionDescripcion(String motivoAutorizacionTramitacionDescripcion) {
		this.motivoAutorizacionTramitacionDescripcion = motivoAutorizacionTramitacionDescripcion;
	}

	public Boolean getTramitable() {
		return tramitable;
	}

	public void setTramitable(Boolean tramitable) {
		this.tramitable = tramitable;
	}

	public String getObservacionesAutoTram() {
		return observacionesAutoTram;
	}

	public void setObservacionesAutoTram(String observacionesAutoTram) {
		this.observacionesAutoTram = observacionesAutoTram;
	}

	public String getDireccionComercial() {
		return direccionComercial;
	}

	public void setDireccionComercial(String direccionComercial) {
		this.direccionComercial = direccionComercial;
	}
	
	public String getDireccionComercialDescripcion() {
		return direccionComercialDescripcion;
	}

	public void setDireccionComercialDescripcion(String direccionComercialDescripcion) {
		this.direccionComercialDescripcion = direccionComercialDescripcion;
	}
	
	public Boolean getVentaSobrePlano() {
		return ventaSobrePlano;
	}

	public void setVentaSobrePlano(Boolean ventaSobrePlano) {
		this.ventaSobrePlano = ventaSobrePlano;
	}

	public Double getImporteComunidadMensualSareb() {
		return importeComunidadMensualSareb;
	}

	public void setImporteComunidadMensualSareb(Double importeComunidadMensualSareb) {
		this.importeComunidadMensualSareb = importeComunidadMensualSareb;
	}

	public String getSiniestroSareb() {
		return siniestroSareb;
	}

	public void setSiniestroSareb(String siniestroSareb) {
		this.siniestroSareb = siniestroSareb;
	}

	public String getTipoCorrectivoSareb() {
		return tipoCorrectivoSareb;
	}

	public void setTipoCorrectivoSareb(String tipoCorrectivoSareb) {
		this.tipoCorrectivoSareb = tipoCorrectivoSareb;
	}

	public Date getFechaFinCorrectivoSareb() {
		return fechaFinCorrectivoSareb;
	}

	public void setFechaFinCorrectivoSareb(Date fechaFinCorrectivoSareb) {
		this.fechaFinCorrectivoSareb = fechaFinCorrectivoSareb;
	}

	public String getTipoCuotaComunidad() {
		return tipoCuotaComunidad;
	}

	public void setTipoCuotaComunidad(String tipoCuotaComunidad) {
		this.tipoCuotaComunidad = tipoCuotaComunidad;
	}

	public String getGgaaSareb() {
		return ggaaSareb;
	}

	public void setGgaaSareb(String ggaaSareb) {
		this.ggaaSareb = ggaaSareb;
	}

	public String getSegmentacionSareb() {
		return segmentacionSareb;
	}

	public void setSegmentacionSareb(String segmentacionSareb) {
		this.segmentacionSareb = segmentacionSareb;
	}
	
	

	public String getActivoObraNuevaComercializacion() {
		return activoObraNuevaComercializacion;
	}

	public void setActivoObraNuevaComercializacion(String activoObraNuevaComercializacion) {
		this.activoObraNuevaComercializacion = activoObraNuevaComercializacion;
	}

	public Date getActivoObraNuevaComercializacionFecha() {
		return activoObraNuevaComercializacionFecha;
	}

	public void setActivoObraNuevaComercializacionFecha(Date activoObraNuevaComercializacionFecha) {
		this.activoObraNuevaComercializacionFecha = activoObraNuevaComercializacionFecha;
	}


	public Boolean getNecesidadIfActivo() {
		return necesidadIfActivo;
	}

	public void setNecesidadIfActivo(Boolean necesidadIfActivo) {
		this.necesidadIfActivo = necesidadIfActivo;
	}
	public Boolean getNecesidadArras() {
		return necesidadArras;
	}

	public void setNecesidadArras(Boolean necesidadArras) {
		this.necesidadArras = necesidadArras;
	}

	public String getMotivoNecesidadArrasCod() {
		return motivoNecesidadArrasCod;
	}

	public void setMotivoNecesidadArrasCod(String motivoNecesidadArrasCod) {
		this.motivoNecesidadArrasCod = motivoNecesidadArrasCod;
	}

	public String getMotivoNecesidadArrasDesc() {
		return motivoNecesidadArrasDesc;
	}

	public void setMotivoNecesidadArrasDesc(String motivoNecesidadArrasDesc) {
		this.motivoNecesidadArrasDesc = motivoNecesidadArrasDesc;
	}
	
	public String getEstadoComercialVentaCodigo() {
		return estadoComercialVentaCodigo;
	}

	public void setEstadoComercialVentaCodigo(String estadoComercialVentaCodigo) {
		this.estadoComercialVentaCodigo = estadoComercialVentaCodigo;
	}

	public String getEstadoComercialVentaDescripcion() {
		return estadoComercialVentaDescripcion;
	}

	public void setEstadoComercialVentaDescripcion(String estadoComercialVentaDescripcion) {
		this.estadoComercialVentaDescripcion = estadoComercialVentaDescripcion;
	}

	public String getEstadoComercialAlquilerCodigo() {
		return estadoComercialAlquilerCodigo;
	}

	public void setEstadoComercialAlquilerCodigo(String estadoComercialAlquilerCodigo) {
		this.estadoComercialAlquilerCodigo = estadoComercialAlquilerCodigo;
	}

	public String getEstadoComercialAlquilerDescripcion() {
		return estadoComercialAlquilerDescripcion;
	}

	public void setEstadoComercialAlquilerDescripcion(String estadoComercialAlquilerDescripcion) {
		this.estadoComercialAlquilerDescripcion = estadoComercialAlquilerDescripcion;
	}

	public Date getFechaEstadoComercialVenta() {
		return fechaEstadoComercialVenta;
	}

	public void setFechaEstadoComercialVenta(Date fechaEstadoComercialVenta) {
		this.fechaEstadoComercialVenta = fechaEstadoComercialVenta;
	}

	public Date getFechaEstadoComercialAlquiler() {
		return fechaEstadoComercialAlquiler;
	}

	public void setFechaEstadoComercialAlquiler(Date fechaEstadoComercialAlquiler) {
		this.fechaEstadoComercialAlquiler = fechaEstadoComercialAlquiler;
	}

	public String getCanalPublicacionVentaCodigo() {
		return canalPublicacionVentaCodigo;
	}

	public void setCanalPublicacionVentaCodigo(String canalPublicacionVentaCodigo) {
		this.canalPublicacionVentaCodigo = canalPublicacionVentaCodigo;
	}

	public String getCanalPublicacionAlquilerCodigo() {
		return canalPublicacionAlquilerCodigo;
	}

	public void setCanalPublicacionAlquilerCodigo(String canalPublicacionAlquilerCodigo) {
		this.canalPublicacionAlquilerCodigo = canalPublicacionAlquilerCodigo;
	}

	
}
