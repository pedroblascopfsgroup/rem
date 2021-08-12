package es.pfsgroup.plugin.rem.activo.dao.impl;

import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import es.pfsgroup.plugin.rem.model.*;
import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.lang.StringUtils;
import org.hibernate.Criteria;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.message.MessageService;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.commons.utils.hibernate.HibernateUtils;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVRawSQLDao;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDUnidadPoblacional;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPublicacionVenta;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivo;
import es.pfsgroup.plugin.rem.utils.MSVREMUtils;

@Repository("ActivoDao")
public class ActivoDaoImpl extends AbstractEntityDao<Activo, Long> implements ActivoDao {

	private static final String REST_USER_USERNAME = "REST-USER";
	private static final String REST_USER_HDC_NAME = "Proceso Excel Masivo";

	@Resource
	private MessageService messageServices;

	@Autowired
	private MSVRawSQLDao rawDao;

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private GenericAdapter adapter;

	private static final String EXISTEN_UNIDADES_ALQUILABLES_CON_OFERTAS_VIVAS ="activo.matriz.con.unidades.alquilables.ofertas.vivas";
	private static final String EXISTE_ACTIVO_MATRIZ_CON_OFERTAS_VIVAS ="activo.unidad.alquilable.con.activo.matriz.ofertas.vivas";
	private static final String isIntegradoQueryString ="select count(*) from ActivoAgrupacionActivo act where act.agrupacion.fechaBaja is null and act.activo.id = :actId and act.agrupacion.tipoAgrupacion.codigo = :codAgrupacion";
	private static final String isPrincipalQueryString ="select count(*) from ActivoAgrupacionActivo act where act.agrupacion.fechaBaja is null and act.agrupacion.activoPrincipal.id = :actId and act.agrupacion.tipoAgrupacion.codigo = :codAgrupacion";
	private static final String activoAgrupacionQueryString ="select act from ActivoAgrupacionActivo act where act.agrupacion.fechaBaja is null and act.activo.id = :actId and act.agrupacion.tipoAgrupacion.codigo = :codAgrupacion";

	@Override
	public Object getListActivos(DtoActivoFilter dto, Usuario usuLogado) {

		HQLBuilder hb = new HQLBuilder(buildFrom(dto));
		 
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.numActivo", dto.getNumActivo());

		if (dto.getEntidadPropietariaCodigo() != null)
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.entidadPropietariaCodigo", dto.getEntidadPropietariaCodigo());

		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.entidadPropietariaCodigo", dto.getEntidadPropietariaCodigoAvanzado());

		if (dto.getTipoTituloActivoCodigo() != null)
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.tipoTituloActivoCodigo", dto.getTipoTituloActivoCodigo());

		if (dto.getSubtipoActivoCodigo() != null)
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.subtipoActivoCodigo", dto.getSubtipoActivoCodigo());
		HQLBuilder.addFiltroLikeSiNotNull(hb, "act.refCatastral", dto.getRefCatastral(), true);
		HQLBuilder.addFiltroLikeSiNotNull(hb, "act.finca", dto.getFinca(), true);
		if (dto.getProvinciaCodigo() != null)
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.provinciaCodigo", dto.getProvinciaCodigo());

		HQLBuilder.addFiltroLikeSiNotNull(hb, "act.localidadDescripcion", dto.getLocalidadDescripcion(), true);
		if (dto.getCodigoPromocionPrinex() != null) {
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.codigoPromocionPrinex", dto.getCodigoPromocionPrinex());
		}

		// Parámteros para la búsqueda avanzada
		if (dto.getIdSareb() != null)
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.numActivoSareb", dto.getIdSareb());

		if (dto.getIdProp() != null && StringUtils.isNumeric(dto.getIdProp()))
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.numActivoPrinex", Long.valueOf(dto.getIdProp()));

		if (dto.getIdRecovery() != null)
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.idRecovery", Long.valueOf(dto.getIdRecovery()));

		if (dto.getIdUvem() != null)
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.numActivoUvem", Long.valueOf(dto.getIdUvem()));

		if (dto.getEstadoActivoCodigo() != null)
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.estadoActivoCodigo", dto.getEstadoActivoCodigo());

		if (dto.getTipoViaCodigo() != null)
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.tipoViaCodigo", dto.getTipoViaCodigo());

		if (dto.getNombreVia() != null)
			HQLBuilder.addFiltroLikeSiNotNull(hb, "act.nombreVia", dto.getNombreVia(), true);

		if (dto.getCodPostal() != null)
			HQLBuilder.addFiltroLikeSiNotNull(hb, "act.codPostal", dto.getCodPostal(), true);

		if (dto.getProvinciaAvanzada() != null)
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.provinciaCodigo", dto.getProvinciaAvanzada());

		if (dto.getMunicipio() != null)
			HQLBuilder.addFiltroLikeSiNotNull(hb, "act.localidadDescripcion", dto.getMunicipio(), true);

		if (dto.getPaisCodigo() != null)
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.paisCodigo", dto.getPaisCodigo());

		if (dto.getNumRegistro() != null)
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.numRegistro", dto.getNumRegistro());

		if (dto.getLocalidadRegistroDescripcion() != null)
			HQLBuilder.addFiltroLikeSiNotNull(hb, "act.localidadRegistroDescripcion",
					dto.getLocalidadRegistroDescripcion(), true);

		if (dto.getIdufir() != null)
			HQLBuilder.addFiltroLikeSiNotNull(hb, "act.idufir", dto.getIdufir(), true);

		if (dto.getFincaAvanzada() != null)
			HQLBuilder.addFiltroLikeSiNotNull(hb, "act.finca", dto.getFincaAvanzada(), true);

		if (dto.getOcupado() != null)
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.ocupado", dto.getOcupado());

		if (dto.getConTitulo() != null)
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.conTitulo", dto.getConTitulo());

		if (dto.getComboSelloCalidad() != null) {
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.selloCalidad",
					dto.getComboSelloCalidad().equals(Integer.valueOf(1)) ? true : false);
		}
		
		if (dto.getTerritorio() != null) {
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.territorio", dto.getTerritorio());
		}
		
