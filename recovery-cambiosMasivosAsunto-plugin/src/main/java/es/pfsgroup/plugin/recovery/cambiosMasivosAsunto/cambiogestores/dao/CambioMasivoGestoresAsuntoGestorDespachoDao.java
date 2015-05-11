package es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.cambiogestores.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;

public interface CambioMasivoGestoresAsuntoGestorDespachoDao extends AbstractDao<GestorDespacho, Long>{

	List<GestorDespacho> buscaGestoresByDespachoTipoGestor(Long despacho, Long tipoGestor, boolean conAsunto);

}
