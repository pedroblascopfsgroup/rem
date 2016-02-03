package es.pfsgroup.plugin.recovery.plazosExterna.tipoJuzgado.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.procesosJudiciales.model.TipoJuzgado;
import es.pfsgroup.plugin.recovery.plazosExterna.plazoTareaExternaPlaza.dto.PTEDtoQuery;

public interface PTETipoJuzgadoDao extends AbstractDao<TipoJuzgado, Long>{

	List<TipoJuzgado> findJuzPlazaYDescrip(PTEDtoQuery dto);

}
