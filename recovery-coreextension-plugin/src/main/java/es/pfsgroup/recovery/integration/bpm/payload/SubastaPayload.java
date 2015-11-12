package es.pfsgroup.recovery.integration.bpm.payload;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import es.pfsgroup.plugin.recovery.coreextension.subasta.model.LoteSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.Subasta;
import es.pfsgroup.recovery.integration.DataContainerPayload;

public class SubastaPayload {
	
	private static final String KEY = "@sub";

	private static final String CAMPO_ESTADO_ASUNTO = String.format("%s.estadoAsunto", KEY);
	private static final String CAMPO_MOTIVO_SUSPENSION = String.format("%s.motivoSuspension", KEY);
	private static final String CAMPO_RESULTADO_COMITE = String.format("%s.resultadoComite", KEY);
	private static final String CAMPO_ESTADO_SUBASTA = String.format("%s.estado", KEY);
	private static final String CAMPO_TIPO_SUBASTA = String.format("%s.tipo", KEY);
	private static final String CAMPO_DEUDA_JUDICIAL = String.format("%s.deudaJudicial", KEY);
	private static final String CAMPO_COSTAS_LETRADO = String.format("%s.costasLetrado", KEY);
	private static final String CAMPO_FECHA_ANUNCIO = String.format("%s.fechaAnuncio", KEY);
	private static final String CAMPO_FECHA_SENYALAMIENTO = String.format("%s.fechaSenyal", KEY);
	private static final String CAMPO_FECHA_SOLICITUD = String.format("%s.fechaSolicitud", KEY);
	private static final String CAMPO_NUM_AUTOS = String.format("%s.numAutos", KEY);
	private static final String CAMPO_BORRADO = String.format("%s.borrado", KEY);
	
	private final DataContainerPayload data;
	private final ProcedimientoPayload procedimiento;

	public SubastaPayload(DataContainerPayload data) {
		this.data = data;
		this.procedimiento = new ProcedimientoPayload(data);
	}
	
	public SubastaPayload(String tipo, Subasta subasta) {
		this(new DataContainerPayload(null, null), subasta);
	}

	public SubastaPayload(DataContainerPayload data, Subasta subasta) {
		this.data = data;
		this.procedimiento = new ProcedimientoPayload(data, subasta.getProcedimiento());
		build(subasta);
	}
	
	public ProcedimientoPayload getProcedimiento() {
		return procedimiento;
	}

	public void build(Subasta subasta) {

		setGuid(subasta.getGuid());
		setId(subasta.getId());
		if (subasta.getTipoSubasta()!=null) {
			setTipoSubasta(subasta.getTipoSubasta().getCodigo());
		}
		if (subasta.getEstadoSubasta()!=null) {
			setEstadoSubasta(subasta.getEstadoSubasta().getCodigo());
		}
		if (subasta.getResultadoComite()!=null) {
			setResultadoComite(subasta.getResultadoComite().getCodigo());
		}
		if (subasta.getMotivoSuspension()!=null) {
			setMotivoSuspension(subasta.getMotivoSuspension().getCodigo());
		}
		if (subasta.getEstadoAsunto()!=null) {
			setEstadoAsunto(subasta.getEstadoAsunto().getCodigo());
		}
		setNumAutos(subasta.getNumAutos());
		setFechaSolicitud(subasta.getFechaSolicitud());
		setFechaSenyalamiento(subasta.getFechaSenyalamiento());
		setFechaAnuncio(subasta.getFechaAnuncio());
		setCostasLetrado(subasta.getCostasLetrado());
		setDeudaJudicial(subasta.getDeudaJudicial());
		setBorrado(subasta.getAuditoria().isBorrado());
	
		// lotes de subasta
		if (subasta.getLotesSubasta()!=null) {
			List<LoteSubasta> lotes = subasta.getLotesSubasta();
			for(LoteSubasta lote : lotes) {
				LoteSubastaPayload lotePayload = new LoteSubastaPayload(LoteSubastaPayload.KEY, lote);
				addLoteSubasta(lotePayload);
			}
		}
		
	}

