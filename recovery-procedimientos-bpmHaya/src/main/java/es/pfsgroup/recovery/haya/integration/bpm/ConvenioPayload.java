package es.pfsgroup.recovery.haya.integration.bpm;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.integration.IntegrationClassCastException;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.concursal.convenio.model.Convenio;
import es.pfsgroup.concursal.convenio.model.ConvenioCredito;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJProcedimiento;
import es.pfsgroup.recovery.integration.DataContainerPayload;
import es.pfsgroup.recovery.integration.IntegrationDataException;
import es.pfsgroup.recovery.integration.bpm.payload.AsuntoPayload;

public class ConvenioPayload {
	
	private static final String KEY = "@cov";

	private static final String CAMPO_GUID_PROCEDIMIENTO = String.format("%s.prc_guid", KEY);
	private static final String CAMPO_FECHA = String.format("%s.fecha", KEY);
	private static final String CAMPO_NUM_PROPONENTES = String.format("%s.numProponentes", KEY);
	private static final String CAMPO_TOTAL_MASA = String.format("%s.totalMasa", KEY);
	private static final String CAMPO_PORCENTAJE = String.format("%s.porcentaje", KEY);
	private static final String CAMPO_ADHERIRSE = String.format("%s.adherirse", KEY);
	private static final String CAMPO_TIPO_CONVENIO = String.format("%s.tipoConvenio", KEY);
	private static final String CAMPO_INICIO_CONVENIO = String.format("%s.inicioConvenio", KEY);
	private static final String CAMPO_ESTADO_CONVENIO = String.format("%s.estadoConvenio", KEY);
	private static final String CAMPO_POSTURA_CONVENIO = String.format("%s.posturaConvenio", KEY);
	private static final String CAMPO_DESCRIPCION = String.format("%s.descripcion", KEY);
	private static final String CAMPO_DESCRIPCION_TERCEROS = String.format("%s.descripcionTerceros", KEY);
	private static final String CAMPO_DESCRIPCION_ANTICIPADO = String.format("%s.descripcionAnticipado", KEY);
	private static final String CAMPO_DESCRIPCION_ADHESIONES = String.format("%s.descripcionAdhesiones", KEY);
	private static final String CAMPO_TIPO_ALTERNATIVA = String.format("%s.tipoAlternativa", KEY);
	private static final String CAMPO_TIPO_ADHESION = String.format("%s.tipoAdhesion", KEY);
	private static final String CAMPO_DESCRIPCION_CONVENIO = String.format("%s.descripcionConvenio", KEY);
	private static final String CAMPO_TOTAL_MASA_ORD = String.format("%s.totalMasaOrd", KEY);
	private static final String CAMPO_PORCENTAJE_ORD = String.format("%s.porcentajeOrd", KEY);
	private static final String CAMPO_BORRADO = String.format("%s.borrado", KEY);
		
	private final DataContainerPayload data;
	private final AsuntoPayload asunto;
	
	public ConvenioPayload(DataContainerPayload data) 
	{
		this.data = data;
		this.asunto = new AsuntoPayload(data);
	}
	
	public ConvenioPayload(String tipo, Convenio convenio) 
	{
		this(new DataContainerPayload(null, null), convenio);
	}

	public ConvenioPayload(DataContainerPayload data, Convenio convenio) 
	{
		this.data = data;
		this.asunto = new AsuntoPayload(data, convenio.getProcedimiento().getAsunto());
		
		build(convenio);
	}
	
	public AsuntoPayload getAsunto() 
	{
		return asunto;
	}
	
