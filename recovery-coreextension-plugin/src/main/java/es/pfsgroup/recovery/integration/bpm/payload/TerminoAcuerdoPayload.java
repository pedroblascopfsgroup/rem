package es.pfsgroup.recovery.integration.bpm.payload;

import java.util.ArrayList;
import java.util.List;

import es.capgemini.pfs.termino.model.TerminoAcuerdo;
import es.capgemini.pfs.termino.model.TerminoBien;
import es.capgemini.pfs.termino.model.TerminoContrato;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.recovery.integration.DataContainerPayload;
import es.pfsgroup.recovery.integration.IntegrationDataException;

public class TerminoAcuerdoPayload {

	public final static String KEY = "@tea";

	private static final String RELACION_TERMINO_ACUERDO_CONTRATO = String.format("%s.cnt", KEY);
	private static final String  RELACION_TERMINO_ACUERDO_BIEN = String.format("%s.bie", KEY);

	private static final String CAMPO_TIPO_ACUERDO = String.format("%s.tipoAcuerdo", KEY);
	private static final String CAMPO_TIPO_PRODUCTO = String.format("%s.tipoProducto", KEY);
	private static final String CAMPO_MODO_DESEMBOLSO = String.format("%s.modoDesembolso", KEY);
	private static final String CAMPO_FORMALIZACION = String.format("%s.formalizacion", KEY);
	private static final String CAMPO_IMPORTE = String.format("%s.importe", KEY);
	private static final String CAMPO_COMISIONES = String.format("%s.comisiones", KEY);
	private static final String CAMPO_PERIODICIDAD = String.format("%s.periodicidad", KEY);
	private static final String CAMPO_PERIODO_FIJO = String.format("%s.periodoFijo", KEY);
	private static final String CAMPO_SISTEMA_AMORTIZACION = String.format("%s.stmaAmort", KEY);
	private static final String CAMPO_INTERES = String.format("%s.interes", KEY);
	private static final String CAMPO_PERIODO_VARIABLE = String.format("%s.periodoVariable", KEY);
	private static final String CAMPO_INFORME_LETRADO = String.format("%s.infLetrado", KEY);
	private static final String CAMPO_BORRADO = String.format("%s.borrado", KEY);
	
	private final DataContainerPayload data;
	private final AcuerdoPayload acuerdo;

	public DataContainerPayload getData() {
		return data;
	}
	
	public TerminoAcuerdoPayload(DataContainerPayload data) {
		this.data = data;
		this.acuerdo = new AcuerdoPayload(data);
	}
	
	public TerminoAcuerdoPayload(String tipo, TerminoAcuerdo termino) {
		this(new DataContainerPayload(null, null), termino);
	}

	public TerminoAcuerdoPayload(DataContainerPayload data, TerminoAcuerdo termino) {
		this.data = data;
		this.acuerdo = new AcuerdoPayload(data, termino.getAcuerdo());
		build(termino);
	}


	public TerminoAcuerdoPayload build(TerminoAcuerdo terminoAcuerdo) {
		if (Checks.esNulo(terminoAcuerdo.getGuid())) {
			throw new IntegrationDataException(String.format("[INTEGRACION] El Termino con ID %d del Acuerdo no tiene referencia de sincronización GUID", terminoAcuerdo.getId()));
		}
		this.setGuid(terminoAcuerdo.getGuid());
		this.setId(terminoAcuerdo.getId());
		
		if (terminoAcuerdo.getTipoAcuerdo()!=null) {
			this.setTipoAcuerdo(terminoAcuerdo.getTipoAcuerdo().getCodigo());	
		}
		
		if (terminoAcuerdo.getTipoProducto()!=null) {
			this.setTipoProducto(terminoAcuerdo.getTipoProducto().getCodigo());	
		}
		
		this.setCampoFormalizacion(terminoAcuerdo.getFormalizacion());
		this.setComisiones(terminoAcuerdo.getComisiones());
		this.setImporte(terminoAcuerdo.getImporte());
		this.setInformeLetrado(terminoAcuerdo.getInformeLetrado());
		this.setInteres(terminoAcuerdo.getInteres());
		this.setModoDesembolso(terminoAcuerdo.getModoDesembolso());
		this.setPeridoVariable(terminoAcuerdo.getPeriodoVariable());
		this.setPeriodicidad(terminoAcuerdo.getPeriodicidad());
		this.setPerioFijo(terminoAcuerdo.getPeriodoFijo());
		this.setSistemaAmortizacion(terminoAcuerdo.getSistemaAmortizacion());
		this.setBorrado(terminoAcuerdo.getAuditoria().isBorrado());
		return this;
	}
	
	public TerminoAcuerdoPayload buildTerminoContrato(List<TerminoContrato> terminosContrato) {
		if (terminosContrato==null) {
			return this;
		}
		for (TerminoContrato tc : terminosContrato) {
			addRelacionContrato(tc);
		}
		return this;
	}

