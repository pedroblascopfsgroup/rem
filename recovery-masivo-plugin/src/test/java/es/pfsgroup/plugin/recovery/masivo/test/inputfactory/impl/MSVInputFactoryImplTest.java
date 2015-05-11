package es.pfsgroup.plugin.recovery.masivo.test.inputfactory.impl;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.mockito.Matchers.any;
import static org.mockito.Mockito.reset;
import static org.mockito.Mockito.when;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;


import static org.mockito.Mockito.reset;
import static org.mockito.Mockito.*;

import org.junit.After;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;

import es.pfsgroup.plugin.recovery.masivo.inputfactory.MSVSelectorTipoInput;
import es.pfsgroup.plugin.recovery.masivo.inputfactory.impl.MSVInputFactoryImpl;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDOperacionMasiva;
import es.pfsgroup.plugin.recovery.masivo.test.SampleBaseTestCase;

@RunWith(MockitoJUnitRunner.class)
public class MSVInputFactoryImplTest extends SampleBaseTestCase{
	
	@InjectMocks
	private MSVInputFactoryImpl inputFactory;
	
	@Mock
	private List<MSVSelectorTipoInput> mockLista;
	
	@Mock
	private MSVSelectorTipoInput mockSelector;
	
	@Mock
	private Iterator<MSVSelectorTipoInput> mockIterator;
	
	@After
	public void after(){
		reset(mockSelector);
		reset(mockLista);
		reset(mockIterator);
	}

	@Test
	public void testDameSelectorNull() {
		MSVDDOperacionMasiva tipoOperacion=new MSVDDOperacionMasiva();
		Map<String, Object> map = new HashMap<String, Object>();
		
		MSVSelectorTipoInput selector= inputFactory.dameSelector(tipoOperacion, map);
		
		assertEquals(null, selector);
		
	}
	
	@Test
	public void testDameSelectorNotNull() {
		MSVDDOperacionMasiva tipoOperacion=new MSVDDOperacionMasiva();
		Map<String, Object> map = new HashMap<String, Object>();
		mockLista.add(mockSelector);
		
		when(mockLista.size()).thenReturn(1);
		when(mockLista.iterator()).thenReturn(mockIterator);
		when(mockIterator.hasNext()).thenReturn(false);
		when(mockLista.get(any(Integer.class))).thenReturn(mockSelector);
		
        
        when(mockSelector.isValidFor(tipoOperacion) ).thenReturn(true); 
         
		
		
		MSVSelectorTipoInput selector= inputFactory.dameSelector(tipoOperacion, map);
		
		assertNotNull(selector);
		
	}

}
