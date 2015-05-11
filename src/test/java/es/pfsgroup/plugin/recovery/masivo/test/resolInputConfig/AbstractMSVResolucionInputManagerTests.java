package es.pfsgroup.plugin.recovery.masivo.test.resolInputConfig;

import static org.mockito.Matchers.eq;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.reset;
import static org.mockito.Mockito.when;

import java.io.IOException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.Set;

import org.junit.After;
import org.junit.Before;
import org.mockito.InjectMocks;
import org.mockito.Mock;

import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.recovery.masivo.api.impl.MSVProcesoManager;
import es.pfsgroup.plugin.recovery.masivo.api.MSVProcesoApi;
import es.pfsgroup.plugin.recovery.masivo.api.MSVResolucionApi;
import es.pfsgroup.plugin.recovery.masivo.callbacks.bpmBO.api.impl.MSVProcedimientoBackOfficeBOCallback;
import es.pfsgroup.plugin.recovery.masivo.dao.MSVFicheroDao;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVDtoAltaProceso;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDEstadoProceso;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDOperacionMasiva;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDTipoResolucion;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDocumentoMasivo;
import es.pfsgroup.plugin.recovery.masivo.model.MSVProcesoMasivo;
import es.pfsgroup.plugin.recovery.masivo.resolInputConfig.api.impl.MSVResolucionInputManager;
import es.pfsgroup.plugin.recovery.masivo.resolInputConfig.model.MSVConfigResolInput;
import es.pfsgroup.plugin.recovery.masivo.resolInputConfig.model.MSVConfigResolucionesProc;
import es.pfsgroup.plugin.recovery.masivo.resolInputConfig.model.MSVConfigTiposResoluciones;
import es.pfsgroup.plugin.recovery.masivo.utils.filecolumns.MSVSolicitarPagoTasasColumns;
import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkInputDto;

/**
 * Esta clase gen�rica para todos los tests de MSVResolucionInputManager
 * 
 * @author pedro
 * 
 */
public abstract class AbstractMSVResolucionInputManagerTests {
	/*
	 * Relaciones con el simulador y validador de interacciones
	 */
	private SimuladorInteraccionesMSVResolucionInput simuladorInteracciones;
	private VerificadorInteraccionesMSVResolucionInput verificadorInteracciones;

	protected Random random;

	protected String descripcionDefecto = "ESTA ES LA DESCRIPCION POR DEFECTO";

	// Inicalizamos el manager
	@InjectMocks
	protected MSVResolucionInputManager manager;

	@Mock
	protected ApiProxyFactory mockApiProxy;

	@Mock
	protected MSVResolucionApi mockMSVResolucionApi;

	protected MSVConfigResolucionesProc mockConfigResolucionesProc;

	@Mock
	protected MSVConfigTiposResoluciones mockConfigTiposResoluciones;

	@Mock
	protected MSVConfigResolInput mockConfigResolInput1;

	@Mock
	protected MSVConfigResolInput mockConfigResolInput2;

	@Mock
	protected MSVConfigResolInput mockConfigResolInput3;

	@Mock
	protected Map<String, MSVConfigTiposResoluciones> mockMapaConfigResoluciones;

	@Mock
	protected Map<String, List<MSVConfigResolInput>> mockMapaTipoResolInput;

	@Mock
	protected List<MSVConfigResolInput> mockListaTipoInputs1;

	@Mock
	protected List<MSVConfigResolInput> mockListaTipoInputs2;

	@Mock
	protected Iterator<MSVConfigResolInput> mockIteratorResolInput1;

	@Mock
	protected Iterator<MSVConfigResolInput> mockIteratorResolInput2;

	@Mock
	protected GenericABMDao mockGenericDao;

	@Mock
	protected MSVDDTipoResolucion mockTipoResolucion1;

	@Mock
	protected MSVDDTipoResolucion mockTipoResolucion2;

	@Mock
	protected Set<String> mockKeySet;
	
	@Mock
	private Iterator<String> mockKeySetIterator;

	@Mock
	private Iterator<MSVConfigResolInput> mockIteratorListaTipoInput;

	protected String codigoProc;
	protected String codigoTipoResol1;
	protected String codigoTipoResol2;

	// protected Long token2;
	//
	// protected Long idProcess;
	// protected Long idProcess2;
	// protected MSVDtoAltaProceso dtoUpdateEstado;
	// protected MSVProcesoMasivo procesoMasivo;
	//
	//
	// protected RecoveryBPMfwkInputDto input = new RecoveryBPMfwkInputDto();
	// protected RecoveryBPMfwkInputDto input2 = new RecoveryBPMfwkInputDto();

