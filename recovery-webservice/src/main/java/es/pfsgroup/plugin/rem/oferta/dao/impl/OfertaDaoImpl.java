package es.pfsgroup.plugin.rem.oferta.dao.impl;

import java.math.BigDecimal;
import java.text.ParseException;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

import org.hibernate.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.GestorExpedienteComercialApi;
import es.pfsgroup.plugin.rem.model.DtoOfertasFilter;
import es.pfsgroup.plugin.rem.model.DtoTextosOferta;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.VOfertasActivosAgrupacion;
import es.pfsgroup.plugin.rem.oferta.dao.OfertaDao;
import es.pfsgroup.plugin.rem.rest.dto.OfertaDto;

@Repository("OfertaDao")
public class OfertaDaoImpl extends AbstractEntityDao<Oferta, Long> implements OfertaDao {
	
	
	public static String TIPO_FECHA_ALTA = "01";
	public static String TIPO_FECHA_FIRMA_RESERVA = "02";
	public static String TIPO_FECHA_POSICIONAMIENTO = "03";
	

	@Autowired
	private GenericAdapter adapter;

	public DtoPage getListOfertas(DtoOfertasFilter dtoOfertasFilter) {
		return getListOfertas(dtoOfertasFilter, null, null);
	}

	@SuppressWarnings("unchecked")
	@Override
	public DtoPage getListOfertas(DtoOfertasFilter dtoOfertasFilter, Usuario usuarioGestor, Usuario usuarioGestoria) {

		HQLBuilder hb = null;
		String from = "select voferta from VOfertasActivosAgrupacion voferta";
		String where = "";
				
		if (!Checks.esNulo(usuarioGestor)) {
			
			if (adapter.tienePerfil("HAYAGESTCOM", usuarioGestor)) {
				if(Checks.esNulo(usuarioGestoria)) {
					from = from	+ ",GestorActivo gestorActivo ";
					where = "gestorActivo.activo.id = voferta.idActivo and gestorActivo.usuario.id =".concat(String.valueOf(usuarioGestor.getId()));
					
				} else{
					from = from	+ ",GestorActivo gestorActivo, GestorExpedienteComercial gestorExpediente";
					where = "gestorActivo.activo.id = voferta.idActivo and "
							+ "gestorActivo.usuario.id =".concat(String.valueOf(usuarioGestor.getId()))+" and " 
							+ "gestorExpediente.expedienteComercial.id = voferta.idExpediente and gestorExpediente.tipoGestor.codigo = '".concat(GestorExpedienteComercialApi.CODIGO_GESTORIA_FORMALIZACION).concat("' and gestorExpediente.usuario.id =".concat(String.valueOf(usuarioGestoria.getId())));
				}				
			} else if (adapter.tienePerfil("GESTCOMBACKOFFICE", usuarioGestor)) {
				if(Checks.esNulo(usuarioGestoria)) {
					from = from	+ ",ActivoLoteComercial lote ";
					where = "lote.id = voferta.idAgrupacion and lote.usuarioGestorComercialBackOffice.id =".concat(String.valueOf(usuarioGestor.getId()));
				} else {
					from = from	+ ",ActivoLoteComercial lote, GestorExpedienteComercial gestorExpediente ";
					where = "lote.id = voferta.idAgrupacion and "
							+ "lote.usuarioGestorComercialBackOffice.id =".concat(String.valueOf(usuarioGestor.getId())) + " and "
							+ "gestorExpediente.expedienteComercial.id = voferta.idExpediente and gestorExpediente.tipoGestor.codigo = '".concat(GestorExpedienteComercialApi.CODIGO_GESTORIA_FORMALIZACION).concat("' and gestorExpediente.usuario.id =".concat(String.valueOf(usuarioGestoria.getId())));
				}

			} else if (adapter.tienePerfil("HAYAGESTFORM", usuarioGestor)) {			
				
				if(Checks.esNulo(usuarioGestoria)) {
					from = from	+ ",GestorExpedienteComercial gestorExpediente ";
					where = "gestorExpediente.expedienteComercial.id = voferta.idExpediente and gestorExpediente.tipoGestor.codigo = '".concat(GestorExpedienteComercialApi.CODIGO_GESTOR_FORMALIZACION).concat("' and gestorExpediente.usuario.id =".concat(String.valueOf(usuarioGestor.getId())));
				} else{
					from = from	+ ",GestorExpedienteComercial gestorExpediente, GestorExpedienteComercial gestoriaExpediente";
					where = "gestorExpediente.expedienteComercial.id = voferta.idExpediente and gestoriaExpediente.expedienteComercial.id = voferta.idExpediente and "
							+ "(gestorExpediente.tipoGestor.codigo = '".concat(GestorExpedienteComercialApi.CODIGO_GESTOR_FORMALIZACION).concat("' and gestorExpediente.usuario.id =".concat(String.valueOf(usuarioGestor.getId())))+") or"
							+ "(gestoriaExpediente.tipoGestor.codigo = '".concat(GestorExpedienteComercialApi.CODIGO_GESTORIA_FORMALIZACION).concat("' and gestoriaExpediente.usuario.id =".concat(String.valueOf(usuarioGestoria.getId())));
				}
			} 
		} 
		
		if (!Checks.esNulo(usuarioGestoria) && Checks.esNulo(usuarioGestor)) {			
			from = from	+ ",GestorExpedienteComercial gestorExpediente ";
			where = "gestorExpediente.expedienteComercial.id = voferta.idExpediente and gestorExpediente.tipoGestor.codigo = '".concat(GestorExpedienteComercialApi.CODIGO_GESTORIA_FORMALIZACION).concat("' and gestorExpediente.usuario.id =".concat(String.valueOf(usuarioGestoria.getId())));
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
			HQLBuilder.addFiltroWhereInSiNotNull(hb, "voferta.codigoEstadoExpediente", Arrays.asList(dtoOfertasFilter.getEstadosExpediente()));
		}
		
		if (!Checks.esNulo(dtoOfertasFilter.getNumAgrupacion())) {
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "voferta.numActivoAgrupacion",
					dtoOfertasFilter.getNumAgrupacion().toString());
		}
		if (!Checks.esNulo(dtoOfertasFilter.getNumActivo())) {
			HQLBuilder.addFiltroLikeSiNotNull(hb, "voferta.activos", dtoOfertasFilter.getNumActivo());
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
			HQLBuilder.addFiltroWhereInSiNotNull(hb, "voferta.codigoEstadoOferta",  Arrays.asList(dtoOfertasFilter.getEstadosOferta()));
		}
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "voferta.codigoTipoOferta", dtoOfertasFilter.getTipoOferta());

		hb.orderBy("voferta.fechaCreacion", HQLBuilder.ORDER_ASC);
		
		HQLBuilder.addFiltroLikeSiNotNull(hb, "voferta.ofertante", dtoOfertasFilter.getOfertante(), true);
		
		// Con la arroba diferenciamos para poder buscar entre varios teléfonos
		if (!Checks.esNulo(dtoOfertasFilter.getTelefonoOfertante())) {
			HQLBuilder.addFiltroLikeSiNotNull(hb, "voferta.telefonoOfertante", dtoOfertasFilter.getTelefonoOfertante());
		}
		HQLBuilder.addFiltroLikeSiNotNull(hb, "voferta.emailOfertante", dtoOfertasFilter.getEmailOfertante(), true);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "voferta.documentoOfertante", dtoOfertasFilter.getDocumentoOfertante());
		
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "voferta.canal", dtoOfertasFilter.getCanal());
		HQLBuilder.addFiltroLikeSiNotNull(hb, "voferta.nombreCanal", dtoOfertasFilter.getNombreCanal(), true);

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
}
