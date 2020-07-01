package es.pfsgroup.plugin.rem.api;

import java.lang.reflect.InvocationTargetException;
import java.util.List;

import es.pfsgroup.plugin.rem.admision.exception.AdmisionException;
import es.pfsgroup.plugin.rem.model.ActivoAgendaRevisionTitulo;
import es.pfsgroup.plugin.rem.model.DtoActivoAgendaRevisionTitulo;
import es.pfsgroup.plugin.rem.model.DtoAdmisionRevisionTitulo;

public interface AdmisionApi {
	
	public ActivoAgendaRevisionTitulo getActivoAgendaRevisionTituloById(Long id);

	public List<DtoActivoAgendaRevisionTitulo> getListAgendaRevisionTitulo(Long idActivo) throws Exception;
	
	public void createAgendaRevisionTitulo(Long idActivo, String subtipologias, String observaciones) throws Exception;

	public void deleteAgendaRevisionTitulo(Long idAgendaRevisionTitulo) throws Exception;

	public void actualizarAgendaRevisionTitulo(DtoActivoAgendaRevisionTitulo dto) throws Exception;

	public DtoAdmisionRevisionTitulo getTabDataRevisionTitulo(Long idActivo) throws AdmisionException, IllegalAccessException, InvocationTargetException;

	public void saveTabDataRevisionTitulo(DtoAdmisionRevisionTitulo dto) throws  AdmisionException, IllegalAccessException, InvocationTargetException;
	
}