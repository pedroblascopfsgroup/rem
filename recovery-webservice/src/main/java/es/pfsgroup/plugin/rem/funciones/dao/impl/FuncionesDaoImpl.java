package es.pfsgroup.plugin.rem.funciones.dao.impl;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.List;

import org.hibernate.Query;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.users.domain.Funcion;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.plugin.rem.funciones.dao.FuncionesDao;
import es.pfsgroup.plugin.rem.funciones.dto.DtoFunciones;

@Repository("FuncionesDao")
public class FuncionesDaoImpl extends AbstractEntityDao<Funcion, Long> implements FuncionesDao {
	
	BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();

	@SuppressWarnings("unchecked")
	@Override
	public List<DtoFunciones> getFunciones(DtoFunciones dto) {
		List<DtoFunciones> listaFunciones = new ArrayList<DtoFunciones>();
		
		HQLBuilder hb = new HQLBuilder("select fun.id, fun.descripcionLarga, fun.descripcion from Funcion fun");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "fun.auditoria.borrado", false);

		Query query = this.getSessionFactory().getCurrentSession().createQuery(hb.toString());
		HQLBuilder.parametrizaQuery(query, hb);
		List<Object[]> listaQuery =  query.list();
		
		for (Object[] funcion : listaQuery) {
			DtoFunciones nuevoDto = new DtoFunciones();
			
			try {
				beanUtilNotNull.copyProperty(nuevoDto, "id", funcion[0]);
				beanUtilNotNull.copyProperty(nuevoDto, "descripcion", funcion[1]);
				beanUtilNotNull.copyProperty(nuevoDto, "descripcionLarga", funcion[2]);
			} catch (IllegalAccessException e) {
				e.printStackTrace();
			} catch (InvocationTargetException e) {
				e.printStackTrace();
			}

			if (!Checks.esNulo(nuevoDto)) {
				listaFunciones.add(nuevoDto);
			}
		}
		
		return listaFunciones;
	}
	
	@Override
	public boolean userHasFunction(String username, String descripcion) {

		HQLBuilder hb = new HQLBuilder("select count(*) from Funcion fun, Perfil pef, ZonaUsuarioPerfil zon, Usuario usu, FuncionPerfil fp");
		hb.appendWhere("zon.usuario.id = usu.id and usu.username = :username");
		hb.appendWhere("pef.id = zon.perfil.id");
		hb.appendWhere("pef.id = fp.perfil.id");
		hb.appendWhere("fp.funcion.id = fun.id and fun.descripcion = :descripcion");
		hb.getParameters().put("username", username);
		hb.getParameters().put("descripcion", descripcion);
		
		 
		Query query = this.getSessionFactory().getCurrentSession().createQuery(hb.toString());
		HQLBuilder.parametrizaQuery(query, hb);
	
		return (((Long)  query.uniqueResult()) != 0L);
	}

}
