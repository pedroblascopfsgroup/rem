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
	private LongDataType idOfertaHayaHome;
	@WebcomRequired
	private LongDataType idOfertaRem;
	private StringDataType entidadOrigen;
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
	private StringDataType origenOferta;
	private DoubleDataType mesesCarencia;
	private BooleanDataType contratoReserva;
	private StringDataType motivoCongelacion;
	private BooleanDataType ibi;
	private DoubleDataType importeIbi;
	private BooleanDataType otrasTasas;
	private DoubleDataType importeOtrasTasas;
	private BooleanDataType ccpp;
	private DoubleDataType importeCcpp;
	private DoubleDataType porcentaje1Anyo;
	private DoubleDataType porcentaje2Anyo;
	private DoubleDataType porcentaje3Anyo;
	private DoubleDataType porcentaje4Anyo;
	private DoubleDataType mesesCarenciaCtraofr;
	private DoubleDataType porcentaje1AnyoCtraofr;
	private DoubleDataType porcentaje2AnyoCtraofr;
	private DoubleDataType porcentaje3AnyoCtraofr;
	private DoubleDataType porcentaje4AnyoCtraofr;
	
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
	public LongDataType getIdOfertaHayaHome() {
		return idOfertaHayaHome;
	}
	public void setIdOfertaHayaHome(LongDataType idOfertaHayaHome) {
		this.idOfertaHayaHome = idOfertaHayaHome;
	}
	public LongDataType getIdOfertaRem() {
		return idOfertaRem;
	}
	public void setIdOfertaRem(LongDataType idOfertaRem) {
		this.idOfertaRem = idOfertaRem;
	}
	public StringDataType getEntidadOrigen() {
		return entidadOrigen;
	}
	public void setEntidadOrigen(StringDataType entidadOrigen) {
		this.entidadOrigen = entidadOrigen;
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
	public StringDataType getOrigenOferta() {
		return origenOferta;
	}
	public void setOrigenOferta(StringDataType origenOferta) {
		this.origenOferta = origenOferta;
	}
	public DoubleDataType getMesesCarencia() {
		return mesesCarencia;
	}
	public void setMesesCarencia(DoubleDataType mesesCarencia) {
		this.mesesCarencia = mesesCarencia;
	}
	public BooleanDataType getContratoReserva() {
		return contratoReserva;
	}
	public void setContratoReserva(BooleanDataType contratoReserva) {
		this.contratoReserva = contratoReserva;
	}
	public StringDataType getMotivoCongelacion() {
		return motivoCongelacion;
	}
	public void setMotivoCongelacion(StringDataType motivoCongelacion) {
		this.motivoCongelacion = motivoCongelacion;
	}
	public BooleanDataType getIbi() {
		return ibi;
	}
	public void setIbi(BooleanDataType ibi) {
		this.ibi = ibi;
	}
	public DoubleDataType getImporteIbi() {
		return importeIbi;
	}
	public void setImporteIbi(DoubleDataType importeIbi) {
		this.importeIbi = importeIbi;
	}
	public BooleanDataType getOtrasTasas() {
		return otrasTasas;
	}
	public void setOtrasTasas(BooleanDataType otrasTasas) {
		this.otrasTasas = otrasTasas;
	}
	public DoubleDataType getImporteOtrasTasas() {
		return importeOtrasTasas;
	}
	public void setImporteOtrasTasas(DoubleDataType importeOtrasTasas) {
		this.importeOtrasTasas = importeOtrasTasas;
	}
	public BooleanDataType getCcpp() {
		return ccpp;
	}
	public void setCcpp(BooleanDataType ccpp) {
		this.ccpp = ccpp;
	}
	public DoubleDataType getImporteCcpp() {
		return importeCcpp;
	}
	public void setImporteCcpp(DoubleDataType importeCcpp) {
		this.importeCcpp = importeCcpp;
	}
	public DoubleDataType getPorcentaje1Anyo() {
		return porcentaje1Anyo;
	}
	public void setPorcentaje1Anyo(DoubleDataType porcentaje1Anyo) {
		this.porcentaje1Anyo = porcentaje1Anyo;
	}
	public DoubleDataType getPorcentaje2Anyo() {
		return porcentaje2Anyo;
	}
	public void setPorcentaje2Anyo(DoubleDataType porcentaje2Anyo) {
		this.porcentaje2Anyo = porcentaje2Anyo;
	}
	public DoubleDataType getPorcentaje3Anyo() {
		return porcentaje3Anyo;
	}
	public void setPorcentaje3Anyo(DoubleDataType porcentaje3Anyo) {
		this.porcentaje3Anyo = porcentaje3Anyo;
	}
	public DoubleDataType getPorcentaje4Anyo() {
		return porcentaje4Anyo;
	}
	public void setPorcentaje4Anyo(DoubleDataType porcentaje4Anyo) {
		this.porcentaje4Anyo = porcentaje4Anyo;
	}
	public DoubleDataType getMesesCarenciaCtraofr() {
		return mesesCarenciaCtraofr;
	}
	public void setMesesCarenciaCtraofr(DoubleDataType mesesCarenciaCtraofr) {
		this.mesesCarenciaCtraofr = mesesCarenciaCtraofr;
	}
	public DoubleDataType getPorcentaje1AnyoCtraofr() {
		return porcentaje1AnyoCtraofr;
	}
	public void setPorcentaje1AnyoCtraofr(DoubleDataType porcentaje1AnyoCtraofr) {
		this.porcentaje1AnyoCtraofr = porcentaje1AnyoCtraofr;
	}
	public DoubleDataType getPorcentaje2AnyoCtraofr() {
		return porcentaje2AnyoCtraofr;
	}
	public void setPorcentaje2AnyoCtraofr(DoubleDataType porcentaje2AnyoCtraofr) {
		this.porcentaje2AnyoCtraofr = porcentaje2AnyoCtraofr;
	}
	public DoubleDataType getPorcentaje3AnyoCtraofr() {
		return porcentaje3AnyoCtraofr;
	}
	public void setPorcentaje3AnyoCtraofr(DoubleDataType porcentaje3AnyoCtraofr) {
		this.porcentaje3AnyoCtraofr = porcentaje3AnyoCtraofr;
	}
	public DoubleDataType getPorcentaje4AnyoCtraofr() {
		return porcentaje4AnyoCtraofr;
	}
	public void setPorcentaje4AnyoCtraofr(DoubleDataType porcentaje4AnyoCtraofr) {
		this.porcentaje4AnyoCtraofr = porcentaje4AnyoCtraofr;
	}

}