	/**
	 * Inicializaci�n gen�rica para todos los tests
	 */
	@Before
	public void before() {

		random = new Random();

		verificadorInteracciones = new VerificadorInteraccionesMSVResolucionInput();

		codigoProc = "P70";
		codigoTipoResol1 = "MDP";
		codigoTipoResol2 = "MID";

		//when(mockConfigResolucionesProc.getMapaConfigResoluciones())
				//.thenReturn(mockMapaConfigResoluciones);
		when(mockMapaConfigResoluciones.get(codigoProc)).thenReturn(
				mockConfigTiposResoluciones);
		when(mockConfigTiposResoluciones.getMapaTiposResoluciones()).thenReturn(
				mockMapaTipoResolInput);

		when(mockMapaTipoResolInput.keySet()).thenReturn(mockKeySet);
		when(mockKeySet.iterator()).thenReturn(mockKeySetIterator);
		when(mockKeySetIterator.next()).thenReturn(codigoTipoResol1, codigoTipoResol2);
		when(mockKeySetIterator.hasNext()).thenReturn(true, true, false);
		
		when(mockMapaTipoResolInput.get(codigoTipoResol1)).thenReturn(
				mockListaTipoInputs1);
		when(mockListaTipoInputs1.iterator()).thenReturn(
				mockIteratorResolInput1);
		when(mockIteratorResolInput1.next()).thenReturn(mockConfigResolInput1);
		when(mockIteratorResolInput1.hasNext()).thenReturn(true, false);

		when(mockConfigResolInput1.getCodigoInput()).thenReturn("DEM_PRESENTA");
		when(mockConfigResolInput1.getTieneProcurador()).thenReturn(null);
		when(mockConfigResolInput1.getSentido()).thenReturn(null);
		when(mockConfigResolInput1.getCompleto()).thenReturn(null);
		when(mockConfigResolInput1.getRespuesta()).thenReturn(null);

		when(mockMapaTipoResolInput.get(eq(codigoTipoResol2))).thenReturn(
				mockListaTipoInputs2);
		when(mockListaTipoInputs2.iterator()).thenReturn(
				mockIteratorResolInput2);
		when(mockIteratorResolInput2.next()).thenReturn(mockConfigResolInput2,
				mockConfigResolInput3);
		when(mockConfigResolInput2.getCodigoInput()).thenReturn(
				"DEM_INADMITIDA_CPROC");
		when(mockConfigResolInput2.getTieneProcurador()).thenReturn("SI");
		when(mockConfigResolInput2.getSentido()).thenReturn(MSVConfigResolInput.POSITIVO);
		when(mockConfigResolInput2.getCompleto()).thenReturn(MSVConfigResolInput.PARCIAL);
		when(mockConfigResolInput2.getRespuesta()).thenReturn(MSVConfigResolInput.DENEGADA);

		when(mockConfigResolInput3.getCodigoInput()).thenReturn(
				"DEM_INADMITIDA_SPROC");
		when(mockConfigResolInput3.getTieneProcurador()).thenReturn("NO");
		when(mockConfigResolInput3.getSentido()).thenReturn(MSVConfigResolInput.NEGATIVO);
		when(mockConfigResolInput3.getCompleto()).thenReturn(MSVConfigResolInput.TOTAL);
		when(mockConfigResolInput3.getRespuesta()).thenReturn(MSVConfigResolInput.APROBADA);

		when(mockApiProxy.proxy(eq(MSVResolucionApi.class))).thenReturn(
				mockMSVResolucionApi);

		when(mockTipoResolucion1.getCodigo()).thenReturn(codigoTipoResol1);
		when(mockTipoResolucion1.getDescripcion()).thenReturn(
				"Demanda presentada");
		when(mockMSVResolucionApi.getTipoResolucionPorCodigo(codigoTipoResol1))
				.thenReturn(mockTipoResolucion1);

		when(mockTipoResolucion2.getCodigo()).thenReturn(codigoTipoResol2);
		when(mockTipoResolucion2.getDescripcion()).thenReturn(
				"Inadmisi�n Demanda");
		when(mockMSVResolucionApi.getTipoResolucionPorCodigo(codigoTipoResol2))
				.thenReturn(mockTipoResolucion2);

		// Ejecutamos la inicializaci�n gen�rica
		simuladorInteracciones = new SimuladorInteraccionesMSVResolucionInput(
				mockApiProxy, random, mockGenericDao, mockConfigResolInput1,
				mockConfigResolInput2, mockConfigResolInput3);

		when(mockListaTipoInputs2.iterator()).thenReturn(mockIteratorListaTipoInput);
		when(mockIteratorListaTipoInput.next()).thenReturn(mockConfigResolInput3, mockConfigResolInput2);
		when(mockIteratorListaTipoInput.hasNext()).thenReturn(true, true, false);
		
	}

	/**
	 * Reseteo gen�rico para todos los tests
	 */
	@After
	public void after() {
		// Ejecutamos el c�digo de reseteo de cada test concreto
		afterChild();
		// Reseteo gen�rico
		simuladorInteracciones = null;
		verificadorInteracciones = null;
		random = null;
		codigoProc = null;
		codigoTipoResol1 = null;
		codigoTipoResol2 = null;

		reset(mockApiProxy);
		reset(mockMSVResolucionApi);
		if (mockConfigResolucionesProc != null)
			reset(mockConfigResolucionesProc);
		reset(mockConfigTiposResoluciones);
		reset(mockConfigResolInput1);
		reset(mockConfigResolInput2);
		reset(mockConfigResolInput3);

		reset(mockMapaConfigResoluciones);
		reset(mockMapaTipoResolInput);
		reset(mockListaTipoInputs1);
		reset(mockListaTipoInputs2);
		reset(mockIteratorResolInput1);
		reset(mockIteratorResolInput2);

		reset(mockGenericDao);
		reset(mockTipoResolucion1);
		reset(mockTipoResolucion2);
		
		reset(mockKeySet);
		reset(mockKeySetIterator);
		reset(mockIteratorListaTipoInput);
		
	}

	/**
	 * En este m�todo hay que implementar el c�digo de inicializaci�n de cada test concreto
	 */
	protected abstract void beforeChild();

	/**
	 * En este m�todo hay que implementar el c�digo de reseteo de cada test concreto
	 */
	protected abstract void afterChild();

	/**
	 * Simula interacciones del m�nager con otros objetos desde un test
	 * 
	 * @return
	 */
	protected SimuladorInteraccionesMSVResolucionInput simularInteracciones() {
		return this.simuladorInteracciones;

	}

	/**
	 * Verifica las interacciones del m�nager
	 * 
	 * @return
	 */
	protected VerificadorInteraccionesMSVResolucionInput verificarInteracciones() {
		return this.verificadorInteracciones;
	}

}
