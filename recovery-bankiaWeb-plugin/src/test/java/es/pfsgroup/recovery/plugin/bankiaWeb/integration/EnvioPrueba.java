package es.pfsgroup.recovery.plugin.bankiaWeb.integration;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.integration.core.MessageChannel;

import es.capgemini.pfs.integration.Producer;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;

public class EnvioPrueba extends Producer<Pojo, Pojo> {

	public final static String CODIGO_MENSAJE = "ENVIO-PRUEBA";

	@Autowired
	private GenericABMDao genericDao;
	
	public EnvioPrueba(MessageChannel channel) {
		super(channel);
	}

	@Override
	public String getCode() {
		return CODIGO_MENSAJE;
	}

	@Override
	protected Pojo getMessagePayload(Pojo object) {
		return object;
	}
	
}
