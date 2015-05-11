package es.pfsgroup.plugin.recovery.masivo.test;

import static org.mockito.Mockito.*;
import static org.junit.Assert.*;

import java.security.Principal;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;
import org.springframework.web.context.request.WebRequest;

import es.pfsgroup.plugin.recovery.masivo.MSVComponenteMasivoListener;
import es.pfsgroup.plugin.recovery.masivo.MSVComponenteMasivoManager;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVResultadoOperacionMasivaDto;
import es.pfsgroup.plugin.recovery.masivo.inputfactory.MSVSelectorTipoInput;

@RunWith(MockitoJUnitRunner.class)
public class MSVComponenteMasivoManagerTest {
	
	@InjectMocks
	private MSVComponenteMasivoManager componenteMasivoManager;
	
	@Mock
	private List<MSVComponenteMasivoListener> mockLista;
	
	@Mock
	private MSVComponenteMasivoListener mockListener;
	
	@Mock
	private Iterator<MSVComponenteMasivoListener> mockIterator;
	

	@Test
	public void testEjecutaOperacionMasiva() {
		MSVResultadoOperacionMasivaDto map=new MSVResultadoOperacionMasivaDto();
		String nombre ="nombreOperacion";
		List<Long> listaLong=new ArrayList<Long>();
		WebRequest request = creaRequest();
		
		mockLista.add(mockListener);
		when(mockLista.size()).thenReturn(1);
		when(mockLista.iterator()).thenReturn(mockIterator);
		when(mockIterator.hasNext()).thenReturn(false);
		when(mockLista.get(any(Integer.class))).thenReturn(mockListener);
		when(mockListener.getNombreOperacionMasiva()).thenReturn(nombre);
		
		when(mockListener.ejecuta(anyList(), any(Map.class))).thenReturn(map);
		
		MSVResultadoOperacionMasivaDto resultado=componenteMasivoManager.ejecutaOperacionMasiva(listaLong, nombre, request);
		
		assertEquals(resultado, map);
	}


	private WebRequest creaRequest() {
		return new WebRequest() {
			
			@Override
			public void setAttribute(String name, Object value, int scope) {
				// TODO Auto-generated method stub
				
			}
			
			@Override
			public void removeAttribute(String name, int scope) {
				// TODO Auto-generated method stub
				
			}
			
			@Override
			public void registerDestructionCallback(String name, Runnable callback,
					int scope) {
				// TODO Auto-generated method stub
				
			}
			
			@Override
			public Object getSessionMutex() {
				// TODO Auto-generated method stub
				return null;
			}
			
			@Override
			public String getSessionId() {
				// TODO Auto-generated method stub
				return null;
			}
			
			@Override
			public String[] getAttributeNames(int scope) {
				// TODO Auto-generated method stub
				return null;
			}
			
			@Override
			public Object getAttribute(String name, int scope) {
				// TODO Auto-generated method stub
				return null;
			}
			
			@Override
			public boolean isUserInRole(String role) {
				// TODO Auto-generated method stub
				return false;
			}
			
			@Override
			public boolean isSecure() {
				// TODO Auto-generated method stub
				return false;
			}
			
			@Override
			public Principal getUserPrincipal() {
				// TODO Auto-generated method stub
				return null;
			}
			
			@Override
			public String getRemoteUser() {
				// TODO Auto-generated method stub
				return null;
			}
			
			@Override
			public String[] getParameterValues(String paramName) {
				// TODO Auto-generated method stub
				return null;
			}
			
			@Override
			public Map getParameterMap() {
				// TODO Auto-generated method stub
				return null;
			}
			
			@Override
			public String getParameter(String paramName) {
				// TODO Auto-generated method stub
				return null;
			}
			
			@Override
			public Locale getLocale() {
				// TODO Auto-generated method stub
				return null;
			}
			
			@Override
			public String getDescription(boolean includeClientInfo) {
				// TODO Auto-generated method stub
				return null;
			}
			
			@Override
			public String getContextPath() {
				// TODO Auto-generated method stub
				return null;
			}
			
			@Override
			public boolean checkNotModified(long lastModifiedTimestamp) {
				// TODO Auto-generated method stub
				return false;
			}
		};
	}

}
