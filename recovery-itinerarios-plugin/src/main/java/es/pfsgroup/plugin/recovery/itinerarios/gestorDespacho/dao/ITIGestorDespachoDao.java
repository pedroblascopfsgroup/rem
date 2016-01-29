package es.pfsgroup.plugin.recovery.itinerarios.gestorDespacho.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;

public interface ITIGestorDespachoDao extends AbstractDao<GestorDespacho, Long> {

	public List<GestorDespacho> getGestores();
	
	public List<GestorDespacho> getSupervisores();

}
