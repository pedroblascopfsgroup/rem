package es.capgemini.pfs.acuerdo.dao.impl;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.acuerdo.dao.DDTipoAcuerdoDao;
import es.capgemini.pfs.acuerdo.model.DDTipoAcuerdo;
import es.capgemini.pfs.dao.AbstractEntityDao;

/**
 * @author Mariano Ruiz
 *
 */
@Repository("DDTipoAcuerdoDao")
public class DDTipoAcuerdoDaoImpl extends AbstractEntityDao<DDTipoAcuerdo, Long> implements DDTipoAcuerdoDao {

	/**
	 * Busca un DDTipoAcuerdo.
	 * @param codigo String: el codigo del DDTipoAcuerdo
	 * @return DDTipoAcuerdo
	 */
    @SuppressWarnings("unchecked")
    public DDTipoAcuerdo buscarPorCodigo(String codigo) {
		String hql = "from DDTipoAcuerdo where codigo = ?";
		List<DDTipoAcuerdo> tipos = getHibernateTemplate().find(hql, codigo);
		if (tipos==null || tipos.size()==0){
			return null;
		}
		return tipos.get(0);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<DDTipoAcuerdo> buscarTipoAcuerdoPorFiltro(Long ambito, Long ambas) {
		StringBuilder sb = new StringBuilder();
		
		sb.append("Select tpa from DDTipoAcuerdo tpa ");
		sb.append("where tpa.auditoria.borrado = 0 ");
		sb.append("and tpa.tipoEntidad.id in ("+ambito+","+ambas+")");
		
		List<DDTipoAcuerdo> lista = getHibernateTemplate().find(sb.toString());
				
		return lista;
	}
	
	private List<DDTipoAcuerdo> castearListado(List<Object[]> lista) {
		List<DDTipoAcuerdo> resultado = new ArrayList<DDTipoAcuerdo>();
		
		for (Object[] item : lista) {
			DDTipoAcuerdo tipoAcuerdo = new DDTipoAcuerdo();
				
						
			resultado.add(tipoAcuerdo);
		}
		
		return resultado;
	}
}
