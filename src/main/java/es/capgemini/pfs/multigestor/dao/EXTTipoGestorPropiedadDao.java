package es.capgemini.pfs.multigestor.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.multigestor.model.EXTTipoGestorPropiedad;

public interface EXTTipoGestorPropiedadDao extends AbstractDao<EXTTipoGestorPropiedad, Long>{

	public List<EXTTipoGestorPropiedad> getByClaveValor(String clave, String valor);
	public List<EXTTipoGestorPropiedad> getByClave(String clave);
	public EXTTipoGestorPropiedad getGestorPropiedad(String codTipoGestor, String clave, String valor);
	public EXTTipoGestorPropiedad getByGestorClave(String codTipoGestor, String clave);
}
