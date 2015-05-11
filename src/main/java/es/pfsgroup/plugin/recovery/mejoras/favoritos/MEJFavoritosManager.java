package es.pfsgroup.plugin.recovery.mejoras.favoritos;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.comun.ComunBusinessOperation;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.eventfactory.EventFactory;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.interna.InternaBusinessOperation;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.mejoras.favoritos.api.MEJFavoritosHandlerApi;
import es.pfsgroup.plugin.recovery.mejoras.favoritos.dao.MEJFavoritosDao;
import es.pfsgroup.plugin.recovery.mejoras.favoritos.dao.impl.MEJFavoritosDaoImpl;
import es.pfsgroup.plugin.recovery.mejoras.favoritos.dto.MEJDtoFavoritos;
import es.pfsgroup.plugin.recovery.mejoras.favoritos.model.MEJFavoritos;

/**
 * Clase manager de la entidad Favoritos.
 *
 * @author jbosnjak
 *
 */

@Service
public class MEJFavoritosManager {

	public static final String MEJ_MGR_FAVORITOS_MANTENER = "plugin.mejoras.MEJfavoritosManager.mantenerFavoritos";
	public static final String MEJ_BO_FAVORITOS_MGR_SAVE_OR_UPDATE = "plugin.mejoras.MEJfavoritosManager.saveOrUpdate";
	public static final String MEJ_BO_FAVORITOS_MGR_ELIMINAR_FAVORITOS_POR_ENTIDAD_ELIMINADA = "plugin.mejoras.MEJfavoritosManager.eliminarFavoritosPorEntidadEliminada";
	public static final String MEJ_BO_FAVORITOS_MGR_ELIMINAR_FAVORITOS_POR_ENTIDAD = "plugin.mejoras.MEJfavoritosManager.eliminarFavoritosUsuarioPorEntidad";
	
	@Autowired(required=false) 
	List<MEJFavoritosHandlerApi> favoritosHandlers;
	
    @Autowired
    private Executor executor;

    @Autowired
	private GenericABMDao genericDao;
    
    @Autowired
    private MEJFavoritosDao MEJfavoritosDao;

    private static final int CANTIDAD_MAXIMA_FAVORITOS = 15;

    /**
     * graba un nuevo favorito en caso de que venga como parametro
     * y devuelve los favoritos para un usuario.
     * @param dto dto favoritos
     * @return favoritos
     */
    @BusinessOperation(MEJ_MGR_FAVORITOS_MANTENER)
    @Transactional(readOnly = false)
    //TODO mejorar la performance de este metodo. saludos terricolas
    public List<MEJFavoritos> mantenerFavoritos(MEJDtoFavoritos dto) {
    	EventFactory.onMethodStart(this.getClass());
    	
        //NUEVO PROCESO:
        if (dto.getEntidadInformacion() == null) {
            return MEJfavoritosDao.obtenerFavoritosOrdenados();
        }
        Usuario usu = (Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO);
        dto.setIdUsuario(usu.getId());
        //BUSCARLO EN LA LISTA, SI ESTA SE BORRA
        MEJfavoritosDao.buscarYBorrarFavorito(dto);
        //SE INSERTA EL NUEVO
        MEJFavoritos nuevoFav = crearFavorito(dto);
        this.saveOrUpdate(nuevoFav);
        List<MEJFavoritos> favoritosActuales = MEJfavoritosDao.obtenerFavoritosOrdenados();
        //SI SON MAS DE 15 SE BORRA EL DE MENOS ID.
        if (favoritosActuales.size() > CANTIDAD_MAXIMA_FAVORITOS) {
        	MEJFavoritos yaNoEsFavorito = favoritosActuales.remove(favoritosActuales.size() - 1);
            MEJfavoritosDao.delete(yaNoEsFavorito);
        }
        //En caso de que no se inserte nada, como la primera vez, se devuelve la lista simplemente
        if (dto.getEntidadInformacion() == null || dto.getIdInformacion() == null) {
            return favoritosActuales;
        }

        return favoritosActuales;
    }
    
    private MEJFavoritos crearFavorito(MEJDtoFavoritos dto) {
    	
    	DDTipoEntidad tipoEntidad  = (DDTipoEntidad)executor.execute(
        		ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
        		DDTipoEntidad.class,
        		dto.getEntidadInformacion());
    	
    	MEJFavoritos newFav = null;
    	
    	if (favoritosHandlers != null){
    		for (MEJFavoritosHandlerApi handler : favoritosHandlers){
        		if (handler.getCodigo().equals(tipoEntidad.getCodigo())){
        			newFav =  handler.crearFavoritoProductorConsumidor(dto);
        		}
    		}
    	} else {
    		newFav = crearFavorito_old(dto);
    	}
    	return newFav;
    }
    
    
    
