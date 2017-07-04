package es.pfsgroup.plugin.rem.adapter;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;
import org.mockito.verification.VerificationMode;
import org.springframework.beans.factory.annotation.Autowired;

import static org.mockito.Mockito.*;

import javax.validation.constraints.AssertTrue;

import static org.junit.Assert.*;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.impl.GenericABMDaoImpl.FilterImpl;
import es.pfsgroup.plugin.rem.api.TareaActivoApi;
import es.pfsgroup.plugin.rem.model.DtoReasignarTarea;
import es.pfsgroup.plugin.rem.model.TareaActivo;
import junit.framework.TestCase;

/**
 * Clase de tests para AgendaAdapter
 * @author gonzalo
 *
 */
@RunWith(MockitoJUnitRunner.class)
public class AgendaAdapterTest {

    private final Long ID_TAREA=1000L;
    private final Long ID_GESTOR=1000L;
    private final Long ID_SUPERVISOR=1000L;

    @Mock
    private TareaActivoApi tareaActivoApi;

    @Mock
    private GenericABMDao genericDao;

    @InjectMocks
    private AgendaAdapter agendaAdapter;

	private TareaActivo tareaActivo;

    private DtoReasignarTarea prepararDto(Long idTarea) {
    	DtoReasignarTarea dto = new DtoReasignarTarea();
    	dto.setIdTarea(idTarea);
    	dto.setUsuarioGestor(ID_GESTOR);
    	dto.setUsuarioSupervisor(ID_SUPERVISOR);
    	return dto;
    }

    @Before
    public void preparar() {
    	tareaActivo = new TareaActivo();
    	tareaActivo.setId(ID_TAREA);
    	
    	when(tareaActivoApi.get(ID_TAREA)).thenReturn(tareaActivo);

		Filter filtroGestor = new FilterImpl(FilterType.EQUALS, "id", ID_GESTOR);
		Usuario usuarioGestor = new Usuario();
		
		when(genericDao.createFilter(filtroGestor.getType(), filtroGestor.getPropertyName(), 
				filtroGestor.getPropertyValue())).thenReturn(filtroGestor);
		when(genericDao.get(Usuario.class, filtroGestor)).thenReturn(usuarioGestor);
		
		Filter filtroSupervisor = new FilterImpl(FilterType.EQUALS, "id", ID_SUPERVISOR);
		Usuario usuarioSupervisor = new Usuario();
		when(genericDao.createFilter(filtroSupervisor.getType(), filtroSupervisor.getPropertyName(), filtroSupervisor.getPropertyValue())).thenReturn(filtroSupervisor);
		when(genericDao.get(Usuario.class, filtroGestor)).thenReturn(usuarioSupervisor);
    }

    @Test
	public void testAgendaAdapterUsoNormal() {
    	DtoReasignarTarea dto = prepararDto(ID_TAREA);
    	Boolean b = agendaAdapter.reasignarTarea(dto);

    	assertEquals(b, true);
    	
    	// Mockito: Verifica que llamamos al método pasandole cualquier (any) instancia de la clase TareaActivo
    	//verify(genericDao).update(TareaActivo.class, any(TareaActivo.class));
    	
    	//Mockito: Verifica que llamamos al método update 1 vez  pasandole cualquier (any) instancia de la clase TareaActivo
    	verify(genericDao, times(1))
    		.update(TareaActivo.class, tareaActivo);

    }

	@Test
	public void testAgendaAdapterUsoSinGestores() {
    	DtoReasignarTarea dto = prepararDto(ID_TAREA);
    	dto.setUsuarioGestor(null);

    	dto.setUsuarioGestor(null);
    	Boolean b = agendaAdapter.reasignarTarea(dto);
    	assertEquals(false, b);

    	dto.setUsuarioGestor(9000L);
    	dto.setUsuarioSupervisor(null);
    	b = agendaAdapter.reasignarTarea(dto);
    	assertEquals(false, b);

    	dto.setUsuarioGestor(null);
    	dto.setUsuarioSupervisor(null);
    	b = agendaAdapter.reasignarTarea(dto);
    	assertEquals(false, b);

    	//Mockito: Verifica que NUNCA llamamos al método update pasandole cualquier (any) instancia de la clase TareaActivo
    	verify(genericDao, never())
    		.update(TareaActivo.class, tareaActivo);
    	
	}
	
	
}
