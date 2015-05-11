package es.pfsgroup.plugin.recovery.masivo.test.resolInputConfig;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;
import static org.mockito.Mockito.eq;
import static org.mockito.Mockito.any;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Random;

import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.core.api.procesosJudiciales.TareaExternaApi;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.plugin.recovery.masivo.api.MSVProcesoApi;
import es.pfsgroup.plugin.recovery.masivo.api.MSVResolucionApi;
import es.pfsgroup.plugin.recovery.masivo.dao.MSVFicheroDao;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVDtoAltaProceso;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDEstadoProceso;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDocumentoMasivo;
import es.pfsgroup.plugin.recovery.masivo.model.MSVProcesoMasivo;
import es.pfsgroup.plugin.recovery.masivo.resolInputConfig.model.MSVConfigResolInput;
import es.pfsgroup.plugin.recovery.masivo.resolInputConfig.model.MSVConfigResolucionesProc;
import es.pfsgroup.plugin.recovery.masivo.test.MSVUtilTest;
import es.pfsgroup.recovery.bpmframework.config.model.RecoveryBPMfwkDDTipoAccion;
import es.pfsgroup.recovery.bpmframework.config.model.RecoveryBPMfwkTipoProcInput;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkDDTipoInput;

/**
 * Clase que sirve para simular interacciones del mánager con otros objetos.
 * <p>
 * Esta clase contiene un método por cada interacción
 * </p>
 * 
 * @author pedro
 * 
 */
public class SimuladorInteraccionesMSVResolucionInput {

	private ApiProxyFactory mockApiProxy;

	private GenericABMDao mockGenericDao;

	private Random random;

	private Long idTarea;

	private RecoveryBPMfwkDDTipoInput[] mockTipoInput;

	/**
	 * Obligamos a pasar los mocks de todas las dependencias del manager
	 * 
	 * @param random
	 * @param genericDao
	 * @param mockmockApiProx
	 * @param mapaErrores
	 */
	public SimuladorInteraccionesMSVResolucionInput(
			ApiProxyFactory mockApiProxy, Random random,
			GenericABMDao mockGenericDao,
			MSVConfigResolInput... mockConfigResolInput) {
		super();
		this.mockApiProxy = mockApiProxy;
		this.random = random;
		this.mockGenericDao = mockGenericDao;
		mockTipoInput = new RecoveryBPMfwkDDTipoInput[mockConfigResolInput.length];
		for (int i = 0; i < mockConfigResolInput.length; i++) {
			mockTipoInput[i] = new RecoveryBPMfwkDDTipoInput();
			mockTipoInput[i].setCodigo(mockConfigResolInput[i].getCodigoInput());
		}
		//this.mockTipoInput = mockTipoInput;
	}

	public void simulaMapaResolInputProcNulo() {
		
		TareaExterna mockTareaExterna = mock(TareaExterna.class);
		TareaExternaApi mockTareaExternaApi = mock(TareaExternaApi.class);
		when(mockApiProxy.proxy(eq(TareaExternaApi.class))).thenReturn(	mockTareaExternaApi);
		when(mockTareaExternaApi.get(any(Long.class))).thenReturn(mockTareaExterna);
		
	}
	public void simulaObtenerTiposResolucionesTareas() {

		idTarea = random.nextLong();

		String codigoProc = "P70";
		String codigoNodo = "P70_InterposicionDemanda";
		String otroNodo = "P70_DemandaInadmitida";
		String todosNodos = "ALL";
		String ningunNodo = "NONE";

		TareaExterna mockTareaExterna = mock(TareaExterna.class);
		TareaProcedimiento mockTareaProcedimiento = mock(TareaProcedimiento.class);
		TareaExternaApi mockTareaExternaApi = mock(TareaExternaApi.class);
		TipoProcedimiento mockTipoProcedimiento = mock(TipoProcedimiento.class);

		when(mockApiProxy.proxy(eq(TareaExternaApi.class))).thenReturn(
				mockTareaExternaApi);
		when(mockTareaExternaApi.get(any(Long.class))).thenReturn(mockTareaExterna);
		when(mockTareaExterna.getTareaProcedimiento()).thenReturn(
				mockTareaProcedimiento);
		when(mockTareaProcedimiento.getCodigo()).thenReturn(codigoNodo);
		when(mockTareaProcedimiento.getTipoProcedimiento()).thenReturn(
				mockTipoProcedimiento);
		when(mockTipoProcedimiento.getCodigo()).thenReturn(codigoProc);

		List<RecoveryBPMfwkTipoProcInput> listaTipoProcInput = new ArrayList<RecoveryBPMfwkTipoProcInput>();
		RecoveryBPMfwkDDTipoAccion tipoAccionAdvance = new RecoveryBPMfwkDDTipoAccion();
		tipoAccionAdvance.setCodigo("ADVANCE");
		RecoveryBPMfwkDDTipoAccion tipoAccionInfo = new RecoveryBPMfwkDDTipoAccion();
		tipoAccionInfo.setCodigo("INFO");
		RecoveryBPMfwkDDTipoAccion tipoAccionForward = new RecoveryBPMfwkDDTipoAccion();
		tipoAccionForward.setCodigo("FORWARD");
		
		RecoveryBPMfwkTipoProcInput tipoProcInput1 = new RecoveryBPMfwkTipoProcInput();
		tipoProcInput1.setTipoAccion(tipoAccionAdvance);
		tipoProcInput1.setTipoInput(mockTipoInput[0]);
		tipoProcInput1.setNodesIncluded(codigoNodo);
		tipoProcInput1.setNodesExcluded(ningunNodo);
		listaTipoProcInput.add(tipoProcInput1);

		RecoveryBPMfwkTipoProcInput tipoProcInput2 = new RecoveryBPMfwkTipoProcInput();
		tipoProcInput2.setTipoAccion(tipoAccionInfo);
		tipoProcInput2.setTipoInput(mockTipoInput[1]);
		tipoProcInput2.setNodesIncluded(otroNodo);
		tipoProcInput2.setNodesExcluded(ningunNodo);
		listaTipoProcInput.add(tipoProcInput2);

		RecoveryBPMfwkTipoProcInput tipoProcInput3 = new RecoveryBPMfwkTipoProcInput();
		tipoProcInput3.setTipoAccion(tipoAccionForward);
		tipoProcInput3.setTipoInput(mockTipoInput[2]);
		tipoProcInput3.setNodesIncluded(todosNodos);
		tipoProcInput3.setNodesExcluded(codigoNodo);
		listaTipoProcInput.add(tipoProcInput3);

		when(
				mockGenericDao.getList(eq(RecoveryBPMfwkTipoProcInput.class), 
						any(Filter.class))).thenReturn(listaTipoProcInput);

	}

