package es.pfsgroup.recovery.integration.bpm;

import es.capgemini.pfs.integration.IntegrationClassCastException;
import es.capgemini.pfs.termino.model.TerminoBien;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.recovery.integration.DataContainerPayload;
import es.pfsgroup.recovery.integration.IntegrationDataException;

public class TerminoAcuerdoBienPayload {

	public final static String KEY = "@tea_bie";

	private static final String CAMPO_BIEN = String.format("%s.bie", KEY);
	private static final String CAMPO_BORRADO = String.format("%s.borrado", KEY);
	
	private final DataContainerPayload data;

	public DataContainerPayload getData() {
		return data;
	}

	public TerminoAcuerdoBienPayload(DataContainerPayload data) {
		this.data = data;
	}
	
	public TerminoAcuerdoBienPayload(String tipo, TerminoBien termino) {
		this.data = new DataContainerPayload(tipo);
		build(termino);
	}

	public TerminoAcuerdoBienPayload build(TerminoBien termino) {
		if (Checks.esNulo(termino.getGuid())) {
			throw new IntegrationDataException(String.format("[INTEGRACION] El Termino Bien con ID %d del Acuerdo no tiene referencia de sincronización GUID", termino.getId()));
		}
		NMBBien nmbBien = NMBBien.instanceOf(termino.getBien());
		if (nmbBien==null) {
			throw new IntegrationClassCastException(NMBBien.class, termino.getBien().getClass(), String.format("No se puede recuperar SYS_GUID para el bien %d.", termino.getBien().getId()));
		}
		this.addGuid(termino.getGuid());
		this.addIdOrigen(termino.getId());
		this.addBienGuid(nmbBien.getCodigoInterno());
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

	public String getBienGuid() {
		return data.getGuid(CAMPO_BIEN);
	}
	public void addBienGuid(String valor) {
		data.addGuid(CAMPO_BIEN, valor);
	}

	public void isBorrado(Boolean valor) {
		data.addFlag(CAMPO_BORRADO, valor);
	}
	public boolean isBorrado() {
		return data.getFlag(CAMPO_BORRADO);
	}
	
}
