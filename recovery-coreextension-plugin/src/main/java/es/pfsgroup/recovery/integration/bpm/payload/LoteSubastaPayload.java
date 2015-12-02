package es.pfsgroup.recovery.integration.bpm.payload;

import java.util.Date;
import java.util.List;

import es.capgemini.pfs.bien.model.Bien;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.LoteSubasta;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.recovery.integration.DataContainerPayload;

public class LoteSubastaPayload {
	
	public static final String KEY = "@los";

	private static final String CAMPO_OBSERVACIONES_COMITE = String.format("%s.obsComite", KEY);
	private static final String CAMPO_DEUDA_JUDICIAL = String.format("%s.obs.deudaJud", KEY);
	private static final String CAMPO_RIESGO_CONSIGNACION = String.format("%s.riesgoCons", KEY);
	private static final String CAMPO_OBSERVACIONES = String.format("%s.obs", KEY);
	private static final String CAMPO_INS_70 = String.format("%s.ins70", KEY);
	private static final String CAMPO_INS_60 = String.format("%s.ins60", KEY);
	private static final String CAMPO_INS_50 = String.format("%s.ins50", KEY);
	private static final String CAMPO_INS_VALOR = String.format("%s.valor", KEY);
	private static final String CAMPO_INS_VALOR_SIN_BIENES = String.format("%s.valorSinBienes", KEY);
	private static final String CAMPO_INS_PUJA_POSTORES_HASTA = String.format("%s.pujaPostHasta", KEY);
	private static final String CAMPO_INS_PUJA_POSTORES_DESDE = String.format("%s.pujaPostDesde", KEY);
	private static final String CAMPO_INS_PUJA_SIN_POSTORES = String.format("%s.pujaSinPost", KEY);
	private static final String CAMPO_NUM_LOTE = String.format("%s.numLote", KEY);
	private static final String CAMPO_BORRADO = String.format("%s.borrado", KEY);
	private static final String CAMPO_ESTADO = String.format("%s.estado", KEY);
	private static final String CAMPO_FECHA_ESTADO = String.format("%s.fechaEstado", KEY);
	private static final String RELACION_BIENES = String.format("%s.bie", KEY);
	
	private final DataContainerPayload data;

	public DataContainerPayload getData() {
		return data;
	}

	public LoteSubastaPayload(DataContainerPayload data) {
		this.data = data;
	}
	
	public LoteSubastaPayload(String tipo, LoteSubasta loteSubasta) {
		this(new DataContainerPayload(null, null), loteSubasta);
	}

	public LoteSubastaPayload(DataContainerPayload data, LoteSubasta loteSubasta) {
		this.data = data;
		build(loteSubasta);
	}
	
	public void build(LoteSubasta loteSubasta) {

		setGuid(loteSubasta.getGuid());
		setId(loteSubasta.getId());
		
		setNumLote(loteSubasta.getNumLote());
		setInsPujaSinPostores(loteSubasta.getInsPujaSinPostores());
		setInsPujaPostoresDesde(loteSubasta.getInsPujaPostoresDesde());
		setInsPujaPostoresHasta(loteSubasta.getInsPujaPostoresHasta());
		setInsValorSubastaSinBienes(loteSubasta.getInsValorSubastaSinBienes());
		setInsValorSubasta(loteSubasta.getInsValorSubasta());
		setIns50DelTipoSubasta(loteSubasta.getIns50DelTipoSubasta());
		setIns60DelTipoSubasta(loteSubasta.getIns60DelTipoSubasta());
		setIns70DelTipoSubasta(loteSubasta.getIns70DelTipoSubasta());
		setObservaciones(loteSubasta.getObservaciones());
		setBorrado(loteSubasta.getAuditoria().isBorrado());

		setRiesgoConsignacion(loteSubasta.getRiesgoConsignacion());
		setDeudaJudicial(loteSubasta.getDeudaJudicial());
		setObservacionesComite(loteSubasta.getObservacionesComite());
		if (loteSubasta.getEstado()!=null) {
			setEstado(loteSubasta.getEstado().getCodigo());	
		}
		setFechaEstado(loteSubasta.getFechaEstado());
		
		
		List<Bien> bienes = loteSubasta.getBienes();
		for(Bien bien : bienes) {
			NMBBien nmbBien = NMBBien.instanceOf(bien);
			addBienRelacionado(nmbBien);
		}
		
	}

	private void setEstado(String codigo) {
		data.addCodigo(CAMPO_ESTADO, codigo);
	}
	public String getEstado() {
		return data.getCodigo(CAMPO_ESTADO);
	}

	private void setFechaEstado(Date fechaEstado) {
		data.addFecha(CAMPO_FECHA_ESTADO, fechaEstado);
	}
	public Date getFechaEstado() {
		return data.getFecha(CAMPO_FECHA_ESTADO);
	}