	public void simulaObtenerTipoInputParaResolucion() {
		
	}
	

	// public MSVProcesoMasivo simulaModificarEstado(Long idProcess, MSVProcesoApi mockMSVProcesoApi, MSVDtoAltaProceso
	// dtoUpdateEstado, String descripcionDefecto ) {
	//
	// MSVDDEstadoProceso estadoProceso = new MSVDDEstadoProceso();
	// estadoProceso.setCodigo(dtoUpdateEstado.getCodigoEstadoProceso());
	// estadoProceso.setDescripcion("Descripcion estado");
	// estadoProceso.setId((long)1234);
	//
	// MSVProcesoMasivo procesoMasivo = new MSVProcesoMasivo();
	// procesoMasivo.setId(idProcess);
	// procesoMasivo.setDescripcion(descripcionDefecto);
	// procesoMasivo.setEstadoProceso(estadoProceso);
	//
	// when(mockApiProxy.proxy(MSVProcesoApi.class)).thenReturn(mockMSVProcesoApi);
	// try {
	// when(mockMSVProcesoApi.modificarProcesoMasivo(dtoUpdateEstado)).thenReturn(procesoMasivo);
	// } catch (Exception e) {
	// // TODO Auto-generated catch block
	// e.printStackTrace();
	// }
	// return procesoMasivo;
	// }

	/**
	 * Simula la busqueda del ficheroDao
	 * 
	 * @param idProcess
	 *            Array con los id de proceso del que queremos obtener su fichero
	 * @return
	 * @throws IOException
	 * @throws IllegalArgumentException
	 */
	// public MSVDocumentoMasivo simulaFindFichero(Long[] idProcess) throws IllegalArgumentException, IOException {
	//
	// File fich = new File(MSVUtilTest.getRutaFichero("RUTA_EXCEL_PRUEBAS_LIBERAR"));
	//
	// MSVDocumentoMasivo mockFichero = mock(MSVDocumentoMasivo.class);
	// // FileItem mockFileitem = mock(FileItem.class);
	// //
	// // when(mockFichero.getContenidoFichero()).thenReturn(mockFileitem);
	// // when(mockFileitem.getFile()).thenReturn(fich);
	// //
	// // for (int i=0;i<idProcess.length;i++) {
	// // when(mockFicheroDao.findByIdProceso(idProcess[i])).thenReturn(mockFichero);
	// // }
	// return mockFichero;
	// }

	// /**
	// * Simula una interacción con el DAO de procedimientos para obtener uno
	// * @param idProcedimiento
	// * @param idAsunto
	// * @return
	// */
	// public Procedimiento simulaDevolverProcedimiento(Long idProcedimiento, Long idAsunto) {
	// Procedimiento mockProcedimiento = mock(Procedimiento.class);
	// when(mockProcedimiento.getId()).thenReturn(idProcedimiento);
	//
	// Asunto mockAsunto = mock(Asunto.class);
	// when(mockAsunto.getId()).thenReturn(idAsunto);
	//
	// when(mockProcedimientoDao.get(idProcedimiento)).thenReturn(mockProcedimiento);
	// when(mockProcedimiento.getAsunto()).thenReturn(mockAsunto);
	//
	// return mockProcedimiento;
	// }
	//
	//
	// /**
	// * Simula una interacción para obtener los usuarios relacionados de un asunto
	// * @param idAsunto
	// * @param usuariosRelacionados Usuarios que queremos devolver
	// */
	// public void simulaObtenerUsuariosRelacionadosAsunto(Long idAsunto, HashSet<EXTUsuarioRelacionadoInfo>
	// usuariosRelacionados) {
	// when(mockExecutor.execute(EXTAsuntoApi.EXT_MGR_ASUNTO_GET_USUARIOS_RELACIONADOS,
	// idAsunto)).thenReturn(usuariosRelacionados);
	//
	// }

}