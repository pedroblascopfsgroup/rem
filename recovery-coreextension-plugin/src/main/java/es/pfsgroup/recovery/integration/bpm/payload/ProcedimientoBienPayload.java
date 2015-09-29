package es.pfsgroup.recovery.integration.bpm.payload;

import es.pfsgroup.recovery.integration.DataContainerPayload;

public class ProcedimientoBienPayload {
	
	public static final String KEY_PROCEDIMIENTOBIEN = "@prb";
	private static final String CAMPO_BORRADO = String.format("%s.borrado", KEY_PROCEDIMIENTOBIEN);
	private static final String CAMPO_SOLVENCIAGARANTIA = String.format("%s.solvenciaGarantia", KEY_PROCEDIMIENTOBIEN);
	private static final String CAMPO_CODIGOINTERNO_BIEN = String.format("%s.codIntBien", KEY_PROCEDIMIENTOBIEN);

	private final DataContainerPayload data;

	public ProcedimientoBienPayload(DataContainerPayload data) {
		this.data = data;
	}
	
	public ProcedimientoBienPayload(String tipo) {
		this(new DataContainerPayload(null, null));
	}

	public DataContainerPayload getData() {
		return data;
	}

	public Long getIdOrigen() {
		return data.getIdOrigen(KEY_PROCEDIMIENTOBIEN);
	}
	
	public void setIdOrigen(Long id) {
		data.addSourceId(KEY_PROCEDIMIENTOBIEN, id);
	}

	public String getGuid() {
		return data.getGuid(KEY_PROCEDIMIENTOBIEN);
	}
	
	public void setGuid(String guid) {
		data.addGuid(KEY_PROCEDIMIENTOBIEN, guid);
	}

	public void setBorrado(boolean borrado) {
		data.addFlag(CAMPO_BORRADO, borrado);
	}
	public boolean getBorrado() {
		return data.getFlag(CAMPO_BORRADO);
	}

	public void setSolvenciaGarantia(String codigo) {
		data.addCodigo(CAMPO_SOLVENCIAGARANTIA, codigo);
	}
	public String getSolvenciaGaratia() {
		return data.getCodigo(CAMPO_SOLVENCIAGARANTIA);
	}

	public void setCodigoInternoDelBien(String codigoInterno) {
		data.addCodigo(CAMPO_CODIGOINTERNO_BIEN, codigoInterno);
	}

	public String getCodigoInternoDelBien() {
		return data.getCodigo(CAMPO_CODIGOINTERNO_BIEN);
	}
	
}
