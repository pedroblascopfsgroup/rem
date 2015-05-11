package es.pfsgroup.plugin.recovery.masivo.test.callbacks.bpmBO.api.MSVProcedimientoBackOfficeBOCallback;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

import java.io.File;
import java.io.IOException;

import es.capgemini.devon.files.FileItem;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.masivo.api.MSVProcesoApi;
import es.pfsgroup.plugin.recovery.masivo.dao.MSVFicheroDao;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVDtoAltaProceso;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDEstadoProceso;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDocumentoMasivo;
import es.pfsgroup.plugin.recovery.masivo.model.MSVProcesoMasivo;
import es.pfsgroup.plugin.recovery.masivo.test.MSVUtilTest;

/**
 * Clase que sirve para simular interacciones del mánager con otros objetos.
 * <p>
 * Esta clase contiene un método por cada interacción
 * </p>
 * 
 * @author carlos
 *
 */
public class SimuladorInteraccionesMSVProcedimientoBackOfficeBOCallback {
	
	private MSVFicheroDao mockFicheroDao;
	
	private ApiProxyFactory mockApiProxy;
	
	

	/**
	 * Obligamos a pasar los mocks de todas las dependencias del manager
	 * @param mockFicheroDao
	 * @param mockGenericDao
	 * @param mapaErrores
	 */
	public SimuladorInteraccionesMSVProcedimientoBackOfficeBOCallback(MSVFicheroDao mockFicheroDao, ApiProxyFactory mockApiProxy) {
		super();
		this.mockFicheroDao = mockFicheroDao;
		this.mockApiProxy = mockApiProxy;
	}

	public MSVProcesoMasivo simulaModificarEstado(Long idProcess, MSVProcesoApi mockMSVProcesoApi, MSVDtoAltaProceso dtoUpdateEstado, String descripcionDefecto ) {
		
		MSVDDEstadoProceso estadoProceso = new MSVDDEstadoProceso();
		estadoProceso.setCodigo(dtoUpdateEstado.getCodigoEstadoProceso());
		estadoProceso.setDescripcion("Descripcion estado");
		estadoProceso.setId((long)1234);
		
		MSVProcesoMasivo procesoMasivo = new MSVProcesoMasivo();
		procesoMasivo.setId(idProcess);
		procesoMasivo.setDescripcion(descripcionDefecto);
		procesoMasivo.setEstadoProceso(estadoProceso);
		
		when(mockApiProxy.proxy(MSVProcesoApi.class)).thenReturn(mockMSVProcesoApi);
		try {			
			when(mockMSVProcesoApi.modificarProcesoMasivo(dtoUpdateEstado)).thenReturn(procesoMasivo);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return procesoMasivo;
	}
	
	/**
	 * Simula la busqueda del ficheroDao
	 * 
	 * @param idProcess Array con los id de proceso del que queremos obtener su fichero
	 * @return
	 * @throws IOException 
	 * @throws IllegalArgumentException 
	 */
	public MSVDocumentoMasivo simulaFindFichero(Long[] idProcess) throws IllegalArgumentException, IOException {
		
		File fich = new File(MSVUtilTest.getRutaFichero("RUTA_EXCEL_PRUEBAS_LIBERAR"));
		
		MSVDocumentoMasivo mockFichero = mock(MSVDocumentoMasivo.class);
		FileItem mockFileitem = mock(FileItem.class);		
		
		when(mockFichero.getContenidoFichero()).thenReturn(mockFileitem);
		when(mockFileitem.getFile()).thenReturn(fich);
		
		for (int i=0;i<idProcess.length;i++) {
			when(mockFicheroDao.findByIdProceso(idProcess[i])).thenReturn(mockFichero);
		}
		return mockFichero;
	}
	
	
//	/**
//	 * Simula una interacción con el DAO de procedimientos para obtener uno
//	 * @param idProcedimiento
//	 * @param idAsunto 
//	 * @return
//	 */
//	public Procedimiento simulaDevolverProcedimiento(Long idProcedimiento, Long idAsunto) {
//		Procedimiento mockProcedimiento = mock(Procedimiento.class);
//		when(mockProcedimiento.getId()).thenReturn(idProcedimiento);
//		
//		Asunto mockAsunto = mock(Asunto.class);
//		when(mockAsunto.getId()).thenReturn(idAsunto);
//		
//		when(mockProcedimientoDao.get(idProcedimiento)).thenReturn(mockProcedimiento);
//		when(mockProcedimiento.getAsunto()).thenReturn(mockAsunto);
//		
//		return mockProcedimiento;
//	}
//
//
//	/**
//	 * Simula una interacción para obtener los usuarios relacionados de un asunto
//	 * @param idAsunto
//	 * @param usuariosRelacionados Usuarios que queremos devolver
//	 */
//	public void simulaObtenerUsuariosRelacionadosAsunto(Long idAsunto, HashSet<EXTUsuarioRelacionadoInfo> usuariosRelacionados) {
//		when(mockExecutor.execute(EXTAsuntoApi.EXT_MGR_ASUNTO_GET_USUARIOS_RELACIONADOS, idAsunto)).thenReturn(usuariosRelacionados);
//		
//	}


	
}