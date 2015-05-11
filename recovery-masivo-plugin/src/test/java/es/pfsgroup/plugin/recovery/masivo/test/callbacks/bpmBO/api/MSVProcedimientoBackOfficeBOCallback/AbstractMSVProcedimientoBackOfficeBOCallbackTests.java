package es.pfsgroup.plugin.recovery.masivo.test.callbacks.bpmBO.api.MSVProcedimientoBackOfficeBOCallback;

import static org.mockito.Mockito.reset;
import static org.mockito.Mockito.when;

import java.io.IOException;
import java.util.HashMap;
import java.util.Random;

import org.junit.After;
import org.junit.Before;
import org.mockito.InjectMocks;
import org.mockito.Mock;

import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.masivo.api.impl.MSVProcesoManager;
import es.pfsgroup.plugin.recovery.masivo.api.MSVProcesoApi;
import es.pfsgroup.plugin.recovery.masivo.callbacks.bpmBO.api.impl.MSVProcedimientoBackOfficeBOCallback;
import es.pfsgroup.plugin.recovery.masivo.dao.MSVFicheroDao;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVDtoAltaProceso;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDEstadoProceso;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDOperacionMasiva;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDocumentoMasivo;
import es.pfsgroup.plugin.recovery.masivo.model.MSVProcesoMasivo;
import es.pfsgroup.plugin.recovery.masivo.utils.filecolumns.MSVSolicitarPagoTasasColumns;
import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkInputDto;

/**
 * Esta clase genérica para todos los tests de EXTProcedimientoManager 
 * @author bruno
 *
 */
public abstract class AbstractMSVProcedimientoBackOfficeBOCallbackTests {
	/*
	 * Relaciones con el simulador y validador de interacciones
	 */
	private SimuladorInteraccionesMSVProcedimientoBackOfficeBOCallback simuladorInteracciones;
	private VerificadorInteraccionesMSVProcedimientoBackOfficeBOCallback verificadorInteracciones;
	
	protected Random random;
	
	protected String descripcionDefecto = "ESTA ES LA DESCRIPCION POR DEFECTO";
	
	// Inicalizamos el manager
	@InjectMocks
	protected MSVProcedimientoBackOfficeBOCallback manager;
	
	@Mock
	protected MSVFicheroDao mockFicheroDao;

	@Mock
	protected ApiProxyFactory mockApiProxy;
	
	@Mock
	protected MSVProcesoApi mockMSVProcesoApi;
	
	@Mock
	protected MSVProcesoMasivo mockMSVProcesoMasivo; 
	
	@Mock
	protected MSVDocumentoMasivo mockDocumentoMasivo;
	
	protected Long token;
	protected Long token2;
	
	protected Long idProcess;
	protected Long idProcess2;
	protected MSVDtoAltaProceso dtoUpdateEstado;
	protected MSVProcesoMasivo procesoMasivo;
	
	
	protected RecoveryBPMfwkInputDto input = new RecoveryBPMfwkInputDto();
	protected RecoveryBPMfwkInputDto input2 = new RecoveryBPMfwkInputDto();
	
