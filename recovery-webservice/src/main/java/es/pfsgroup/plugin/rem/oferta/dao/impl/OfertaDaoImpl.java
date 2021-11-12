package es.pfsgroup.plugin.rem.oferta.dao.impl;

import java.math.BigDecimal;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import es.pfsgroup.plugin.rem.model.*;
import es.pfsgroup.plugin.rem.restclient.caixabc.ReplicarOfertaDto;
import org.apache.commons.lang.StringUtils;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVRawSQLDao;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.model.DtoOfertaGridFilter;
import es.pfsgroup.plugin.rem.model.DtoOfertasFilter;
import es.pfsgroup.plugin.rem.model.DtoTextosOferta;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.TitularesAdicionalesOferta;
import es.pfsgroup.plugin.rem.model.UsuarioCartera;
import es.pfsgroup.plugin.rem.model.VGridOfertasActivosAgrupacionIncAnuladas;
import es.pfsgroup.plugin.rem.model.VListOfertasCES;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.oferta.dao.OfertaDao;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.dto.OfertaDto;
import es.pfsgroup.plugin.rem.restclient.caixabc.CaixaBcRestClient;

@Repository("OfertaDao")
public class OfertaDaoImpl extends AbstractEntityDao<Oferta, Long> implements OfertaDao {
	
	
	public static final String TIPO_FECHA_ALTA = "01";
	public static final String TIPO_FECHA_FIRMA_RESERVA = "02";
	public static final String TIPO_FECHA_POSICIONAMIENTO = "03";
	public static final String TIPO_FECHA_ENTRADA_CRMSF = "04";
	public static final String TIPO_FECHA_OFR_PENDIENTE = "05";
	public static final String CODIGO_NUM_ACTIVO_UVEM= "NUM_UVEM";
	public static final String CODIGO_NUM_ACTIVO_SAREB= "NUM_SAREB";
	public static final String CODIGO_NUM_ACTIVO_PRINEX= "NUM_PRINEX";
	public static final String CODIGO_NUM_ACTIVO= "NUM_ACTIVO";
	

	@Autowired
	private MSVRawSQLDao rawDao;
	
	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private CaixaBcRestClient caixaBcRestClient;
	

	//HREOS-6229
	@SuppressWarnings("unchecked")
	@Override
	public DtoPage getListOfertasGestoria(DtoOfertasFilter dtoOfertasFilter) {
		HQLBuilder hb = null;
		
		String from = "SELECT voferta FROM VGridOfertasActivosAgrupacionIncAnuladas voferta, GestorActivo ga INNER JOIN ga.activo INNER JOIN ga.tipoGestor";
					
		hb = new HQLBuilder(from);
		hb.appendWhere("voferta.idActivo = ga.activo.id");
		HQLBuilder.addFiltroIgualQue(hb, "ga.usuario.id", dtoOfertasFilter.getGestoria());
		HQLBuilder.addFiltroIgualQue(hb, "voferta.numActivoAgrupacion", dtoOfertasFilter.getNumActivo());

		Page page = HibernateQueryUtils.page(this, hb, dtoOfertasFilter);
		List<VGridOfertasActivosAgrupacionIncAnuladas> ofertas;
		if(!Checks.estaVacio(page.getResults())) {
			ofertas = (List<VGridOfertasActivosAgrupacionIncAnuladas>) page.getResults();
			return new DtoPage(ofertas, page.getTotalCount());
		}
		return null;		
	}

	@Override
	public Page getListTextosOfertaById(DtoTextosOferta dto, Long id) {

		HQLBuilder hb = new HQLBuilder(" from TextosOferta txo");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "txo.oferta.id", id);

