package es.pfsgroup.plugin.rem.perfilAdministracion.dao.impl;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.hibernate.Query;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.plugin.rem.model.VBusquedaPerfiles;
import es.pfsgroup.plugin.rem.perfilAdministracion.dao.PerfilAdministracionDao;
import es.pfsgroup.plugin.rem.perfilAdministracion.dto.DtoPerfilAdministracionFilter;

@Repository("PerfilAdministracionDao")
public class PerfilAdministracionDaoImpl extends AbstractEntityDao<VBusquedaPerfiles, Long> implements PerfilAdministracionDao {
	
	BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();

	@SuppressWarnings("unchecked")
	@Override
	public List<DtoPerfilAdministracionFilter> getPerfiles(DtoPerfilAdministracionFilter dto) {
		String hql = "select distinct pef.pefId, pef.perfilDescripcion, pef.perfilDescripcionLarga, pef.perfilCodigo from VBusquedaPerfiles pef";	
		HQLBuilder hb = new HQLBuilder(hql);

		HQLBuilder.addFiltroLikeSiNotNull(hb, "pef.perfilDescripcion", dto.getPerfilDescripcion(), true);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pef.perfilCodigo", dto.getPerfilCodigo());

		if (!Checks.esNulo(dto.getFuncionDescripcionLarga())) {
			boolean primero = true;
			List<String> listaFuncionDescripcionLarga = Arrays.asList(dto.getFuncionDescripcionLarga().split(","));
			
			for (String funcionDescripcionLarga : listaFuncionDescripcionLarga) {
				if (primero) {
					HQLBuilder.addFiltroLikeSiNotNull(hb, "pef.funcionDescripcionLarga", funcionDescripcionLarga);
					primero = false;
				} else {
					HQLBuilder.addFiltroLikeSiNotNull(hb, "pef.funcionDescripcionLarga", funcionDescripcionLarga, false, true);
				}
			}
		}

		Page p = HibernateQueryUtils.page(this, hb, dto);
		List<Object[]> busquedaPerfil = (List<Object[]>) p.getResults();
		List<DtoPerfilAdministracionFilter> dtoPerfilFilter = new ArrayList<DtoPerfilAdministracionFilter>();

		for (Object[] busqueda : busquedaPerfil) {
			DtoPerfilAdministracionFilter nuevoDto = new DtoPerfilAdministracionFilter();
			try {
				beanUtilNotNull.copyProperty(nuevoDto, "pefId", busqueda[0]);
				beanUtilNotNull.copyProperty(nuevoDto, "perfilDescripcion", busqueda[1]);
				beanUtilNotNull.copyProperty(nuevoDto, "perfilDescripcionLarga", busqueda[2]);
				beanUtilNotNull.copyProperty(nuevoDto, "perfilCodigo", busqueda[3]);
				beanUtilNotNull.copyProperty(nuevoDto, "totalCount", p.getTotalCount());
			} catch (IllegalAccessException e) {
				logger.error(e);
			} catch (InvocationTargetException e) {
				logger.error(e);
			}

			if (!Checks.esNulo(nuevoDto)) {
				dtoPerfilFilter.add(nuevoDto);
			}
		}
		
		return dtoPerfilFilter;

	}

	@Override
	public VBusquedaPerfiles getPerfilById(Long id) {
		HQLBuilder hb = new HQLBuilder("from VBusquedaPerfiles pef");

		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pef.pefId", id);

		return HibernateQueryUtils.uniqueResult(this, hb);
	}

	@Override
	public List<DtoPerfilAdministracionFilter> getFuncionesByPerfilId(Long id, DtoPerfilAdministracionFilter dto) {
		HQLBuilder hb = new HQLBuilder("select pef.id, pef.funcionDescripcion, pef.funcionDescripcionLarga from VBusquedaPerfiles pef");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pef.pefId", id);
		
		Page p = HibernateQueryUtils.page(this, hb, dto);
		List<Object[]> listaFunciones = (List<Object[]>) p.getResults();
		List<DtoPerfilAdministracionFilter> dtoPerfilFilter = new ArrayList<DtoPerfilAdministracionFilter>();

		for (Object[] lista : listaFunciones) {
			DtoPerfilAdministracionFilter nuevoDto = new DtoPerfilAdministracionFilter();
			try {
				beanUtilNotNull.copyProperty(nuevoDto, "id", lista[0]);
				beanUtilNotNull.copyProperty(nuevoDto, "funcionDescripcion", lista[1]);
				beanUtilNotNull.copyProperty(nuevoDto, "funcionDescripcionLarga", lista[2]);
				beanUtilNotNull.copyProperty(nuevoDto, "totalCount", p.getTotalCount());
			} catch (IllegalAccessException e) {
				logger.error(e);
			} catch (InvocationTargetException e) {
				logger.error(e);
			}

			if (!Checks.esNulo(nuevoDto)) {
				dtoPerfilFilter.add(nuevoDto);
			}
		}
		
		return dtoPerfilFilter;	
	}

	@Override
	public String getBlackListMatriculasByUsuario(String username) {

		String blackListMatriculas = "";
		HQLBuilder hb = new HQLBuilder("select distinct(doc.matricula) from DDTipoDocumentoEntidad doc, ConfiguracionOcultarPerfilDocumento conf, ZonaUsuarioPerfil zon, Usuario usu");
		hb.appendWhere("doc.id = conf.tipoDocumentoEntidad.id");
		hb.appendWhere("conf.perfil.id = zon.perfil.id");
		hb.appendWhere("zon.usuario.id = usu.id and usu.username = :username");
		hb.getParameters().put("username", username);
		
		 
		Query query = this.getSessionFactory().getCurrentSession().createQuery(hb.toString());
		HQLBuilder.parametrizaQuery(query, hb);
		
		List<String> list = query.list();
		if(list != null && !list.isEmpty()) {
			blackListMatriculas = list.toString();
			blackListMatriculas = blackListMatriculas.replace("[", "");
			blackListMatriculas = blackListMatriculas.replace("]", "");
			blackListMatriculas = blackListMatriculas.replace(" ","");
		}
		
		
		return blackListMatriculas;
	}
}