	/**
	 * Inicialización genérica para todos los tests
	 */
	@Before
	public void before(){
		// Ejecutamos la inicialización genérica
		simuladorInteracciones = new SimuladorInteraccionesMSVProcedimientoBackOfficeBOCallback(mockFicheroDao, mockApiProxy);
		verificadorInteracciones = new VerificadorInteraccionesMSVProcedimientoBackOfficeBOCallback();
		random = new Random();
		
		token=1L;
		token2=2L;
		idProcess 	= (long) 684;
		idProcess2 	= (long) 22222;
		
		MSVProcesoMasivo msvProcesoMasivo = new MSVProcesoMasivo();
		msvProcesoMasivo.setId(idProcess);
		msvProcesoMasivo.setToken(token);
		
		MSVProcesoMasivo msvProcesoMasivo2 = new MSVProcesoMasivo();
		msvProcesoMasivo2.setId(idProcess2);
		msvProcesoMasivo2.setToken(token2);
		
		when(mockApiProxy.proxy(MSVProcesoApi.class)).thenReturn(mockMSVProcesoApi);
		when(mockMSVProcesoApi.getByToken(token)).thenReturn(msvProcesoMasivo);
		
		when(mockMSVProcesoApi.getByToken(token2)).thenReturn(msvProcesoMasivo2);
		
		Long[] arrIdProcess = {idProcess, idProcess2};
		
		dtoUpdateEstado = new MSVDtoAltaProceso();
		dtoUpdateEstado.setIdProceso(idProcess);
		dtoUpdateEstado.setCodigoEstadoProceso(MSVDDEstadoProceso.CODIGO_EN_PROCESO);
		
		try {
			mockDocumentoMasivo = simularInteracciones().simulaFindFichero(arrIdProcess);
		} catch (IllegalArgumentException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		simularInteracciones().simulaModificarEstado(idProcess, mockMSVProcesoApi, dtoUpdateEstado, descripcionDefecto);

		
		HashMap<String, Object> datos = new HashMap<String, Object>();
		datos.put(MSVProcesoManager.COLUMNA_NUMERO_FILA, "1");
		datos.put(MSVSolicitarPagoTasasColumns.NUM_CONTRATO, "123456789");
		datos.put(MSVSolicitarPagoTasasColumns.NUM_NOVA, "");
		datos.put(MSVSolicitarPagoTasasColumns.FECHA_SOLICITUD, "02/03/2013");
		
		input.setCodigoTipoInput(MSVDDOperacionMasiva.CODIGO_INPUT_PAGO_TASAS_SOLICITADO);
		input.setIdProcedimiento((long) 123456789);
		input.setDatos(datos);
		
		HashMap<String, Object> datos2 = new HashMap<String, Object>();
		datos2.put(MSVProcesoManager.COLUMNA_NUMERO_FILA, "4");
		datos2.put(MSVSolicitarPagoTasasColumns.NUM_CONTRATO, "654321");
		datos2.put(MSVSolicitarPagoTasasColumns.NUM_NOVA, "");
		datos2.put(MSVSolicitarPagoTasasColumns.FECHA_SOLICITUD, "04/01/2013");
		
		input2.setCodigoTipoInput(MSVDDOperacionMasiva.CODIGO_INPUT_PAGO_TASAS_SOLICITADO);
		input2.setIdProcedimiento((long) 123456789);
		input2.setDatos(datos2);
		
		// Invocamos el código de inicialización de cada test concreto
		beforeChild();
	}
	
	/**
	 * Reseteo genérico para todos los tests
	 */
	@After
	public void after(){
		// Ejecutamos el código de reseteo de cada test concreto
		afterChild();
		// Reseteo genérico
		simuladorInteracciones = null;
		verificadorInteracciones = null;
		random = null;
		reset(mockFicheroDao);
		reset(mockApiProxy);
		reset(mockMSVProcesoApi);
		reset(mockMSVProcesoMasivo);
		reset(mockDocumentoMasivo);
	}
	
	/**
	 * En este método hay que implementar el código de inicialización de cada test concreto
	 */
	protected abstract void beforeChild();
	
	/**
	 * En este método hay que implementar el código de reseteo de cada test concreto
	 */
	protected abstract void afterChild();

	/**
	 * Simula interacciones del mánager con otros objetos desde un test
	 * @return
	 */
	protected SimuladorInteraccionesMSVProcedimientoBackOfficeBOCallback simularInteracciones(){
		return this.simuladorInteracciones;
		
	}
	
	/**
	 * Verifica las interacciones del mánager
	 * @return
	 */
	protected VerificadorInteraccionesMSVProcedimientoBackOfficeBOCallback verificarInteracciones(){
		return this.verificadorInteracciones;
	}

}