	public void build(Convenio convenio) 
	{
		setGuid(convenio.getGuid());
		setId(convenio.getId());
		
		Procedimiento proc = convenio.getProcedimiento();
		MEJProcedimiento procedimiento = MEJProcedimiento.instanceOf(proc);
		if (procedimiento==null) {
			throw new IntegrationClassCastException(MEJProcedimiento.class, proc.getClass(), String.format("No se puede recuperar SYS_GUID para el procedimiento %d.", proc.getId()));
		}
		
		if (Checks.esNulo(procedimiento.getGuid())) {
			throw new IntegrationDataException(String.format("[INTEGRACION] El procedimiento ID: %d no tiene referencia de sincronización", procedimiento.getId()));
		}
		
		setGuidProcedimiento(procedimiento.getGuid());				
		setFecha(convenio.getFecha());
		setNumProponentes(convenio.getNumProponentes());
		setTotalMasa(convenio.getTotalMasa());
		setPorcentaje(convenio.getPorcentaje());
		
		if (convenio.getAdherirse() != null) {
			setAdherirse(convenio.getAdherirse().getCodigo());
		}
		
		if (convenio.getTipoConvenio() != null) {
			setTipoConvenio(convenio.getTipoConvenio().getCodigo());
		}
		
		if (convenio.getInicioConvenio() != null) {
			setInicioConvenio(convenio.getInicioConvenio().getCodigo());
		}
		
		if (convenio.getEstadoConvenio() != null) {
			setEstadoConvenio(convenio.getEstadoConvenio().getCodigo());
		}

		if (convenio.getPosturaConvenio() != null) {
			setPosturaConvenio(convenio.getPosturaConvenio().getCodigo());
		}

		setDescripcion(convenio.getDescripcion());
		setDescripcionTerceros(convenio.getDescripcionTerceros());
		setDescripcionAnticipado(convenio.getDescripcionAnticipado());
		setDescripcionAdhesiones(convenio.getDescripcionAdhesiones());

		if (convenio.getTipoAlternativa() != null) {
			setTipoAlternativa(convenio.getTipoAlternativa().getCodigo());
		}

		if (convenio.getTipoAdhesion() != null) {
			setTipoAdhesion(convenio.getTipoAdhesion().getCodigo());
		}

		setDescripcionConvenio(convenio.getDescripcionConvenio());
		setTotalMasaOrd(convenio.getTotalMasaOrd());
		setPorcentajeOrd(convenio.getPorcentajeOrd());
		setBorrado(convenio.getAuditoria().isBorrado());
		
		if (convenio.getConvenioCreditos() != null) {
			for(ConvenioCredito convenioCredito : convenio.getConvenioCreditos()) {
				ConvenioCreditoPayload convenioCreditoPayload = new ConvenioCreditoPayload(ConvenioCreditoPayload.KEY, convenioCredito);
				addConvenioCredito(convenioCreditoPayload);
			}
		}		
	}

	private void setGuidProcedimiento(String guidProcedimiento)
	{
		data.addGuid(CAMPO_GUID_PROCEDIMIENTO, guidProcedimiento);
	}
	
	public String getGuidProcedimiento() 
	{
		return data.getGuid(CAMPO_GUID_PROCEDIMIENTO);
	}
	
	private void setFecha(Date fecha) 
	{
		data.addFecha(CAMPO_FECHA, fecha);		
	}
	
	public Date getFecha()
	{
		return data.getFecha(CAMPO_FECHA);
	}
		
	public Long getNumProponentes() 
	{
		return data.getValLong(CAMPO_NUM_PROPONENTES);
	}

	private void setNumProponentes(Long numProponentes) 
	{
		data.addNumber(CAMPO_NUM_PROPONENTES, numProponentes);
	}

	public Float getTotalMasa() 
	{
		return data.getValFloat(CAMPO_TOTAL_MASA);
	}

	private void setTotalMasa(Float totalMasa) 
	{
		data.addNumber(CAMPO_TOTAL_MASA, totalMasa);
	}

	public Float getPorcentaje() 
	{
		return data.getValFloat(CAMPO_PORCENTAJE);
	}

	private void setPorcentaje(Float porcentaje) 
	{
		data.addNumber(CAMPO_PORCENTAJE, porcentaje);
	}

	public String getEstadoConvenio() 
	{
		return data.getCodigo(CAMPO_ESTADO_CONVENIO);
	}

	private void setEstadoConvenio(String estadoConvenio) 
	{
		data.addCodigo(CAMPO_ESTADO_CONVENIO, estadoConvenio);
	}

	public String getDescripcion() 
	{
		return data.getExtraInfo(CAMPO_DESCRIPCION);
	}

	private void setDescripcion(String descripcion) 
	{
		data.addExtraInfo(CAMPO_DESCRIPCION, descripcion);
	}

	public String getPosturaConvenio() 
	{
		return data.getCodigo(CAMPO_POSTURA_CONVENIO);
	}
	
	private void setPosturaConvenio(String posturaConvenio) 
	{
		data.addCodigo(CAMPO_POSTURA_CONVENIO, posturaConvenio);
	}
	
	private void setInicioConvenio(String inicioConvenio) 
	{
		data.addCodigo(CAMPO_INICIO_CONVENIO, inicioConvenio);
	}

	public String getInicioConvenio() 
	{
		return data.getCodigo(CAMPO_INICIO_CONVENIO);
	}

