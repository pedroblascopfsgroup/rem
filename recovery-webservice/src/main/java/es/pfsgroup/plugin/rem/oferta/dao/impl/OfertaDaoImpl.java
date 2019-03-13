package es.pfsgroup.plugin.rem.oferta.dao.impl;

import java.math.BigDecimal;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

import org.hibernate.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.DtoActivoFilter;
import es.pfsgroup.plugin.rem.model.DtoOfertasFilter;
import es.pfsgroup.plugin.rem.model.DtoTextosOferta;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.TitularesAdicionalesOferta;
import es.pfsgroup.plugin.rem.model.VBusquedaActivos;
import es.pfsgroup.plugin.rem.model.VOfertasActivosAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.oferta.dao.OfertaDao;
import es.pfsgroup.plugin.rem.rest.dto.OfertaDto;

@Repository("OfertaDao")
public class OfertaDaoImpl extends AbstractEntityDao<Oferta, Long> implements OfertaDao {
	
	
	public static String TIPO_FECHA_ALTA = "01";
	public static String TIPO_FECHA_FIRMA_RESERVA = "02";
	public static String TIPO_FECHA_POSICIONAMIENTO = "03";
	public static String CODIGO_NUM_ACTIVO_UVEM= "NUM_UVEM";
	public static String CODIGO_NUM_ACTIVO_SAREB= "NUM_SAREB";
	public static String CODIGO_NUM_ACTIVO_PRINEX= "NUM_PRINEX";
	public static String CODIGO_NUM_ACTIVO= "NUM_ACTIVO";
	

	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ActivoDao activoDao;

