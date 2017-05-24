package es.pfsgroup.plugin.rem.oferta.dao.impl;

import java.math.BigDecimal;
import java.text.ParseException;
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
import es.pfsgroup.plugin.rem.model.DtoOfertasFilter;
import es.pfsgroup.plugin.rem.model.DtoTextosOferta;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.VOfertasActivosAgrupacion;
import es.pfsgroup.plugin.rem.oferta.dao.OfertaDao;
import es.pfsgroup.plugin.rem.rest.dto.OfertaDto;

@Repository("OfertaDao")
public class OfertaDaoImpl extends AbstractEntityDao<Oferta, Long> implements OfertaDao {

	@Autowired
	private GenericAdapter adapter;

	public DtoPage getListOfertas(DtoOfertasFilter dtoOfertasFilter) {
		return getListOfertas(dtoOfertasFilter, null);
	}

	@SuppressWarnings("unchecked")
	@Override
	public DtoPage getListOfertas(DtoOfertasFilter dtoOfertasFilter, Usuario usuario) {

		HQLBuilder hb = null;
		String from = "select voferta from VOfertasActivosAgrupacion voferta";
		if (usuario != null) {
			// segun el tipo de usuario, asumimos que la tipologia es exclusiva
			if (adapter.tienePerfil("HAYAGESTCOM", usuario)) {
				from = from
						+ ",GestorActivo gestorActivo where gestorActivo.activo.id = voferta.idActivo and gestorActivo.usuario.id ="
								.concat(String.valueOf(usuario.getId()));
				hb = new HQLBuilder(from);
				hb.setHasWhere(true);
			} else if (adapter.tienePerfil("GESTCOMBACKOFFICE", usuario)) {
				from = from
						+ ",ActivoLoteComercial lote where lote.id = voferta.idAgrupacion and lote.usuarioGestorComercialBackOffice.id ="
								.concat(String.valueOf(usuario.getId()));
				hb = new HQLBuilder(from);
				hb.setHasWhere(true);
			} else if (adapter.tienePerfil("GESTIAFORM", usuario) || adapter.tienePerfil("HAYAGESTFORM", usuario)) {
				from = from
						+ ",GestorExpedienteComercial gestorExpediente where gestorExpediente.expedienteComercial.id = voferta.idExpediente and gestorExpediente.usuario.id ="
								.concat(String.valueOf(usuario.getId()));
				hb = new HQLBuilder(from);
				hb.setHasWhere(true);
			} else {
				hb = new HQLBuilder(from);
			}

		} else {
			hb = new HQLBuilder(from);
		}

		if (!Checks.esNulo(dtoOfertasFilter.getNumOferta())) {
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "voferta.numOferta", dtoOfertasFilter.getNumOferta().toString());
		}

		if (!Checks.esNulo(dtoOfertasFilter.getNumAgrupacion())) {
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "voferta.numActivoAgrupacion",
					dtoOfertasFilter.getNumAgrupacion().toString());
		}
		if (!Checks.esNulo(dtoOfertasFilter.getNumActivo())) {
			HQLBuilder.addFiltroLikeSiNotNull(hb, "voferta.activos", dtoOfertasFilter.getNumActivo().toString());
		}

		try {
			Date fechaAltaDesde = DateFormat.toDate(dtoOfertasFilter.getFechaAltaDesde());
			Date fechaAltaHasta = DateFormat.toDate(dtoOfertasFilter.getFechaAltaHasta());
			HQLBuilder.addFiltroBetweenSiNotNull(hb, "voferta.fechaCreacion", fechaAltaDesde, fechaAltaHasta);

		} catch (ParseException e) {
			e.printStackTrace();
		}

		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "voferta.codigoTipoOferta", dtoOfertasFilter.getTipoOferta());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "voferta.codigoEstadoOferta", dtoOfertasFilter.getEstadoOferta());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "voferta.codigoTipoOferta", dtoOfertasFilter.getTipoOferta());

		hb.orderBy("voferta.fechaCreacion", HQLBuilder.ORDER_ASC);
		// Faltan los dos combos

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
