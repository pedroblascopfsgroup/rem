package es.capgemini.pfs.despachoExterno;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.despachoExterno.dao.DespachoExternoDao;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.users.domain.Usuario;

/**
 * Clase manager de Despachos Externos.
 * @author pamuller
 */
@Service
public class DespachoExternoManager {

    @Autowired
    private DespachoExternoDao despachoExternoDao;
    
    /**
     * Devuelve la lista de despachos externos.
     * @return la lista de despachos externos.
     */
    @BusinessOperation
    public List<DespachoExterno> getDespachosExternos() {
        return despachoExternoDao.getList();
    }

    /**
     * Devuelve la lista de gestores de un despacho.
     * @param idDespacho el id del despacho.
     * @return la lista de gestores.
     */
    @BusinessOperation
    public List<GestorDespacho> getGestoresDespacho(Long idDespacho) {
        return despachoExternoDao.buscarGestoresDespacho(idDespacho);
    }

    /**
     * Devuelve los despachos de un usuario y tipo
     * @param idUsuario
     * @param ddTipoDespachoExterno Constante de DDTipoDespachoExterno
     * @return
     */
    @BusinessOperation
    public List<GestorDespacho> buscaDespachosPorUsuarioYTipo(Long idUsuario, String ddTipoDespachoExterno) {
    	return despachoExternoDao.buscaDespachosPorUsuarioYTipo(idUsuario, ddTipoDespachoExterno);
    }

    /**
     * Devuelve los despachos de un usuario
     * 
     * @param idUsuario
     * @return
     */
    @BusinessOperation
    public List<GestorDespacho> buscaDespachosPorUsuario(Long idUsuario) {
    	return despachoExternoDao.buscaDespachosPorUsuario(idUsuario);
    }
    
    /**
     * Devuelve la lista de supervisores de un despacho.
     * @param idDespacho el id del despacho.
     * @return la lista de supervisores.
     */
    @BusinessOperation
    public List<GestorDespacho> getSupervisoresDespacho(Long idDespacho) {
        return despachoExternoDao.buscarSupervisoresDespacho(idDespacho);
    }

    /**
     * Devuelve la lista de gestores de un despacho.
     * @param idDespacho el id del despacho.
     * @return la lista de gestores.
     */
    @BusinessOperation
    public List<Usuario> getGestoresListadoDespachos(String listadoDespachos) {
        if (listadoDespachos == null || listadoDespachos.length() == 0)
            return new ArrayList<Usuario>();
        else
            return despachoExternoDao.getGestoresListadoDespachos(listadoDespachos);
    }

    /**
     * Devuelve la lista de supervisores de un despacho.
     * @param idDespacho el id del despacho.
     * @return la lista de supervisores.
     */
    @BusinessOperation
    public List<Usuario> getSupervisoresListadoDespachos(String listadoDespachos) {
        if (listadoDespachos == null || listadoDespachos.length() == 0)
            return new ArrayList<Usuario>();
        else
            return despachoExternoDao.getSupervisoresListadoDespachos(listadoDespachos);
    }

    /**
     * Devuelve la lista de supervisores completa.
     * @return la lista de supervisores.
     */
    @BusinessOperation
    public List<Usuario> getAllSupervisores() {
        return despachoExternoDao.buscarAllSupervisores();
    }

    /**
     * Devuelve una lista de despachos segun la lista de zonas
     * @param zonas
     * @return
     */
    @BusinessOperation
    public List<DespachoExterno> getDespachosPorTipoZona(String zonas, String tipoDespacho) {
        return despachoExternoDao.buscarDespachosPorTipoZona(zonas, tipoDespacho);
    }
    
   
    /**
     * Recupera un despacho externo que concuerde con el Id que le pasamos
     * @param idDespacho
     * @return
     */
    public DespachoExterno get(Long idDespacho) {
        return despachoExternoDao.get(idDespacho);
    }

}
