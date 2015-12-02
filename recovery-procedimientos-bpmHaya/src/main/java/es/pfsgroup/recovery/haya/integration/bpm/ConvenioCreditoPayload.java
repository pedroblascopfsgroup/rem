package es.pfsgroup.recovery.haya.integration.bpm;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.concursal.convenio.model.Convenio;
import es.pfsgroup.concursal.convenio.model.ConvenioCredito;
import es.pfsgroup.concursal.credito.model.Credito;
import es.pfsgroup.recovery.integration.DataContainerPayload;
import es.pfsgroup.recovery.integration.IntegrationDataException;

public class ConvenioCreditoPayload {
	
	public static final String KEY = "@covcre";

	private static final String CAMPO_GUID_CONVENIO = String.format("%s.cov_guid", KEY);
	private static final String CAMPO_GUID_CREDITO = String.format("%s.cre_cex_guid", KEY);
	private static final String CAMPO_QUITA = String.format("%s.quita", KEY);
	private static final String CAMPO_ESPERA = String.format("%s.obs.espera", KEY);
	private static final String CAMPO_CARENCIA = String.format("%s.carencia", KEY);
	private static final String CAMPO_COMENTARIO = String.format("%s.comentario", KEY);
	private static final String CAMPO_CONFORMIDAD_CONVENIO = String.format("%s.conformidadConvenio", KEY);
	private static final String CAMPO_BORRADO = String.format("%s.borrado", KEY);
	
	private final DataContainerPayload data;
	
	public ConvenioCreditoPayload(DataContainerPayload data) 
	{
		this.data = data;
	}
	
	public ConvenioCreditoPayload(String tipo, ConvenioCredito convenioCredito) 
	{
		this(new DataContainerPayload(null, null), convenioCredito);
	}

	public ConvenioCreditoPayload(DataContainerPayload data, ConvenioCredito convenioCredito) 
	{
		this.data = data;
		build(convenioCredito);
	}
	
	public DataContainerPayload getData() 
	{
		return data;
	}
		
	public void build(ConvenioCredito convenioCredito) 
	{

		setGuid(convenioCredito.getGuid());
		setId(convenioCredito.getId());
		
		Convenio convenio = convenioCredito.getConvenio();
		
		if (Checks.esNulo(convenio.getGuid())) {
			throw new IntegrationDataException(String.format("[INTEGRACION] El convenio ID: %d no tiene referencia de sincronización", convenio.getId()));
		}
		
		setGuidConvenio(convenio.getGuid());
		
		Credito credito = convenioCredito.getCredito();
		
		if (Checks.esNulo(convenio.getGuid())) {
			throw new IntegrationDataException(String.format("[INTEGRACION] El crédito ID: %d no tiene referencia de sincronización", credito.getId()));
		}
		
		setGuidCredito(credito.getGuid());
		setQuita(convenioCredito.getQuita());
		setEspera(convenioCredito.getEspera());
		setCarencia(convenioCredito.getCarencia());
		setComentario(convenioCredito.getComentario());
		
		if(convenioCredito.getConformidadConvenio() != null) {
			setConformidadConvenio(convenioCredito.getConformidadConvenio().getCodigo());
		}
		
		setBorrado(convenioCredito.getAuditoria().isBorrado());
	}
	
	private void setGuidConvenio(String guidConvenio)
	{
		data.addGuid(CAMPO_GUID_CONVENIO, guidConvenio);
	}
	
	public String getGuidConvenio() 
	{
		return data.getGuid(CAMPO_GUID_CONVENIO);
	}
	
	private void setGuidCredito(String guidCredito)
	{
		data.addGuid(CAMPO_GUID_CREDITO, guidCredito);
	}
	
	public String getGuidCredito() 
	{
		return data.getGuid(CAMPO_GUID_CREDITO);
	}
	
	private void setQuita(Float quita) 
	{
		data.addNumber(CAMPO_QUITA, quita);
	}
	
	public Float getQuita() 
	{
		return data.getValFloat(CAMPO_QUITA);
	}

	private void setEspera(Float espera) 
	{
		data.addNumber(CAMPO_ESPERA, espera);
	}
	
	public Float getEspera() 
	{
		return data.getValFloat(CAMPO_ESPERA);
	}

	private void setCarencia(Float carencia) 
	{
		data.addNumber(CAMPO_CARENCIA, carencia);
	}
	
	public Float getCarencia() 
	{
		return data.getValFloat(CAMPO_CARENCIA);
	}

	private void setComentario(String comentario) 
	{
		data.addExtraInfo(CAMPO_COMENTARIO, comentario);
	}
	
	public String getComentario() 
	{
		return data.getExtraInfo(CAMPO_COMENTARIO);
	}

	private void setConformidadConvenio(String conformidadConvenio) 
	{
		data.addCodigo(CAMPO_CONFORMIDAD_CONVENIO, conformidadConvenio);
	}
	
	public String getConformidadConvenio() 
	{
		return data.getCodigo(CAMPO_CONFORMIDAD_CONVENIO);
	}
	
	private void setBorrado(boolean borrado) 
	{
		data.addFlag(CAMPO_BORRADO, borrado);
	}
	
	public void isBorrado() 
	{
		data.getFlag(CAMPO_BORRADO);
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
}