    /**
     * crea una entidad favorito.
     * @param dto dtoFavoritos
     */
    private MEJFavoritos crearFavorito_old(MEJDtoFavoritos dto) {
    	DDTipoEntidad tipoEntidad  = (DDTipoEntidad)executor.execute(
        		ComunBusinessOperation.BO_DICTIONARY_GET_BY_CODE,
        		DDTipoEntidad.class,
        		dto.getEntidadInformacion());

    	if (tipoEntidad==null){
    		Filter f1 = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getEntidadInformacion());
    		tipoEntidad = genericDao.get(DDTipoEntidad.class, f1);
    	}
    	
    	MEJFavoritos newFav = new MEJFavoritos();
        newFav.setEntidadInformacion(tipoEntidad);
        newFav.setUsuario((Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO));
        newFav.setOrden(new Integer(1));
        if (DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO.equals(tipoEntidad.getCodigo())) {
            Asunto asu = (Asunto) executor.execute(ExternaBusinessOperation.BO_ASU_MGR_GET, dto.getIdInformacion());
            newFav.setAsunto(asu);
        } else if (DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE.equals(tipoEntidad.getCodigo())) {
            Persona per = (Persona) executor.execute(PrimariaBusinessOperation.BO_PER_MGR_GET, dto.getIdInformacion());
            newFav.setPersona(per);
        } else if (DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE.equals(tipoEntidad.getCodigo())) {
            Expediente exp = (Expediente) executor.execute(InternaBusinessOperation.BO_EXP_MGR_GET_EXPEDIENTE, dto.getIdInformacion());
            newFav.setExpediente(exp);
        } else if (DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO.equals(tipoEntidad.getCodigo())) {
            Procedimiento prc = (Procedimiento) executor.execute(ExternaBusinessOperation.BO_PRC_MGR_GET_PROCEDIMIMENTO, dto.getIdInformacion());
            newFav.setProcedimiento(prc);
        } else if (DDTipoEntidad.CODIGO_ENTIDAD_CONTRATO.equals(tipoEntidad.getCodigo())) {
            Contrato cnt = (Contrato) executor.execute(PrimariaBusinessOperation.BO_CNT_MGR_GET, dto.getIdInformacion());
            newFav.setContrato(cnt);
        } else if (MEJFavoritosDaoImpl.CODIGO_ENTIDAD_BIEN.equals(tipoEntidad.getCodigo())) {
            Bien bie = (Bien) executor.execute(PrimariaBusinessOperation.BO_BIEN_MGR_GET, dto.getIdInformacion());
            newFav.setBien(bie);
        } else if (MEJFavoritosDaoImpl.CODIGO_ENTIDAD_ASUNTOND.equals(tipoEntidad.getCodigo())) {
        	Asunto asu = (Asunto) executor.execute("plugin.gestionJudicial.asunto.nd.obtener", dto.getIdInformacion());
            newFav.setAsunto(asu);
        }
        return newFav;
    }

    /**
     * Guarda favoritos en la base de datos.
     * @param favoritos la tarea a guardar.
     */
    @BusinessOperation(MEJ_BO_FAVORITOS_MGR_SAVE_OR_UPDATE)
    public void saveOrUpdate(MEJFavoritos favoritos) {
        MEJfavoritosDao.saveOrUpdate(favoritos);
    }

    /**
     * elimina todas la entradas de favoritos relacionadas con una entidad.
     * @param idEntidad id (para este metodo siempre sera un bien)
     * @param tipoEntidad tipo entidad
     */
    @BusinessOperation(MEJ_BO_FAVORITOS_MGR_ELIMINAR_FAVORITOS_POR_ENTIDAD_ELIMINADA)
    @Transactional(readOnly = false)
    public void eliminarFavoritosPorEntidadEliminada(Long idEntidad, String tipoEntidad) {
        List<MEJFavoritos> favoritos = MEJfavoritosDao.obtenerFavoritosEntidad(idEntidad, tipoEntidad);
        for (MEJFavoritos fav : favoritos) {
            MEJfavoritosDao.delete(fav);
        }
    }

    /**
     * elimina todas la entradas de favoritos relacionadas con una entidad.
     * @param idUsuario id
     * @param idEntidad long (para este metodo siempre sera un bien)
     * @param tipoEntidad string
     */
    @BusinessOperation(MEJ_BO_FAVORITOS_MGR_ELIMINAR_FAVORITOS_POR_ENTIDAD)
    @Transactional(readOnly = false)
    public void eliminarFavoritosUsuarioPorEntidad(Long idUsuario, Long idEntidad, String tipoEntidad) {
    	MEJDtoFavoritos dto = new MEJDtoFavoritos();

        dto.setEntidadInformacion(tipoEntidad);
        dto.setIdInformacion(idEntidad);
        dto.setIdUsuario(idUsuario);

        MEJfavoritosDao.buscarYBorrarFavorito(dto);
    }
}
