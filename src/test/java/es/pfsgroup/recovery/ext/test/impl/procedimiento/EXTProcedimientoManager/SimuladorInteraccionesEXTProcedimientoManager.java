package es.pfsgroup.recovery.ext.test.impl.procedimiento.EXTProcedimientoManager;

import static org.mockito.Mockito.*;

import java.util.HashSet;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.core.api.procedimiento.ProcedimientoApi;
import es.pfsgroup.recovery.ext.api.asunto.EXTAsuntoApi;
import es.pfsgroup.recovery.ext.api.asunto.EXTUsuarioRelacionadoInfo;
import es.pfsgroup.recovery.ext.impl.procedimiento.dao.EXTProcedimientoDao;

/**
 * Clase que sirve para simular interacciones del mánager con otros objetos.
 * <p>
 * Esta clase contiene un método por cada interacción
 * </p>
 * 
 * @author bruno
 *
 */
public class SimuladorInteraccionesEXTProcedimientoManager {
	
	private EXTProcedimientoDao mockProcedimientoDao;
	
	private Executor mockExecutor;

	/**
	 * Obligamos a pasar los mocks de todas as dependencias del managet
	 * @param mockProcedimientoDao
	 * @param mockExecutor 
	 */
	public SimuladorInteraccionesEXTProcedimientoManager(EXTProcedimientoDao mockProcedimientoDao, Executor mockExecutor) {
		super();
		this.mockProcedimientoDao = mockProcedimientoDao;
		this.mockExecutor = mockExecutor;
	}

	
	/**
	 * Simula una interacción con el DAO de procedimientos para obtener uno
	 * @param idProcedimiento
	 * @param idAsunto 
	 * @return
	 */
	public Procedimiento simulaDevolverProcedimiento(Long idProcedimiento, Long idAsunto) {
		Procedimiento mockProcedimiento = mock(Procedimiento.class);
		when(mockProcedimiento.getId()).thenReturn(idProcedimiento);
		
		Asunto mockAsunto = mock(Asunto.class);
		when(mockAsunto.getId()).thenReturn(idAsunto);
		
		when(mockProcedimientoDao.get(idProcedimiento)).thenReturn(mockProcedimiento);
		when(mockProcedimiento.getAsunto()).thenReturn(mockAsunto);
		
		return mockProcedimiento;
	}


	/**
	 * Simula una interacción para obtener los usuarios relacionados de un asunto
	 * @param idAsunto
	 * @param usuariosRelacionados Usuarios que queremos devolver
	 */
	public void simulaObtenerUsuariosRelacionadosAsunto(Long idAsunto, HashSet<EXTUsuarioRelacionadoInfo> usuariosRelacionados) {
		when(mockExecutor.execute(EXTAsuntoApi.EXT_MGR_ASUNTO_GET_USUARIOS_RELACIONADOS, idAsunto)).thenReturn(usuariosRelacionados);
		
	}


	
}