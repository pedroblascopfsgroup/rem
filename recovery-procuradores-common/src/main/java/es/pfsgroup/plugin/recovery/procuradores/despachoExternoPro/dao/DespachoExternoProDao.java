package es.pfsgroup.plugin.recovery.procuradores.despachoExternoPro.dao;

import es.capgemini.devon.pagination.Page;
import es.pfsgroup.plugin.recovery.procuradores.categorias.dto.CategorizacionDto;

public interface DespachoExternoProDao {

	Page getPageDespachosExternos(CategorizacionDto dto, String nombre);

}
