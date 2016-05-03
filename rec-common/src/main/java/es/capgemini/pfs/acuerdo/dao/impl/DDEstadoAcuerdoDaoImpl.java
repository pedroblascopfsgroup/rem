package es.capgemini.pfs.acuerdo.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.acuerdo.dao.DDEstadoAcuerdoDao;
import es.capgemini.pfs.acuerdo.model.DDEstadoAcuerdo;
import es.capgemini.pfs.dao.AbstractEntityDao;

/**
 * @author Mariano Ruiz
 *
 */
@Repository("DDEstadoAcuerdoDao")
public class DDEstadoAcuerdoDaoImpl extends AbstractEntityDao<DDEstadoAcuerdo, Long> implements DDEstadoAcuerdoDao {

	/**
	 * Busca un DDEstadoAcuerdo.
	 * @param codigo String: el codigo del DDEstadoAcuerdo
	 * @return DDEstadoAcuerdo
	 */
    @SuppressWarnings("unchecked")
    public DDEstadoAcuerdo buscarPorCodigo(String codigo) {
		String hql = "from DDEstadoAcuerdo where codigo = ?";
		List<DDEstadoAcuerdo> tipos = getHibernateTemplate().find(hql, codigo);
		if (tipos==null || tipos.size()==0){
			return null;
		}
		return tipos.get(0);
	}
    
    @SuppressWarnings("unchecked")
   	public List<DDEstadoAcuerdo> getListEstadosAcuerdo() {
   		//StringBuilder sb = new StringBuilder();
       	String hql = "from DDEstadoAcuerdo where auditoria.borrado = 0";
   		//sb.append("Select * from DDSolicitante sol ");
   		//sb.append("where sol.auditoria.borrado = 0 ");
   		
   		List<DDEstadoAcuerdo> lista = getHibernateTemplate().find(hql);
   				
   		return lista;
   	}
}
