package es.pfsgroup.plugin.recovery.masivo.test;

import static org.junit.Assert.*;
import static org.mockito.Mockito.reset;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.mockito.Mockito.any;

import org.junit.After;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;

import es.capgemini.pfs.asunto.model.DDEstadoAsunto;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.masivo.api.impl.MSVAsuntoManager;
import es.pfsgroup.plugin.recovery.masivo.model.MSVResolucion;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAsunto;

@RunWith(MockitoJUnitRunner.class)
public class MSVAsuntoManagerTest {

	@InjectMocks MSVAsuntoManager msvAsuntoManager;
	
	@Mock
	GenericABMDao mockGenericDao;
	
	/**
	 * Comprobamos que el método comprobarEstadoAsunto 
	 * (que recibe un Dto que contiene el Id del asunto)
	 * realiza correctamente las siguientes comprobaciones:
	 * 		El asunto exista.
	 * 		No esté borrado.
	 * 		Esté en estado 3 (Aceptado). 
	 */
	@Test
	public void testComprobarEstadoAsunto() {
		
		String nomAsunto = "";
		boolean asuntoValido = false;
		Filter filtroExiste;
		Filter filtroNoBorrado;
		Filter filtroEstadoAceptado;
		
		// Probar que si se le pasa un asunto que no existe, devuelve false
		nomAsunto = "LIN-NO-EXISTE";
		
		filtroExiste = mockGenericDao.createFilter(FilterType.EQUALS, "nombre", nomAsunto);
		filtroNoBorrado = mockGenericDao.createFilter(FilterType.EQUALS, "borrado", 0);
		filtroEstadoAceptado = mockGenericDao.createFilter(FilterType.EQUALS, "estadoAsunto", DDEstadoAsunto.ESTADO_ASUNTO_ACEPTADO);
		when(mockGenericDao.get(EXTAsunto.class, filtroExiste, filtroNoBorrado, filtroEstadoAceptado)).thenReturn(null);

		asuntoValido = msvAsuntoManager.comprobarEstadoAsunto(nomAsunto);
		assertFalse("No se ha detectado asunto inexistente", asuntoValido);
		verify(mockGenericDao,times(1)).get(EXTAsunto.class, filtroExiste, filtroNoBorrado, filtroEstadoAceptado);
		reset(mockGenericDao);
		
		// Probar que si se le pasa un asunto cuyo campo borrado=1, devuelve false
		nomAsunto = "LIN-0001";
		
		filtroExiste = mockGenericDao.createFilter(FilterType.EQUALS, "nombre", nomAsunto);
		filtroNoBorrado = mockGenericDao.createFilter(FilterType.EQUALS, "borrado", 1);
		filtroEstadoAceptado = mockGenericDao.createFilter(FilterType.EQUALS, "estadoAsunto", DDEstadoAsunto.ESTADO_ASUNTO_ACEPTADO);
		when(mockGenericDao.get(EXTAsunto.class, filtroExiste, filtroNoBorrado, filtroEstadoAceptado)).thenReturn(null);

		asuntoValido = msvAsuntoManager.comprobarEstadoAsunto(nomAsunto);
		assertFalse("No se ha detectado asunto borrado", asuntoValido);
		verify(mockGenericDao,times(1)).get(EXTAsunto.class, filtroExiste, filtroNoBorrado, filtroEstadoAceptado);
		reset(mockGenericDao);
		
		
		// Probar que si se le pasa un asunto cuyo campo estado es distinto de 3, devuelve false
		nomAsunto = "LIN-0001";
		
		filtroExiste = mockGenericDao.createFilter(FilterType.EQUALS, "nombre", nomAsunto);
		filtroNoBorrado = mockGenericDao.createFilter(FilterType.EQUALS, "borrado", 0);
		filtroEstadoAceptado = mockGenericDao.createFilter(FilterType.EQUALS, "estadoAsunto", DDEstadoAsunto.ESTADO_ASUNTO_CERRADO);
		when(mockGenericDao.get(EXTAsunto.class, filtroExiste, filtroNoBorrado, filtroEstadoAceptado)).thenReturn(null);

		asuntoValido = msvAsuntoManager.comprobarEstadoAsunto(nomAsunto);
		assertFalse("No se ha detectado asunto cerrado", asuntoValido);
		verify(mockGenericDao,times(1)).get(EXTAsunto.class, filtroExiste, filtroNoBorrado, filtroEstadoAceptado);
		reset(mockGenericDao);
		
		// Probar que devuelve true si se le pasa un asunto que cumple las tres condiciones
		nomAsunto = "LIN-0001";
		
		filtroExiste = mockGenericDao.createFilter(FilterType.EQUALS, "nombre", nomAsunto);
		filtroNoBorrado = mockGenericDao.createFilter(FilterType.EQUALS, "borrado", 0);
		filtroEstadoAceptado = mockGenericDao.createFilter(FilterType.EQUALS, "estadoAsunto", DDEstadoAsunto.ESTADO_ASUNTO_ACEPTADO);
		when(mockGenericDao.get(EXTAsunto.class, filtroExiste, filtroNoBorrado, filtroEstadoAceptado)).thenReturn(new EXTAsunto());

		asuntoValido = msvAsuntoManager.comprobarEstadoAsunto(nomAsunto);
		assertTrue("No se ha detectado que es un asunto valido", asuntoValido);
		verify(mockGenericDao,times(1)).get(EXTAsunto.class, filtroExiste, filtroNoBorrado, filtroEstadoAceptado);
		reset(mockGenericDao);
		
	}

	
	@After
	public void after(){
		reset(mockGenericDao);
	}
	
}
