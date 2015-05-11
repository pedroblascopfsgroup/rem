package es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.web.test;

import static org.junit.Assert.*;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import static org.mockito.Mockito.when;
import org.mockito.runners.MockitoJUnitRunner;
import org.springframework.ui.ModelMap;

import es.capgemini.pfs.asunto.model.Asunto;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.agendaMultifuncion.impl.web.RecoveryAgendaMultifuncionAnotacionController;
import es.pfsgroup.recovery.api.AsuntoApi;

@RunWith(MockitoJUnitRunner.class)
public class RecoveryAgendaMultifuncionAnotacionControllerTest {

	@InjectMocks RecoveryAgendaMultifuncionAnotacionController recoveryAgendaMultifuncionAnotacionController;
	
	@Mock ApiProxyFactory mockProxyFactory;
	@Mock AsuntoApi mockAsuntoApi;
	
	@Test
	public void testGetAdjuntosEntidad(){
		ModelMap map =new ModelMap();
		Long idAsunto = 1L;
		
		Asunto asunto=new Asunto();
		
		when(mockProxyFactory.proxy(AsuntoApi.class)).thenReturn(mockAsuntoApi);
		when(mockAsuntoApi.get(idAsunto)).thenReturn(asunto);
		
		String resultado=recoveryAgendaMultifuncionAnotacionController.getAdjuntosEntidad(idAsunto, "3", map);
		
		assertEquals(RecoveryAgendaMultifuncionAnotacionController.ADJUNTOS_ASUNTO, resultado);
	}
}