	public TerminoAcuerdoPayload buildTerminoBien(List<TerminoBien> terminosBien) {
		if (terminosBien==null) {
			return this;
		}
		for (TerminoBien tb : terminosBien) {
			addRelacionBien(tb);
		}
		return this;
	}

	public Long getId() {
		return data.getIdOrigen(KEY);
	}
	private void setId(Long valor) {
		data.addSourceId(KEY, valor);
	}

	public String getGuid() {
		return data.getGuid(KEY);
	}
	private void setGuid(String valor) {
		data.addGuid(KEY, valor);
	}

	
	private void addRelacionContrato(TerminoContrato terminoContrato) {
		this.data.addRelacion(RELACION_TERMINO_ACUERDO_CONTRATO, terminoContrato.getContrato().getNroContrato());
	}
	public List<String> getContratosRelacionados() {
		return this.data.getRelaciones(RELACION_TERMINO_ACUERDO_CONTRATO);
	}

	private void addRelacionBien(TerminoBien terminoBien) {
		NMBBien nbmBien = NMBBien.instanceOf(terminoBien.getBien());
		if (nbmBien==null) {
			throw new IntegrationDataException(String.format("[INTEGRACION] El Bien de la relación con termino de acuerdo con ID %d no tiene referencia de sincronización GUID", terminoBien.getId()));
		}
		this.data.addRelacion(RELACION_TERMINO_ACUERDO_BIEN, nbmBien.getCodigoInterno());
	}
	public List<String> getBienesRelacionados() {
		return this.data.getRelaciones(RELACION_TERMINO_ACUERDO_BIEN);
	}

	public String getTipoAcuerdo() {
		return this.data.getCodigo(CAMPO_TIPO_ACUERDO);
	}
	private void setTipoAcuerdo(String valor) {
		data.addCodigo(CAMPO_TIPO_ACUERDO, valor);
	}

	public String getTipoProducto() {
		return this.data.getCodigo(CAMPO_TIPO_PRODUCTO);
	}
	private void setTipoProducto(String valor) {
		data.addCodigo(CAMPO_TIPO_PRODUCTO, valor);
	}

	public String getModoDesembolso() {
		return this.data.getExtraInfo(CAMPO_MODO_DESEMBOLSO);
	}
	private void setModoDesembolso(String valor) {
		data.addExtraInfo(CAMPO_MODO_DESEMBOLSO, valor);
	}
    
	public String getCampoFormalizacion() {
		return this.data.getExtraInfo(CAMPO_FORMALIZACION);
	}
	private void setCampoFormalizacion(String valor) {
		data.addExtraInfo(CAMPO_FORMALIZACION, valor);
	}
    
	public Float getImporte() {
		return this.data.getValFloat(CAMPO_IMPORTE);
	}
	private void setImporte(Float valor) {
		data.addNumber(CAMPO_IMPORTE, valor);
	}
    
	public Float getComisiones() {
		return this.data.getValFloat(CAMPO_COMISIONES);
	}
	private void setComisiones(Float valor) {
		data.addNumber(CAMPO_COMISIONES, valor);
	}
    
	public String getPeriodicidad() {
		return this.data.getExtraInfo(CAMPO_PERIODICIDAD);
	}
	private void setPeriodicidad(String valor) {
		data.addExtraInfo(CAMPO_PERIODICIDAD, valor);
	}

	public String getPerioFijo() {
		return this.data.getExtraInfo(CAMPO_PERIODO_FIJO);
	}
	private void setPerioFijo(String valor) {
		data.addExtraInfo(CAMPO_PERIODO_FIJO, valor);
	}
	
	public String getSistemaAmortizacion() {
		return this.data.getExtraInfo(CAMPO_SISTEMA_AMORTIZACION);
	}
	private void setSistemaAmortizacion(String valor) {
		data.addExtraInfo(CAMPO_SISTEMA_AMORTIZACION, valor);
	}

	public Float getInteres() {
		return this.data.getValFloat(CAMPO_INTERES);
	}
	private void setInteres(Float valor) {
		data.addNumber(CAMPO_INTERES, valor);
	}
	
	public String getPeridoVariable() {
		return this.data.getExtraInfo(CAMPO_PERIODO_VARIABLE);
	}
	private void setPeridoVariable(String valor) {
		data.addExtraInfo(CAMPO_PERIODO_VARIABLE, valor);
	}

	public String getInformeLetrado() {
		return this.data.getExtraInfo(CAMPO_INFORME_LETRADO);
	}
	private void setInformeLetrado(String valor) {
		data.addExtraInfo(CAMPO_INFORME_LETRADO, valor);
	}

	public void setBorrado(Boolean valor) {
		data.addFlag(CAMPO_BORRADO, valor);
	}
	public boolean isBorrado() {
		return data.getFlag(CAMPO_BORRADO);
	}

	public AcuerdoPayload getAcuerdo() {
		return acuerdo;
	}

}
