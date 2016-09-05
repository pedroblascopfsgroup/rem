package es.capgemini.pfs.acuerdo.dao.impl;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.acuerdo.dao.DDTipoAcuerdoDao;
import es.capgemini.pfs.acuerdo.model.DDTipoAcuerdo;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.tareaNotificacion.model.DDEntidadAcuerdo;

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
		sb.append("order by tpa.descripcion");
		
		List<DDTipoAcuerdo> lista = getHibernateTemplate().find(sb.toString());
				
		return lista;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<DDTipoAcuerdo> buscarTipoAcuerdoPorEntidad(DDEntidadAcuerdo entidadAmbas, DDEntidadAcuerdo entidad) {
		StringBuilder sb = new StringBuilder();

		sb.append("Select tpa from DDTipoAcuerdo tpa ");
		//sb.append("where tpa.auditoria.borrado = 0 ");
		sb.append("where 1=1 ");
		
		if(entidad.getCodigo().equals("ASU")){
			sb.append(" and tpa.tipoEntidad.id in ("+entidadAmbas.getId()+")");
			sb.append(" or tpa.tipoEntidad.id in ("+entidad.getId()+")");
		}
		
		if(entidad.getCodigo().equals("EXP")){
			sb.append(" and tpa.tipoEntidad.id in ("+entidadAmbas.getId()+")");
			sb.append(" or tpa.tipoEntidad.id in ("+entidad.getId()+")");
		}	
		
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
