package es.capgemini.pfs.zona;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.oficina.model.Oficina;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.zona.dao.NivelDao;
import es.capgemini.pfs.zona.dao.ZonaDao;
import es.capgemini.pfs.zona.model.DDZona;
import es.capgemini.pfs.zona.model.Nivel;
import es.pfsgroup.commons.utils.Checks;

/**
 * Manager de Zona.
 * @author pamuller
 *
 */
@Service
public class ZonaManager {

    @Autowired
    private Executor executor;;

    @Autowired
    private NivelDao nivelDao;

    @Autowired
    private ZonaDao zonaDao;

    /**
     * obtiene todos los niveles.
     * @return niveles
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_ZONA_MGR_GET_NIVELES)
    public List<Nivel> getNiveles() {
        Long maximoNivel = ((Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO)).getMaximoNivelZona();
        List<Nivel> niveles = nivelDao.getList();
        niveles = filtrarPermisosNivel(niveles, maximoNivel);
        return niveles;
    }

    /**
     * obtiene todos los niveles.
     * @return niveles
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_ZONA_MGR_GET_ALL_NIVELES)
    public List<Nivel> getAllNiveles() {
        List<Nivel> niveles = nivelDao.getList();
        return niveles;
    }

    /**
     * filtra los niveles a los que no tengo acceso.
     * @param niveles niveles
     * @param maximoNivel maximo acceso
     * @return nuevos niveles
     */
    private List<Nivel> filtrarPermisosNivel(List<Nivel> niveles, Long maximoNivel) {
        List<Nivel> nuevoNivel = new ArrayList<Nivel>();
        for (Nivel n : niveles) {
            if (n.getId().longValue() >= maximoNivel.longValue()) {
                nuevoNivel.add(n);
            }
        }
        return nuevoNivel;
    }

    /**
     * Obtiene las zonas del nivel.
     * @param idNivel id nivel
     * @return zonas
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_ZONA_MGR_GET_ALL_ZONAS_POR_NIVEL)
    public List<DDZona> getAllZonasPorNivel(Long idNivel) {
        if (idNivel == null || idNivel.longValue() == 0) { return new ArrayList<DDZona>(); }
        return zonaDao.buscarZonasPorCodigoNivel(idNivel, null);
    }

    /**
     * Obtiene las zonas del nivel.
     * @param idNivel id nivel
     * @return zonas
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_ZONA_MGR_GET_ZONAS_POR_NIVEL)
    public List<DDZona> getZonasPorNivel(Long idNivel) {
        if (idNivel == null || idNivel.longValue() == 0) { return new ArrayList<DDZona>(); }
        Set<String> codigoZonasUsuario = ((Usuario) executor.execute(ConfiguracionBusinessOperation.BO_USUARIO_MGR_GET_USUARIO_LOGADO))
                .getCodigoZonas();
        return zonaDao.buscarZonasPorCodigoNivel(idNivel, codigoZonasUsuario);
    }

    /**
     * Obtiene las zonas relacionadas con el perfil de la tabla ZON_PEF_USU.
     * @param idPerfil id idPerfil
     * @return zonas
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_ZONA_MGR_GET_ZONA_POR_PERFIL)
    public List<DDZona> getZonasPorPerfil(Long idPerfil) {
        return zonaDao.buscarZonasPorPerfil(idPerfil);
    }

    /**
     * Obtiene las zonas relacionadas con el perfil de la tabla ZON_PEF_USU.
     * @param idPerfil id idPerfil
     * @return zonas
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_ZONA_MGR_GET_ZONA_POR_CODIGO_PERFIL)
    public List<DDZona> getZonasPorCodigoPerfil(String codPerfil) {
        return zonaDao.buscarZonasPorCodigoPerfil(codPerfil);
    }
    
    /**
     * Obtiene la zona correspondiente a un nÃºmero de centro.
     *
     * @param centro String
     * @return Zona
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_ZONA_MGR_GET_ZONA_POR_CENTRO)
    public DDZona getZonaPorCentro(String centro) {
        return zonaDao.getZonaPorCentro(centro);
    }

    /**
     * @param codigo String
     * @return Zona
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_ZONA_MGR_GET_ZONA_POR_CODIGO)
    public DDZona getZonaPorCodigo(String codigo) {
        return zonaDao.getZonaPorCodigo(codigo);
    }

    /**
     * @param descripcion String
     * @return Zona
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_ZONA_MGR_GET_ZONA_POR_DESCRIPCION)
    public DDZona getZonaPorDescripcion(String descripcion) {
        return zonaDao.getZonaPorDescripcion(descripcion);
    }

    /**
     * Retorna todas las zonas con los códigos pasados.
     * @param codigos Set String
     * @return List Zona
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_ZONA_MGR_FIND_ZONA_BY_CODIGO)
    List<DDZona> findZonasBycodigo(Set<String> codigos) {
        return zonaDao.findZonasBycodigo(codigos);
    }

    /**
     * @param id Long
     * @return Nivel
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_ZONA_MGR_GET_NIVEL)
    public Nivel getNivel(Long id) {
        return nivelDao.get(id);
    }

    /**
     * Obtiene el nivel, pero el id se pasa como un String.
     * @param id String
     * @return Nivel
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_ZONA_MGR_GET_NIVELES_BY_ID)
    public Nivel getNivelById(String id) {
        if (id == null || id.equals("")) { return null; }
        return nivelDao.get(new Long(id));
    }

    /**
     * Obtiene el nivel, pero el id se pasa como un String.
     * @param id String
     * @return Nivel
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_ZONA_MGR_GET_NIVELES_BY_ID_OR_EMPTY_OBJ)
    public Nivel getNivelByIdOrEmptyObj(String id) {
        Nivel nivel;
        if (id == null || id.equals("")) {
            nivel = new Nivel();
            nivel.setDescripcion("");
        } else {
            nivel = nivelDao.get(new Long(id));
        }
        return nivel;
    }

    /**
     * Obtiene las zonas relacionadas con el perfil de la tabla ZON_PEF_USU.
     * @param idPerfil id idPerfil
     * @return zonas
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_ZONA_MGR_BUSCAR_ZONA_POR_PERFIL)
    public List<DDZona> buscarZonasPorPerfil(Long idPerfil) {
        return zonaDao.buscarZonasPorPerfil(idPerfil);
    }

    /**
     * Consulta si para esa zona existe ese perfil
     * @param idZona
     * @param idPerfil
     * @return
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_ZONA_MGR_EXISTE_PERFIL_ZONA)
    public Boolean existePerfilZona(Long idZona, Long idPerfil) {
        return zonaDao.existePerfilZona(idZona, idPerfil);
    }

    /**
     * Devuelve si el padre de la zona es territorial, sino null
     * @param idZona
     * @return
     */
    @BusinessOperation(ConfiguracionBusinessOperation.BO_ZONA_MGR_GET_ZONA_TERRITORIAL)
    public DDZona getZonaTerritorial(DDZona zona) {
        if (!Checks.esNulo(zona)) {
        	DDZona zPadre = zona.getZonaPadre();
        	if (!Checks.esNulo(zPadre)) {
	        	if (Nivel.NIVEL_TERRITORIO.toString().equals(zPadre.getNivel().getCodigo())) {

	        		DDZona zonaTerritorial = zPadre;
					Oficina oficinaTerritorial = (!Checks.esNulo(zonaTerritorial)) ? zonaTerritorial.getOficina() : null;
					
					// TERRITORIAL
					zPadre.setDescripcion(oficinaTerritorial.getCodDescripOficina(true, false));

					return zPadre;
	        	}        	
        	}
        }
        return null;
    }

}