	public DtoPage getListOfertas(DtoOfertasFilter dtoOfertasFilter) {
		return getListOfertas(dtoOfertasFilter, null, null);
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Override
	public DtoPage getListOfertas(DtoOfertasFilter dtoOfertasFilter, Usuario usuarioGestor, Usuario usuarioGestoria) {

		HQLBuilder hb = null;
		String from = "select voferta from VOfertasActivosAgrupacion voferta";
		String where = "";
				
		if (!Checks.esNulo(usuarioGestor)) {
			
			if (dtoOfertasFilter.getTipoGestor().equals(GestorActivoApi.CODIGO_GESTOR_COMERCIAL) || dtoOfertasFilter.getTipoGestor().equals(GestorActivoApi.CODIGO_GESTOR_FORMALIZACION)) {
				
				// Consulta el tipo gestor: Gestor Comercial (para cruzar por ID en lugar de codigo - evitar subconsulta)
				Filter filtroTipoGestorComer = genericDao.createFilter(FilterType.EQUALS, "codigo", GestorActivoApi.CODIGO_GESTOR_COMERCIAL);
				EXTDDTipoGestor tipoGestorComercial = genericDao.get(EXTDDTipoGestor.class, filtroTipoGestorComer);
				
				if(Checks.esNulo(usuarioGestoria)) {
					
					// Busca ofertas por gestor comercial en activos o en agrupaciones
					from = from + " "
					+ "	 , GestorActivo gac,  " 
					+ "	   GestorEntidad gee ";
					where =
					  "       gac.activo.id = voferta.idActivo "
					+ "       AND gac.id = gee.id AND gee.tipoGestor.id = ".concat(String.valueOf(tipoGestorComercial.getId()))+ " "
					+ "	      AND (voferta.gestorLote = ".concat(String.valueOf(usuarioGestor.getId()))+" "
					+ "		       OR gee.usuario.id = ".concat(String.valueOf(usuarioGestor.getId()))+" )"
					+ "  "; 
				} else{
					// Consulta el tipo gestor: Gestoria Formalizacion (para cruzar por ID en lugar de codigo - evitar subconsulta)
					Filter filtroTipoGestorFormal = genericDao.createFilter(FilterType.EQUALS, "codigo", GestorActivoApi.CODIGO_GESTOR_FORMALIZACION);
					EXTDDTipoGestor tipoGestorFormalizacion = genericDao.get(EXTDDTipoGestor.class, filtroTipoGestorFormal);
					
					// Busca ofertas por usuario gestor comercial y por gestoria en activos o en agrupaciones
					// Nota: Las gestorías actuales son de formalizacion
					from = from + " "
					+ "	 , GestorActivo gac,  " 
					+ "	   GestorEntidad gee, "
					+ "    GestorExpedienteComercial gex ";
					where =
					  "       gac.activo.id = voferta.idActivo "
					+ "       AND gex.expedienteComercial.id = voferta.idExpediente "
					+ "       AND gac.id = gee.id "
					+ "	      AND ( "
					//                Cruce con gestorias de tipo formalizacion, en gestores del expediente
					+ "               ( "
					+ "                  gex.tipoGestor.id = ".concat(String.valueOf(tipoGestorFormalizacion.getId()))+ " "
					+ "                  AND gex.usuario.id = ".concat(String.valueOf(usuarioGestoria.getId()))+" "
					+ "               ) "
					+ "               AND "
					//                Cruce con gestores comerciales, en gestores del activo
					+ "               ( "
					+ "                  gee.tipoGestor.id = ".concat(String.valueOf(tipoGestorComercial.getId()))+ " "
					+ "                  AND gee.usuario.id = ".concat(String.valueOf(usuarioGestoria.getId()))+" "
					+ "               ) "
					+ "       ) "
					+ "  "; 
				}				

			}else{
				
				from = from	+ " ,Oferta ofr ,ActivoOferta afr ,GestorActivo gac ,GestorEntidad gee ,Usuario usu "+" ".concat(" ");
				
				where = " "+" voferta.numOferta = ofr.numOferta ".concat(" ")
						+" "+" AND ofr.id = afr.oferta "+" ".concat(" ") 
						+" "+" AND gac.activo = afr.activo "+" ".concat(" ")
						+" "+" AND gee.id = gac.id "+" ".concat(" ")
						+" "+" AND usu.id = gee.usuario.id "+" ".concat(" ")
						+" "+" AND gee.tipoGestor.codigo = '".concat(dtoOfertasFilter.getTipoGestor()).concat("' ").concat("and gee.usuario.id = '".concat(String.valueOf(usuarioGestor.getId())).concat("'"));
				
			} 
			
		}else if(!Checks.esNulo(usuarioGestor) && !Checks.esNulo(dtoOfertasFilter.getTipoGestor())){			
					
			from = from	+ " ,Oferta ofr ,ActivoOferta afr ,GestorActivo gac ,GestorEntidad gee ,Usuario usu ".concat(" ")+" ";
			
			where = " "+" voferta.numOferta = ofr.numOferta "+" ".concat(" ")
					+" "+" AND ofr.id = afr.oferta "+" ".concat(" ") 
					+" "+" AND gac.activo = afr.activo "+" ".concat(" ")
					+" "+" AND gee.id = gac.id "+" ".concat(" ")
					+" "+" AND usu.id = gee.usuario.id "+" ".concat(" ")
					+" "+" AND ((gee.tipoGestor.codigo = ".concat(" '").concat(dtoOfertasFilter.getTipoGestor()).concat("' ").concat(" and gee.usuario.id = '".concat(String.valueOf(usuarioGestor.getId())).concat("' ")+" )) "+" ");
			
				
		}else if(!Checks.esNulo(dtoOfertasFilter.getTipoGestor()) && Checks.esNulo(usuarioGestor)){
			
			from = from	+ " ,Oferta ofr ,ActivoOferta afr ,GestorActivo gac ,GestorEntidad gee ,Usuario usu "+" ".concat(" ");
			
			where = " "+" voferta.numOferta = ofr.numOferta ".concat(" ")
					+" "+" AND ofr.id = afr.oferta "+" ".concat(" ") 
					+" "+" AND gac.activo = afr.activo "+" ".concat(" ")
					+" "+" AND gee.id = gac.id "+" ".concat(" ")
					+" "+" AND usu.id = gee.usuario.id "+" ".concat(" ")
					+" "+" AND gee.tipoGestor.codigo = '".concat(dtoOfertasFilter.getTipoGestor()).concat("' ");
				
		}
			
		hb = new HQLBuilder(from);
		
		if(!Checks.esNulo(where)) {
			hb.appendWhere(where);
		}
		

		if (!Checks.esNulo(dtoOfertasFilter.getNumOferta())) {
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "voferta.numOferta", dtoOfertasFilter.getNumOferta());
		}
		
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "voferta.numExpediente", dtoOfertasFilter.getNumExpediente());
		
