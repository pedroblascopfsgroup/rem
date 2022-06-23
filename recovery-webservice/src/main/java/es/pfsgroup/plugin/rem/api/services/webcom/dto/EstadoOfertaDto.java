package es.pfsgroup.plugin.rem.api.services.webcom.dto;

import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.BooleanDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.DateDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.DoubleDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.LongDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.StringDataType;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.WebcomRequired;
import es.pfsgroup.plugin.rem.api.services.webcom.dto.datatype.annotations.MappedColumn;

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
	private StringDataType tipoRechazoSancion;
	private StringDataType motivoRechazo;
	private LongDataType importeContraoferta;
	private LongDataType idExpedienteRem;
	private DateDataType fechaVenta;
	private DateDataType fechaReserva;
	private DateDataType fechaAlquiler;
	private DateDataType fechaCreacionOpSf;
	private BooleanDataType necesidadIf;
	private BooleanDataType exclusionIf;
	private DoubleDataType importe;
	private StringDataType codOrigenOferta;
	private DoubleDataType mesesCarencia;
	private BooleanDataType tienecontratoReserva;
	private StringDataType motivoCongelacion;
	@MappedColumn("TIENE_IBI")
	private BooleanDataType tieneIBI;
	@MappedColumn("IMPORTE_IBI")
	private DoubleDataType importeIBI;
	private BooleanDataType tieneOtrasTasas;
	private DoubleDataType importeOtrasTasas;
	@MappedColumn("TIENE_CCPP")
	private BooleanDataType tieneCCPP;
	@MappedColumn("IMPORTE_CCPP")
	private DoubleDataType importeCCPP;
	private DoubleDataType bonificacionAnyo1;
	private DoubleDataType bonificacionAnyo2;
	private DoubleDataType bonificacionAnyo3;
	private DoubleDataType bonificacionAnyo4;
	private DoubleDataType mesesCarenciaCtraofr;
	private DoubleDataType bonificacionAnyo1Contraoferta;
	private DoubleDataType bonificacionAnyo2Contraoferta;
	private DoubleDataType bonificacionAnyo3Contraoferta;
	private DoubleDataType bonificacionAnyo4Contraoferta;
	private StringDataType codSubestadoExpediente;
	private StringDataType codOfertaSalesforce;
	private StringDataType cuentaVirtual;


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
	public StringDataType getTipoRechazoSancion() {
		return tipoRechazoSancion;
	}
	public void setTipoRechazoSancion(StringDataType tipoRechazoSancion) {
		this.tipoRechazoSancion = tipoRechazoSancion;
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
	public DateDataType getFechaCreacionOpSf() {
		return fechaCreacionOpSf;
	}
	public void setFechaCreacionOpSf(DateDataType fechaCreacionOpSf) {
		this.fechaCreacionOpSf = fechaCreacionOpSf;
	}
	public BooleanDataType getNecesidadIf() {
		return necesidadIf;
	}
	public void setNecesidadIf(BooleanDataType necesidadIf) {
		this.necesidadIf = necesidadIf;
	}
	public BooleanDataType getExclusionIf() {
		return exclusionIf;
	}
	public void setExclusionIf(BooleanDataType exclusionIf) {
		this.exclusionIf = exclusionIf;
	}
	public DoubleDataType getImporte() {
		return importe;
	}
	public void setImporte(DoubleDataType importe) {
		this.importe = importe;
	}
	public StringDataType getCodOrigenOferta() {
		return codOrigenOferta;
	}
	public void setCodOrigenOferta(StringDataType codOrigenOferta) {
		this.codOrigenOferta = codOrigenOferta;
	}
	public DoubleDataType getMesesCarencia() {
		return mesesCarencia;
	}
	public void setMesesCarencia(DoubleDataType mesesCarencia) {
		this.mesesCarencia = mesesCarencia;
	}
	public BooleanDataType getTienecontratoReserva() {
		return tienecontratoReserva;
	}
	public void setTienecontratoReserva(BooleanDataType tienecontratoReserva) {
		this.tienecontratoReserva = tienecontratoReserva;
	}
	public StringDataType getMotivoCongelacion() {
		return motivoCongelacion;
	}
	public void setMotivoCongelacion(StringDataType motivoCongelacion) {
		this.motivoCongelacion = motivoCongelacion;
	}
	public BooleanDataType getTieneIBI() {
		return tieneIBI;
	}
	public void setTieneIBI(BooleanDataType tieneIBI) {
		this.tieneIBI = tieneIBI;
	}
	public DoubleDataType getImporteIBI() {
		return importeIBI;
	}
	public void setImporteIBI(DoubleDataType importeIBI) {
		this.importeIBI = importeIBI;
	}
	public BooleanDataType getTieneOtrasTasas() {
		return tieneOtrasTasas;
	}
	public void setTieneOtrasTasas(BooleanDataType tieneOtrasTasas) {
		this.tieneOtrasTasas = tieneOtrasTasas;
	}
	public DoubleDataType getImporteOtrasTasas() {
		return importeOtrasTasas;
	}
	public void setImporteOtrasTasas(DoubleDataType importeOtrasTasas) {
		this.importeOtrasTasas = importeOtrasTasas;
	}
	public BooleanDataType getTieneCCPP() {
		return tieneCCPP;
	}
	public void setTieneCCPP(BooleanDataType tieneCCPP) {
		this.tieneCCPP = tieneCCPP;
	}
	public DoubleDataType getImporteCCPP() {
		return importeCCPP;
	}
	public void setImporteCCPP(DoubleDataType importeCCPP) {
		this.importeCCPP = importeCCPP;
	}
	public DoubleDataType getBonificacionAnyo1() {
		return bonificacionAnyo1;
	}
	public void setBonificacionAnyo1(DoubleDataType bonificacionAnyo1) {
		this.bonificacionAnyo1 = bonificacionAnyo1;
	}
	public DoubleDataType getBonificacionAnyo2() {
		return bonificacionAnyo2;
	}
	public void setBonificacionAnyo2(DoubleDataType bonificacionAnyo2) {
		this.bonificacionAnyo2 = bonificacionAnyo2;
	}
	public DoubleDataType getBonificacionAnyo3() {
		return bonificacionAnyo3;
	}
	public void setBonificacionAnyo3(DoubleDataType bonificacionAnyo3) {
		this.bonificacionAnyo3 = bonificacionAnyo3;
	}
	public DoubleDataType getBonificacionAnyo4() {
		return bonificacionAnyo4;
	}
	public void setBonificacionAnyo4(DoubleDataType bonificacionAnyo4) {
		this.bonificacionAnyo4 = bonificacionAnyo4;
	}
	public DoubleDataType getMesesCarenciaCtraofr() {
		return mesesCarenciaCtraofr;
	}
	public void setMesesCarenciaCtraofr(DoubleDataType mesesCarenciaCtraofr) {
		this.mesesCarenciaCtraofr = mesesCarenciaCtraofr;
	}
	public DoubleDataType getBonificacionAnyo1Contraoferta() {
		return bonificacionAnyo1Contraoferta;
	}
	public void setBonificacionAnyo1Contraoferta(DoubleDataType bonificacionAnyo1Contraoferta) {
		this.bonificacionAnyo1Contraoferta = bonificacionAnyo1Contraoferta;
	}
	public DoubleDataType getBonificacionAnyo2Contraoferta() {
		return bonificacionAnyo2Contraoferta;
	}
	public void setBonificacionAnyo2Contraoferta(DoubleDataType bonificacionAnyo2Contraoferta) {
		this.bonificacionAnyo2Contraoferta = bonificacionAnyo2Contraoferta;
	}
	public DoubleDataType getBonificacionAnyo3Contraoferta() {
		return bonificacionAnyo3Contraoferta;
	}
	public void setBonificacionAnyo3Contraoferta(DoubleDataType bonificacionAnyo3Contraoferta) {
		this.bonificacionAnyo3Contraoferta = bonificacionAnyo3Contraoferta;
	}
	public DoubleDataType getBonificacionAnyo4Contraoferta() {
		return bonificacionAnyo4Contraoferta;
	}
	public void setBonificacionAnyo4Contraoferta(DoubleDataType bonificacionAnyo4Contraoferta) {
		this.bonificacionAnyo4Contraoferta = bonificacionAnyo4Contraoferta;
	}
	public StringDataType getCodSubestadoExpediente() {
		return codSubestadoExpediente;
	}
	public void setCodSubestadoExpediente(StringDataType codSubestadoExpediente) {
		this.codSubestadoExpediente = codSubestadoExpediente;
	}
	public StringDataType getCodOfertaSalesforce() {
		return codOfertaSalesforce;
	}
	public void setCodOfertaSalesforce(StringDataType codOfertaSalesforce) {
		this.codOfertaSalesforce = codOfertaSalesforce;
	}

	public StringDataType getCuentaVirtual() {
		return cuentaVirtual;
	}

	public void setCuentaVirtual(StringDataType cuentaVirtual) {
		this.cuentaVirtual = cuentaVirtual;
	}
}