	private void setBorrado(boolean borrado) {
		data.addFlag(CAMPO_BORRADO, borrado);
	}
	public void isBorrado() {
		data.getFlag(CAMPO_BORRADO);
	}

	private void setDeudaJudicial(Float deudaJudicial) {
		data.addNumber(CAMPO_DEUDA_JUDICIAL, deudaJudicial);
	}
	public Float getDeudaJudicial() {
		return data.getValFloat(CAMPO_DEUDA_JUDICIAL);
	}
	
	private void setCostasLetrado(Float costasLetrado) {
		data.addNumber(CAMPO_COSTAS_LETRADO, costasLetrado);
	}
	public Float getCostasLetrado() {
		return data.getValFloat(CAMPO_COSTAS_LETRADO);
	}

	private void setFechaAnuncio(Date fechaAnuncio) {
		data.addFecha(CAMPO_FECHA_ANUNCIO, fechaAnuncio);
	}
	public Date getFechaAnuncio() {
		return data.getFecha(CAMPO_FECHA_ANUNCIO);
	}

	private void setFechaSenyalamiento(Date fechaSenyalamiento) {
		data.addFecha(CAMPO_FECHA_SENYALAMIENTO,  fechaSenyalamiento);
	}
	public Date getFechaSenyalamiento() {
		return data.getFecha(CAMPO_FECHA_SENYALAMIENTO);
	}

	private void setFechaSolicitud(Date fechaSolicitud) {
		data.addFecha(CAMPO_FECHA_SOLICITUD,  fechaSolicitud);
	}
	public Date getFechaSolicitud() {
		return data.getFecha(CAMPO_FECHA_SOLICITUD);
	}

	private void setNumAutos(String numAutos) {
		data.addExtraInfo(CAMPO_NUM_AUTOS,  numAutos);
	}
	public String getNumAutos() {
		return data.getExtraInfo(CAMPO_NUM_AUTOS);
	}

	private void setEstadoAsunto(String codigo) {
		data.addCodigo(CAMPO_ESTADO_ASUNTO,  codigo);
	}
	public String getEstadoAsunto() {
		return data.getCodigo(CAMPO_ESTADO_ASUNTO);
	}

	private void setMotivoSuspension(String codigo) {
		data.addCodigo(CAMPO_MOTIVO_SUSPENSION, codigo);	
	}
	public String getMotivoSuspension() {
		return data.getCodigo(CAMPO_MOTIVO_SUSPENSION);
	}

	private void setResultadoComite(String codigo) {
		data.addCodigo(CAMPO_RESULTADO_COMITE, codigo);	
	}
	public String getResultadoComite() {
		return data.getCodigo(CAMPO_RESULTADO_COMITE);
	}

	private void setEstadoSubasta(String codigo) {
		data.addCodigo(CAMPO_ESTADO_SUBASTA, codigo);	
	}
	public String getEstadoSubasta() {
		return data.getCodigo(CAMPO_ESTADO_SUBASTA);
	}

	private void setTipoSubasta(String codigo) {
		data.addCodigo(CAMPO_TIPO_SUBASTA, codigo);	
	}
	public String getTipoSubasta() {
		return data.getCodigo(CAMPO_TIPO_SUBASTA);
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
	
	private void addLoteSubasta(LoteSubastaPayload valor) {
		this.data.addChildren(LoteSubastaPayload.KEY, valor.getData());
	}
	
	public List<LoteSubastaPayload> getLotesSubasta() {
		List<LoteSubastaPayload> listado = new ArrayList<LoteSubastaPayload>();
		if (data.getChildren()==null ||
				!data.getChildren().containsKey(LoteSubastaPayload.KEY)) {
			return listado;
		}
		List<DataContainerPayload> dataList = data.getChildren(LoteSubastaPayload.KEY);
		for (DataContainerPayload child : dataList) {
			LoteSubastaPayload container = new LoteSubastaPayload(child);
			listado.add(container);
		}
		return listado;
	}
	
}
