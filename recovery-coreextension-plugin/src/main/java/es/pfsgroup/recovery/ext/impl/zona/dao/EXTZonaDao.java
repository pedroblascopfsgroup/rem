package es.pfsgroup.recovery.ext.impl.zona.dao;

import java.util.List;
import java.util.Set;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.zona.model.DDZona;

public interface EXTZonaDao extends AbstractDao<DDZona, Long>{
	
    /**
     * Obtiene todas las zonas de un nivel.
     *
     * @param codigoNivel 
     * @param codigoZonasUsuario zonas del usuario
     * @return zonas
     */
	List<DDZona> buscarZonasPorCodigoNivel(Integer codigoNivel, Set<String> codigoZonasUsuario);

}
