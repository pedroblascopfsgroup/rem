package es.pfsgroup.plugin.rem.test.tareasactivo.tareaactivomanager;

import static org.junit.Assert.*;
import static org.mockito.Mockito.*;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.plugin.rem.model.VTareaActivoCount;
import es.pfsgroup.plugin.rem.tareasactivo.TareaActivoManager;
import es.pfsgroup.plugin.rem.tareasactivo.dao.VTareaActivoCountDao;
import es.pfsgroup.recovery.ext.impl.multigestor.model.EXTGrupoUsuarios;

@RunWith(MockitoJUnitRunner.class)
public class GetAlertasPendientesTests {

	@InjectMocks
	private TareaActivoManager manager;

	@Mock
	private GenericABMDao genericDao;

	@Mock
	private VTareaActivoCountDao countDao;

	Usuario usuario;
	EXTGrupoUsuarios grupo1;
	EXTGrupoUsuarios grupo2;

	@Before
	public void before() {
		usuario = new Usuario();
		grupo1 = new EXTGrupoUsuarios();
	}

	/**
	 * En este caso un usuario pertenece a un sólo grupo
	 */
	@Test
	public void usuarioEnUnGrupo() {
		List<VTareaActivoCount> counts = createCounts(1, 1, 1);
		List<EXTGrupoUsuarios> listOfGroups = Arrays.asList(grupo1);

		when(genericDao.getList(any(Class.class), any(Filter.class))).thenReturn(listOfGroups);
		when(countDao.getContador(usuario, listOfGroups)).thenReturn(counts);

		Long count = manager.getAlertasPendientes(usuario);

		assertEquals("La cuenta de tareas no es la esperada", new Long(2), count);

	}

	/**
	 * En este caso un usuario pertenece a varios grupos
	 */
	@Test
	public void usuarioEnVariosGrupos() {
		List<VTareaActivoCount> counts = createCounts(2, 1, 1);
		
		List<EXTGrupoUsuarios> listOfGroups = Arrays.asList(grupo1, grupo2);
		
		when(genericDao.getList(any(Class.class), any(Filter.class))).thenReturn(listOfGroups);
		when(countDao.getContador(usuario, listOfGroups)).thenReturn(counts);

		Long count = manager.getAlertasPendientes(usuario);

		assertEquals("La cuenta de tareas no es la esperada", new Long(4), count);

	}

	private List<VTareaActivoCount> createCounts(int grupos, long countUsuario, long countGrupo) {
		List<VTareaActivoCount> counts = new ArrayList<VTareaActivoCount>();

		for (int i = 0; i < grupos; i++) {
			VTareaActivoCount cu = new VTareaActivoCount();
			cu.setTareas(countUsuario);
			cu.setAlertas(countUsuario);
			cu.setAvisos(countUsuario);
			VTareaActivoCount cg = new VTareaActivoCount();
			cg.setTareas(countGrupo);
			cg.setAlertas(countGrupo);
			cg.setAvisos(countGrupo);
			counts.add(cu);
			counts.add(cg);
		}
		return counts;
	}

}