	private void setObservacionesComite(String observacionesComite) {
		data.addExtraInfo(CAMPO_OBSERVACIONES_COMITE, observacionesComite);
	}
	public String getObservacionesComite() {
		return data.getExtraInfo(CAMPO_OBSERVACIONES_COMITE);
	}

	private void setDeudaJudicial(Float deudaJudicial) {
		data.addNumber(CAMPO_DEUDA_JUDICIAL, deudaJudicial);
	}
	public Float getDeudaJudicial() {
		return data.getValFloat(CAMPO_DEUDA_JUDICIAL);
	}

	private void setRiesgoConsignacion(Boolean riesgoConsignacion) {
		data.addFlag(CAMPO_RIESGO_CONSIGNACION, riesgoConsignacion);
	}
	public Boolean getRiesgoConsignacion() {
		return data.getFlag(CAMPO_RIESGO_CONSIGNACION);
	}

	private void setObservaciones(String observaciones) {
		data.addExtraInfo(CAMPO_OBSERVACIONES, observaciones);
	}
	public String getObservaciones() {
		return data.getExtraInfo(CAMPO_OBSERVACIONES);
	}

	private void setIns70DelTipoSubasta(Float ins70DelTipoSubasta) {
		data.addNumber(CAMPO_INS_70, ins70DelTipoSubasta);
	}
	public Float getIns70DelTipoSubasta() {
		return data.getValFloat(CAMPO_INS_70);
	}

	private void setIns60DelTipoSubasta(Float ins60DelTipoSubasta) {
		data.addNumber(CAMPO_INS_60, ins60DelTipoSubasta);
	}
	public Float getIns60DelTipoSubasta() {
		return data.getValFloat(CAMPO_INS_60);
	}

	private void setIns50DelTipoSubasta(Float ins50DelTipoSubasta) {
		data.addNumber(CAMPO_INS_50, ins50DelTipoSubasta);
	}
	public Float getIns50DelTipoSubasta() {
		return data.getValFloat(CAMPO_INS_50);
	}

	private void setInsValorSubasta(Float insValorSubasta) {
		data.addNumber(CAMPO_INS_VALOR, insValorSubasta);
	}
	public Float getInsValorSubasta() {
		return data.getValFloat(CAMPO_INS_VALOR);
	}

	private void setInsValorSubastaSinBienes(Float insValorSubastaSinBienes) {
		data.addNumber(CAMPO_INS_VALOR_SIN_BIENES, insValorSubastaSinBienes);
	}
	public Float getInsValorSubastaSinBienes() {
		return data.getValFloat(CAMPO_INS_VALOR_SIN_BIENES);
	}

	private void setInsPujaPostoresHasta(Float insPujaPostoresHasta) {
		data.addNumber(CAMPO_INS_PUJA_POSTORES_HASTA, insPujaPostoresHasta);
	}
	public Float getInsPujaPostoresHasta() {
		return data.getValFloat(CAMPO_INS_PUJA_POSTORES_HASTA);
	}
	
	private void setInsPujaPostoresDesde(Float insPujaPostoresDesde) {
		data.addNumber(CAMPO_INS_PUJA_POSTORES_DESDE, insPujaPostoresDesde);
	}
	public Float getInsPujaPostoresDesde() {
		return data.getValFloat(CAMPO_INS_PUJA_POSTORES_DESDE);
	}

	private void setInsPujaSinPostores(Float insPujaSinPostores) {
		data.addNumber(CAMPO_INS_PUJA_SIN_POSTORES, insPujaSinPostores);
	}
	public Float getInsPujaSinPostores() {
		return data.getValFloat(CAMPO_INS_PUJA_SIN_POSTORES);
	}

	private void setNumLote(Integer numLote) {
		data.addNumber(CAMPO_NUM_LOTE, numLote);
	}
	public Integer getNumLote() {
		return data.getValInt(CAMPO_NUM_LOTE);
	}

	private void setGuid(String valor) {
		data.addGuid(KEY, valor);
	}
	public String getGuid() {
		return data.getGuid(KEY);
	}
	
	private void setId(Long valor) {
		data.addSourceId(KEY, valor);
	}
	public Long getId() {
		return data.getIdOrigen(KEY);
	}
	
	private void setBorrado(boolean borrado) {
		data.addFlag(CAMPO_BORRADO, borrado);
	}
	public void isBorrado() {
		data.getFlag(CAMPO_BORRADO);
	}

	private void addBienRelacionado(NMBBien bien) {
		this.data.addRelacion(RELACION_BIENES, bien.getCodigoInterno());
	}
	public List<String> getBienesRelacionados() {
		return data.getRelaciones(RELACION_BIENES);
	}
	
}
