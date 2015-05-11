package es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.manager.test;

import java.io.IOException;
import java.io.InputStream;

import org.junit.Test;

import es.capgemini.devon.bo.BusinessOperationException;
import es.pfsgroup.commons.utils.Checks;

public class RecoveryAnotacionManagerTest {


	
	@Test
	public void testGetUsuarios() {
		InputStream in = this.getClass().getResourceAsStream("optionalConfiguration/template/mailTemplate.html");
		// indicadora de quien es el cliente?
		if (!Checks.esNulo(in)) {
			throw new BusinessOperationException("optionalConfiguration/mailTemplate.html" + ": no se encuentra el recurso");
		}
		
		try {
			if(in != null)in.close();
		} catch (IOException e) {
			e.printStackTrace();
		}

	}

	@Test
	public void testCreateAnotacion() {

	}

	@Test
	public void testCreateRespuesta() {
	
	}

	@Test
	public void testGetListaTiposAnotacion() {
		
	}

	@Test
	public void testGetAnotacionesAgenda() {
	
	}

	@Test
	public void testGetTipoAnotacionByCodigo() {
	
	}

	@Test
	public void testSetGenericDao() {
		
	}

	@Test
	public void testGetGenericDao() {
	
	}

	@Test
	public void testGetCustomize() {
		
	}

	@Test
	public void testGetCodigoLitigioAsu() {
		
	}

}