	private void setTipoConvenio(String tipoConvenio) 
	{
		data.addCodigo(CAMPO_TIPO_CONVENIO, tipoConvenio);
	}

	public String getTipoConvenio() 
	{
		return data.getCodigo(CAMPO_TIPO_CONVENIO);
	}

	private void setAdherirse(String adherirse) 
	{
		data.addCodigo(CAMPO_ADHERIRSE, adherirse);
	}

	public String getAdherirse() 
	{
		return data.getCodigo(CAMPO_ADHERIRSE);
	}

	private void setDescripcionTerceros(String descripcionTerceros) 
	{
		data.addExtraInfo(CAMPO_DESCRIPCION_TERCEROS, descripcionTerceros);
	}

	public String getDescripcionTerceros() 
	{
		return data.getExtraInfo(CAMPO_DESCRIPCION_TERCEROS);
	}

	private void setDescripcionAdhesiones(String descripcionAdhesiones) 
	{
		data.addExtraInfo(CAMPO_DESCRIPCION_ADHESIONES, descripcionAdhesiones);
	}

	public String getDescripcionAdhesiones() 
	{
		return data.getExtraInfo(CAMPO_DESCRIPCION_ADHESIONES);
	}

	private void setDescripcionAnticipado(String descripcionAnticipado) 
	{
		data.addExtraInfo(CAMPO_DESCRIPCION_ANTICIPADO, descripcionAnticipado);
	}

	public String getDescripcionAnticipado() 
	{
		return data.getExtraInfo(CAMPO_DESCRIPCION_ANTICIPADO);
	}
	
	public String getTipoAlternativa() 
	{
		return data.getCodigo(CAMPO_TIPO_ALTERNATIVA);
	}

	private void setTipoAlternativa(String tipoAlternativa) 
	{
		data.addCodigo(CAMPO_TIPO_ALTERNATIVA, tipoAlternativa);
	}

	private void setTipoAdhesion(String tipoAdhesion) 
	{
		data.addCodigo(CAMPO_TIPO_ADHESION, tipoAdhesion);
	}

	public String getTipoAdhesion() 
	{
		return data.getCodigo(CAMPO_TIPO_ADHESION);
	}

	private void setDescripcionConvenio(String descripcionConvenio) 
	{
		data.addExtraInfo(CAMPO_DESCRIPCION_CONVENIO, descripcionConvenio);
	}

	public String getDescripcionConvenio() 
	{
		return data.getExtraInfo(CAMPO_DESCRIPCION_CONVENIO);
	}

	private void setTotalMasaOrd(Float totalMasaOrd) 
	{
		data.addNumber(CAMPO_TOTAL_MASA_ORD, totalMasaOrd);
	}

	public Float getTotalMasaOrd() 
	{
		return data.getValFloat(CAMPO_TOTAL_MASA_ORD);
	}

	private void setPorcentajeOrd(Float porcentajeOrd) 
	{
		data.addNumber(CAMPO_PORCENTAJE_ORD, porcentajeOrd);
	}

	public Float getPorcentajeOrd() 
	{
		return data.getValFloat(CAMPO_PORCENTAJE_ORD);
	}
	
	private void setBorrado(boolean borrado) 
	{
		data.addFlag(CAMPO_BORRADO, borrado);
	}
	
	public boolean isBorrado() 
	{
		return data.getFlag(CAMPO_BORRADO);
	}

	private void setGuid(String valor) 
	{
		data.addGuid(KEY, valor);
	}
	
	public String getGuid() 
	{
		return data.getGuid(KEY);
	}
	
	private void setId(Long valor) 
	{
		data.addSourceId(KEY, valor);
	}
	
	public Long getId() 
	{
		return data.getIdOrigen(KEY);
	}
	
	private void addConvenioCredito(ConvenioCreditoPayload valor) 
	{
		this.data.addChildren(ConvenioCreditoPayload.KEY, valor.getData());
	}
	
	public List<ConvenioCreditoPayload> getConvenioCreditos() 
	{
		if (data.getChildren() == null || !data.getChildren().containsKey(ConvenioCreditoPayload.KEY)) {
			return null;
		}
		
		List<ConvenioCreditoPayload> listado = new ArrayList<ConvenioCreditoPayload>();
		List<DataContainerPayload> dataList = data.getChildren(ConvenioCreditoPayload.KEY);
		for (DataContainerPayload child : dataList) {
			ConvenioCreditoPayload container = new ConvenioCreditoPayload(child);
			listado.add(container);
		}
		return listado;
	}
}
