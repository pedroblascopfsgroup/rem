package es.pfsgroup.plugin.rem.api.services.webcom.dto;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.BooleanDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.DateDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.DoubleDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.LongDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.StringDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.WebcomRequired;

public class EstadoOfertaDto implements WebcomRESTDto{
	
	@WebcomRequired //No se puede quitar
	private LongDataType idUsuarioRemAccion;
	@WebcomRequired //No se puede quitar
	private DateDataType fechaAccion;
	@WebcomRequired
	private LongDataType idOfertaWebcom;
	@WebcomRequired
	private LongDataType idOfertaRem;
	@WebcomRequired
	private StringDataType codEstadoOferta;
	private StringDataType codEstadoExpediente;
	private BooleanDataType vendido;
	@WebcomRequired
	private LongDataType idAgrupacionRem;
	private LongDataType idActivoHaya;
	private StringDataType motivoRechazo;
	private LongDataType importeContraoferta;
	private LongDataType idExpedienteRem;
	private DateDataType fechaVenta;
	private DateDataType fechaReserva;
	private DateDataType fechaAlquiler;
	private DoubleDataType importe;
	
	public LongDataType getIdUsuarioRemAccion() {
		return idUsuarioRemAccion;
	}
	public void setIdUsuarioRemAccion(LongDataType idUsuarioRemAccion) {
		this.idUsuarioRemAccion = idUsuarioRemAccion;
	}
	public DateDataType getFechaAccion() {
		return fechaAccion;
	}
	public void setFechaAccion(DateDataType fechaAccion) {
		this.fechaAccion = fechaAccion;
	}
	public LongDataType getIdOfertaWebcom() {
		return idOfertaWebcom;
	}
	public void setIdOfertaWebcom(LongDataType idOfertaWebcom) {
		this.idOfertaWebcom = idOfertaWebcom;
	}
	public LongDataType getIdOfertaRem() {
		return idOfertaRem;
	}
	public void setIdOfertaRem(LongDataType idOfertaRem) {
		this.idOfertaRem = idOfertaRem;
	}
	public StringDataType getCodEstadoOferta() {
		return codEstadoOferta;
	}
	public void setCodEstadoOferta(StringDataType codEstadoOferta) {
		this.codEstadoOferta = codEstadoOferta;
	}
	public StringDataType getCodEstadoExpediente() {
		return codEstadoExpediente;
	}
	public void setCodEstadoExpediente(StringDataType codEstadoExpediente) {
		this.codEstadoExpediente = codEstadoExpediente;
	}
	public BooleanDataType getVendido() {
		return vendido;
	}
	public void setVendido(BooleanDataType vendido) {
		this.vendido = vendido;
	}
	public LongDataType getIdAgrupacionRem() {
		return idAgrupacionRem;
	}
	public void setIdAgrupacionRem(LongDataType idAgrupacionRem) {
		this.idAgrupacionRem = idAgrupacionRem;
	}
	public LongDataType getIdActivoHaya() {
		return idActivoHaya;
	}
	public void setIdActivoHaya(LongDataType idActivoHaya) {
		this.idActivoHaya = idActivoHaya;
	}
	public StringDataType getMotivoRechazo() {
		return motivoRechazo;
	}
	public void setMotivoRechazo(StringDataType motivoRechazo) {
		this.motivoRechazo = motivoRechazo;
	}
	public LongDataType getImporteContraoferta() {
		return importeContraoferta;
	}
	public void setImporteContraoferta(LongDataType importeContraoferta) {
		this.importeContraoferta = importeContraoferta;
	}
	public LongDataType getIdExpedienteRem() {
		return idExpedienteRem;
	}
	public void setIdExpedienteRem(LongDataType idExpedienteRem) {
		this.idExpedienteRem = idExpedienteRem;
	}
	public DateDataType getFechaVenta() {
		return fechaVenta;
	}
	public void setFechaVenta(DateDataType fechaVenta) {
		this.fechaVenta = fechaVenta;
	}
	public DateDataType getFechaReserva() {
		return fechaReserva;
	}
	public void setFechaReserva(DateDataType fechaReserva) {
		this.fechaReserva = fechaReserva;
	}
	public DateDataType getFechaAlquiler() {
		return fechaAlquiler;
	}
	public void setFechaAlquiler(DateDataType fechaAlquiler) {
		this.fechaAlquiler = fechaAlquiler;
	}
	public DoubleDataType getImporte() {
		return importe;
	}
	public void setImporte(DoubleDataType importe) {
		this.importe = importe;
	}

}
