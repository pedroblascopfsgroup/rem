package es.pfsgroup.recovery.integration.bpm;


import es.capgemini.pfs.termino.model.TerminoContrato;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.recovery.integration.DataContainerPayload;
import es.pfsgroup.recovery.integration.IntegrationDataException;

public class TerminoAcuerdoContratoPayload {

	public final static String KEY = "@tea_cnt";

	private static final String CAMPO_CONTRATO = String.format("%s.cnt", KEY);
	private static final String CAMPO_BORRADO = String.format("%s.borrado", KEY);;
	
	private final DataContainerPayload data;

	public DataContainerPayload getData() {
		return data;
	}

	public TerminoAcuerdoContratoPayload(DataContainerPayload data) {
		this.data = data;
	}
	
	public TerminoAcuerdoContratoPayload(String tipo, TerminoContrato termino) {
		this.data = new DataContainerPayload(tipo);
		build(termino);
	}

	public TerminoAcuerdoContratoPayload build(TerminoContrato termino) {
		if (Checks.esNulo(termino.getGuid())) {
			throw new IntegrationDataException(String.format("[INTEGRACION] El Termino Contrato con ID %d del Acuerdo no tiene referencia de sincronización GUID", termino.getId()));
		}
		this.addGuid(termino.getGuid());
		this.addIdOrigen(termino.getId());
		this.addContratoGuid(termino.getContrato().getNroContrato());
		return this;
	}

	public Long getIdOrigen() {
		return data.getIdOrigen(KEY);
	}
	public void addIdOrigen(Long valor) {
		data.addSourceId(KEY, valor);
	}

	public String getGuid() {
		return data.getGuid(KEY);
	}
	public void addGuid(String valor) {
		data.addGuid(KEY, valor);
	}

	public String getContratoGuid() {
		return data.getGuid(CAMPO_CONTRATO);
	}
	public void addContratoGuid(String valor) {
		data.addGuid(CAMPO_CONTRATO, valor);
	}

	public void setBorrado(Boolean valor) {
		data.addFlag(CAMPO_BORRADO, valor);
	}
	public boolean isBorrado() {
		return data.getFlag(CAMPO_BORRADO);
	}

}
