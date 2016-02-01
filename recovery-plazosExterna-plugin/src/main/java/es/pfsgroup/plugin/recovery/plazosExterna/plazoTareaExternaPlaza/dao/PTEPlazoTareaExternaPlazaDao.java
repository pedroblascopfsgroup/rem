package es.pfsgroup.plugin.recovery.plazosExterna.plazoTareaExternaPlaza.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.recovery.plazosExterna.plazoTareaExternaPlaza.dto.PTEDtoBusquedaPlazo;
import es.pfsgroup.plugin.recovery.plazosExterna.plazoTareaExternaPlaza.dto.PTEDtoPlazoTarea;
import es.pfsgroup.plugin.recovery.plazosExterna.plazoTareaExternaPlaza.model.PTEPlazoTareaExternaPlaza;

public interface PTEPlazoTareaExternaPlazaDao extends AbstractDao<PTEPlazoTareaExternaPlaza, Long>{

	List<PTEPlazoTareaExternaPlaza> findPlazos(PTEDtoBusquedaPlazo dto);

	List<PTEPlazoTareaExternaPlaza> compruebaExistePlazo(PTEDtoPlazoTarea dto);

}
