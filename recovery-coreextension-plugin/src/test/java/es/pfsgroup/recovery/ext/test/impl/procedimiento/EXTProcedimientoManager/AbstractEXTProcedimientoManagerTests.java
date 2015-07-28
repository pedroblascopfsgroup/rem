package es.pfsgroup.recovery.ext.test.impl.procedimiento.EXTProcedimientoManager;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.reset;
import static org.mockito.Mockito.when;

import java.util.Random;

import org.junit.After;
import org.junit.Before;
import org.mockito.InjectMocks;
import org.mockito.Mock;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.diccionarios.Dictionary;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.recovery.ext.impl.procedimiento.EXTProcedimientoManager;
import es.pfsgroup.recovery.ext.impl.procedimiento.dao.EXTProcedimientoDao;

/**
 * Esta clase genérica para todos los tests de EXTProcedimientoManager 
 * @author bruno
 *
 */
public abstract class AbstractEXTProcedimientoManagerTests {
	/*
	 * Relaciones con el simulador y validador de interacciones
	 */
	private SimuladorInteraccionesEXTProcedimientoManager simuladorInteracciones;
	private VerificadorInteraccionesEXTProcedimientoManager verificadorInteracciones;
	
	protected Random random;
	
	
	// Inicalizamos el manager
	@InjectMocks
	protected EXTProcedimientoManager manager;
	
	@Mock
	private EXTProcedimientoDao mockProcedimientoDao;
	
	@Mock
	private Executor mockExecutor;
	
	/**
	 * Inicialización genérica para todos los tests
	 */
	@Before
	public void before(){
		// Ejecutamos la inicialización genérica
		simuladorInteracciones = new SimuladorInteraccionesEXTProcedimientoManager(mockProcedimientoDao, mockExecutor);
		verificadorInteracciones = new VerificadorInteraccionesEXTProcedimientoManager();
		random = new Random();
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
		reset(mockProcedimientoDao);
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
	protected SimuladorInteraccionesEXTProcedimientoManager simularInteracciones(){
		return this.simuladorInteracciones;
		
	}
	

	protected VerificadorInteraccionesEXTProcedimientoManager verificarInteracciones(){
		return this.verificadorInteracciones;
	}

	/**
	 * Crea un mock de un usuario
	 * @param nombreApellioUsuario nombre + apellidos del usuario
	 * @return
	 */
	protected Usuario creaMockUsuario(String nombreApellidoUsuario) {
		Usuario usuario = mock(Usuario.class);
		when(usuario.getNombre()).thenReturn(nombreApellidoUsuario);
		when(usuario.getApellidoNombre()).thenReturn(nombreApellidoUsuario);
		return usuario;
	}

	/**
	 * Crea un mock de un diccionario
	 * @param codigo
	 * @param descripcion
	 * @return
	 */
	protected Dictionary creaMockDictionary(String codigo, String descripcion) {
		Dictionary dicc = mock(Dictionary.class);
		when(dicc.getCodigo()).thenReturn(codigo);
		when(dicc.getDescripcion()).thenReturn(descripcion);
		when(dicc.getDescripcionLarga()).thenReturn(descripcion);
		return dicc;
	}

}

