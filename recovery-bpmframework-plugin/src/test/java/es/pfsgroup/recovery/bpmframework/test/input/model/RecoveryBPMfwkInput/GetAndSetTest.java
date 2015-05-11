package es.pfsgroup.recovery.bpmframework.test.input.model.RecoveryBPMfwkInput;

import static org.mockito.Mockito.*;
import static org.junit.Assert.*;

import java.util.HashSet;
import java.util.Map;
import java.util.Random;
import java.util.Set;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;

import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkDDTipoInput;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkDatoInput;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkInput;

/**
 * Pruebas de algunos getters y setters delicados de esta clase
 * 
 * @author bruno
 * 
 */
@RunWith(MockitoJUnitRunner.class)
public class GetAndSetTest {
    
    private RecoveryBPMfwkInput input;
    
    private Random random = new Random();
    
    @Mock
    private RecoveryBPMfwkDatoInput mockDato1;
    
    @Mock
    private RecoveryBPMfwkDatoInput mockDato2;
    
    @Mock
    private RecoveryBPMfwkDatoInput mockDato3;

    private String nombreDato1;

    private String valorDato1;

    private String nombreDato2;

    private String valorDato2;

    private String nombreDato3;

    private String valorDato3;

    @Mock
    private RecoveryBPMfwkDDTipoInput mockTipo;

    private String codigoTipo;
    
    @Before
    public void before(){
        input = new RecoveryBPMfwkInput();
        
        nombreDato1 = "afafafa" + random.nextInt();
        valorDato1 = random.nextFloat() + "";
        
        nombreDato2 = "k-k-k-k-k-" + random.nextInt();
        valorDato2 = random.nextLong() + "";
        
        nombreDato3 = "dddddd" + random.nextInt();
        valorDato3 = random.nextDouble() + "";
        
        prepara(mockDato1, nombreDato1, valorDato1, null);
        prepara(mockDato2, nombreDato2, null,valorDato2);
        prepara(mockDato3, nombreDato3, valorDato3, null);
        
        codigoTipo = "tipo - " + random.nextLong();
        
        when(mockTipo.getCodigo()).thenReturn(codigoTipo);
        
    }
    
    private void prepara(RecoveryBPMfwkDatoInput mockDato, String nombreDato, String valorDato, String valorLargoDato) {
        when(mockDato.getNombre()).thenReturn(nombreDato);
        when(mockDato.getValor()).thenReturn(valorDato);
        when(mockDato.getValorLargo()).thenReturn(valorLargoDato);
        
    }

    @After
    public void after(){
        input = null;
        mockDato1 = null;
        mockDato2 = null;
        mockDato3 = null;
        
        nombreDato1 = null;
        valorDato1 = null;
        nombreDato2 = null;
        valorDato2 = null;
        nombreDato3 = null;
        valorDato3 = null;
        
        reset(mockTipo);
        
        codigoTipo = null;
    }
    
    /**
     * Comprueba el método calculado getDatos() implementado para que cumpla con la interfaz
     */
    @Test
    public void testGetDatos(){
        input.setDatosPersistidos(creaSetDatosPersistidos(new RecoveryBPMfwkDatoInput[] {mockDato1, mockDato2, mockDato3}));
        
        final Map<String, Object> mapaDatos = input.getDatos();
        
        assertNotNull("El mapa de datos es null", mapaDatos);
        assertEquals("El tamaño del mapa de datos no es el correcto", 3, mapaDatos.size());
        
        assertNotNull("El dato1 no se encuentra", mapaDatos.get(nombreDato1));
        assertEquals("El valor del dato1 no coincide", valorDato1, mapaDatos.get(nombreDato1));
        
        assertNotNull("El dato2 no se encuentra", mapaDatos.get(nombreDato2));
        assertEquals("El valor del dato2 no coincide", valorDato2, mapaDatos.get(nombreDato2));
        
        assertNotNull("El dato3 no se encuentra", mapaDatos.get(nombreDato3));
        assertEquals("El valor del dato3 no coincide", valorDato3, mapaDatos.get(nombreDato3));
    }
    
    /**
     * Comprueba el método calculado que devuelve el código del tipo de input
     */
    @Test
    public void testGetCodigoTipo(){
        input.setTipo(mockTipo);
        assertNotNull("El código de tipo devuelto es null", input.getCodigoTipoInput());
        
        assertEquals("El código de tipo de input no coincide", codigoTipo, input.getCodigoTipoInput());
    }

    private Set<RecoveryBPMfwkDatoInput> creaSetDatosPersistidos(RecoveryBPMfwkDatoInput[] datos) {
       HashSet<RecoveryBPMfwkDatoInput> set = new HashSet<RecoveryBPMfwkDatoInput>();
       
       for (RecoveryBPMfwkDatoInput dato : datos){
           set.add(dato);
       }
       
       return set;
    }

}
