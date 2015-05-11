package es.pfsgroup.recovery.bpmframework.test.run.executors.RecoveryBPMfwkInputGenDocExecutor.methods;

import static org.mockito.Matchers.any;
import static org.mockito.Mockito.doThrow;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.reset;
import static org.mockito.Mockito.when;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.RandomStringUtils;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.runners.MockitoJUnitRunner;

import es.pfsgroup.recovery.bpmframework.api.config.RecoveryBPMfwkCfgInputDto;
import es.pfsgroup.recovery.bpmframework.api.config.RecoveryBPMfwkGrupoDatoDto;
import es.pfsgroup.recovery.bpmframework.exceptions.RecoveryBPMfwkError;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkDDTipoInput;
import es.pfsgroup.recovery.bpmframework.run.executors.RecoveryBPMfwkInputGenDocExecutor;
import es.pfsgroup.recovery.bpmframework.run.executors.RecoveryBPMfwkInputInformarDatosExecutor;
import es.pfsgroup.recovery.bpmframework.test.run.executors.RecoveryBPMfwkInputGenDocExecutor.AbstractRecoveryBPMfwkInputGenDocExecutorTest;
import es.pfsgroup.recovery.geninformes.dto.GENINFGenerarEscritoDto;

/**
 * Prueba el método execute para el
 * {@link RecoveryBPMfwkInputInformarDatosExecutor}
 * 
 * @author bruno
 * 
 */
//TODO programar el caso de pruebas para cuando falle el execute en algún punto
@RunWith(MockitoJUnitRunner.class)
public class ExecuteTest extends AbstractRecoveryBPMfwkInputGenDocExecutorTest {

    private RecoveryBPMfwkCfgInputDto mockConfig;

    private DatosEntradaInput datosInput;

    private Map<String, RecoveryBPMfwkGrupoDatoDto> configDatos;

    private String codigoTipoProcedimiento;

    private String codigoTipoInput;

	private Long idAsunto;

	private String codigoPlantilla;

	private String nodoProcedimiento; 

	private List<String> nodosProcedimiento;
	
    @Override
    public void childBefore() {
        datosInput = new DatosEntradaInput(random);

        codigoTipoProcedimiento = "TP" + random.nextLong();
        codigoTipoInput = datosInput.getCodigoTipoInput();
        codigoPlantilla = RandomStringUtils.randomAlphanumeric(20);
        nodoProcedimiento = RandomStringUtils.randomAlphanumeric(20);
        idAsunto = random.nextLong();
        
        nodosProcedimiento = new ArrayList<String>();
        nodosProcedimiento.add(nodoProcedimiento);
        nodosProcedimiento.add(RandomStringUtils.randomAlphanumeric(20));
        nodosProcedimiento.add(RandomStringUtils.randomAlphanumeric(20));
        nodosProcedimiento.add(RandomStringUtils.randomAlphanumeric(20));
        
        
        simular().simulaSeObtieneProcedimiento(datosInput.getIdProcedimiento(), idAsunto, codigoTipoProcedimiento);
        simular().simulaSeObtieneElNodoProcedimiento(nodosProcedimiento);
        mockConfig = simular().simulaSeObtieneLaConfiguracionParaInput(codigoTipoProcedimiento, codigoTipoInput, codigoPlantilla, nodoProcedimiento);
        when(mockConfig.getCodigoPlantilla()).thenReturn(codigoPlantilla);
        
        configDatos = mockConfig.getConfigDatos();

        RecoveryBPMfwkDDTipoInput mockTipoInput = mock(RecoveryBPMfwkDDTipoInput.class);
        when(mockTipoInput.getCodigo()).thenReturn(codigoTipoInput);
        
        when(mockInput.getIdProcedimiento()).thenReturn(datosInput.getIdProcedimiento());
        when(mockInput.getTipo()).thenReturn(mockTipoInput);

        when(mockConfig.getConfigDatos()).thenReturn(configDatos);

        
    }

    @Override
    public void childAfter() {
        mockConfig = null;
        datosInput = null;
        reset(mockInput);
        configDatos = null;
        codigoTipoProcedimiento = null;
        codigoTipoInput = null;
        idAsunto = null;
        codigoPlantilla = null;
        nodoProcedimiento = null;

    }

    /**
     * Testea el caso general para la generación de documentos.
     */
    @Test
    public void testCasoGeneralGenerarDocumentacion()  throws Exception {
    	

    	boolean adjuntar = true;
    	String tipoEntidad = RecoveryBPMfwkInputGenDocExecutor.ENTIDAD_EXT_ASUNTO;
    	
        executor.execute(mockInput);
        
        verificar().seLanzaLaGeneracionDeDocumentos(tipoEntidad, codigoPlantilla, idAsunto, adjuntar);
    }
    
    /**
     * Testea el caso en el que se produzca una excepción al generar un documento.
     * @throws Exception 
     */
    
	@SuppressWarnings("unchecked")
	@Test(expected=RecoveryBPMfwkError.class)
    public void testSeProduceUnaExcepcion() throws Exception {
    	
//		doThrow(new RuntimeException("mock test exception")).when(
//				mockGENINFInformesManager).generarEscrito(any(String.class),
//				any(String.class), any(Long.class),
//				any(Boolean.class).booleanValue(), 
//				any(Procedimiento.class));
		 
		
		doThrow(new RuntimeException("mock test exception")).when(
				mockGENINFInformesManager).generarEscritoEditable(any(GENINFGenerarEscritoDto.class),any(HashMap.class));

		executor.execute(mockInput);
    	
    }

}