		return HibernateQueryUtils.page(this, hb, dto);

	}

	@Override
	public Long getNextNumOfertaRem() {
		String sql = "SELECT S_OFR_NUM_OFERTA.NEXTVAL FROM DUAL";
		return ((BigDecimal) this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult())
				.longValue();
	}

	@Override
	public List<Oferta> getListaOfertas(OfertaDto ofertaDto) {

		HQLBuilder hql = new HQLBuilder("from Oferta ");
		if (ofertaDto.getIdOfertaWebcom() != null)
			HQLBuilder.addFiltroIgualQueSiNotNull(hql, "idWebCom", ofertaDto.getIdOfertaWebcom());
		if (ofertaDto.getIdOfertaRem() != null)
			HQLBuilder.addFiltroIgualQueSiNotNull(hql, "numOferta", ofertaDto.getIdOfertaRem());

		HQLBuilder.addFiltroIgualQueSiNotNull(hql, "cliente.id", ofertaDto.getIdClienteComercial());

		return HibernateQueryUtils.list(this, hql);
	}
	
	@Override
	public Oferta getOfertaByIdOfertaHayaHomeOrNumOfertaRem(Long idOfertaHayaHome, Long numOfertaRem) {

		HQLBuilder hql = new HQLBuilder("from Oferta ");
		if (idOfertaHayaHome != null)
			HQLBuilder.addFiltroIgualQueSiNotNull(hql, "idOfertaHayaHome", idOfertaHayaHome);
		if (numOfertaRem != null)
			HQLBuilder.addFiltroIgualQueSiNotNull(hql, "numOferta", numOfertaRem);

		return HibernateQueryUtils.uniqueResult(this, hql);
	}

	@Override
	public BigDecimal getImporteCalculo(Long idOferta, String tipoComision, Long idActivo, Long idProveedor) {
		StringBuilder functionHQL = new StringBuilder(
				"SELECT CALCULAR_HONORARIO(:OFR_ID, :ACT_ID, :PVE_ID, :TIPO_COMISION) FROM DUAL");
		if (Checks.esNulo(idProveedor)) {
			idProveedor = -1L;
		}
		Query callFunctionSql = this.getSessionFactory().getCurrentSession().createSQLQuery(functionHQL.toString());

		callFunctionSql.setParameter("OFR_ID", idOferta);
		callFunctionSql.setParameter("ACT_ID", idActivo);
		callFunctionSql.setParameter("PVE_ID", idProveedor);
		callFunctionSql.setParameter("TIPO_COMISION", tipoComision);

		return (BigDecimal) callFunctionSql.uniqueResult();
	}
	
	@Override
	@Transactional
	public Boolean tieneTareaActivaOrFinalizada(String tarea, String numOferta) {
		String sql = "SELECT COUNT(DISTINCT ECO.ECO_ID)" + 
				"		FROM ECO_EXPEDIENTE_COMERCIAL ECO" + 
				"		INNER JOIN ACT_TRA_TRAMITE ATR ON ECO.TBJ_ID = ATR.TBJ_ID" + 
				"		INNER JOIN TAC_TAREAS_ACTIVOS TAC ON ATR.TRA_ID = TAC.TRA_ID" + 
				"		INNER JOIN TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID = TAC.TAR_ID" + 
				"		INNER JOIN TEX_TAREA_EXTERNA TXT ON TXT.TAR_ID = TAR.TAR_ID" + 
				"		INNER JOIN TAP_TAREA_PROCEDIMIENTO TAP ON TXT.TAP_ID = TAP.TAP_ID" + 
				"		INNER JOIN OFR_OFERTAS OFR ON OFR.OFR_ID = ECO.OFR_ID" +  
				"		WHERE TAP.TAP_CODIGO = :tarea " + 
				"		AND OFR.OFR_NUM_OFERTA = :numOferta";
		
		Query callFunctionSql = this.getSessionFactory().getCurrentSession().createSQLQuery(sql.toString());

		callFunctionSql.setParameter("tarea", tarea);
		callFunctionSql.setParameter("numOferta", numOferta);

		return !"0".equals(callFunctionSql.uniqueResult().toString()) ;
		
	}
	
	@Override
	@Transactional
	public Boolean tieneTareaActiva(String tarea, String numOferta) {
		String sql = "SELECT COUNT(1)" + 
				"		FROM ECO_EXPEDIENTE_COMERCIAL ECO" + 
				"		INNER JOIN ACT_TRA_TRAMITE ATR ON ECO.TBJ_ID = ATR.TBJ_ID" + 
				"		INNER JOIN TAC_TAREAS_ACTIVOS TAC ON ATR.TRA_ID = TAC.TRA_ID" + 
				"		INNER JOIN TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID = TAC.TAR_ID" + 
				"		INNER JOIN TEX_TAREA_EXTERNA TXT ON TXT.TAR_ID = TAR.TAR_ID" + 
				"		INNER JOIN TAP_TAREA_PROCEDIMIENTO TAP ON TXT.TAP_ID = TAP.TAP_ID" + 
				"		INNER JOIN OFR_OFERTAS OFR ON OFR.OFR_ID = ECO.OFR_ID" + 
				"		WHERE TAR.TAR_TAREA_FINALIZADA = 0" + 
				"		AND TAP.TAP_CODIGO = :tarea " + 
				"		AND OFR.OFR_NUM_OFERTA = :numOferta";
		
		Query callFunctionSql = this.getSessionFactory().getCurrentSession().createSQLQuery(sql.toString());

		callFunctionSql.setParameter("tarea", tarea);
		callFunctionSql.setParameter("numOferta", numOferta);

		return !"0".equals(callFunctionSql.uniqueResult().toString()) ;
	}
	
	@Override
	@Transactional
	public Boolean tieneTareaFinalizada(String tarea, String numOferta) {
		String sql = "SELECT COUNT(1)" + 
				"		FROM ECO_EXPEDIENTE_COMERCIAL ECO" + 
				"		INNER JOIN ACT_TRA_TRAMITE ATR ON ECO.TBJ_ID = ATR.TBJ_ID" + 
				"		INNER JOIN TAC_TAREAS_ACTIVOS TAC ON ATR.TRA_ID = TAC.TRA_ID" + 
				"		INNER JOIN TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID = TAC.TAR_ID" + 
				"		INNER JOIN TEX_TAREA_EXTERNA TXT ON TXT.TAR_ID = TAR.TAR_ID" + 
				"		INNER JOIN TAP_TAREA_PROCEDIMIENTO TAP ON TXT.TAP_ID = TAP.TAP_ID" + 
				"		INNER JOIN OFR_OFERTAS OFR ON OFR.OFR_ID = ECO.OFR_ID" + 
				"		WHERE TAR.TAR_TAREA_FINALIZADA = 1" + 
				"		AND TAP.TAP_CODIGO = :tarea " + 
				"		AND OFR.OFR_NUM_OFERTA = :numOferta";
		
		Query callFunctionSql = this.getSessionFactory().getCurrentSession().createSQLQuery(sql.toString());

		callFunctionSql.setParameter("tarea", tarea);
		callFunctionSql.setParameter("numOferta", numOferta);

		return !"0".equals(callFunctionSql.uniqueResult().toString()) ;
	}
	
	@Override
	@Transactional
	public List<String> getTareasActivas(String numOferta) {
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("numOferta", numOferta);
		
		rawDao.addParams(params);
		
		List<Object> resultados = rawDao.getExecuteSQLList(
				"		SELECT TAP.TAP_CODIGO" + 
				"		FROM ECO_EXPEDIENTE_COMERCIAL ECO" + 
				"		INNER JOIN ACT_TRA_TRAMITE ATR ON ECO.TBJ_ID = ATR.TBJ_ID" + 
				"		INNER JOIN TAC_TAREAS_ACTIVOS TAC ON ATR.TRA_ID = TAC.TRA_ID" + 
				"		INNER JOIN TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID = TAC.TAR_ID" + 
				"		INNER JOIN TEX_TAREA_EXTERNA TXT ON TXT.TAR_ID = TAR.TAR_ID" + 
				"		INNER JOIN TAP_TAREA_PROCEDIMIENTO TAP ON TXT.TAP_ID = TAP.TAP_ID" + 
				"		INNER JOIN OFR_OFERTAS OFR ON OFR.OFR_ID = ECO.OFR_ID" + 
				"		WHERE TAR.TAR_TAREA_FINALIZADA = 0" + 
				"		AND OFR.OFR_NUM_OFERTA = :numOferta");
		
		List<String> listaTareas = new ArrayList<String>();

		for(Object o: resultados){
			listaTareas.add((String) o);
		}

		return listaTareas;
	}
	
	@Override
	public BigDecimal getImporteCalculoAlquiler(Long idOferta, String tipoComision, Long idProveedor) {
		StringBuilder functionHQL = new StringBuilder(
				"SELECT CALCULAR_HONORARIO_ALQUILER(:OFR_ID, :PVE_ID, :TIPO_COMISION) FROM DUAL");
		if (Checks.esNulo(idProveedor)) {
			idProveedor = -1L;
		}
		Query callFunctionSql = this.getSessionFactory().getCurrentSession().createSQLQuery(functionHQL.toString());

		callFunctionSql.setParameter("OFR_ID", idOferta);
		callFunctionSql.setParameter("PVE_ID", idProveedor);
		callFunctionSql.setParameter("TIPO_COMISION", tipoComision);

		return (BigDecimal) callFunctionSql.uniqueResult();
	}
	
	/**
	 * Sustituye el método "HQLBuilder.addFiltroWhereInSiNotNull" que presenta
	 * un comportamiento extraño cuando los valores son Strings.
	 * 
	 * Se añadien comillas simples "'" a claúsula in (...)
	 * 
	 * @param hb
	 * @param nombreCampo
	 * @param valores
	 */
	private void addFiltroWhereInSiNotNullConStrings(HQLBuilder hb, String nombreCampo, List<String> valores) {
		if (!Checks.estaVacio(valores)) {
			final StringBuilder b = new StringBuilder();
			boolean first = true;
			for (String s : valores) {
				if (!first) {
					b.append(", ");
				} else {
					first = false;
				}
				b.append("'" + s + "'");
			}
			hb.appendWhere(nombreCampo.concat(" in (").concat(b.toString()).concat(")"));
		}
		
	}
	
	public void deleteTitularesAdicionales(Oferta oferta){
		List<TitularesAdicionalesOferta> titularesAdicionales = oferta.getTitularesAdicionales();
		
		for(TitularesAdicionalesOferta titularAdicional : titularesAdicionales){
			genericDao.deleteById(TitularesAdicionalesOferta.class, titularAdicional.getId());
		}
	}

	@Override
	public Oferta getOfertaByIdwebcom(Long idWebcom) {
		Oferta resultado = null;
		HQLBuilder hql = new HQLBuilder("from Oferta ");
		if (idWebcom != null) {
			HQLBuilder.addFiltroIgualQueSiNotNull(hql, "idWebCom", idWebcom);
			try {
				resultado = HibernateQueryUtils.uniqueResult(this, hql);
			} catch (Exception e) {
				logger.error("error obtienendo oferta por idWebcom",e);
			}
		}
		return resultado;
	}

	@Override
	public Oferta getOfertaByIdRem(Long idRem) {
		Oferta resultado = null;
		HQLBuilder hql = new HQLBuilder("from Oferta ");
		if (idRem != null) {
			HQLBuilder.addFiltroIgualQueSiNotNull(hql, "numOferta", idRem);
			try {
				resultado = HibernateQueryUtils.uniqueResult(this, hql);
			} catch (Exception e) {
				logger.error("error obtienendo oferta por idWebcom",e);
			}
		}
		return resultado;
	}

	@Override
	public Oferta getOfertaPrincipal(Long idferta) {

		Oferta resultado = null;
		HQLBuilder hql = new HQLBuilder("select oferAgruLbk.ofertaPrincipal from OfertasAgrupadasLbk oferAgruLbk join oferAgruLbk.ofertaDependiente depen");
		HQLBuilder.addFiltroIgualQue(hql, "depen.id", idferta);
		try {
			resultado = HibernateQueryUtils.uniqueResult(this, hql);
		} catch (Exception e) {
			logger.error("error obtienendo oferta principal",e);
		}

		return resultado;
	}

	@Override
	public List<Oferta> getListOtrasOfertasVivasAgr(Long idOferta, Long idAgr) {
		List<Oferta> ofertasVivas = new ArrayList<Oferta>();
		HQLBuilder hql = new HQLBuilder("from Oferta ");
		DDEstadoOferta estado = genericDao.get(DDEstadoOferta.class
				,genericDao.createFilter(FilterType.EQUALS, "DD_EOF_CODIGO", DDEstadoOferta.CODIGO_RECHAZADA));
		
		if (!Checks.esNulo(idOferta) && !Checks.esNulo(idAgr)) {
			
			hql.appendWhere("id != :idOferta");
			HQLBuilder.addFiltroIgualQue(hql, "agrupacion.id", idAgr);
			hql.appendWhere("estadoOferta.codigo != :estadoCodigo");
			hql.getParameters().put("idOferta", idOferta);
			hql.getParameters().put("estadoCodigo", estado.getCodigo());
			
			try {
				ofertasVivas = HibernateQueryUtils.list(this, hql);
			} catch (Exception e) {
				logger.error("error obtienendo las ofertas vivas",e);
			}
		}
		return ofertasVivas;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public DtoPage getListOfertasCES(DtoOfertasFilter dtoOfertasFilter) {
		String from = "select vofertasces from VListOfertasCES vofertasces";
		HQLBuilder hb = new HQLBuilder(from);

		Page pageVisitas = HibernateQueryUtils.page(this, hb,dtoOfertasFilter);
		List<VListOfertasCES> ofertas = (List<VListOfertasCES>) pageVisitas.getResults();

		return new DtoPage(ofertas, pageVisitas.getTotalCount());
	}
	
	@Override
	public void guardaRegistroWebcom(final Oferta obj) {
		Session session = getSessionFactory().openSession();
		Transaction tx = session.beginTransaction();
		try{
			obj.getAuditoria().setUsuarioModificar(RestApi.REST_LOGGED_USER_USERNAME);
			obj.getAuditoria().setFechaModificar(new Date());
			session.saveOrUpdate(obj);
			tx.commit();
		}
		catch (Exception e) {
			logger.error("error al persistir la oferta",e);
			tx.rollback();
		}
		finally{
			if (session.isOpen()){
				session.flush();
				session.close();
			}
		}
		
		
	}
	
	public void flush() {
		this.getSessionFactory().getCurrentSession().flush();
	}

	@Override
	public Page getBusquedaOfertasGrid(DtoOfertaGridFilter dto, Long usuarioId) {
		List<UsuarioCartera> usuarioCartera = genericDao.getList(UsuarioCartera.class, genericDao.createFilter(FilterType.EQUALS, "usuario.id", usuarioId));
		List<String> subcarteras = new ArrayList<String>();
		
		HQLBuilder hb = new HQLBuilder("select vgrid from VGridBusquedaOfertas vgrid");
		
		if (usuarioCartera != null && !usuarioCartera.isEmpty()) {
			dto.setCarteraCodigo(usuarioCartera.get(0).getCartera().getCodigo());
			
			if (dto.getSubcarteraCodigo() == null) {			
				for (UsuarioCartera usu : usuarioCartera) {
					if (usu.getSubCartera() != null) {
						subcarteras.add(usu.getSubCartera().getCodigo());
					}
				}
			}
		}	
		
		if (dto.getNumOferta() != null && StringUtils.isNumeric(dto.getNumOferta().trim()))
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.numOferta", Long.valueOf(dto.getNumOferta().trim()));
		if (dto.getNumExpediente() != null && StringUtils.isNumeric(dto.getNumExpediente().trim()))
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.numExpediente", Long.valueOf(dto.getNumExpediente().trim()));
		if (dto.getNumActivo() != null && StringUtils.isNumeric(dto.getNumActivo().trim()))
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.numActivo", Long.valueOf(dto.getNumActivo().trim()));
		if (dto.getNumAgrupacion() != null && StringUtils.isNumeric(dto.getNumAgrupacion().trim()))
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.numAgrupacion", Long.valueOf(dto.getNumAgrupacion().trim()));
		if (dto.getNumActivoUvem() != null && StringUtils.isNumeric(dto.getNumActivoUvem().trim()))
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.numActivoUvem", Long.valueOf(dto.getNumActivoUvem().trim()));
		if (dto.getNumPrinex() != null && StringUtils.isNumeric(dto.getNumPrinex().trim()))
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.numActivoPrinex", Long.valueOf(dto.getNumPrinex().trim()));
		
		if (dto.getTipoFecha() != null) {
			try {				
				Date fechaDesde = dto.getFechaDesde() != null ? DateFormat.toDate(dto.getFechaDesde()) : null;
				Date fechaHasta = dto.getFechaHasta() != null ? DateFormat.toDate(dto.getFechaHasta()) : null;
				if (TIPO_FECHA_ALTA.equals(dto.getTipoFecha())) {
					HQLBuilder.addFiltroBetweenSiNotNull(hb, "vgrid.fechaCreacion", fechaDesde, fechaHasta);
				} else if (TIPO_FECHA_FIRMA_RESERVA.equals(dto.getTipoFecha())) {
					HQLBuilder.addFiltroBetweenSiNotNull(hb, "vgrid.fechaFirmaReserva", fechaDesde, fechaHasta);
				} else if (TIPO_FECHA_OFR_PENDIENTE.equals(dto.getTipoFecha())) {
					HQLBuilder.addFiltroBetweenSiNotNull(hb, "vgrid.fechaOfertaPendiente", fechaDesde, fechaHasta);
				}
			} catch (ParseException e) {
				logger.error(e.getMessage());
			}
		}
		
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.tipoComercializacionCodigo", dto.getTipoComercializacionCodigo());
		HQLBuilder.addFiltroLikeSiNotNull(hb, "vgrid.ofertante", dto.getOfertante(), true);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.documentoOfertante", dto.getDocumentoOfertante());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.canalCodigo", dto.getCanalCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.numActivoSareb", dto.getNumActivoSareb());
		HQLBuilder.addFiltroLikeSiNotNull(hb, "vgrid.telefonoOfertante", dto.getTelefonoOfertante(), true);
		HQLBuilder.addFiltroLikeSiNotNull(hb, "vgrid.emailOfertante", dto.getEmailOfertante(), true);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.carteraCodigo", dto.getCarteraCodigo());
		if (subcarteras != null && !subcarteras.isEmpty()) {
			HQLBuilder.addFiltroWhereInSiNotNull(hb, "vgrid.subcarteraCodigo", subcarteras);
		} else {
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.subcarteraCodigo", dto.getSubcarteraCodigo());
		}
		HQLBuilder.addFiltroLikeSiNotNull(hb, "vgrid.nombreCanal", dto.getNombreCanal(), true);
		HQLBuilder.addFiltroLikeSiNotNull(hb, "vgrid.codigoPromocionPrinex", dto.getCodigoPromocionPrinex(), true);
				
		if(dto.getNumAgrupacion() == null
				&& (dto.getAgrupacionesVinculadas() == null || Boolean.FALSE.equals(dto.getAgrupacionesVinculadas()))
				&& (dto.getNumActivoUvem() != null || dto.getNumActivoSareb() != null || dto.getNumPrinex() != null || dto.getNumActivo() != null)){
			HQLBuilder.addFiltroIsNull(hb, "vgrid.idAgrupacion");			
		}						

		if (dto.getClaseActivoBancarioCodigo() != null) {
			hb.appendWhere(" exists (select 1 from ActivoBancario ab where ab.claseActivo.codigo = :claseActivoBancarioCodigo and vgrid.idActivo = ab.activo.id) ");
			hb.getParameters().put("claseActivoBancarioCodigo", dto.getClaseActivoBancarioCodigo());
		}
		
		if (dto.getTipoGestor() != null || dto.getUsuarioGestor() != null) {
			StringBuilder sb = new StringBuilder(" exists (select 1 from GestorActivo ga where vgrid.idActivo = ga.activo.id ");
			if (dto.getTipoGestor() != null) {
				sb.append(" and ga.tipoGestor.codigo = :tipoGestor ");
				hb.getParameters().put("tipoGestor", dto.getTipoGestor());
			}
			if (dto.getUsuarioGestor() != null) {
				sb.append(" and ga.usuario.id = :usuarioGestor ");
				hb.getParameters().put("usuarioGestor", Long.valueOf(dto.getUsuarioGestor()));
			}
			sb.append(" ) ");
			hb.appendWhere(sb.toString());
		}
		
		if (dto.getGestoria() != null) {
			hb.appendWhere(" exists (select 1 from GestorExpedienteComercial gex where vgrid.idExpediente = gex.expedienteComercial.id and gex.usuario.id = :gestoria) ");
			hb.getParameters().put("gestoria", Long.valueOf(dto.getGestoria()));
		}
			
		if (dto.getGestoriaBag() != null) {
			hb.appendWhere(" exists (select 1 from VBusquedaActivosGestorias bag where bag.gestoria = :gestoriaBag and vgrid.idActivo = bag.id) ");
			hb.getParameters().put("gestoriaBag", dto.getGestoriaBag());
		}
		
		if (dto.getCodigoEstadoOferta() != null)
			this.addFiltroWhereInSiNotNullConStrings(hb, "vgrid.codigoEstadoOferta", Arrays.asList(dto.getCodigoEstadoOferta().split(",")));
		if (dto.getCodigoTipoOferta() != null) {
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgrid.codigoTipoOferta", dto.getCodigoTipoOferta());
			if (dto.getEstadoExpedienteVenta() != null) {
				this.addFiltroWhereInSiNotNullConStrings(hb, "vgrid.codigoEstadoExpediente", Arrays.asList(dto.getEstadoExpedienteVenta().split(",")));				
			}else if (dto.getEstadoExpedienteAlquiler() != null) {
				this.addFiltroWhereInSiNotNullConStrings(hb, "vgrid.codigoEstadoExpediente", Arrays.asList(dto.getEstadoExpedienteAlquiler().split(",")));
			}
		}			
		
		return HibernateQueryUtils.page(this, hb, dto);
	}
	
	
	@Override
	public List<Oferta> getListOtrasOfertasTramitadasActivo(Long idActivo) {
		List<Oferta> ofertasTramitadas = new ArrayList<Oferta>();
		HQLBuilder hql = new HQLBuilder("from Oferta o");
		
		if (!Checks.esNulo(idActivo)) {
			hql.appendWhere(" exists (select 1 from  ActivoOferta ao where ao.oferta = o.id and ao.activo = " + idActivo +  ")");	
			HQLBuilder.addFiltroIgualQueSiNotNull(hql, "o.estadoOferta.codigo", DDEstadoOferta.CODIGO_ACEPTADA);
			
			try {
				ofertasTramitadas = HibernateQueryUtils.list(this, hql);
			} catch (Exception e) {
				logger.error("error obtienendo las ofertas tramitadas",e);
			}
		}
		return ofertasTramitadas;
	}

	@Override
	public Boolean replicateOfertaFlush(Long numOferta) {
		flush();
		return caixaBcRestClient.callReplicateOferta(numOferta);
		
	}

	@Override
	public Boolean replicateOfertaFlushWithDto(ReplicarOfertaDto dto) {
		flush();
		return caixaBcRestClient.callReplicateOfertaWithDto(dto);

	}

	@Override
	public Boolean pbcFlush(LlamadaPbcDto dto) {
		flush();
		return caixaBcRestClient.callPbc(dto);

	}
}
