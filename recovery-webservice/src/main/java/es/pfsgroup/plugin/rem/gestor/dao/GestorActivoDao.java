package es.pfsgroup.plugin.rem.gestor.dao;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.framework.paradise.gestorEntidad.dao.GestorEntidadDao;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ConfiguracionAccesoGestoria;


public interface GestorActivoDao extends GestorEntidadDao{
	public List<Usuario> getListUsuariosGestoresActivoByTipoYActivo(Long idTipoGestor, Activo activo);
	
	public Usuario getDirectorEquipoByGestor(Usuario gestor);
	
	public List<Usuario> getListUsuariosGestoresActivoBycodigoTipoYActivo(String codigoTipoGestor, Activo activo);
	
	/**
	 * Comprueba si el usuario es Gestor Externo, es decir, con perfiles:
	 * 'HAYAFSV','PERFGCCBANKIA','GESTOADM','GESTIAFORM','HAYAGESTADMT','GESTOCED','GESTOPLUS','GTOPOSTV','GESTOPDV','HAYAPROV','HAYACERTI','HAYACONSU'
	 * @param idUsuario
	 * @return
	 */
	public Boolean isUsuarioGestorExterno(Long idUsuario);
	
	/**
	 * Comprueba si el usuario es Gestor Externo de tipo proveedor, es decir, con perfiles:
	 * 'GESTOADM','GESTIAFORM','HAYAGESTADMT','GESTOCED','GESTOPLUS','GTOPOSTV','GESTOPDV','HAYAPROV','HAYACERTI'
	 * @param idUsuario
	 * @return
	 */
	public Boolean isUsuarioGestorExternoProveedor(Long idUsuario);
	
    /*
     * Recupera una lista con la configuracion de gestorias dado un id de usuario
     * @param usuario
     * @return lista usuarios
     */
	List<ConfiguracionAccesoGestoria> getConfiguracionGestorias(ArrayList<String> idGrupos);
}