		if (dto.getApiPrimarioId() != null) {
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.apiPrimarioId", dto.getApiPrimarioId());
		}
		
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "scr.codigo", dto.getSubcarteraCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "scr.codigo", dto.getSubcarteraCodigoAvanzado());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.tipoActivoCodigo", dto.getTipoActivoCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tud.codigo", dto.getTipoUsoDestinoCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "ca.codigo", dto.getClaseActivoBancarioCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "subca.codigo", dto.getSubClaseActivoBancarioCodigo());
		//HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.numActivoBbva", dto.getNumActivoBbva());
		//HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.idDivarian", dto.getIdDivarianBbva());
		
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "subtipotitulo.codigo", dto.getSubtipoTituloActivoCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.divHorizontal", dto.getDivisionHorizontal());

		if (dto.getInscrito() != null) {
			if (dto.getInscrito() == 0) {
				hb.appendWhere(" tit.fechaInscripcionReg IS NULL ");
			} else {
				hb.appendWhere(" tit.fechaInscripcionReg IS NOT NULL");
			}
		}

		HQLBuilder.addFiltroLikeSiNotNull(hb, "pro.nombre", dto.getPropietarioNombre(), true);
		HQLBuilder.addFiltroLikeSiNotNull(hb, "pro.docIdentificativo", dto.getPropietarioNIF(), true);

		if (dto.getConPosesion() != null) {
			if (dto.getConPosesion() == 0) {
				hb.appendWhere(" act.fechaTomaPosesion IS NULL ");
			} else {
				hb.appendWhere(" act.fechaTomaPosesion IS NOT NULL");
			}
		}

		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.accesoTapiado", dto.getAccesoTapiado());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.accesoAntiocupa", dto.getAccesoAntiocupa());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.situacionComercialCodigo", dto.getSituacionComercialCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.tipoTituloPosesorio", dto.getTipoTituloPosesorio());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tco.codigo", dto.getTipoComercializacionCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "perac.aplicaGestion", dto.getPerimetroGestion());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.flagRating", dto.getRatingCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.conCargas", dto.getConCargas());
		if(!Checks.esNulo(dto.getUsuarioGestor())) {
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "gausu.id", dto.getUsuarioGestor());
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "ga.tipoGestor.codigo", dto.getTipoGestorCodigo());	
		}
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.estadoComunicacionGencat",
				dto.getEstadoComunicacionGencatCodigo());
		
		if (dto.getUsuarioGestoria()) {
			hb.appendWhere(" act.id = bag.id");
			HQLBuilder.addFiltroIgualQue(hb, "bag.gestoria", dto.getGestoria());
		}
		
		if(!Checks.esNulo(dto.getNumAgrupacion())) {
			hb.appendWhere(" exists (select 1 from ActivoAgrupacionActivo aga where aga.agrupacion.numAgrupRem = :numAgrupacion and act.id = aga.activo.id)");
			hb.getParameters().put("numAgrupacion", dto.getNumAgrupacion());
		}
		
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.numActivoDivarian", dto.getNumActivoDivarian());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.tipoSegmento", dto.getTipoSegmento());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.perimetroMacc", dto.getPerimetroMacc());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.equipoGestion", dto.getEquipoGestion());

		if(!Checks.esNulo(dto.isListPage()) && dto.isListPage())
			return HibernateQueryUtils.page(this, hb, dto);
		else
			return HibernateQueryUtils.list(this, hb);
	}

	private String buildFrom(DtoActivoFilter dto) {
		StringBuilder sb = new StringBuilder("select act from VBusquedaActivos act "); 
		
		if (dto.getUsuarioGestoria()) {
			sb.append(" ,VBusquedaActivosGestorias bag ");
		}
		
		if (!Checks.esNulo(dto.getSubcarteraCodigo()) || !Checks.esNulo(dto.getSubcarteraCodigoAvanzado())) {
			sb.append(" join act.subcartera scr ");
		}

		if (!Checks.esNulo(dto.getTipoUsoDestinoCodigo())) {
			sb.append(" join act.tipoUsoDestino tud ");
		}
		
		
		
		if (!Checks.esNulo(dto.getClaseActivoBancarioCodigo())
				|| !Checks.esNulo(dto.getSubClaseActivoBancarioCodigo())) {
			sb.append(" join act.activoBancario ab");

			if (!Checks.esNulo(dto.getClaseActivoBancarioCodigo())) {
				sb.append(" join ab.claseActivo ca ");
			}

			if (!Checks.esNulo(dto.getSubClaseActivoBancarioCodigo())) {
				sb.append(" join ab.subtipoClaseActivo subca ");
			}
		}
		
		if (!Checks.esNulo(dto.getSubtipoTituloActivoCodigo())) {
			sb.append(" join act.subtipoTitulo subtipotitulo ");
		}

		if (dto.getInscrito() != null) {
			sb.append(" join act.titulo tit ");
		}

		if (!Checks.esNulo(dto.getPropietarioNIF()) || !Checks.esNulo(dto.getPropietarioNombre())) {
			sb.append(" join act.propietariosActivo pac ");
			sb.append(" join pac.propietario pro ");
		}

		if (!Checks.esNulo(dto.getTipoComercializacionCodigo())) {
			sb.append(" join act.tipoComercializacion tco ");
		}

		if (dto.getPerimetroGestion() != null) {
			sb.append(" join act.perimetroActivo perac ");
		}

		if (dto.getUsuarioGestor() != null) {
			sb.append(" join act.gestoresActivo ga ");
			sb.append(" join ga.usuario gausu ");
		}
		
		return sb.toString();
	}

	@Override
	public List<Activo> getListActivosLista(DtoActivoFilter dto, Usuario usuLogado) {

		HQLBuilder hb = new HQLBuilder(" from VBusquedaActivos act");

		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.numActivo", dto.getNumActivo());

   		if (dto.getEntidadPropietariaCodigo() != null)
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.entidadPropietariaCodigo", dto.getEntidadPropietariaCodigo());

   		if (dto.getTipoTituloActivoCodigo() != null)
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.tipoTituloActivoCodigo", dto.getTipoTituloActivoCodigo());

   		if (dto.getSubtipoActivoCodigo() != null)
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.subtipoActivoCodigo", dto.getSubtipoActivoCodigo());
   		HQLBuilder.addFiltroLikeSiNotNull(hb, "act.refCatastral", dto.getRefCatastral(), true);
   		HQLBuilder.addFiltroLikeSiNotNull(hb, "act.finca", dto.getFinca(), true);
   		if (dto.getProvinciaCodigo() != null)
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.provinciaCodigo", dto.getProvinciaCodigo());

   		HQLBuilder.addFiltroLikeSiNotNull(hb, "act.localidadDescripcion", dto.getLocalidadDescripcion(), true);
   		if(dto.getCodigoPromocionPrinex() != null) {
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.codigoPromocionPrinex", dto.getCodigoPromocionPrinex());
   		}
   		//Parámteros para la búsqueda avanzada
   		if (dto.getNumActivoRem() != null)
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.numActivoRem", dto.getNumActivoRem());

   		if (dto.getIdProp() != null && StringUtils.isNumeric(dto.getIdProp()))
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.numActivoPrinex", Long.valueOf(dto.getIdProp()));

   		if (dto.getIdRecovery() != null && StringUtils.isNumeric(dto.getIdRecovery()))
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.idRecovery", Long.valueOf(dto.getIdRecovery()));

   		if (dto.getIdUvem() != null && StringUtils.isNumeric(dto.getIdUvem()))
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.numActivoUvem", Long.valueOf(dto.getIdUvem()));

   		if (dto.getEstadoActivoCodigo() != null)
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.estadoActivoCodigo", dto.getEstadoActivoCodigo());

   		if (dto.getTipoViaCodigo() != null)
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.tipoViaCodigo", dto.getTipoViaCodigo());

   		if (dto.getNombreVia() != null)
   			HQLBuilder.addFiltroLikeSiNotNull(hb, "act.nombreVia", dto.getNombreVia(), true);

   		if (dto.getCodPostal() != null)
   			HQLBuilder.addFiltroLikeSiNotNull(hb, "act.codPostal", dto.getCodPostal(), true);

   		if (dto.getProvinciaAvanzada() != null)
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.provinciaCodigo", dto.getProvinciaAvanzada());

   		if (dto.getMunicipio() != null)
   			HQLBuilder.addFiltroLikeSiNotNull(hb, "act.localidadDescripcion", dto.getMunicipio(), true);

   		/*if (dto.getUnidadInferior() != null)
   			HQLBuilder.addFiltroLikeSiNotNull(hb, "act.unidadPoblacional.descripcion", dto.getUnidadInferior(), true);*/

   		if (dto.getPaisCodigo() != null)
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.paisCodigo", dto.getPaisCodigo());

   		if (dto.getNumRegistro() != null)
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.numRegistro", dto.getNumRegistro());

   		if (dto.getLocalidadRegistroDescripcion() != null)
   			HQLBuilder.addFiltroLikeSiNotNull(hb, "act.localidadRegistroDescripcion", dto.getLocalidadRegistroDescripcion(), true);

   		if (dto.getIdufir() != null)
   			HQLBuilder.addFiltroLikeSiNotNull(hb, "act.idufir", dto.getIdufir(), true);

   		if (dto.getFincaAvanzada() != null)
   			HQLBuilder.addFiltroLikeSiNotNull(hb, "act.finca", dto.getFincaAvanzada(), true);

   		if (dto.getOcupado() != null)
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.ocupado", dto.getOcupado());

   		if (dto.getConTitulo() != null)
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.conTitulo", dto.getConTitulo());

   		if (dto.getComboSelloCalidad() != null)
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.selloCalidad", dto.getComboSelloCalidad());

		return HibernateQueryUtils.list(this, hb);

	}

	@Override
	public Page getListHistoricoPresupuestos(DtoHistoricoPresupuestosFilter dto, Usuario usuLogado) {

		HQLBuilder hb = new HQLBuilder(" from VBusquedaPresupuestosActivo pre");

		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pre.idActivo", dto.getIdActivo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "pre.id", dto.getIdPresupuesto());

		return HibernateQueryUtils.page(this, hb, dto);

	}

	@Override
	public Integer isIntegradoAgrupacionRestringida(Long id, Usuario usuLogado) {
		HQLBuilder hb = new HQLBuilder(isIntegradoQueryString);

		 Query q = this.getSessionFactory().getCurrentSession().createQuery(hb.toString());
		 q.setParameter("actId", id);
		 q.setParameter("codAgrupacion", DDTipoAgrupacion.AGRUPACION_RESTRINGIDA);
		
		return ((Long) q.uniqueResult()).intValue();
	}

	@Override
	public Integer isIntegradoAgrupacionComercial(Long idActivo) {
		HQLBuilder hb = new HQLBuilder(isIntegradoQueryString);
		
		 Query q = this.getSessionFactory().getCurrentSession().createQuery(hb.toString());
		 q.setParameter("actId", idActivo);
		 q.setParameter("codAgrupacion", DDTipoAgrupacion.AGRUPACION_LOTE_COMERCIAL);

		return ((Long) q.uniqueResult()).intValue();
	}

	@Override
	public Integer isActivoPrincipalAgrupacionRestringida(Long id) {
		HQLBuilder hb = new HQLBuilder(isPrincipalQueryString);

		Query q = this.getSessionFactory().getCurrentSession().createQuery(hb.toString());
		 q.setParameter("actId", id);
		 q.setParameter("codAgrupacion", DDTipoAgrupacion.AGRUPACION_RESTRINGIDA);
		return ((Long) q.uniqueResult()).intValue();
	}

	@Override
	public ActivoAgrupacionActivo getActivoAgrupacionActivoAgrRestringidaPorActivoID(Long id) {
		HQLBuilder hb = new HQLBuilder(
				"select act from ActivoAgrupacionActivo act where act.agrupacion.fechaBaja is null and act.activo.id = "
						+ id + " and act.agrupacion.tipoAgrupacion.codigo = "
						+ DDTipoAgrupacion.AGRUPACION_RESTRINGIDA);
		List <ActivoAgrupacionActivo> activoAgrupacionlist = (List<ActivoAgrupacionActivo>) getHibernateTemplate().find(hb.toString());
		
		if (activoAgrupacionlist != null && !activoAgrupacionlist.isEmpty()) {
			return activoAgrupacionlist.get(0);
		}
		return null;
	}
	
	@Override
	public ActivoAgrupacionActivo getActivoAgrupacionActivoObraNuevaPorActivoID(Long id) {
		HQLBuilder hb = new HQLBuilder(activoAgrupacionQueryString);

		 Query q = this.getSessionFactory().getCurrentSession().createQuery(hb.toString());
		 q.setParameter("actId", id);
		 q.setParameter("codAgrupacion", DDTipoAgrupacion.AGRUPACION_OBRA_NUEVA);
		
		return ((ActivoAgrupacionActivo) q.uniqueResult());
	}

	@Override
	public Integer isIntegradoAgrupacionObraNueva(Long id, Usuario usuLogado) {
		HQLBuilder hb = new HQLBuilder(isIntegradoQueryString);

		Query q = this.getSessionFactory().getCurrentSession().createQuery(hb.toString());
		 q.setParameter("actId", id);
		 q.setParameter("codAgrupacion", DDTipoAgrupacion.AGRUPACION_OBRA_NUEVA);
		return ((Long) q.uniqueResult()).intValue();

	}

	@SuppressWarnings("unchecked")
	@Override
	public List<DDUnidadPoblacional> getComboInferiorMunicipio(String codigoMunicipio) {

		String hql = "from DDUnidadPoblacional where localidad.codigo= ? and codigo NOT LIKE '%0000'";

		List<DDUnidadPoblacional> list = getHibernateTemplate().find(hql, new Object[] { codigoMunicipio });
		return list;

	}

	@Override
	public Integer getMaxOrdenFotoById(Long id) {
		HQLBuilder hb = new HQLBuilder("select max(orden) from ActivoFoto foto where foto.activo.id = " + id);
		try {
			// Integer cont = ((Integer)
			// getHibernateTemplate().find(hb.toString()).get(0)).intValue();
			return ((Integer) getHibernateTemplate().find(hb.toString()).get(0)).intValue();
		} catch (Exception e) {
			return 0;
		}
	}

	@Override
	public Integer getMaxOrdenFotoByIdSubdivision(Long idEntidad, Long hashSdv) {
		HQLBuilder hb = new HQLBuilder("select max(orden) from ActivoFoto foto where foto.agrupacion.id = " + idEntidad);
		if(hashSdv != null)
				hb.appendWhere("foto.subdivision = " + hashSdv);
		try {
			// Integer cont = ((Integer)
			// getHibernateTemplate().find(hb.toString()).get(0)).intValue();
			return ((Integer) getHibernateTemplate().find(hb.toString()).get(0)).intValue();
		} catch (Exception e) {
			return 0;
		}
	}

	@Override
	public Long getPresupuestoActual(Long id) {
		SimpleDateFormat df = new SimpleDateFormat("yyyy");
		String yearNow = df.format(new Date());

		HQLBuilder hb = new HQLBuilder("select presupuesto.id from PresupuestoActivo presupuesto "
				+ " where presupuesto.activo.id = " + id + " and presupuesto.ejercicio.anyo = " + yearNow);

		try {
			if (getHibernateTemplate().find(hb.toString()).size() > 0)
				return ((Long) getHibernateTemplate().find(hb.toString()).get(0));
			else
				return null;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

    @Override
   	public Long getUltimoHistoricoPresupuesto(Long id) {
       	HQLBuilder hb = new HQLBuilder("select presupuesto.id from PresupuestoActivo presupuesto "
       			+ " where presupuesto.activo.id = " + id
       			+ " order by presupuesto.ejercicio.anyo desc ");

       	try {
       		if (getHibernateTemplate().find(hb.toString()).size() > 0)
	       		return ((Long) getHibernateTemplate().find(hb.toString()).get(0));
       		else return null;
       	} catch (Exception e) {
       		e.printStackTrace();
       		return null;
       	}
   	}

	@Override
	public Page getListActivosPrecios(DtoActivoFilter dto) {
		HQLBuilder hb = new HQLBuilder(" from VBusquedaActivosPrecios act");

		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.entidadPropietariaCodigo", dto.getEntidadPropietariaCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.tipoTituloActivoCodigo", dto.getTipoTituloActivoCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.subTipoTituloActivoCodigo", dto.getSubtipoTituloActivoCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.inscrito", dto.getInscrito());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.conPosesion", dto.getConPosesion());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.conCargas", dto.getConCargas());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.destinoComercialCodigo", dto.getDestinoComercialCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.conOfertaAprobada", dto.getConOfertaAprobada());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.conReserva", dto.getConReserva());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.tieneMediador", dto.getTieneMediador());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.tieneLLavesMediador", dto.getTieneLLavesMediador());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.estadoInformeComercial", dto.getEstadoInformeComercial());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.conTasacion", dto.getConTasacion());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.codigoProvincia", dto.getProvinciaCodigo());
		HQLBuilder.addFiltroLikeSiNotNull(hb, "act.municipio", dto.getMunicipio(), true);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.codigoPostal", dto.getCodPostal());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.subcarteraCodigo", dto.getSubcarteraCodigo());

		// caso multiseleccion propietarios
		if (dto.getPropietario() != null && !dto.getPropietario().isEmpty() && dto.getPropietario().contains(",")) {
			ArrayList<String> valores = new ArrayList<String>();
			for (String token : dto.getPropietario().split(",")) {
				valores.add(token);
			}
			HQLBuilder.addFiltroWhereInSiNotNull(hb, "act.idPropietario", valores);

		} else {
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.idPropietario", dto.getPropietario());
		}

		if (dto.getSubcarteraCodigo() != null) {
			if ("00".equals(dto.getSubcarteraCodigo())) {
				List<String> lista = new ArrayList<String>();
				Collections.addAll(lista, "'" + DDSubcartera.CODIGO_BAN_BFA + "'",
						"'" + DDSubcartera.CODIGO_BAN_BH + "'", "'" + DDSubcartera.CODIGO_BAN_BK + "'");
				HQLBuilder.addFiltroWhereInSiNotNull(hb, "act.subcarteraCodigo", lista);
			} else {
				HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.subcarteraCodigo", dto.getSubcarteraCodigo());
			}
		}

		if (dto.getEstadoActivoCodigo() != null)
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.estadoActivoCodigo", dto.getEstadoActivoCodigo());

		if (!Checks.esNulo(dto.getConFsvVenta())) {
			if (BooleanUtils.toBoolean(dto.getConFsvVenta())) {
				hb.appendWhere("act.fsvVenta is not null");
			} else {
				hb.appendWhere("act.fsvVenta is null");
			}
		}

		if (!Checks.esNulo(dto.getConFsvRenta())) {
			if (BooleanUtils.toBoolean(dto.getConFsvRenta())) {
				hb.appendWhere("act.fsvRenta is not null");
			} else {
				hb.appendWhere("act.fsvRenta is null");
			}
		}
		if (!Checks.esNulo(dto.getMinimoVigente())) {
			if (BooleanUtils.toBoolean(dto.getMinimoVigente())) {
				hb.appendWhere("act.precioMinimoAutorizado is not null");
			} else {
				hb.appendWhere("act.precioMinimoAutorizado is null");
			}
		}
		if (!Checks.esNulo(dto.getVentaWebVigente())) {
			if (BooleanUtils.toBoolean(dto.getVentaWebVigente())) {
				hb.appendWhere("act.precioAprobadoVenta is not null");
			} else {
				hb.appendWhere("act.precioAprobadoVenta is null");
			}
		}
		if (!Checks.esNulo(dto.getMinimoHistorico())) {
			if (BooleanUtils.toBoolean(dto.getMinimoHistorico())) {
				hb.appendWhere("act.precioHistoricoMinimoAutorizado is not null");
			} else {
				hb.appendWhere("act.precioHistoricoMinimoAutorizado is null");
			}
		}
		if (!Checks.esNulo(dto.getWebHistorico())) {
			if (BooleanUtils.toBoolean(dto.getWebHistorico())) {
				hb.appendWhere("act.precioHistoricoAprobadoVenta is not null");
			} else {
				hb.appendWhere("act.precioHistoricoAprobadoVenta is null");
			}
		}

		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "act.conBloqueo", dto.getConBloqueo());

		// HREOS-639 - Indicador de activos para preciar/repreciar/descuento
		if (Checks.esNulo(dto.getCheckTodosActivos()) || !dto.getCheckTodosActivos()) {
			if (!Checks.esNulo(dto.getTipoPropuestaCodigo())) {
				if (dto.getTipoPropuestaCodigo().equals("01")) {
					hb.appendWhere("act.fechaPreciar is not null");
					hb.appendWhere("act.fechaRepreciar is null");
				} else if (dto.getTipoPropuestaCodigo().equals("02")) {
					hb.appendWhere("act.fechaRepreciar is not null");
				} else if (dto.getTipoPropuestaCodigo().equals("03")) {
					hb.appendWhere("act.fechaDescuento is not null");
				}
			}
		}
		return HibernateQueryUtils.page(this, hb, dto);

	}

	@Override
	public Page getHistoricoValoresPrecios(DtoHistoricoPreciosFilter dto) {

		HQLBuilder hb = new HQLBuilder(" from ActivoHistoricoValoraciones hist");

		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "hist.activo.id", Long.parseLong(dto.getIdActivo()));

		hb.orderBy("hist.tipoPrecio", HQLBuilder.ORDER_ASC);

		return HibernateQueryUtils.page(this, hb, dto);

	}

	@Override
	public void deleteValoracionById(Long id) {

		StringBuilder sb = new StringBuilder("delete from ActivoValoraciones val where val.id = " + id);
		this.getSessionFactory().getCurrentSession().createQuery(sb.toString()).executeUpdate();

	}

	@Override
	public boolean deleteValoracionSinDuplicarById(Long id) {

		StringBuilder sb = new StringBuilder("delete from ActivoValoraciones val where val.id = " + id);
		Query query = this.getSessionFactory().getCurrentSession().createQuery(sb.toString());
		int afectado = query.executeUpdate();

		return (afectado > 0) ? true : false;

	}

	@SuppressWarnings("unchecked")
	@Override
	public ActivoCondicionEspecifica getUltimaCondicion(Long idActivo) {

		String hql = "from ActivoCondicionEspecifica where activo.id = ? and fechaHasta IS NULL";

		List<ActivoCondicionEspecifica> listaCondiciones = getHibernateTemplate().find(hql, new Object[] { idActivo });

		return !Checks.estaVacio(listaCondiciones) ? listaCondiciones.get(0) : null;

	}

	@Override
	public Page getPropuestas(DtoPropuestaFilter dto) {

		HQLBuilder hb = new HQLBuilder(" from VBusquedaPropuestasActivo propact");

		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "propact.entidadPropietariaCodigo",
				dto.getEntidadPropietariaCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "propact.numPropuesta", dto.getNumPropuesta());
		HQLBuilder.addFiltroLikeSiNotNull(hb, "propact.nombrePropuesta", dto.getNombrePropuesta());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "propact.estadoCodigo", dto.getEstadoCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "propact.estadoActivoCodigo", dto.getEstadoActivoCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "propact.idActivo", dto.getIdActivo());
		HQLBuilder.addFiltroLikeSiNotNull(hb, "propact.gestor", dto.getGestorPrecios(), true);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "propact.tipoPropuesta", dto.getTipoPropuesta());

		if (!Checks.esNulo(dto.getTipoDeFecha())) {
			switch (Integer.parseInt(dto.getTipoDeFecha())) {
			case 1:
				agregarFiltroFecha(hb, dto.getFechaDesde().toString(), dto.getFechaHasta(), "propact.fechaEmision");
				break;
			case 2:
				agregarFiltroFecha(hb, dto.getFechaDesde().toString(), dto.getFechaHasta(), "propact.fechaEnvio");
				break;
			case 3:
				agregarFiltroFecha(hb, dto.getFechaDesde().toString(), dto.getFechaHasta(), "propact.fechaSancion");
				break;
			case 4:
				agregarFiltroFecha(hb, dto.getFechaDesde().toString(), dto.getFechaHasta(), "propact.fechaCarga");
				break;
			default:
				break;
			}
		}

		return HibernateQueryUtils.page(this, hb, dto);

	}

	@Override
	public Page getActivosPublicacion(DtoActivosPublicacion dto) {

		HQLBuilder hb = new HQLBuilder(" from VBusquedaPublicacionActivo activopubli");

		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "activopubli.numActivo", dto.getNumActivo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "activopubli.tipoActivoCodigo", dto.getTipoActivo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "activopubli.subtipoActivoCodigo", dto.getSubtipoActivo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "activopubli.cartera", dto.getCartera());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "activopubli.subCartera", dto.getSubCartera());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "activopubli.estadoPublicacionCodigo",
				dto.getEstadoPublicacionCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "activopubli.admision", dto.getAdmision());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "activopubli.gestion", dto.getGestion());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "activopubli.publicacion", dto.getPublicacion());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "activopubli.precio", dto.getPrecio());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "activopubli.informeComercial", dto.getInformeComercial());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "activopubli.okventa", dto.getOkventa());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "activopubli.okalquiler", dto.getOkalquiler());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "activopubli.motivoOcultacionVenta", dto.getMotivosOcultacionCodigo());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "activopubli.motivoOcultacionAlquiler", dto.getMotivosOcultacionAlquilerCodigo());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "activopubli.fasePublicacionCodigo", dto.getFasePublicacionCodigo());
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "activopubli.subFasePublicacionCodigo", dto.getSubfasePublicacionCodigo());
   		if (!Checks.esNulo(dto.getTipoComercializacionCodigo()))HQLBuilder.addFiltroWhereInSiNotNull(hb, "activopubli.tipoComercializacionCodigo", Arrays.asList(dto.getTipoComercializacionCodigo()));

		return HibernateQueryUtils.page(this, hb, dto);
	}
	
	@Override
	public Page getBusquedaPublicacionGrid(DtoPublicacionGridFilter dto) {
		HQLBuilder hb = new HQLBuilder(" from VGridBusquedaPublicaciones vgrid");

		if (dto.getNumActivo() != null && StringUtils.isNumeric(dto.getNumActivo()))
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.numActivo", Long.valueOf(dto.getNumActivo()));

		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.carteraCodigo", dto.getCarteraCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.subcarteraCodigo", dto.getSubcarteraCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.estadoPublicacionVentaCodigo", dto.getEstadoPublicacionVentaCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.motivosOcultacionVentaCodigo", dto.getMotivosOcultacionVentaCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.estadoPublicacionAlquilerCodigo", dto.getEstadoPublicacionAlquilerCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.motivosOcultacionAlquilerCodigo", dto.getMotivosOcultacionAlquilerCodigo());

		if (dto.getEstadoPublicacionVentaCodigo() != null && dto.getEstadoPublicacionAlquilerCodigo() != null) {
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.tipoComercializacionCodigo", DDTipoComercializacion.CODIGO_ALQUILER_VENTA);
		} else if (dto.getEstadoPublicacionVentaCodigo() != null) {
			HQLBuilder.addFiltroWhereInSiNotNull(hb, "vgrid.tipoComercializacionCodigo", Arrays.asList(DDTipoComercializacion.CODIGOS_VENTA));
		} else if (dto.getEstadoPublicacionAlquilerCodigo() != null) {
			HQLBuilder.addFiltroWhereInSiNotNull(hb, "vgrid.tipoComercializacionCodigo", Arrays.asList(DDTipoComercializacion.CODIGOS_ALQUILER));
		}

		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.tipoActivoCodigo", dto.getTipoActivoCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.subtipoActivoCodigo", dto.getSubtipoActivoCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.fasePublicacionCodigo", dto.getFasePublicacionCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.subfasePublicacionCodigo", dto.getSubfasePublicacionCodigo());

		if (Boolean.TRUE.equals(dto.getCheckOkAdmision()) || Boolean.TRUE.equals(dto.getCheckOkVenta()) || Boolean.TRUE.equals(dto.getCheckOkAlquiler()))
			HQLBuilder.addFiltroIgualQue(hb, "vgrid.admision", 1);
		if (Boolean.TRUE.equals(dto.getCheckOkGestion()) || Boolean.TRUE.equals(dto.getCheckOkVenta()) || Boolean.TRUE.equals(dto.getCheckOkAlquiler()))
			HQLBuilder.addFiltroIgualQue(hb, "vgrid.gestion", 1);		
		if (Boolean.TRUE.equals(dto.getCheckOkInformeComercial()))
			HQLBuilder.addFiltroIgualQue(hb, "vgrid.informeComercial", 1);
		if (Boolean.TRUE.equals(dto.getCheckOkPrecio()))
			HQLBuilder.addFiltroIgualQue(hb, "vgrid.precio", 1);		
		if (Boolean.TRUE.equals(dto.getCheckOkVenta())) {		
			hb.appendWhere(" (vgrid.adecuacionAlquilerCodigo = '02' OR vgrid.publicarSinPrecioVenta = 1) "
					+ " AND NVL(vgrid.informeComercial, 0) = CASE WHEN vgrid.carteraCodigo IN ('01','08') THEN 1 ELSE NVL(vgrid.informeComercial, 0) END ");			
		}
		if (Boolean.TRUE.equals(dto.getCheckOkAlquiler())) {		
			hb.appendWhere(" vgrid.tipoActivoCodigo = '02'"
					+ " AND vgrid.adecuacionAlquilerCodigo = '01' OR vgrid.adecuacionAlquilerCodigo = '03' AND vgrid.adjuntoActivo = 1  AND (vgrid.conPrecioAlquiler = 1 OR vgrid.publicarSinPrecioAlquiler = 1) "
					+ " AND NVL(vgrid.informeComercial, 0) = CASE WHEN vgrid.carteraCodigo IN ('01','08') THEN 1 ELSE NVL(vgrid.informeComercial, 0) END ");
		}
		return HibernateQueryUtils.page(this, hb, dto);
	}

	@Override
	public Boolean getDptoPrecio(Activo activo) {
		HQLBuilder hb = new HQLBuilder(" from VBusquedaPublicacionActivo activopubli");
		hb.appendWhere("activopubli.numActivo = " + activo.getNumActivo());

		VBusquedaPublicacionActivo busquedaActivo = (VBusquedaPublicacionActivo) this.getSessionFactory()
				.getCurrentSession().createQuery(hb.toString()).uniqueResult();
		if (Checks.esNulo(busquedaActivo))
			return null;
		return busquedaActivo.getPrecio();
	}

	public Boolean publicarActivoConHistorico(Long idActivo, String username, String eleccionUsuarioTipoPublicacionAlquiler, boolean doFlush) {
    	// Antes de realizar la llamada al SP realizar las operaciones previas con los datos.
		if(doFlush){
			getHibernateTemplate().flush();
		}

		return this.publicarActivo(idActivo, username, eleccionUsuarioTipoPublicacionAlquiler);
	}

	@Override
	public Boolean publicarAgrupacionConHistorico(Long idAgrupacion, String username, String eleccionUsuarioTipoPublicacionAlquiler, boolean doFlush) {
		if(doFlush){
			getHibernateTemplate().flush();
		}
		return this.publicarAgrupacion(idAgrupacion, username, eleccionUsuarioTipoPublicacionAlquiler);
	}


	/**
	 * Este método lanza el procedimiento de cambio de estado de publicación
	 *
	 * @param idActivo:
	 *            ID del activo para el cual se desea realizar la operación.
	 * @param username:
	 *            nombre del usuario, si la llamada es desde la web, que realiza
	 *            la operación.
	 * @param historificar:
	 *            indica si la operación ha de realizar un histórico de los
	 *            movimientos realizados.
	 * @return Devuelve True si la operación ha sido satisfactoria, False si no
	 *         ha sido satisfactoria.
	 */
	private Boolean publicarActivo(Long idActivo, String username, String eleccionUsuarioTipoPublicacionAlquiler) {
		String procedureHQL = "BEGIN SP_CAMBIO_ESTADO_PUBLICACION(:idActivoParam, :eleccionUsuarioParam, :usernameParam);  END;";


		Query callProcedureSql = this.getSessionFactory().getCurrentSession().createSQLQuery(procedureHQL);
		callProcedureSql.setParameter("idActivoParam", idActivo);
		callProcedureSql.setParameter("eleccionUsuarioParam", eleccionUsuarioTipoPublicacionAlquiler);
		callProcedureSql.setParameter("usernameParam", username);

		int resultado = callProcedureSql.executeUpdate();

		return resultado == 1;
	}

	/**
	 * Este metodo lanza el procedimiento de cambio de estado de publicación de
	 * agrupaciones
	 *
	 * @param idAgrupacion:
	 *            ID del activo para el cual se desea realizar la operación.
	 * @param username:
	 *            nombre del usuario, si la llamada es desde la web, que realiza
	 *            la operación.
	 * @param historificar:
	 *            indica si la operación ha de realizar un histórico de los
	 *            movimientos realizados.
	 * @return Devuelve True si la operacion ha sido satisfactoria, False si no
	 *         ha sido satisfactoria.
	 */

	private Boolean publicarAgrupacion(Long idAgrupacion, String username, String eleccionUsuarioTipoPublicacionAlquiler) {
		String procedureHQL = "BEGIN SP_CAMBIO_ESTADO_PUBLI_AGR(:idAgrupacionParam, :eleccionUsusarioParam, :usernameParam); END;";
		int resultado = 0;
		try {
			Query callProcedureSql = this.getSessionFactory().getCurrentSession().createSQLQuery(procedureHQL);
			callProcedureSql.setParameter("idAgrupacionParam", idAgrupacion);
			callProcedureSql.setParameter("eleccionUsusarioParam", eleccionUsuarioTipoPublicacionAlquiler);
			callProcedureSql.setParameter("usernameParam", username);

			resultado = callProcedureSql.executeUpdate();

			return resultado == 1;
		} catch (Exception e) {
			logger.error("Error en el SP_CAMBIO_ESTADO_PUBLI_AGR para el AGR_ID "+idAgrupacion.toString(), e);
			return resultado == 0;
		}

	}

	public Long getNextNumExpedienteComercial() {
		String sql = "SELECT S_ECO_NUM_EXPEDIENTE.NEXTVAL FROM DUAL ";
		return ((BigDecimal) this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult())
				.longValue();
	}

	public Long getNextNumOferta() {
		String sql = "SELECT S_OFR_NUM_OFERTA.NEXTVAL FROM DUAL ";
		return ((BigDecimal) this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult())
				.longValue();
	}

	public Long getNextClienteRemId() {
		String sql = "SELECT S_CLC_REM_ID.NEXTVAL FROM DUAL ";
		return ((BigDecimal) this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult())
				.longValue();
	}

	@Override
	public Page getPropuestaActivosVinculadosByActivo(DtoPropuestaActivosVinculados dto) {
		HQLBuilder hb = new HQLBuilder(" from PropuestaActivosVinculados activosVinculados");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "activosVinculados.activoOrigen.id", dto.getActivoOrigenID());

		return HibernateQueryUtils.page(this, hb, dto);
	}

	@Override
	public Activo getActivoByNumActivo(Long activoVinculado) {
    	Session session = this.getSessionFactory().getCurrentSession();
		Criteria criteria = session.createCriteria(Activo.class);
		criteria.add(Restrictions.eq("numActivo", activoVinculado));

		Activo activo =  HibernateUtils.castObject(Activo.class, criteria.uniqueResult());

		return activo;
	}

	@Override
	public PropuestaActivosVinculados getPropuestaActivosVinculadosByID(Long id) {
		HQLBuilder hb = new HQLBuilder(" from PropuestaActivosVinculados activosVinculados");
		hb.appendWhere("activosVinculados.id = " + id);

		return (PropuestaActivosVinculados) this.getSessionFactory().getCurrentSession().createQuery(hb.toString())
				.uniqueResult();
	}

	@SuppressWarnings("unchecked")
	@Override
	public ActivoTasacion getActivoTasacion(Long id) {
		HQLBuilder hb = new HQLBuilder(" from ActivoTasacion tas");
		hb.appendWhere(" tas.activo.id = " + id);
		hb.appendWhere(" tas.fechaRecepcionTasacion is null");
		hb.orderBy("tas.id", HQLBuilder.ORDER_DESC);

		List<ActivoTasacion> activoTasacionList = (List<ActivoTasacion>) this.getSessionFactory().getCurrentSession()
				.createQuery(hb.toString()).list();

		if (!Checks.estaVacio(activoTasacionList)) {
			return activoTasacionList.get(0);
		}

		return null;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<ActivoTasacion> getListActivoTasacionByIdActivo(Long idActivo) {
		HQLBuilder hb = new HQLBuilder(" from ActivoTasacion tas");
		hb.appendWhere(" tas.activo.id = " + idActivo);
		hb.orderBy("tas.valoracionBien.fechaValorTasacion", HQLBuilder.ORDER_DESC);
		List<ActivoTasacion> activoTasacionList = (List<ActivoTasacion>) this.getSessionFactory().getCurrentSession()
				.createQuery(hb.toString()).list();
		return activoTasacionList;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<ActivoTasacion> getListActivoTasacionByIdActivoAsc(Long idActivo) {
		HQLBuilder hb = new HQLBuilder(" from ActivoTasacion tas");
		hb.appendWhere(" tas.activo.id = " + idActivo);
		hb.orderBy("tas.valoracionBien.fechaValorTasacion", HQLBuilder.ORDER_ASC);
		List<ActivoTasacion> activoTasacionList = (List<ActivoTasacion>) this.getSessionFactory().getCurrentSession()
				.createQuery(hb.toString()).list();
		return activoTasacionList;
	}



	@Override
	public Page getLlavesByActivo(DtoLlaves dto) {

		HQLBuilder hb = new HQLBuilder(" from ActivoLlave lla");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "activo.id", Long.parseLong(dto.getIdActivo()));

		return HibernateQueryUtils.page(this, hb, dto);
	}

	@Override
	public Page getListMovimientosLlaveByLlave(WebDto dto, Long idLlave) {

		HQLBuilder hb = new HQLBuilder("select mov from ActivoMovimientoLlave mov, ActivoLlave lla ");
		hb.appendWhere("lla.id = mov.activoLlave.id");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "lla.id", idLlave);

		this.ordenarMovimientos(dto, hb);

		return HibernateQueryUtils.page(this, hb, dto);
	}

	@Override
	public Page getListMovimientosLlaveByActivo(WebDto dto, Long idActivo) {

		HQLBuilder hb = new HQLBuilder("select mov from ActivoMovimientoLlave mov, ActivoLlave lla ");
		hb.appendWhere("lla.id = mov.activoLlave.id");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "lla.activo.id", idActivo);

		this.ordenarMovimientos(dto, hb);

		return HibernateQueryUtils.page(this, hb, dto);
	}

	/**
	 * Inserta un orderBy en la consulta, para los movimientos, ya que al ser
	 * una consulta de dos tablas, no las ordena por defecto desde sencha.
	 *
	 * @param dto
	 * @param hb
	 */
	private void ordenarMovimientos(WebDto dto, HQLBuilder hb) {

		if (!Checks.esNulo(dto.getSort())) {
			String numLlave = "numLlave", codigoTipoTenedor = "codigoTipoTenedor";
			if (numLlave.equalsIgnoreCase(dto.getSort())) {
				hb.orderBy("lla.numLlave", dto.getDir().toLowerCase());
			} else if (codigoTipoTenedor.equalsIgnoreCase(dto.getSort())) {
				hb.orderBy("mov.codTenedor", dto.getDir().toLowerCase());
			} else {
				hb.orderBy("mov." + dto.getSort(), dto.getDir().toLowerCase());
			}

		}
	}

	@Override
	public Integer isIntegradoAgrupacionObraNuevaOrAsistida(Long id) {

		HQLBuilder hb = new HQLBuilder(
				"select count(*) from ActivoAgrupacionActivo act where act.agrupacion.fechaBaja is null and act.activo.id = "
						+ id + " and act.agrupacion.tipoAgrupacion.codigo in ('01','13')");

		return ((Long) getHibernateTemplate().find(hb.toString()).get(0)).intValue();
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<VGridOfertasActivosAgrupacionIncAnuladas> getListOfertasActivo(Long idActivo) {

		String hql = " from VGridOfertasActivosAgrupacionIncAnuladas voa ";
		String listaIdsOfertas = "";

		HQLBuilder hb = new HQLBuilder(hql);

		if (!Checks.esNulo(idActivo)) {
			Filter filtroIdActivo = genericDao.createFilter(FilterType.EQUALS, "id", idActivo);
			Activo activo = genericDao.get(Activo.class, filtroIdActivo);

			List<ActivoOferta> listaActivoOfertas = activo.getOfertas();

			for (ActivoOferta activoOferta : listaActivoOfertas) {
				listaIdsOfertas = listaIdsOfertas.concat(activoOferta.getPrimaryKey().getOferta().getId().toString())
						.concat(",");
			}
			listaIdsOfertas = listaIdsOfertas.concat("-1");

			hb.appendWhere(" voa.idOferta in (" + listaIdsOfertas + ") ");
		}

		return (List<VGridOfertasActivosAgrupacionIncAnuladas>) this.getSessionFactory().getCurrentSession().createQuery(hb.toString())
				.list();

	}

	@SuppressWarnings("unchecked")
	@Override
	public List<VGridOfertasActivosAgrupacion> getListOfertasTramitadasPendientesActivo(Long idActivo) {

		String hql = " from VGridOfertasActivosAgrupacion voa2 ";
		String listaIdsOfertas = "";

		HQLBuilder hb = new HQLBuilder(hql);

		if (!Checks.esNulo(idActivo)) {
			Filter filtroIdActivo = genericDao.createFilter(FilterType.EQUALS, "id", idActivo);
			Activo activo = genericDao.get(Activo.class, filtroIdActivo);

			List<ActivoOferta> listaActivoOfertas = activo.getOfertas();

			for (ActivoOferta activoOferta : listaActivoOfertas) {
				listaIdsOfertas = listaIdsOfertas.concat(activoOferta.getPrimaryKey().getOferta().getId().toString())
						.concat(",");
			}
			listaIdsOfertas = listaIdsOfertas.concat("-1");

			hb.appendWhere(" voa2.idOferta in (" + listaIdsOfertas + ") ");
		}

		return (List<VGridOfertasActivosAgrupacion>) this.getSessionFactory().getCurrentSession()
				.createQuery(hb.toString()).list();

	}

	@Override
	public void actualizarRatingActivo(Long idActivo, String username) {
		getHibernateTemplate().flush();

		Session session = this.getSessionFactory().getCurrentSession();
		Query query = session.createSQLQuery("CALL CALCULO_RATING_ACTIVO_AUTO(:idActivo, :username)")
				.setParameter("idActivo", idActivo).setParameter("username", username);

		query.executeUpdate();
	}

	@Override
	public void actualizarSingularRetailActivo(Long idActivo, String username, Integer all_activos,
			Integer ingore_block) {
		Session session = this.getSessionFactory().getCurrentSession();
		Query query = session
				.createSQLQuery("CALL CALCULO_SINGULAR_RETAIL_AUTO(:idActivo, :username, :all_activos, :ingore_block)")
				.setParameter("idActivo", idActivo).setParameter("username", username)
				.setParameter("all_activos", all_activos).setParameter("ingore_block", ingore_block);

		query.executeUpdate();
	}

	@Override
	public String getCodigoTipoComercializarByActivo(Long idActivo) {
		String codComercializar = rawDao.getExecuteSQL("SELECT tcr.DD_TCR_CODIGO " + "		  FROM ACT_ACTIVO act"
				+ "			INNER JOIN DD_TCR_TIPO_COMERCIALIZAR tcr ON act.dd_tcr_id = tcr.dd_tcr_id"
				+ "			WHERE act.ACT_ID = " + idActivo + "			AND act.BORRADO = 0"
				+ "         AND ROWNUM = 1 ");

		return codComercializar;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<VBusquedaActivosPrecios> getListActivosPreciosFromListId(String cadenaId) {

		HQLBuilder hb = new HQLBuilder(
				"select act from VBusquedaActivosPrecios act where act.id in (" + cadenaId + ")");

		return this.getSessionFactory().getCurrentSession().createQuery(hb.toString()).list();
	}

	@Override
	public Long getNextNumActivoRem() {
		String sql = "SELECT S_ACT_NUM_ACTIVO_REM.NEXTVAL FROM DUAL ";
		return ((BigDecimal) this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult())
				.longValue();
	}



	@Override
	public Activo getActivoById(Long activoId) {
		HQLBuilder hb = new HQLBuilder("from Activo act");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "id", activoId);

		return HibernateQueryUtils.uniqueResult(this, hb);
	}

	/* Borra todos las distribuciones excelto las de tipo garaje y trastero */
	public void deleteActivoDistribucion(Long idActivoInfoComercial) {
		Session session = this.getSessionFactory().getCurrentSession();
		Query query = session.createSQLQuery("DELETE FROM ACT_DIS_DISTRIBUCION dis1 where dis1.DIS_ID IN"
				+ " ( select dis2.DIS_ID from ACT_DIS_DISTRIBUCION dis2"
				+ "	INNER JOIN DD_TPH_TIPO_HABITACULO tph ON dis2.dd_tph_id = tph.dd_tph_id"
				+ "	WHERE dis2.ICO_ID = " + idActivoInfoComercial
				// + " AND tph.DD_TPH_CODIGO NOT IN
				// ('"+DDTipoHabitaculo.TIPO_HABITACULO_TRASTERO + "','"+
				// DDTipoHabitaculo.TIPO_HABITACULO_GARAJE +"')"
				+ "	)");
		query.executeUpdate();

	}

	@SuppressWarnings("unchecked")
	@Override
	public List<ActivoCalificacionNegativa> getListActivoCalificacionNegativaByIdActivo(Long idActivo) {
		String hql = "select acn from ActivoCalificacionNegativa acn ";
		HQLBuilder hb = new HQLBuilder(hql);
		hb.appendWhere(" acn.activo.id =  "+idActivo+" ");
		hb.appendWhere(" acn.auditoria.borrado = 0 ");

		List<ActivoCalificacionNegativa> lista = (List<ActivoCalificacionNegativa>) this.getSessionFactory().getCurrentSession().createQuery(hb.toString()).list();
		if(!Checks.estaVacio(lista)) {
			return HibernateUtils.castList(ActivoCalificacionNegativa.class, lista);
		}
		return lista;
		//return  HibernateUtils.castList(ActivoCalificacionNegativa.class, this.getSessionFactory().getCurrentSession().createQuery(hb.toString()).list());

	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<ActivoCalificacionNegativaAdicional> getListActivoCalificacionNegativaAdicionalByIdActivo(Long idActivo) {
		String hql = "select acn from ActivoCalificacionNegativaAdicional acn ";
		HQLBuilder hb = new HQLBuilder(hql);
		hb.appendWhere(" acn.activo.id =  "+idActivo+" ");
		hb.appendWhere(" acn.auditoria.borrado = 0 ");

		List<ActivoCalificacionNegativaAdicional> lista = (List<ActivoCalificacionNegativaAdicional>) this.getSessionFactory().getCurrentSession().createQuery(hb.toString()).list();
		if(!Checks.estaVacio(lista)) {
			return HibernateUtils.castList(ActivoCalificacionNegativaAdicional.class, lista);
		}
		return lista;

	}

	@SuppressWarnings("unchecked")
	@Override
	public List<ActivoCalificacionNegativa> getListActivoCalificacionNegativaByIdActivoBorradoFalse(Long idActivo) {
		String hql = " from ActivoCalificacionNegativa acn ";
		HQLBuilder hb = new HQLBuilder(hql);
		hb.appendWhere(" acn.activo.id =  "+idActivo+" ");
		hb.appendWhere(" acn.auditoria.borrado = false ");

		return (List<ActivoCalificacionNegativa>) this.getSessionFactory().getCurrentSession().createQuery(hb.toString()).list();

	}

	@Override
	public Page getListHistoricoOcupacionesIlegalesByActivo(WebDto dto, Long idActivo) {
		// También se puede usar el genericDao en REM, pero hay que ver como
		// devolver un Page porque no he encontrado casos así.
		// List<ActivoOcupacionIlegal> listaOcupacionesIlegales =
		// genericDao.getList(ActivoOcupacionIlegal.class,
		// genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo));
		HQLBuilder hb = new HQLBuilder("select ocu from ActivoOcupacionIlegal ocu ");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "activo.id", idActivo);

		return HibernateQueryUtils.page(this, hb, dto);

	}

	public void finHistoricoDestinoComercial(Activo activo, Object[] extraArgs) {

		Session session = this.getSessionFactory().getCurrentSession();
		Query query = session.createQuery("UPDATE HistoricoDestinoComercial hdc "
				+ " SET hdc.fechaFin = sysdate, hdc.gestorActualizacion = :gestorActualizacion "
				+ " WHERE hdc.activo.id = :idActivo AND hdc.fechaFin IS NULL");

		query.setParameter("idActivo", activo.getId());

		query.setParameter("gestorActualizacion", getGestorActualizacionHistoricoDestinoComercial(extraArgs));

		query.executeUpdate();

	}

	@Override
	public void hibernateFlush() {
		getHibernateTemplate().flush();
	}

	private String getGestorActualizacionHistoricoDestinoComercial(Object[] extraArgs) {

		Usuario usuario = adapter.getUsuarioLogado();

		String usuarioActualizacion = HistoricoDestinoComercial.GESTOR_ACTUALIZACION_DESCONOCIDO;

		if (!Checks.esNulo(usuario.getNombre())) {

			usuarioActualizacion = usuario.getNombre() + " " + usuario.getApellidos();

		} else if (!Checks.esNulo(usuario.getUsername())) {

			if (REST_USER_USERNAME.equals(usuario.getUsername())) {

				try {

					usuario = (Usuario) extraArgs[MSVREMUtils.MASIVE_PROCES_USER_STARTER_INDEX];

					if (!Checks.esNulo(usuario.getNombre())) {
						usuarioActualizacion = usuario.getNombre() + " " + usuario.getApellidos();
					} else {
						usuarioActualizacion = REST_USER_HDC_NAME;
					}

				} catch (Exception e) {
					usuarioActualizacion = REST_USER_HDC_NAME;
				}

			} else {
				usuarioActualizacion = usuario.getUsername();
			}

		}

		return usuarioActualizacion;
	}

	public void crearHistoricoDestinoComercial(Activo activo, Object[] extraArgs) {

		HistoricoDestinoComercial hdc = new HistoricoDestinoComercial();

		hdc.setActivo(activo);
		hdc.setFechaFin(null);
		hdc.setFechaInicio(new Date());

		hdc.setGestorActualizacion(getGestorActualizacionHistoricoDestinoComercial(extraArgs));

		hdc.setTipoComercializacion(activo.getActivoPublicacion().getTipoComercializacion());

		genericDao.save(HistoricoDestinoComercial.class, hdc);

	}

	@Override
	public Boolean existenOfertasVentaActivo(Long idActivo) {
		try {
			Session session = this.getSessionFactory().getCurrentSession();
			Query query = session.createSQLQuery(
					"SELECT count(ofr.*) FROM OFR_OFERTAS ofr " + "JOIN ACT_OFR afr ON  afr.ofr_id = ofr.ofr_id "
							+ "JOIN DD_TOF_TIPOS_OFERTA tof ON tof.dd_tof_id = ofr.dd_tof_id "
							+ "JOIN DD_EOF_ESTADOS_OFERTA eof ON eof.DD_EOF_ID = ofr.DD_EOF_ID "
							+ "where afr.act_id = 110055 and tof.dd_tof_codigo = '01'");

			String contador = (String) query.uniqueResult();

			if ("1".equals(contador)) {
				return true;
			} else {
				return false;
			}

		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}

	private void agregarFiltroFecha(HQLBuilder hb, String fechaD, String fechaH, String tipoFecha) {
		try {

			if (fechaD != null) {
				Date fechaDesde = DateFormat.toDate(fechaD);
				HQLBuilder.addFiltroBetweenSiNotNull(hb, tipoFecha, fechaDesde, null);
			}

			if (fechaH != null) {
				Date fechaHasta = DateFormat.toDate(fechaH);

				// Se le añade un día para que encuentre las fechas del día
				// anterior hasta las 23:59
				Calendar calendar = Calendar.getInstance();
				if (fechaHasta != null) {
					calendar.setTime(fechaHasta); // Configuramos la fecha que
													// se recibe
				}
				calendar.add(Calendar.DAY_OF_YEAR, 1); // numero de días a
														// añadir, o restar en
														// caso de días<0

				HQLBuilder.addFiltroBetweenSiNotNull(hb, tipoFecha, null, calendar.getTime());
			}

		} catch (ParseException e) {
			e.printStackTrace();
		}
	}

	@Override
	public Page getActivosFromCrearTrabajo(List<String> listIdActivos, DtoTrabajoListActivos dto) {

		HQLBuilder hb = new HQLBuilder("select act from VBusquedaActivosCrearTrabajo act");
		HQLBuilder.addFiltroWhereInSiNotNull(hb, "numActivoHaya", listIdActivos);
		if(dto.getSort() == null) {
			dto.setSort("numActivoHaya");
			dto.setDir("ASC");
		}
		return HibernateQueryUtils.page(this, hb, dto);
	}

	@Override
	public List<Activo> getListActivosPorID(List<Long> activosID) {
		HQLBuilder hb = new HQLBuilder("from Activo act");

		HQLBuilder.addFiltroWhereInSiNotNull(hb, "id", activosID);

		return HibernateQueryUtils.list(this, hb);
	}
	
	@Override
	public Page getListActivosPorID(List<String> activosID, DtoTrabajoListActivos dto) {
		HQLBuilder hb = new HQLBuilder("from VBusquedaActivosCrearTrabajo");

		HQLBuilder.addFiltroWhereInSiNotNull(hb, "idActivo", activosID);
		return HibernateQueryUtils.page(this, hb, dto);
	}

	@Override
	public Boolean todasLasOfertasEstanAnuladas(Long idActivo) {
		String sql = "Select count(1) "
					+ "FROM ACT_OFR actOfr "
					+ "INNER JOIN OFR_OFERTAS ofr ON actOfr.OFR_ID = ofr.OFR_ID"
					+ " WHERE actOfr.ACT_ID = "+idActivo
					+ " AND ofr.DD_EOF_ID NOT IN (SELECT DD_EOF_ID FROM DD_EOF_ESTADOS_OFERTA WHERE DD_EOF_CODIGO = '02')";
		Long ofertasAnuladas;
		if (Checks.esNulo(this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult())) {
			  return false;
		} else {
			 ofertasAnuladas = ((BigDecimal) this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult()).longValue();
			 if (ofertasAnuladas == 0 )
				 return true;
			 else
				 return false;
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	public ActivoAgrupacion getAgrupacionPAByIdActivo(Long idActivo) {

		HQLBuilder hb = new HQLBuilder("select act.agrupacion	 from ActivoAgrupacionActivo act where act.agrupacion.fechaBaja is null and act.activo.id = " + idActivo + " and act.agrupacion.tipoAgrupacion.codigo = " + DDTipoAgrupacion.AGRUPACION_PROMOCION_ALQUILER);

		List<ActivoAgrupacion> lista = getHibernateTemplate().find(hb.toString());

		if (!Checks.estaVacio(lista)) {
			return lista.get(0);
		} else {
			return null;
		}
	}

	@SuppressWarnings("unchecked")
	@Override 
	public ActivoAgrupacionActivo getActivoAgrupacionActivoPA(Long idActivo) {

		HQLBuilder hb = new HQLBuilder("select act from ActivoAgrupacionActivo act where act.activo.id = " + idActivo + " and act.agrupacion.tipoAgrupacion.codigo = " + DDTipoAgrupacion.AGRUPACION_PROMOCION_ALQUILER + " and act.agrupacion.fechaBaja is null");

		List<ActivoAgrupacionActivo> lista = getHibernateTemplate().find(hb.toString());
		
		if (!Checks.estaVacio(lista)) {
			return lista.get(0);
		} else {
			return null;
		}
	}
	
	@SuppressWarnings("unchecked")
	@Override 
	public ActivoAgrupacion getAgrupacionPAByIdActivoConFechaBaja(Long idActivo) {

		HQLBuilder hb = new HQLBuilder("select act.agrupacion	 from ActivoAgrupacionActivo act where act.activo.id = " + idActivo + " and act.agrupacion.tipoAgrupacion.codigo = " + DDTipoAgrupacion.AGRUPACION_PROMOCION_ALQUILER);

		List<ActivoAgrupacion> lista = getHibernateTemplate().find(hb.toString());

		if (!Checks.estaVacio(lista)) {
			return lista.get(0);
		} else {
			return null;
		}
	}

//	@Override
//	public boolean isAgrupacionDadaDeBaja(Long idActivo) {
//
//	}

	@Override
	public boolean isIntegradoEnAgrupacionPA(Long idActivo) {
		HQLBuilder hb = new HQLBuilder("select count(*) from ActivoAgrupacionActivo act where act.activo.id = " + idActivo + " and act.agrupacion.tipoAgrupacion.codigo = " + DDTipoAgrupacion.AGRUPACION_PROMOCION_ALQUILER);

   		return ((Long) getHibernateTemplate().find(hb.toString()).get(0)).intValue() > 0;
	}

	@Override
	public boolean isActivoMatriz(Long idActivo) {
		HQLBuilder hb = new HQLBuilder("select count(*) from ActivoAgrupacionActivo aga where aga.activo.id = " + idActivo
				+ " and aga.agrupacion.tipoAgrupacion.codigo = " + DDTipoAgrupacion.AGRUPACION_PROMOCION_ALQUILER
				+ " and aga.principal = 1");

   		return ((Long) getHibernateTemplate().find(hb.toString()).get(0)).intValue() > 0;
	}
    @Override
    public Long getIdActivoMatriz (Long idAgrupacion) {

    	String sql = "SELECT aga.ACT_ID "
    			+"FROM ACT_AGA_AGRUPACION_ACTIVO aga "
    			+"WHERE aga.AGA_PRINCIPAL = 1 "
    			+"AND aga.AGR_ID  = "+ idAgrupacion;

		if (!Checks.esNulo(this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult())) {
			return ((BigDecimal) this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult()).longValue();
		}
		return null;
    }
    
    

	@Override
	public boolean isUnidadAlquilable(Long idActivo) {
		if (idActivo != null) {
			Activo activo = genericDao.get(Activo.class, genericDao.createFilter(FilterType.EQUALS, "id", idActivo));
			return isUnidadAlquilable(activo);
		}

		return false;
	}

	@Override
	public boolean isUnidadAlquilable(Activo activo) {
		return (activo != null && activo.getTipoTitulo() != null)
				&& DDTipoTituloActivo.UNIDAD_ALQUILABLE.equals(activo.getTipoTitulo().getCodigo());
	}

	@Override
	public Long countUAsByIdAgrupacionPA( Long idAgrupacion) {
		HQLBuilder hb = new HQLBuilder("select count(*) from ActivoAgrupacionActivo aga where aga.agrupacion.id = " + idAgrupacion
				+" and aga.principal = 0"
				+ " and aga.agrupacion.tipoAgrupacion.codigo = " + DDTipoAgrupacion.AGRUPACION_PROMOCION_ALQUILER);

   		return (long) ((Long) getHibernateTemplate().find(hb.toString()).get(0)).intValue();
	}

	@Override
	public boolean isAgrupacionPromocionAlquiler (Long idAgrupacion ) {
		HQLBuilder hb = new HQLBuilder ( "SELECT  count (*) FROM ActivoAgrupacion agr WHERE agr.id = " +idAgrupacion
				+ " and  agr.tipoAgrupacion.codigo = " + DDTipoAgrupacion.AGRUPACION_PROMOCION_ALQUILER);

		return ((Long) getHibernateTemplate().find(hb.toString()).get(0)).intValue() > 0;
	}

	@Override
	public boolean existenUAsconOfertasVivas(Long idAgrupacion) {
		String sql = " SELECT count(1)      "
	+			"				 FROM ACT_AGA_AGRUPACION_ACTIVO aga      "
	+			"				 INNER JOIN ACT_OFR  actOfr ON  aga.ACT_ID =  actOfr.ACT_ID      "
	+			"				 INNER JOIN OFR_OFERTAS ofr ON actOfr.OFR_ID = ofr.OFR_ID      "
	+			"				 INNER JOIN ECO_EXPEDIENTE_COMERCIAL eco ON ofr.OFR_ID = eco.OFR_ID      "
	+			"				 INNER JOIN ACT_ACTIVO act ON actOfr.ACT_ID = act.ACT_ID      "
	+			"				 WHERE aga.AGR_ID =    "	+idAgrupacion
	+			"                AND eco.DD_EEC_ID NOT IN (SELECT DD_EEC_ID FROM DD_EEC_EST_EXP_COMERCIAL WHERE DD_EEC_CODIGO IN ('02','03','08')) "
	+			"				 AND ofr.DD_EOF_ID  IN  (SELECT DD_EOF_ID FROM DD_EOF_ESTADOS_OFERTA WHERE DD_EOF_CODIGO = '01')      "
	+			"				 AND aga.AGA_PRINCIPAL = 0 "
	+			"				 AND act.DD_TTA_ID  = ( SELECT DD_TTA_ID FROM DD_TTA_TIPO_TITULO_ACTIVO WHERE DD_TTA_CODIGO = '05') ";

		if (!Checks.esNulo(this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult())) {
			return ((BigDecimal) this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult()).longValue() > 0;
		}
		return false;

	}
	
	

	@Override
	public boolean existenUAsconTrabajos(Long idAgrupacion) {
		String sql = "                SELECT count(*)  " +
				"				FROM REM01.ACT_AGA_AGRUPACION_ACTIVO aga   " +
				"				INNER JOIN REM01.V_BUSQUEDA_TRAMITES_ACTIVO VBTA ON aga.ACT_ID = VBTA.ACT_ID  " +
				"				WHERE aga.AGR_ID = "+ idAgrupacion
				+"				AND VBTA.ESTADO_CODIGO NOT IN ('04','05','11')";


		if (!Checks.esNulo(this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult())) {
			return ((BigDecimal) this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult()).intValue() > 0;
		}
		return false;

	}

	@Override
	public boolean activoUAsconOfertasVivas(Long idActivo) {
		String sql = " SELECT count(1)      "
	+			"				 FROM ACT_OFR  actOfr      "
	+			"				 INNER JOIN OFR_OFERTAS ofr ON actOfr.OFR_ID = ofr.OFR_ID      "
	+			"				 INNER JOIN ECO_EXPEDIENTE_COMERCIAL eco ON ofr.OFR_ID = eco.OFR_ID      "
	+			"				 INNER JOIN ACT_ACTIVO act ON actOfr.ACT_ID = act.ACT_ID      "
	+			"				 WHERE  act.ACT_ID =    "	+idActivo
	+			"                AND eco.DD_EEC_ID NOT IN (SELECT DD_EEC_ID FROM DD_EEC_EST_EXP_COMERCIAL WHERE DD_EEC_CODIGO IN ('02','03','08')) "
	+			"				 AND ofr.DD_EOF_ID  IN  (SELECT DD_EOF_ID FROM DD_EOF_ESTADOS_OFERTA WHERE DD_EOF_CODIGO = '01')      "
	+			"				 AND act.DD_TTA_ID  = ( SELECT DD_TTA_ID FROM DD_TTA_TIPO_TITULO_ACTIVO WHERE DD_TTA_CODIGO = '05') ";

		if (!Checks.esNulo(this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult())) {
			return ((BigDecimal) this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult()).longValue() > 0;
		}
		return false;

	}
	
	@Override

	public boolean isActivoBBVADivarian(Long idActivo) {
		String sql = "          SELECT count(1)  " +
				"				FROM REM01.ACT_ACTIVO ACT  "+ 
				"				INNER JOIN DD_CRA_CARTERA CRA ON ACT.dd_cra_id = CRA.dd_cra_id "+
				"				INNER JOIN DD_SCR_SUBCARTERA SUBC ON act.dd_scr_id = SUBC.dd_scr_id" +
				"				WHERE ACT.ACT_ID= "+ idActivo +
				"				AND cra.dd_cra_codigo = '16' OR (cra.dd_cra_codigo = '07' AND SUBC.dd_scr_codigo IN ('151','152'))" +
				"				AND ACT.BORRADO = 0";		

		if (!Checks.esNulo(this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult())) {
			return ((BigDecimal) this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult()).intValue() > 0;
		}
		return false;

	}


	@Override
	public boolean existeactivoIdHAYA(Long idActivo) {
		String sql = "          SELECT count(1)  " +
		" FROM REM01.ACT_ACTIVO  " +
		" WHERE ACT_NUM_ACTIVO = "+ idActivo +
		" AND BORRADO = 0";
	
		if (!Checks.esNulo(this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult())) {
			return ((BigDecimal) this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult()).intValue() > 0;
		}
		return false;

	}
	
	@Override
	public boolean activocheckGestion(Long idActivo) {
		String sql = "          SELECT count(1)  " +
		" FROM REM01.ACT_ACTIVO ACT  " +
		" JOIN REM01.ACT_PAC_PERIMETRO_ACTIVO PAC ON PAC.ACT_ID=ACT.ACT_ID " +
		" WHERE ACT_NUM_ACTIVO = "+ idActivo +
		" AND ACT.BORRADO = 0 AND PAC.PAC_CHECK_GESTIONAR=1";
		int result;
	
		if (!Checks.esNulo(this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult())) {
			result=((BigDecimal) this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult()).intValue();
			if (result==1) {
				return true;
			}else {
				return false;
			}			 
		}
		return false;

	}
	
	@Override
	public boolean activoPerteneceABBVAAndCERBERUS(Long idActivo) { 
		String sql = "          SELECT count(1)  " +
				"				FROM REM01.ACT_ACTIVO ACT " +
				" 				inner join REM01.dd_cra_cartera car on act.dd_cra_id=car.dd_cra_id "+		
				"				WHERE ACT.ACT_NUM_ACTIVO = "+ idActivo +
				"				AND car.dd_cra_codigo	in('07','16') 		 "+
				"				AND act.BORRADO = 0";

		if (!Checks.esNulo(this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult())) {
			return ((BigDecimal) this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult()).intValue() > 0;
		}
		return false;

	}
	
	@Override
	public boolean activoEstadoVendido(Long idActivo) { 
		String sql = "          SELECT count(1)  " + 
				"				FROM REM01.ACT_ACTIVO act " +
				"				inner join rem01.dd_scm_situacion_comercial sit on act.dd_scm_id = sit.dd_scm_id "+
				"				WHERE act.ACT_NUM_ACTIVO = "+ idActivo +
				"				AND sit.dd_scm_codigo	in ('05')		 "+
				"				AND act.BORRADO = 0 ";
		
	  

		if (!Checks.esNulo(this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult())) {
			return ((BigDecimal) this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult()).intValue() > 0;
		}
		return false;

	}
	
	@Override
	public boolean activoFueraPerimetroHAYA(Long idActivo) { 
		String sql = "          SELECT count(1)  " +
				"				FROM REM01.ACT_ACTIVO ACT  " +
				"				INNER JOIN ACT_PAC_PERIMETRO_ACTIVO PAC  on PAC.ACT_ID=ACT.ACT_ID"+
				"				WHERE ACT.ACT_NUM_ACTIVO = "+ idActivo +
				"				AND PAC.PAC_INCLUIDO = 0 "+
				"				AND PAC.BORRADO = 0"  +
				"				AND ACT.BORRADO = 0"	;

		if (!Checks.esNulo(this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult())) {
			return ((BigDecimal) this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult()).intValue() > 0;
		}
		return false;

	}

	@Override
	public boolean activoUAsconTrabajos(Long idActivo) {
		String sql = "          SELECT count(*)  " +
				"				FROM REM01.V_BUSQUEDA_TRAMITES_ACTIVO VBTA   " +
				"				WHERE VBTA.ACT_ID = "+ idActivo +
				"				AND VBTA.ESTADO_CODIGO NOT IN ('04','05','11')";

		if (!Checks.esNulo(this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult())) {
			return ((BigDecimal) this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult()).intValue() > 0;
		}
		return false;

	}

	@Override
	public boolean existeAMconOfertasVivas(Long idAgrupacion) {
		String sql = " SELECT count(1)      "
	+			"				 FROM ACT_AGA_AGRUPACION_ACTIVO aga      "
	+			"				 INNER JOIN ACT_OFR  actOfr ON  aga.ACT_ID =  actOfr.ACT_ID      "
	+			"				 INNER JOIN OFR_OFERTAS ofr ON actOfr.OFR_ID = ofr.OFR_ID      "
	+			"				 INNER JOIN ECO_EXPEDIENTE_COMERCIAL eco ON ofr.OFR_ID = eco.OFR_ID      "
	+			"				 INNER JOIN ACT_ACTIVO act ON actOfr.ACT_ID = act.ACT_ID      "
	+			"				 WHERE aga.AGR_ID =    "	+idAgrupacion
	+			"                AND eco.DD_EEC_ID NOT IN (SELECT DD_EEC_ID FROM DD_EEC_EST_EXP_COMERCIAL WHERE DD_EEC_CODIGO IN ('02','03','08')) "
	+			"				 AND ofr.DD_EOF_ID  IN  (SELECT DD_EOF_ID FROM DD_EOF_ESTADOS_OFERTA WHERE DD_EOF_CODIGO = '01')      "
	+			"				 AND aga.AGA_PRINCIPAL = 1 ";


		if (!Checks.esNulo(this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult())) {
			return ((BigDecimal) this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult()).intValue() > 0;
		}
		return false;
	}
	
	@Override
	public boolean existeAMalquilado(Long idAgrupacion) {
		String sql = " SELECT count(1) FROM ACT_AGA_AGRUPACION_ACTIVO AGA	"
	+			"				INNER JOIN ACT_ACTIVO act ON AGA.ACT_ID = act.ACT_ID	"
	+			"				INNER JOIN ACT_PTA_PATRIMONIO_ACTIVO PTA ON ACT.ACT_ID = PTA.ACT_ID	"
	+			"				WHERE AGA.AGR_ID = 	"	+idAgrupacion
	+			"				AND PTA.DD_EAL_ID = (SELECT DD_EAL_ID FROM DD_EAL_ESTADO_ALQUILER WHERE DD_EAL_CODIGO = 02)	"
	+			"				AND AGA.AGA_PRINCIPAL = 1 ";
		
		if (!Checks.esNulo(this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult())) {
			return ((BigDecimal) this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult()).intValue() > 0;
		}
		return false;
	}
	
	@Override
	public boolean existenUAsAlquiladas(Long idAgrupacion) {
		String sql = " SELECT count(1) FROM ACT_AGA_AGRUPACION_ACTIVO AGA	"
		+		"				INNER JOIN ACT_ACTIVO ACT ON AGA.ACT_ID = ACT.ACT_ID	"
		+		"				INNER JOIN ACT_PTA_PATRIMONIO_ACTIVO PTA ON ACT.ACT_ID = PTA.ACT_ID	"
		+		"				WHERE AGA.AGR_ID =  "	+idAgrupacion
		+		"				AND PTA.DD_EAL_ID = (SELECT DD_EAL_ID FROM DD_EAL_ESTADO_ALQUILER WHERE DD_EAL_CODIGO = 02)	"
		+		"				AND AGA.AGA_PRINCIPAL = 0 	"
		+		"				AND ACT.DD_TTA_ID  = (SELECT DD_TTA_ID FROM DD_TTA_TIPO_TITULO_ACTIVO WHERE DD_TTA_CODIGO = '05')";
		
		if (!Checks.esNulo(this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult())) {
			return ((BigDecimal) this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult()).intValue() > 0;
		}
		return false;
	}


	public void validateAgrupacion(Long idActivo) {
		ActivoAgrupacion agrupacion = getAgrupacionPAByIdActivo(idActivo);
		if(!Checks.esNulo(agrupacion)) {
			if (isActivoMatriz(idActivo)) {
				if (existenUAsconOfertasVivas(agrupacion.getId())) {
					logger.error(EXISTEN_UNIDADES_ALQUILABLES_CON_OFERTAS_VIVAS);
					throw new JsonViewerException(messageServices.getMessage(EXISTEN_UNIDADES_ALQUILABLES_CON_OFERTAS_VIVAS));
				}
			}else if (isUnidadAlquilable(idActivo)) {
				if (existeAMconOfertasVivas(agrupacion.getId())) {
					logger.error(EXISTE_ACTIVO_MATRIZ_CON_OFERTAS_VIVAS);
					throw new JsonViewerException(messageServices.getMessage(EXISTE_ACTIVO_MATRIZ_CON_OFERTAS_VIVAS));

				}
			}
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<VBusquedaProveedoresActivo> getListProveedor(List<String> listaIds) {
		String hql = " from VBusquedaProveedoresActivo acn ";
		String ids = "";
		HQLBuilder hb = new HQLBuilder(hql);

		for (int i = 0; i<listaIds.size();i++) {
			ids+=listaIds.get(i);
			if(i+1 != listaIds.size()){
				ids+=", ";
			}
		}
		hb.appendWhereIN("acn.idFalso.idActivo", ids);


		return (List<VBusquedaProveedoresActivo>) this.getSessionFactory().getCurrentSession().createQuery(hb.toString()).list();
	}

	@Override
	public Boolean isPANoDadaDeBaja(Long idActivo) {
		HQLBuilder hb = new HQLBuilder("select count(*) from ActivoAgrupacionActivo aga where aga.activo.id = " + idActivo
				+ " and aga.agrupacion.tipoAgrupacion.codigo = " + DDTipoAgrupacion.AGRUPACION_PROMOCION_ALQUILER
				+ " and aga.principal = 1 and aga.agrupacion.fechaBaja is null");

   		return ((Long) getHibernateTemplate().find(hb.toString()).get(0)).intValue() > 0;

	}
	@Override
	public Boolean checkOfertasVivasAgrupacion(Long idAgrupacion) {
		String sql = "SELECT Count(1) FROM ACT_PAC_PERIMETRO_ACTIVO pac " +
				" JOIN ACT_AGA_AGRUPACION_ACTIVO aga on pac.act_id = aga.act_id and aga.agr_id =" + idAgrupacion +
				" WHERE pac.PAC_OFERTAS_VIVAS = 1 AND AGA.AGA_PRINCIPAL = 0";


		if (!Checks.esNulo(this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult())) {
			return ((BigDecimal) this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult()).intValue() > 0;
		}
		return false;
	}
	@Override
	public Boolean checkOTrabajosVivosAgrupacion(Long idAgrupacion) {
		String sql = "SELECT Count(1) FROM ACT_PAC_PERIMETRO_ACTIVO pac " +
				" JOIN ACT_AGA_AGRUPACION_ACTIVO aga on pac.act_id = aga.act_id and aga.agr_id = " + idAgrupacion +
				" WHERE pac.PAC_TRABAJOS_VIVOS = 1 AND AGA.AGA_PRINCIPAL = 0";


		if (!Checks.esNulo(this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult())) {
			return ((BigDecimal) this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult()).intValue() > 0;
		}
		return false;
	}

	@Override
	public Boolean existeActivo(Long numActivo) {
		String sql = "SELECT Count(1) FROM ACT_ACTIVO " +
				" WHERE act_num_activo = "  + numActivo;

		if (!Checks.esNulo(this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult())) {
			return ((BigDecimal) this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult()).intValue() > 0;
		}
		return false;
	}


	@SuppressWarnings("unchecked")
	@Override
	public List<Object[]> getTrabajosUa (Long idAM, Long idUA){

		HQLBuilder hb = new HQLBuilder(" from Trabajo tbj, ActivoTrabajo atj, Activo act, Activo actUA");
		hb.appendWhere(" atj.trabajo.id = tbj.id ");
		hb.appendWhere(" act.id = tbj.activo.id ");
		hb.appendWhere(" actUA.id = atj.activo.id ");
		hb.appendWhere(" act.id = " + idAM);
		hb.appendWhere(" actUA.id = " + idUA);

		List<Object[]> trabajoList = (List<Object[]>) this.getSessionFactory().getCurrentSession()
				.createQuery(hb.toString()).list();
		return trabajoList;
		
	}

	@Override
	public Long getAgrupacionYubaiByIdActivo(Long id) {
		String sql = "SELECT agrupacion.AGR_ID "  
				+" FROM ACT_AGA_AGRUPACION_ACTIVO activoAgrupacion "
				+" INNER JOIN ACT_ACTIVO  activo ON activoAgrupacion.ACT_ID = activo.ACT_ID AND activo.ACT_ID = " +id
				+" INNER JOIN ACT_AGR_AGRUPACION agrupacion ON activoAgrupacion.AGR_ID = agrupacion.AGR_ID "
				+" INNER JOIN DD_TAG_TIPO_AGRUPACION tipoAgrupacion ON  agrupacion.DD_TAG_ID = tipoAgrupacion.DD_TAG_ID AND DD_TAG_CODIGO = "+DDTipoAgrupacion.AGRUPACION_OBRA_NUEVA
				+" INNER JOIN DD_CRA_CARTERA cartera ON activo.DD_CRA_ID = cartera.DD_CRA_ID AND cartera.DD_CRA_CODIGO = "+DDCartera.CODIGO_CARTERA_THIRD_PARTY  
				+" INNER JOIN DD_SCR_SUBCARTERA subCartera ON activo.DD_SCR_ID = subCartera.DD_SCR_ID AND subCartera.DD_SCR_CODIGO = " +DDSubcartera.CODIGO_YUBAI;
				
		
		if (!Checks.esNulo(this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult())) {
			return ((BigDecimal) this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult()).longValue();
		}
		return null;
	}
	
	
	@SuppressWarnings("unchecked")
	@Override
	public List<ActivoProveedor> getComboApiPrimario() {
		HQLBuilder hb = new HQLBuilder(" from ActivoProveedor pve");
		hb.appendWhere(" pve.tipoProveedor.codigo = '" + DDTipoProveedor.COD_MEDIADOR + "' and pve.auditoria.borrado = 0 and pve.nombre is not null and pve.fechaBaja is null ");
		hb.orderBy("pve.nombre", "asc");
		
		List<ActivoProveedor> mediadores = (List<ActivoProveedor>) getHibernateTemplate().find(hb.toString());
		
		return mediadores;
	}

	@Override
	public ActivoPlusvalia getPlusvaliaByIdActivo(Long idActivo) {
		Criteria criteria = this.getSessionFactory().getCurrentSession().createCriteria(ActivoPlusvalia.class);
		criteria.add(Restrictions.eq("activo.id", idActivo));

		return HibernateUtils.castObject(ActivoPlusvalia.class, criteria.uniqueResult());
	}

	@Override
	public DtoPage getListPlusvalia(DtoPlusvaliaFilter dtoPlusvaliaFilter) {

		HQLBuilder hb = this.rellenarFiltrosBusquedaPlusvalia(dtoPlusvaliaFilter);

		return this.getListadoPlusvaliaCompleto(dtoPlusvaliaFilter, hb);
	}

	private HQLBuilder rellenarFiltrosBusquedaPlusvalia(DtoPlusvaliaFilter dtoPlusvaliaFilter) {
		String select = "select vplusvalia ";
		String from = "from VPlusvalia vplusvalia";

		HQLBuilder hb = null;

		hb = new HQLBuilder(select + from);
		
		if (!Checks.esNulo(dtoPlusvaliaFilter.getNumActivo())) {
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vplusvalia.activo", dtoPlusvaliaFilter.getNumActivo());
		}

		if (!Checks.esNulo(dtoPlusvaliaFilter.getNumPlusvalia())) {
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vplusvalia.plusvalia", dtoPlusvaliaFilter.getNumPlusvalia());
		}

		if (!Checks.esNulo(dtoPlusvaliaFilter.getProvinciaCombo())) {
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vplusvalia.provincia", dtoPlusvaliaFilter.getProvinciaCombo());
		}
		if (!Checks.esNulo(dtoPlusvaliaFilter.getMunicipioCombo())) {
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vplusvalia.municipio", dtoPlusvaliaFilter.getMunicipioCombo());
		}

		return hb;

	}

	@SuppressWarnings("unchecked")
	private DtoPage getListadoPlusvaliaCompleto(DtoPlusvaliaFilter dtoPlusvaliaFilter, HQLBuilder hb) {

		Page pagePlusvalia = HibernateQueryUtils.page(this, hb, dtoPlusvaliaFilter);
		List<VPlusvalia> plusvalias = (List<VPlusvalia>) pagePlusvalia.getResults();

		return new DtoPage(plusvalias, pagePlusvalia.getTotalCount());
	}

	
	@Override
	public void deleteActOfr(Long idActivo, Long idOferta) {
		StringBuilder sb = new StringBuilder("delete from ActivoOferta actofr where actofr.activo = " + idActivo + " and actofr.oferta = " + idOferta);
		this.getSessionFactory().getCurrentSession().createQuery(sb.toString()).executeUpdate();
	}
	
	@Override
	public Object getBusquedaActivosGrid(DtoActivoGridFilter dto, Usuario usuLogado, boolean devolverPage) {
		List<UsuarioCartera> usuarioCartera = genericDao.getList(UsuarioCartera.class,genericDao.createFilter(FilterType.EQUALS, "usuario.id", usuLogado.getId()));
		List<String> subcarteras = new ArrayList<String>();
		
		HQLBuilder hb = new HQLBuilder(" select vgrid from VGridBusquedaActivos vgrid ");
		
		if (usuarioCartera != null && !usuarioCartera.isEmpty()) {
			dto.setCarteraCodigo(usuarioCartera.get(0).getCartera().getCodigo());
			
			if (dto.getSubcarteraCodigo() == null) {
				for (UsuarioCartera uca : usuarioCartera) {
					if (uca.getSubCartera() != null)
						subcarteras.add(uca.getSubCartera().getCodigo());
				}
			}
		}
		
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.carteraCodigo", dto.getCarteraAvanzadaCodigo() != null ?  dto.getCarteraAvanzadaCodigo() : dto.getCarteraCodigo());		
		
		if (subcarteras != null && !subcarteras.isEmpty()) {
			HQLBuilder.addFiltroWhereInSiNotNull(hb, "vgrid.subcarteraCodigo", subcarteras);
		} else {
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.subcarteraCodigo", dto.getSubcarteraAvanzadaCodigo() != null ?  dto.getSubcarteraAvanzadaCodigo() : dto.getSubcarteraCodigo());
		}
		
		HQLBuilder.addFiltroLikeSiNotNull(hb, "vgrid.localidadDescripcion", dto.getLocalidadAvanzadaDescripcion() != null ?  dto.getLocalidadAvanzadaDescripcion() : dto.getLocalidadDescripcion(), true);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.provinciaCodigo", dto.getProvinciaAvanzadaCodigo() != null ?  dto.getProvinciaAvanzadaCodigo() : dto.getProvinciaCodigo());	
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.numFinca", dto.getNumFincaAvanzada() != null ?  dto.getNumFincaAvanzada() : dto.getNumFinca());		
	
		if(dto.getNumAgrupacion() != null) 
			hb.appendWhere(" exists (select 1 from ActivoAgrupacionActivo aga where aga.agrupacion.numAgrupRem = " + dto.getNumAgrupacion() + " and vgrid.id = aga.activo.id) ");			
		if(dto.getRefCatastral() != null) 
			hb.appendWhere(" exists (select 1 from ActivoCatastro cat where upper(cat.refCatastral) like '%" + dto.getRefCatastral().toUpperCase() + "%' and vgrid.id = cat.activo.id) ");
		
		if (dto.getNumActivo() != null && StringUtils.isNumeric(dto.getNumActivo()))
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.numActivo", Long.valueOf(dto.getNumActivo()));						
		if (dto.getNumActivoPrinex() != null && StringUtils.isNumeric(dto.getNumActivoPrinex()))
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.numActivoPrinex", Long.valueOf(dto.getNumActivoPrinex()));		
		if (dto.getNumActivoRecovery() != null && StringUtils.isNumeric(dto.getNumActivoRecovery()))
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.numActivoRecovery", Long.valueOf(dto.getNumActivoRecovery()));
   		if (dto.getNumActivoUvem() != null && StringUtils.isNumeric(dto.getNumActivoUvem()))
   			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.numActivoUvem", Long.valueOf(dto.getNumActivoUvem()));
   		   		   		
   		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.numActivoSareb", dto.getNumActivoSareb());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.numActivoDivarian", dto.getNumActivoDivarian());		
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.estadoActivoCodigo", dto.getEstadoActivoCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.tipoUsoDestinoCodigo", dto.getTipoUsoDestinoCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.claseActivoBancarioCodigo", dto.getClaseActivoBancarioCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.subclaseActivoBancarioCodigo", dto.getSubclaseActivoBancarioCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.numActivoBbva", dto.getNumActivoBbva());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.numActivoCaixa", dto.getNumActivoCaixa());

		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.tipoActivoCodigo", dto.getTipoActivoCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.subtipoActivoCodigo", dto.getSubtipoActivoCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.selloCalidad",	dto.getSelloCalidad());		
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.codPromoPrinex", dto.getCodPromoPrinex());
		
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.tipoViaCodigo", dto.getTipoViaCodigo());		
		HQLBuilder.addFiltroLikeSiNotNull(hb, "vgrid.nombreVia", dto.getNombreVia(), true);
		HQLBuilder.addFiltroLikeSiNotNull(hb, "vgrid.codPostal", dto.getCodPostal(), true);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.paisCodigo", dto.getPaisCodigo());
		
		HQLBuilder.addFiltroLikeSiNotNull(hb, "vgrid.localidadRegistroDescripcion", dto.getLocalidadRegistroDescripcion(), true);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.numRegistro", dto.getNumRegistro());
		HQLBuilder.addFiltroLikeSiNotNull(hb, "vgrid.idufir", dto.getIdufir(), true);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.tipoTituloActivoCodigo", dto.getTipoTituloActivoCodigo());		
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.subtipoTituloActivoCodigo", dto.getSubtipoTituloActivoCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.divHorizontal", dto.getDivHorizontal());			
		
		if (dto.getFechaInscripcionReg() != null) 
			hb.appendWhere(dto.getFechaInscripcionReg() == 1 ? " vgrid.fechaInscripcionReg IS NOT NULL" : " vgrid.fechaInscripcionReg IS NULL ");		
								
		HQLBuilder.addFiltroLikeSiNotNull(hb, "vgrid.nombrePropietario", dto.getNombrePropietario(), true);
		HQLBuilder.addFiltroLikeSiNotNull(hb, "vgrid.docPropietario", dto.getDocPropietario(), true);		
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.ocupado", dto.getOcupado());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.conTituloCodigo", dto.getConTituloCodigo());		
		
		if (dto.getFechaPosesion() !=null) 		
			hb.appendWhere(dto.getFechaPosesion() == 1 ? " vgrid.fechaPosesion IS NOT NULL" : " vgrid.fechaPosesion IS NULL ");		
	
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.tapiado", dto.getTapiado());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.antiocupa", dto.getAntiocupa());		
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.tituloPosesorioCodigo", dto.getTituloPosesorioCodigo());
		
		if(dto.getUsuarioGestor() !=null && dto.getTipoGestorCodigo() !=null) 
			hb.appendWhere(" exists (select 1 from GestorActivo ga where ga.tipoGestor.codigo = '" +  dto.getTipoGestorCodigo() + "' and ga.usuario.id = " +   dto.getUsuarioGestor() + " and vgrid.id = ga.activo.id) ");		
		if (dto.getGestoria() != null) 
			hb.appendWhere(" exists (select 1 from VBusquedaActivosGestorias bag where bag.gestoria = " + dto.getGestoria() + " and vgrid.id = bag.id) ");		
		if(dto.getApiPrimarioId() !=null)
			hb.appendWhere(" exists (select 1 from ActivoInfoComercial aic where aic.mediadorInforme.id = " +  dto.getApiPrimarioId() + " and vgrid.id = aic.activo.id) ");
		
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.situacionComercialCodigo", dto.getSituacionComercialCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.tipoComercializacionCodigo", dto.getTipoComercializacionCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.gestion", dto.getGestion());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.flagRatingCodigo", dto.getFlagRatingCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.conCargas", dto.getConCargas());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.estadoComunicacionGencatCodigo", dto.getEstadoComunicacionGencatCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.direccionComercialCodigo", dto.getDireccionComercialCodigo());
		
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.tipoSegmentoCodigo", dto.getTipoSegmentoCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.perimetroMacc", dto.getPerimetroMacc());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.equipoGestion", dto.getEquipoGestion());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.codPromocionBbva", dto.getCodPromocionBbva());

		return devolverPage ? HibernateQueryUtils.page(this, hb, dto) : HibernateQueryUtils.list(this, hb);	
	}

	@Override
	public List<HistoricoPeticionesPrecios> getHistoricoSolicitudesPrecios(Long idActivo) {
		Order order = new Order(OrderType.DESC,"auditoria.fechaCrear");
		return genericDao.getListOrdered(HistoricoPeticionesPrecios.class, order, genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo));
	}
	
	@Override
	public List<HistoricoRequisitosFaseVenta> getReqFaseVenta(Long idActivo) {
		Order order = new Order(OrderType.DESC,"auditoria.fechaCrear");
		return genericDao.getListOrdered(HistoricoRequisitosFaseVenta.class, order, genericDao.createFilter(FilterType.EQUALS, "activoInfAdministrativa.activo.id", idActivo));
	}

	@Override
	public List<ActivoSuministros> getSuministrosByIdActivo(Long idActivo) {
		Order order = new Order(OrderType.DESC,"auditoria.fechaCrear");
		return genericDao.getListOrdered(ActivoSuministros.class, order, genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo));
	}
	
	@Override
	public void actualizaDatoCDC(CalidadDatosConfig cdc, String valor, String identificador, String username) {
		getHibernateTemplate().flush();		
		Session session = this.getSessionFactory().getCurrentSession();
		StringBuilder sb = new StringBuilder(				
				"UPDATE " + cdc.getTabla() 
				+ " SET " + cdc.getCampo() + "  = " +  valor + " , "
				+ " USUARIOMODIFICAR = '"  +  username + "', "
				+ " FECHAMODIFICAR = SYSDATE " 
				+ " WHERE " + cdc.getCampoId() + " = "
						+ " (SELECT " + cdc.getCampoId() + " "
								+ " FROM " + cdc.getTablaAux() + " "
								+ " WHERE " + cdc.getCampoIdTablaAux() + " = " + identificador + ") "
				+ " AND BORRADO = 0"				
			);
		session.createSQLQuery(sb.toString()).executeUpdate();
	}
	


	@Override
	public Long getComunidadAutonomaId(Activo activo) {
		if(activo.getProvincia() == null) {
			return null;
		}
		
		String sql = " SELECT DD_CCA_ID FROM remmaster.DD_PRV_PROVINCIA prv WHERE DD_PRV_CODIGO = " +activo.getProvincia();
		
		if (!Checks.esNulo(this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult())) {
			return Long.valueOf(this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult().toString());
		}
		return null;
	}
	
	@Override
	public String getUltimaFasePublicacion(Long id) {
		
		String maxId = rawDao.getExecuteSQL("select max(hfp_id) from ACT_HFP_HIST_FASES_PUB where act_id = "+ id + " and hfp_fecha_fin is not null and borrado = 0");
		return maxId;
	}
	
	public Long getNextBbvaNumActivo() {
		String sql = "SELECT S_BBVA_NUM_ACTIVO.NEXTVAL FROM DUAL ";
		return ((BigDecimal) this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult())
				.longValue();
	}

	@Override
	public Activo existeActivoUsuarioCarterizado(Long numActivo, Long idCartera, List<Long> idSubcarteras) {
		
		HQLBuilder hql = new HQLBuilder("from Activo");
		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "numActivo", numActivo);
		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "cartera.id", idCartera);
		HQLBuilder.addFiltroWhereInSiNotNull(hql, "subcartera.id", idSubcarteras);
		List<Activo> activos = HibernateQueryUtils.list(this, hql);
		
		if (activos != null && !activos.isEmpty()) {
			return activos.get(0);
		} else {
			return null;
		}
	}
	

	@Override 
	public Long getCarga(String idBieCarRecovery) {
		if(Checks.esNulo(idBieCarRecovery) || !StringUtils.isNumeric(idBieCarRecovery)) {
			return null;
		}	
	    String resultado;
	    resultado = rawDao.getExecuteSQL(" SELECT CRG.CRG_ID"
	            +" FROM BIE_CAR_CARGAS BIE_CAR"
	            +" JOIN ACT_CRG_CARGAS CRG ON CRG.BIE_CAR_ID = BIE_CAR.BIE_CAR_ID AND CRG.BORRADO = 0"
	            +" WHERE BIE_CAR.BORRADO = 0"
	            +" AND BIE_CAR.BIE_CAR_ID_RECOVERY = " + idBieCarRecovery);
	                
	    return resultado == null ? null : Long.parseLong(resultado);
	}
	
	@Override
	public void actualizaBieCarIdRecovery(Long idBieCar, Long bieCarIdRecovery) {
		getHibernateTemplate().flush();		
		Session session = this.getSessionFactory().getCurrentSession();
		StringBuilder sb = new StringBuilder(				
				"UPDATE BIE_CAR_CARGAS"
				+ " SET BIE_CAR_ID_RECOVERY = " + bieCarIdRecovery
				+ " WHERE BIE_CAR_ID = " + idBieCar
				+ " AND BORRADO = 0"				
			);
		session.createSQLQuery(sb.toString()).executeUpdate();
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<ActivoTasacion> getListActivoTasacionByIdActivos(List<Long> idActivos) {

		HQLBuilder hql = new HQLBuilder("from ActivoTasacion ");
		HQLBuilder.addFiltroWhereInSiNotNull(hql, "activo", idActivos);
		hql.orderBy("fechaInicioTasacion", HQLBuilder.ORDER_ASC);
		
		List<ActivoTasacion> tasacionesList = (List<ActivoTasacion>) this.getSessionFactory().getCurrentSession()
				.createQuery(hql.toString()).list();
		
		return tasacionesList;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<ActivosAlquilados> getListActivosAlquiladosByIdActivos(List<Long> idActivos) {

		HQLBuilder hql = new HQLBuilder("from ActivosAlquilados ");
		HQLBuilder.addFiltroWhereInSiNotNull(hql, "activoAlq", idActivos);
		
		List<ActivosAlquilados> actAlquiladosList = (List<ActivosAlquilados>) this.getSessionFactory().getCurrentSession()
				.createQuery(hql.toString()).list();
		
		return actAlquiladosList;
	}


	@SuppressWarnings("unchecked")
	@Override
	public Boolean cambiarSpOficinaBankia(String codProveedorAnterior, String codProveedorNuevo, String usuario) {
		String procedureHQL = "BEGIN SP_CAMBIO_OFICINA_BANKIA(:vUsuario,:plOutput, :codProveedorAnterior, :codProveedorNuevo); END;";
		int resultado = 0;
		
		try {
			Query callProcedureSql = this.getSessionFactory().getCurrentSession().createSQLQuery(procedureHQL);
			callProcedureSql.setParameter("vUsuario", usuario);
			callProcedureSql.setParameter("plOutput", new String());
			callProcedureSql.setParameter("codProveedorAnterior", codProveedorAnterior);
			callProcedureSql.setParameter("codProveedorNuevo", codProveedorNuevo);			
			
			
			resultado = callProcedureSql.executeUpdate();

			return resultado == 1;
		} catch (Exception e) {
			logger.error("Error en el SP_CAMBIO_OFICINA_BANKIA para el COD PROVEEDOR ANTERIOR "+codProveedorAnterior, e);			
			return false;
		}

	}
	
	@Override
	@Transactional
	public List<Long> getIdsAuxiliarCierreOficinaBankias() {
		List<Object> resultados = rawDao.getExecuteSQLList(
				"		SELECT AUX.ECO_ID" + 
				"		FROM ENVIO_CIERRE_OFICINAS_BANKIA AUX" + 
				"		WHERE AUX.ENVIADO = 0");
		
		List<Long> listaTareas = new ArrayList<Long>();

		/*for(Object o: resultados){
			listaTareas.add((Long) o);
		}*/
		
		for(Object o: resultados){
			String objetoString = o.toString();
			listaTareas.add(Long.parseLong(objetoString));
		}

		return listaTareas;
	}
	@SuppressWarnings("unchecked")
	@Override
	public List<ActivoHistoricoValoraciones> getListActivoHistoricoValoracionesByIdActivo(Long idActivo) {
		
		Order order = new Order(OrderType.ASC,"fechaInicio");
		return genericDao.getListOrdered(ActivoHistoricoValoraciones.class, order, genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo));
	}
	

	@Override
	public boolean perteneceActivoREAM(Long idActivo) {
		String sql = " SELECT count(1)      "
			+			"				 FROM V_ACTIVOS_GESTIONADOS_REAM act    "
			+			"				 WHERE act.act_id =       " + idActivo ;
		if (!Checks.esNulo(this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult())) {
			return ((BigDecimal) this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult()).longValue() > 0;
		}
		return false;

	}


	@SuppressWarnings("unchecked")
	@Override
	public List<ActivoHistoricoValoraciones> getListActivoHistoricoValoracionesByIdActivoAndTipoPrecio(Long idActivo, String codigoTipoPrecio) {
		
		Order order = new Order(OrderType.ASC,"fechaInicio");
		Filter tipo = genericDao.createFilter(FilterType.EQUALS, "tipoPrecio.codigo", codigoTipoPrecio);
		Filter activo = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
		return genericDao.getListOrdered(ActivoHistoricoValoraciones.class, order, activo, tipo);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<ActivoValoraciones> getListActivoValoracionesByIdActivoAndTipoPrecio(Long idActivo, String codigoTipoPrecio) {
		
		Order order = new Order(OrderType.DESC,"id");
		Filter tipo = genericDao.createFilter(FilterType.EQUALS, "tipoPrecio.codigo", codigoTipoPrecio);
		Filter activo = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
		return genericDao.getListOrdered(ActivoValoraciones.class, order, activo, tipo);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public boolean isPublicadoVentaHistoricoByFechaValoracion(Long idActivo, Date fechaValoracion) {
        SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
        String fecha = formatter.format(fechaValoracion);
		
		HQLBuilder hb = new HQLBuilder("select estadoPublicacionVenta.id from ActivoPublicacionHistorico ");
		hb.appendWhere("TO_DATE('"+ fecha +"', 'DD/MM/YYYY') between fechaInicioVenta and fechaFinVenta");
		hb.appendWhere("activo = " + idActivo );
	
		List<String> estadoPublicacionList = this.getSessionFactory().getCurrentSession().createQuery(hb.toString()).list();
		if(estadoPublicacionList != null && !estadoPublicacionList.isEmpty()) {
			DDEstadoPublicacionVenta estadoPublicacion = genericDao.get(DDEstadoPublicacionVenta.class, genericDao.createFilter(FilterType.EQUALS, "id", estadoPublicacionList.get(0)));
			if(estadoPublicacion != null) {
				return !DDEstadoPublicacionVenta.isNoPublicadoVenta(estadoPublicacion);
			}
		}
		
		return false;
		
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public boolean isPublicadoVentaByFechaValoracion(Long idActivo, Date fechaValoracion) {
        SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
        String fecha = formatter.format(fechaValoracion);
		
		HQLBuilder hb = new HQLBuilder("select estadoPublicacionVenta.id from ActivoPublicacion ");
		hb.appendWhere("fechaInicioVenta <= TO_DATE('"+ fecha +"', 'DD/MM/YYYY')");
		hb.appendWhere("activo = " + idActivo );
	
		List<String> estadoPublicacionList = this.getSessionFactory().getCurrentSession().createQuery(hb.toString()).list();
		if(estadoPublicacionList != null && !estadoPublicacionList.isEmpty()) {
			DDEstadoPublicacionVenta estadoPublicacion = genericDao.get(DDEstadoPublicacionVenta.class, genericDao.createFilter(FilterType.EQUALS, "id", estadoPublicacionList.get(0)));
			if(estadoPublicacion != null) {
				return !DDEstadoPublicacionVenta.isNoPublicadoVenta(estadoPublicacion);
			}
		}
		
		return false;		
	}
	
	@Override
	public List<AuxiliarCierreOficinasBankiaMul> getListAprAuxCierreBnK() {
		//TODO aquí se recoge el objetoMapeado
		return genericDao.getList(AuxiliarCierreOficinasBankiaMul.class);
	}
	
	
	
	@SuppressWarnings("unchecked")
	@Override
	public List<Activo> getActivosNoPrincipalesAgrupacion(Long agrId, Long idActivoPrincipal) {
		HQLBuilder hb = new HQLBuilder("Select aga.activo from ActivoAgrupacionActivo aga");
	
		hb.appendWhere("aga.agrupacion.fechaBaja is null");
		hb.appendWhere("aga.agrupacion.id ="+ agrId + " and aga.activo.id !=" +idActivoPrincipal + "");
		
		return this.getSessionFactory().getCurrentSession().createQuery(hb.toString()).list();
	}
	
	@Override
	public boolean isCarteraCaixa(Long idActivo) {
		if (idActivo != null) {
			Activo activo = genericDao.get(Activo.class, genericDao.createFilter(FilterType.EQUALS, "id", idActivo));
			return isCarteraCaixa(activo);
		}
		return false;
	}

	@Override
	public boolean isCarteraCaixa(Activo activo) {
		return (activo != null && activo.getCartera() != null)
				&& DDCartera.CODIGO_CARTERA_BANKIA.equals(activo.getCartera().getCodigo());
	}

	@Override
	public Page findTasaciones(DtoFiltroTasaciones dto) {
		HQLBuilder hb = new HQLBuilder(" from VTasacionesGastosBusqueda tas");

		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tas.idTasacion",
				dto.getIdTasacion());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tas.numActivo",
				dto.getNumActivo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tas.idTasacionExt",
				dto.getIdTasacionExt());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tas.codigoFirmaTasacion",
				dto.getCodigoFirmaTasacion());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "tas.fechaRecepcionTasacion",
				dto.getFechaRecepcionTasacion());

		return HibernateQueryUtils.page(this, hb, dto);
	}
}
