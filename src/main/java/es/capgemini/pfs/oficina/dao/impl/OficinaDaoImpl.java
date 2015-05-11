package es.capgemini.pfs.oficina.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.oficina.dao.OficinaDao;
import es.capgemini.pfs.oficina.model.Oficina;

/**
 * Implementacion de OficinaDao.
 *
 */
@Repository("OficinaDao")
public class OficinaDaoImpl extends AbstractEntityDao<Oficina, Long> implements OficinaDao {

	   private static final String BUSCAR_POR_CODIGO = "from Oficina where codigo = ?";
	   private static final String BUSCAR_POR_CODIGO_OFICINA = "from Oficina where codigoOficina = ?";

    /**
     * Busca una oficina por su codigo.
     * @param codigo el codigo de la oficina
     * @return la oficina.
     */
    @SuppressWarnings("unchecked")
    public Oficina buscarPorCodigo(Integer codigo) {
        List<Oficina> oficinas = getHibernateTemplate().find(BUSCAR_POR_CODIGO, new Object[] { codigo });
        if (oficinas.size() > 0) {
            return oficinas.get(0);
        }
        return null;
    }

	@Override
	public Oficina buscarPorCodigoOficina(Integer codigo) {
		@SuppressWarnings("unchecked")
		List<Oficina> oficinas = getHibernateTemplate().find(BUSCAR_POR_CODIGO_OFICINA, new Object[] { codigo });
        
        return oficinas.size() == 0 ? null : oficinas.get(0);
	}
	
	@Override
	public List<Oficina> damePadresOficina(Long idZonaOficina) {
		StringBuffer sql = new StringBuffer();
		sql.append("WITH recursiveBOM (zon_id,zon_pid,niv_id, ofi_id) AS ")
			.append("(SELECT ZON_ID,ZON_PID,NIV_ID,OFI_ID FROM ZON_ZONIFICACION ")
			.append("WHERE BORRADO=0 AND ZON_ID=").append(idZonaOficina).append(" ")
			.append("UNION ALL ")
			.append("SELECT p.ZON_ID,CASE WHEN p.ZON_ID=p.ZON_PID THEN NULL ELSE p.ZON_PID END,p.niv_id,p.ofi_id FROM recursiveBOM c, ZON_ZONIFICACION p ")
			.append("WHERE p.ZON_ID=c.ZON_PID AND p.BORRADO=0 AND ) ")
			.append("SELECT ofi.* FROM recursiveBOM rec INNER JOIN OFI_OFICINAS ofi ON ofi.OFI_ID=rec.OFI_ID AND ofi.BORRADO=0 ")
			.append("ORDER BY rec.NIV_ID DESC");
		return  (List<Oficina>) getSession().createSQLQuery(sql.toString()).addEntity(Oficina.class).list();
	}
	
	@Override
	public List<Oficina> dameAscendientesOficinaAPartirDeNivel(Long idZonaOficina, Long nivelId) {
		StringBuffer sql = new StringBuffer();
		sql.append("WITH recursiveBOM (zon_id,zon_pid,niv_id, ofi_id) AS ")
			.append("(SELECT ZON_ID,ZON_PID,NIV_ID,OFI_ID FROM ZON_ZONIFICACION ")
			.append("WHERE BORRADO=0 AND ZON_ID=").append(idZonaOficina).append(" ")
			.append("UNION ALL ")
			.append("SELECT p.ZON_ID,CASE WHEN p.ZON_ID=p.ZON_PID THEN NULL ELSE p.ZON_PID END,p.niv_id,p.ofi_id FROM recursiveBOM c, ZON_ZONIFICACION p ")
			.append("WHERE p.ZON_ID=c.ZON_PID AND p.BORRADO=0) ")
			.append("SELECT ofi.* FROM recursiveBOM rec INNER JOIN OFI_OFICINAS ofi ON ofi.OFI_ID=rec.OFI_ID AND ofi.BORRADO=0 ")
			.append("WHERE rec.NIV_ID<=").append(nivelId).append(" ORDER BY rec.NIV_ID DESC");
		return  (List<Oficina>) getSession().createSQLQuery(sql.toString()).addEntity(Oficina.class).list();
	}

	@Override
	public Oficina dameAscendientesDirectoAPartirDeNivel(Long idZonaOficina, Long nivelId) {
		StringBuffer sql = new StringBuffer();
		sql.append("WITH recursiveBOM (zon_id,zon_pid,niv_id, ofi_id) AS ")
			.append("(SELECT ZON_ID,ZON_PID,NIV_ID,OFI_ID FROM ZON_ZONIFICACION ")
			.append("WHERE BORRADO=0 AND ZON_ID=").append(idZonaOficina).append(" ")
			.append("UNION ALL ")
			.append("SELECT p.ZON_ID,CASE WHEN p.ZON_ID=p.ZON_PID THEN NULL ELSE p.ZON_PID END,p.niv_id,p.ofi_id FROM recursiveBOM c, ZON_ZONIFICACION p ")
			.append("WHERE p.ZON_ID=c.ZON_PID AND p.BORRADO=0) ")
			.append("SELECT ofi.* FROM recursiveBOM rec INNER JOIN OFI_OFICINAS ofi ON ofi.OFI_ID=rec.OFI_ID AND ofi.BORRADO=0")
			.append("WHERE rec.NIV_ID<=").append(nivelId).append(" AND rownum=1 ORDER BY rec.NIV_ID DESC");
		return  (Oficina) getSession().createSQLQuery(sql.toString()).addEntity(Oficina.class).uniqueResult();
	}
	
}
