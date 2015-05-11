package es.pfsgroup.recovery.bpmframework.test.config.model.RecoveryBPMfwkTipoProcInput;

import static org.junit.Assert.*;
import org.apache.commons.lang.RandomStringUtils;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.runners.MockitoJUnitRunner;

import es.pfsgroup.recovery.bpmframework.config.model.RecoveryBPMfwkTipoProcInput;

/**
 * Pruebas para los gets y sets de los campos nodeIncluded y nodeExcluded
 * @author manuel
 *
 */
@RunWith(MockitoJUnitRunner.class)
public class GetAndSetTest {
	
	@InjectMocks
    private RecoveryBPMfwkTipoProcInput tipoProcInput;

	private String node1;

    private String node2;

    private String node3;
   
    
    @Before
    public void before(){
    	this.node1 = RandomStringUtils.randomAlphanumeric(10);
    	this.node2 = RandomStringUtils.randomAlphanumeric(10);
    	this.node3 = RandomStringUtils.randomAlphanumeric(10);
    }
    
    @After
    public void after(){
    	this.node1 = null;
    	this.node2 = null;
    	this.node3 = null;
    }
    
	/**
	 * Comprobamos el funcionamiento del método void setNodesExcludedAsArray(final String[] nodesExcluded)
	 */    
    @Test
    public void testSetNodesIncludedAsArray(){
    	
    	tipoProcInput.setNodesIncludedAsArray(null);
    	
    	assertEquals("El valor del campo nodesIncluded no es correcto", tipoProcInput.getNodesIncluded(), RecoveryBPMfwkTipoProcInput.ALL_INCLUDED);
    	
    	tipoProcInput.setNodesIncludedAsArray(new String[]{RecoveryBPMfwkTipoProcInput.ALL_INCLUDED});
    	
    	assertEquals("El valor del campo nodesIncluded no es correcto", tipoProcInput.getNodesIncluded(), RecoveryBPMfwkTipoProcInput.ALL_INCLUDED);
    	
    	tipoProcInput.setNodesIncludedAsArray(new String[]{node1,node2,node3});
    	
    	assertEquals("El valor del campo nodesIncluded no es correcto", tipoProcInput.getNodesIncluded(), creaStringNodos());

    }

	/**
	 * Comprobamos el funcionamiento del método String[] getNodesIncludedAsArray();
	 */
	@Test
    public void testGetNodesIncludedAsArray(){
		
		//nodos vacíos.
		tipoProcInput.setNodesIncluded(null);
		
    	String[] nodos = tipoProcInput.getNodesIncludedAsArray();

    	assertEquals("EL tamaño del array no es correcto",1,nodos.length);
    	
		//nodos con ALL.
    	
    	tipoProcInput.setNodesIncluded(RecoveryBPMfwkTipoProcInput.ALL_INCLUDED);
    	
    	nodos = tipoProcInput.getNodesIncludedAsArray();

    	assertEquals("EL tamaño del array no es correcto",1,nodos.length);
    	
		//rellenamos los nodos.
    	tipoProcInput.setNodesIncluded(creaStringNodos());
    	
    	nodos = tipoProcInput.getNodesIncludedAsArray();
    	
    	assertEquals("El tamaño del array no es correcto",3,nodos.length);
    	assertEquals("El nodo1 no es correcto",this.node1,nodos[0]);
    	assertEquals("El nodo2 no es correcto",this.node2,nodos[1]);
    	assertEquals("El nodo3 no es correcto",this.node3,nodos[2]);
    }
    
	/**
	 * Comprobamos el funcionamiento del método void setNodesExcludedAsArray(final String[] nodesExcluded)
	 */
	@Test
    public void testSetNodesExcludedAsArray(){
    	
    	//Array vacío
    	tipoProcInput.setNodesExcludedAsArray(null);
    	
    	assertEquals("El valor del campo nodesExcluded no es correcto", tipoProcInput.getNodesExcluded(), RecoveryBPMfwkTipoProcInput.NONE_EXCLUDED);

    	//Array con NONE
    	tipoProcInput.setNodesExcludedAsArray(new String[]{RecoveryBPMfwkTipoProcInput.NONE_EXCLUDED});
    	
    	assertEquals("El valor del campo nodesExcluded no es correcto", tipoProcInput.getNodesExcluded(), RecoveryBPMfwkTipoProcInput.NONE_EXCLUDED);
    	
    	//Array con nodos
    	tipoProcInput.setNodesExcludedAsArray(new String[]{node1,node2,node3});
    	
    	assertEquals("El valor del campo nodesExcluded no es correcto", tipoProcInput.getNodesExcluded(), creaStringNodos());    	
    }
    
	/**
	 * Comprobamos el funcionamiento del método String[] getNodesExcludedAsArray();
	 */    
    @Test
    public void testGetNodesExcludedAsArray(){
		
		//nodos vacíos.
		tipoProcInput.setNodesExcluded(null);
		
    	String[] nodos = tipoProcInput.getNodesExcludedAsArray();

    	assertEquals("EL tamaño del array no es correcto",1,nodos.length);
    	
		//nodos con ALL.
    	
    	tipoProcInput.setNodesExcluded(RecoveryBPMfwkTipoProcInput.NONE_EXCLUDED);
    	
    	nodos = tipoProcInput.getNodesExcludedAsArray();

    	assertEquals("EL tamaño del array no es correcto",1,nodos.length);
    	
		//rellenamos los nodos.
    	tipoProcInput.setNodesExcluded(creaStringNodos());
    	
    	nodos = tipoProcInput.getNodesExcludedAsArray();
    	
    	assertEquals("El tamaño del array no es correcto",3,nodos.length);
    	assertEquals("El nodo1 no es correcto",this.node1,nodos[0]);
    	assertEquals("El nodo2 no es correcto",this.node2,nodos[1]);
    	assertEquals("El nodo3 no es correcto",this.node3,nodos[2]);    	
    }

    private String creaStringNodos() {
    	StringBuffer buffer = new StringBuffer();
    	buffer.append(node1).append(",").append(node2).append(",").append(node3);
    	return buffer.toString();
	}
}