		if (!Checks.esNulo(dtoOfertasFilter.getEstadosExpediente())) {
			addFiltroWhereInSiNotNullConStrings(hb, "voferta.codigoEstadoExpediente", Arrays.asList(dtoOfertasFilter.getEstadosExpediente()));
		}
		
		if (!Checks.esNulo(dtoOfertasFilter.getEstadosExpedienteAlquiler())) {
			addFiltroWhereInSiNotNullConStrings(hb, "voferta.codigoEstadoExpediente", Arrays.asList(dtoOfertasFilter.getEstadosExpedienteAlquiler()));
		}

		if (!Checks.esNulo(dtoOfertasFilter.getTipoComercializacion())) {
			addFiltroWhereInSiNotNullConStrings(hb, "voferta.tipoComercializacion", Arrays.asList(dtoOfertasFilter.getTipoComercializacion()));
		}

		if (!Checks.esNulo(dtoOfertasFilter.getClaseActivoBancario())) {
			addFiltroWhereInSiNotNullConStrings(hb, "voferta.claseActivoBancario", Arrays.asList(dtoOfertasFilter.getClaseActivoBancario()));
		}
		
		if (!Checks.esNulo(dtoOfertasFilter.getNumAgrupacion())) {
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "voferta.numActivoAgrupacion",
					dtoOfertasFilter.getNumAgrupacion());
		}

		if (!Checks.esNulo(dtoOfertasFilter.getNumActivo())) {
			Filter filtroIdActivo = genericDao.createFilter(FilterType.EQUALS, "numActivo", dtoOfertasFilter.getNumActivo());
			Activo idActivo = genericDao.get(Activo.class, filtroIdActivo);
			
			if(!Checks.esNulo(idActivo)){
				HQLBuilder.addFiltroIgualQueSiNotNull(hb, "voferta.idActivo", idActivo.getId());
			}else{
				HQLBuilder.addFiltroIsNull(hb, "voferta.idActivo");
			}
			
		}
		
		//HREOS-2716
		if (!Checks.esNulo(dtoOfertasFilter.getCodigoPromocionPrinex())) {
			DtoActivoFilter dtoActivo = new DtoActivoFilter();
			dtoActivo.setCodigoPromocionPrinex(dtoOfertasFilter.getCodigoPromocionPrinex());
			List activos = activoDao.getListActivosLista(dtoActivo, null);
			List<Long> idActivos = new ArrayList<Long>();
			for(int i = 0; i < activos.size(); i++) {
				idActivos.add(((VBusquedaActivos)activos.get(i)).getId());
			}
			HQLBuilder.addFiltroWhereInSiNotNull(hb, "voferta.idActivo", idActivos);
		}
		
		try {
			
			Date fechaDesde = DateFormat.toDate(dtoOfertasFilter.getFechaDesde());
			Date fechaHasta = DateFormat.toDate(dtoOfertasFilter.getFechaHasta());
			String tipo = dtoOfertasFilter.getTipoFecha();
			String campo=null;
			
			if(TIPO_FECHA_ALTA.equals(tipo)) {
				campo = "voferta.fechaCreacion";
			} else if(TIPO_FECHA_FIRMA_RESERVA.equals(tipo)) {
				campo = "voferta.fechaFirmaReserva";
			}/* else if(TIPO_FECHA_POSICIONAMIENTO.equals(tipo)) {
				campo = "";
			}*/
			
			if(!Checks.esNulo(campo)) {
				HQLBuilder.addFiltroBetweenSiNotNull(hb, campo, fechaDesde, fechaHasta);
			}
			


		} catch (ParseException e) {
			e.printStackTrace();
		}

		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "voferta.codigoTipoOferta", dtoOfertasFilter.getTipoOferta());
		if (!Checks.esNulo(dtoOfertasFilter.getEstadosOferta())) {
			addFiltroWhereInSiNotNullConStrings(hb, "voferta.codigoEstadoOferta",  Arrays.asList(dtoOfertasFilter.getEstadosOferta()));
		}
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "voferta.codigoTipoOferta", dtoOfertasFilter.getTipoOferta());

		if(dtoOfertasFilter.getSort() == null || dtoOfertasFilter.getSort().isEmpty()){
			hb.orderBy("voferta.fechaCreacion", HQLBuilder.ORDER_ASC);
		}
		
		
		HQLBuilder.addFiltroLikeSiNotNull(hb, "voferta.ofertante", dtoOfertasFilter.getOfertante(), true);
		
		// Con la arroba diferenciamos para poder buscar entre varios teléfonos
		if (!Checks.esNulo(dtoOfertasFilter.getTelefonoOfertante())) {
			HQLBuilder.addFiltroLikeSiNotNull(hb, "voferta.telefonoOfertante", dtoOfertasFilter.getTelefonoOfertante());
		}
		HQLBuilder.addFiltroLikeSiNotNull(hb, "voferta.emailOfertante", dtoOfertasFilter.getEmailOfertante(), true);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "voferta.documentoOfertante", dtoOfertasFilter.getDocumentoOfertante());
		
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "voferta.canal", dtoOfertasFilter.getCanal());
		HQLBuilder.addFiltroLikeSiNotNull(hb, "voferta.nombreCanal", dtoOfertasFilter.getNombreCanal(), true);

		if(!Checks.esNulo(dtoOfertasFilter.getCarteraCodigo())) {
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "voferta.carteraCodigo", dtoOfertasFilter.getCarteraCodigo());
		}
		
		if(!Checks.esNulo(dtoOfertasFilter.getNumActivoUvem())){
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "voferta.numActivoUvem", dtoOfertasFilter.getNumActivoUvem());
		}
		if(!Checks.esNulo(dtoOfertasFilter.getNumActivoSareb())){
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "voferta.numActivoSareb", dtoOfertasFilter.getNumActivoSareb());
		}
		if(!Checks.esNulo(dtoOfertasFilter.getNumPrinex())){
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "voferta.numActivoPrinex", dtoOfertasFilter.getNumPrinex());
		}
		
		if(((
				!Checks.esNulo(dtoOfertasFilter.getNumActivoUvem()) || 
				!Checks.esNulo(dtoOfertasFilter.getNumActivoSareb()) || 
				!Checks.esNulo(dtoOfertasFilter.getNumPrinex()) || 
				!Checks.esNulo(dtoOfertasFilter.getNumActivo())
			) && 
				(Checks.esNulo(dtoOfertasFilter.getNumAgrupacion()) && 
						(Checks.esNulo(dtoOfertasFilter.getAgrupacionesVinculadas()) || dtoOfertasFilter.getAgrupacionesVinculadas().equals(false))
				)
			)){
			
			HQLBuilder.addFiltroIsNull(hb, "voferta.idAgrupacion");
		}
		
		Page pageVisitas = HibernateQueryUtils.page(this, hb, dtoOfertasFilter);

		List<VOfertasActivosAgrupacion> ofertas = (List<VOfertasActivosAgrupacion>) pageVisitas.getResults();

		return new DtoPage(ofertas, pageVisitas.getTotalCount());

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
				b.append("'" + s.toString() + "'");
			}
			hb.appendWhere(nombreCampo.concat(" in (").concat(b.toString()).concat(")"));
		}
		
	}
	
	public void deleteTitularesAdicionales(Long idOferta){
		Filter f1 = genericDao.createFilter(FilterType.EQUALS, "id", idOferta);
		Oferta oferta = genericDao.get(Oferta.class, f1);
		
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
	public List<Oferta> getListOtrasOfertasVivasAgr(Long idOferta, Long idAgr) {
		List<Oferta> ofertasVivas = new ArrayList<Oferta>();
		HQLBuilder hql = new HQLBuilder("from Oferta ");
		DDEstadoOferta estado = genericDao.get(DDEstadoOferta.class
				,genericDao.createFilter(FilterType.EQUALS, "DD_EOF_CODIGO", DDEstadoOferta.CODIGO_RECHAZADA));
		
		if (!Checks.esNulo(idOferta) && !Checks.esNulo(idAgr)) {
			hql.appendWhere(" id != " + idOferta
					+ " and agrupacion.id = " + idAgr
					+ " and estadoOferta.codigo != '" + estado.getCodigo() + "'");
			try {
				ofertasVivas = HibernateQueryUtils.list(this, hql);
			} catch (Exception e) {
				logger.error("error obtienendo las ofertas vivas",e);
			}
		}
		return ofertasVivas;
	}
}
