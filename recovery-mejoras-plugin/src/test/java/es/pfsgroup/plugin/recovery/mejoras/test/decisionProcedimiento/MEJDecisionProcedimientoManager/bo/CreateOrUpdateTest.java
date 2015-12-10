package es.pfsgroup.plugin.recovery.mejoras.test.decisionProcedimiento.MEJDecisionProcedimientoManager.bo;

import static org.junit.Assert.*;

import java.util.Date;

import org.apache.commons.lang.RandomStringUtils;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.runners.MockitoJUnitRunner;

import es.capgemini.pfs.decisionProcedimiento.model.DecisionProcedimiento;
import es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.dto.MEJDtoDecisionProcedimiento;
import es.pfsgroup.plugin.recovery.mejoras.test.decisionProcedimiento.MEJDecisionProcedimientoManager.AbstractMEJDecisionProcedimientoManagerTests;
import es.pfsgroup.plugin.recovery.mejoras.test.decisionProcedimiento.MEJDecisionProcedimientoManager.MEJDtoDecisionProcedimientoTestFactory;

/**
 * Suite de pruebas para el m�todo CreateOrUpdate.
 * 
 * @author bruno
 * 
 */
@RunWith(MockitoJUnitRunner.class)
public class CreateOrUpdateTest extends AbstractMEJDecisionProcedimientoManagerTests{

    private Long idProcedimiento;
    private String estadoDecision;
    //private String causaDecision;
    private String causaDecisionFinalizar;
    private String causaDecisionParalizar;    
    private String comentarios;
    private Date fechaParalizacion;
    private Long[] derivadosId;
    private Long idAsunto;

    @Override
    public void setUpChildTest() {
        idProcedimiento = random.nextLong();
        estadoDecision = RandomStringUtils.randomAlphabetic(50);
        //causaDecision = RandomStringUtils.randomAlphabetic(50);
        causaDecisionFinalizar = RandomStringUtils.randomAlphabetic(50);
        causaDecisionParalizar = RandomStringUtils.randomAlphabetic(50);        
        comentarios = RandomStringUtils.randomAlphabetic(5000);
        fechaParalizacion = new Date(Math.abs(random.nextLong()));
        derivadosId = initArray(random.nextInt(20));
        idAsunto = random.nextLong();
        
        simularInteracciones().obtenerProcedimiento(idProcedimiento, idAsunto);
        //simularInteracciones().seObtieneConfiguracionDerivacion();
        simularInteracciones().seObtieneEstadoDecision(estadoDecision);
        //simularInteracciones().seObtieneCausaDecision(causaDecision);
        simularInteracciones().seObtieneCausaDecisionFinalizar(causaDecisionFinalizar);
        simularInteracciones().seObtieneCausaDecisionParalizar(causaDecisionParalizar);        
        
    }

    @Override
    public void tearDownChildTest() {
       idProcedimiento = null;
       estadoDecision = null;
       //causaDecision = null;
       causaDecisionFinalizar = null;
       causaDecisionParalizar = null;       
       comentarios = null;
       fechaParalizacion = null;
       derivadosId = null;
       idAsunto = null;
    }
    
    /**
     * Prueba el caso general
     * 
     * @throws Exception
     */
    @Test
    public void testCreaNuevaDecision() throws Exception{
        //MEJDtoDecisionProcedimiento dtoDecisionProcedimiento = MEJDtoDecisionProcedimientoTestFactory.nuevaDecision(estadoDecision, causaDecision, idProcedimiento, derivadosId);
        MEJDtoDecisionProcedimiento dtoDecisionProcedimiento = MEJDtoDecisionProcedimientoTestFactory.nuevaDecision(estadoDecision, causaDecisionFinalizar, causaDecisionParalizar, idProcedimiento, derivadosId);
        
        dtoDecisionProcedimiento.setComentarios(comentarios);
        dtoDecisionProcedimiento.setFechaParalizacion(fechaParalizacion);
                
        DecisionProcedimiento current = new DecisionProcedimiento();
        manager.createOrUpdate(current, dtoDecisionProcedimiento);
       
        verifica().seHaGuardadoLaDecision(current);
        
        //assertNotNull("La decisi�n no tiene causa", current.getCausaDecision());
        //assertEquals("La causa de la decisi�n no es la esperada", causaDecision, current.getCausaDecision().getCodigo());
        assertNotNull("La decisi�n de finalizaci�n no tiene causa", current.getCausaDecisionFinalizar());
        assertEquals("La causa de finalizaci�n la decisi�n no es la esperada", causaDecisionFinalizar, current.getCausaDecisionFinalizar().getCodigo());
        assertNotNull("La decisi�n de paralizaci�n no tiene causa", current.getCausaDecisionParalizar());
        assertEquals("La causa de la decisi�n de paralizaci�n no es la esperada", causaDecisionParalizar, current.getCausaDecisionParalizar().getCodigo());
        
        
        assertNotNull("La decisi�n no tiene estado", current.getEstadoDecision());
        assertEquals("El c�digo del estado de la decisi�n no es correcto", estadoDecision, current.getEstadoDecision().getCodigo());
        
        assertFalse("La decisi�n no deber�a estar finalizada", current.getFinalizada());
        assertFalse("La decisi�n no deber�a estar paralizada", current.getParalizada());
        
        assertEquals("Los comentarios de la decisi�n no coinciden", comentarios, current.getComentarios());
        assertEquals("La fecha de paralizaci�n no coincide", fechaParalizacion, current.getFechaParalizacion());
    }

}
