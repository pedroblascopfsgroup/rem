package es.pfsgroup.plugin.rem.gasto.dao.impl;

import java.math.BigDecimal;
import java.text.ParseException;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import es.pfsgroup.commons.utils.hibernate.HibernateUtils;
import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.gasto.dao.GastoDao;
import es.pfsgroup.plugin.rem.model.DtoGastosFilter;
import es.pfsgroup.plugin.rem.model.GastoProveedor;
import es.pfsgroup.plugin.rem.model.VGastosProveedor;
import es.pfsgroup.plugin.rem.model.VGastosProveedorExcel;
import es.pfsgroup.plugin.rem.model.VGastosProvision;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoGasto;
import es.pfsgroup.plugin.rem.proveedores.dao.ProveedoresDao;

@Repository("GastoDao")
public class GastoDaoImpl extends AbstractEntityDao<GastoProveedor, Long> implements GastoDao {

	@Autowired
	ProveedoresDao proveedorDao;

	@Override
	public DtoPage getListGastos(DtoGastosFilter dtoGastosFilter) {

		HQLBuilder hb = this.rellenarFiltrosBusquedaGasto(dtoGastosFilter, false);

		return this.getListadoGastosCompleto(dtoGastosFilter, hb);
	}

	@Override
	public DtoPage getListGastosExcel(DtoGastosFilter dtoGastosFilter) {

		HQLBuilder hb = this.rellenarFiltrosBusquedaGasto(dtoGastosFilter, true);

		hb.orderBy("vgasto.numGastoHaya", HQLBuilder.ORDER_ASC);

		return this.getListadoGastosCompletoExcel(dtoGastosFilter, hb);
	}

	@Override
	public DtoPage getListGastosFilteredByProveedorContactoAndGestoria(DtoGastosFilter dtoGastosFilter, Long idUsuario,
			Boolean isGestoria, Boolean isGenerateExcel) {

		HQLBuilder hb = this.rellenarFiltrosBusquedaGasto(dtoGastosFilter, isGenerateExcel);

		List<String> nombresProveedor = proveedorDao.getNombreProveedorByIdUsuario(idUsuario);
		if (!Checks.estaVacio(nombresProveedor)) {
			if (!isGestoria)
				HQLBuilder.addFiltroWhereInSiNotNull(hb, "vgasto.nombreProveedor", nombresProveedor);
			else {
				String listNombres = this.listToCadenaCommas(nombresProveedor);
				String whereCondition = "vgasto.nombreProveedor in (" + listNombres + ")";

				List<Long> idsProveedor = proveedorDao.getIdProveedoresByIdUsuario(idUsuario);
				if (!Checks.estaVacio(idsProveedor)) {
					String listIds = this.listToCadenaCommas(idsProveedor);
					whereCondition += " or vgasto.idGestoria in (" + listIds + ")";
				}
				hb.appendWhere(whereCondition);
			}
		} else {
			// Si no hay proveedores, no debe mostrar ningún gasto en el listado
			hb.appendWhere("vgasto.id is null");
		}

		if (isGenerateExcel) {
			return this.getListadoGastosCompletoExcel(dtoGastosFilter, hb);
		}
		return this.getListadoGastosCompleto(dtoGastosFilter, hb);
	}

	@SuppressWarnings("unchecked")
	private DtoPage getListadoGastosCompleto(DtoGastosFilter dtoGastosFilter, HQLBuilder hb) {

		Page pageGastos = HibernateQueryUtils.page(this, hb, dtoGastosFilter);
		List<VGastosProveedor> gastos = (List<VGastosProveedor>) pageGastos.getResults();
		if (dtoGastosFilter.getIdProvision() != null) {
			dtoGastosFilter.setLimit(100000);
			Page pageGastosAll = HibernateQueryUtils.page(this, hb, dtoGastosFilter);
			List<VGastosProveedor> gastosAll = (List<VGastosProveedor>) pageGastosAll.getResults();
			Double importeTotalAgrupacion = new Double(0);
			for (VGastosProveedor gasto : gastosAll) {
				if (gasto.getImporteTotal() != null && gasto.getEstadoGastoCodigo() != null
						&& gasto.getEstadoGastoCodigo().equals(DDEstadoGasto.AUTORIZADO_ADMINISTRACION)) {
					importeTotalAgrupacion += gasto.getImporteTotal();
				}
			}
			for (VGastosProveedor gasto : gastos) {
				gasto.setImporteTotalAgrupacion(importeTotalAgrupacion);
			}
		}
		return new DtoPage(gastos, pageGastos.getTotalCount());
	}

	@SuppressWarnings("unchecked")
	private DtoPage getListadoGastosCompletoExcel(DtoGastosFilter dtoGastosFilter, HQLBuilder hb) {

		Page pageGastos = HibernateQueryUtils.page(this, hb, dtoGastosFilter);
		List<VGastosProveedorExcel> gastos = (List<VGastosProveedorExcel>) pageGastos.getResults();
		if (dtoGastosFilter.getIdProvision() != null) {
			dtoGastosFilter.setLimit(100000);
			Page pageGastosAll = HibernateQueryUtils.page(this, hb, dtoGastosFilter);
			List<VGastosProveedorExcel> gastosAll = (List<VGastosProveedorExcel>) pageGastosAll.getResults();
			Double importeTotalAgrupacion = new Double(0);
			for (VGastosProveedorExcel gasto : gastosAll) {
				if (gasto.getImporteTotal() != null && gasto.getEstadoGastoCodigo() != null
						&& gasto.getEstadoGastoCodigo().equals(DDEstadoGasto.AUTORIZADO_ADMINISTRACION)) {
					importeTotalAgrupacion += gasto.getImporteTotal();
				}
			}
			for (VGastosProveedorExcel gasto : gastos) {
				gasto.setImporteTotalAgrupacion(importeTotalAgrupacion);
			}
		}
		return new DtoPage(gastos, pageGastos.getTotalCount());
	}

	private HQLBuilder rellenarFiltrosBusquedaGasto(DtoGastosFilter dtoGastosFilter, Boolean isGenerateExcel) {
		String select = "select vgasto ";
		String from;
		if (isGenerateExcel) {
			from = "from VGastosProveedorExcel vgasto";
		} else {
			from = "from VGastosProveedor vgasto";
		}
		String where = "";
		boolean hasWhere = false;
		HQLBuilder hb = null;

		// Por si es necesario filtrar por datos de los activos del gasto
		String fromGastoActivos = GastoActivosHqlHelper.getFrom(dtoGastosFilter);
		if (!Checks.esNulo(fromGastoActivos)) {
			select = "select distinct vgasto ";
			from = from + fromGastoActivos;
			where = where + GastoActivosHqlHelper.getWhereJoin(dtoGastosFilter, hasWhere);
			hasWhere = true;

		}

		// Por si es necesario filtrar por datos de la provision de gastos
		String fromProvisiongastos = ProvisionGastosHqlHelper.getFrom(dtoGastosFilter);
		if (!Checks.esNulo(fromProvisiongastos)) {
			from = from + fromProvisiongastos;
			where = where + ProvisionGastosHqlHelper.getWhereJoin(dtoGastosFilter, hasWhere);
			hasWhere = true;
		}

		// Por si es necesario filtrar por motivos de gasto
		String fromMotivos = MotivosAvisoHqlHelper.getFrom(dtoGastosFilter);
		if (!Checks.esNulo(fromMotivos)) {
			from = from + fromMotivos;
			where = where + MotivosAvisoHqlHelper.getWhereJoin(dtoGastosFilter, hasWhere);
			hasWhere = true;
		}

		hb = new HQLBuilder(select + from + where);
		if (hasWhere) {
			hb.setHasWhere(true);
		}

		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "gastoActivo.activo.numActivo", dtoGastosFilter.getNumActivo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "gastoActivo.activo.subcartera.codigo",
				dtoGastosFilter.getSubentidadPropietariaCodigo());

		if (!Checks.esNulo(dtoGastosFilter.getNumProvision())) {
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "provision.numProvision",
					Long.parseLong(dtoGastosFilter.getNumProvision()));
		}

		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgasto.idProvision", dtoGastosFilter.getIdProvision());

		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgasto.entidadPropietariaCodigo",
				dtoGastosFilter.getEntidadPropietariaCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgasto.codigoProveedorRem", dtoGastosFilter.getCodigoProveedorRem());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgasto.nifProveedor", dtoGastosFilter.getNifProveedor());

		//////////////////////// Por situación del gasto

		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgasto.estadoAutorizacionHayaCodigo",
				dtoGastosFilter.getEstadoAutorizacionHayaCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgasto.estadoAutorizacionPropietarioCodigo",
				dtoGastosFilter.getEstadoAutorizacionPropietarioCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgasto.estadoGastoCodigo", dtoGastosFilter.getEstadoGastoCodigo());

		//////////////////////// Por gasto

		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgasto.numGastoHaya", dtoGastosFilter.getNumGastoHaya());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgasto.tipoCodigo", dtoGastosFilter.getTipoGastoCodigo());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgasto.subtipoCodigo", dtoGastosFilter.getSubtipoGastoCodigo());

		if (!Checks.esNulo(dtoGastosFilter.getImpuestoIndirecto())) {
			if (dtoGastosFilter.getImpuestoIndirecto() == 1) {
				HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgasto.sujetoImpuestoIndirecto", Boolean.TRUE);
			} else {
				HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgasto.sujetoImpuestoIndirecto", Boolean.FALSE);
			}
		}

		if (!Checks.esNulo(dtoGastosFilter.getImporteDesde()) || !Checks.esNulo(dtoGastosFilter.getImporteHasta())) {
			Double importeHasta = null;
			Double importeDesde = null;

			if (Checks.esNulo(dtoGastosFilter.getImporteDesde())) {
				importeHasta = Double.parseDouble(dtoGastosFilter.getImporteHasta());
			} else if (Checks.esNulo(dtoGastosFilter.getImporteHasta())) {
				importeDesde = Double.parseDouble(dtoGastosFilter.getImporteDesde());
			} else {
				importeHasta = Double.parseDouble(dtoGastosFilter.getImporteHasta());
				importeDesde = Double.parseDouble(dtoGastosFilter.getImporteDesde());
			}

			HQLBuilder.addFiltroBetweenSiNotNull(hb, "vgasto.importeTotal", importeDesde, importeHasta);
		}
		if (!Checks.esNulo(dtoGastosFilter.getNumGastoGestoria())) {
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgasto.numGastoGestoria",
					Long.parseLong(dtoGastosFilter.getNumGastoGestoria()));
		}

		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgasto.idGestoria", dtoGastosFilter.getIdGestoria());

		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgasto.numFactura", dtoGastosFilter.getReferenciaEmisor());

		try {
			Date fechaTopePagoDesde = DateFormat.toDate(dtoGastosFilter.getFechaTopePagoDesde());
			Date fechaTopePagoHasta = DateFormat.toDate(dtoGastosFilter.getFechaTopePagoHasta());
			HQLBuilder.addFiltroBetweenSiNotNull(hb, "vgasto.fechaTopePago", fechaTopePagoDesde, fechaTopePagoHasta);

			Date fechaEmisionDesde = DateFormat.toDate(dtoGastosFilter.getFechaEmisionDesde());
			Date fechaEmisionHasta = DateFormat.toDate(dtoGastosFilter.getFechaEmisionHasta());
			HQLBuilder.addFiltroBetweenSiNotNull(hb, "vgasto.fechaEmision", fechaEmisionDesde, fechaEmisionHasta);

			// filtrar por fechas de autorizacion
			Date fechaAutorizacionDesde = null;
			if (dtoGastosFilter.getFechaAutorizacionDesde() != null) {
				Calendar calendar = Calendar.getInstance();
				calendar.setTime(DateFormat.toDate(dtoGastosFilter.getFechaAutorizacionDesde()));
				calendar.set(Calendar.HOUR_OF_DAY, 0);
				calendar.set(Calendar.MINUTE, 0);
				calendar.set(Calendar.SECOND, 0);
				fechaAutorizacionDesde = calendar.getTime();
			}
			Date fechaAutorizacionHasta = null;
			if (dtoGastosFilter.getFechaAutorizacionHasta() != null) {
				Calendar calendar = Calendar.getInstance();
				calendar.setTime(DateFormat.toDate(dtoGastosFilter.getFechaAutorizacionHasta()));
				calendar.set(Calendar.HOUR_OF_DAY, 23);
				calendar.set(Calendar.MINUTE, 59);
				calendar.set(Calendar.SECOND, 59);
				fechaAutorizacionHasta = calendar.getTime();
			}

			HQLBuilder.addFiltroBetweenSiNotNull(hb, "vgasto.fechaAutorizacion", fechaAutorizacionDesde,
					fechaAutorizacionHasta);

		} catch (ParseException e) {
			e.printStackTrace();
		}
		if (!Checks.esNulo(dtoGastosFilter.getDestinatario())) {
			HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgasto.destinatarioCodigo", dtoGastosFilter.getDestinatario());
		}
		if (!Checks.esNulo(dtoGastosFilter.getCubreSeguro())) {
			if ("1".equals(dtoGastosFilter.getCubreSeguro())) {
				HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgasto.cubreSeguro", true);
			} else if ("0".equals(dtoGastosFilter.getCubreSeguro())) {
				HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgasto.cubreSeguro", false);
			}
		}

		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgasto.periodicidadCodigo", dtoGastosFilter.getPeriodicidad());

		HQLBuilder.addFiltroLikeSiNotNull(hb, "vgasto.nombrePropietario", dtoGastosFilter.getNombrePropietario(), true);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgasto.docIdentifPropietario",
				dtoGastosFilter.getDocIdentifPropietario());

		//////////////////////// Por Proveedor

		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgasto.tipoProveedorCodigo",
				dtoGastosFilter.getCodigoSubtipoProveedor());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgasto.tipoEntidadCodigo", dtoGastosFilter.getCodigoTipoProveedor());
		HQLBuilder.addFiltroLikeSiNotNull(hb, "vgasto.nombreProveedor", dtoGastosFilter.getNombreProveedor(), true);

		//////////////////////// Motivos de Aviso
		String motivosAvisoWhere = MotivosAvisoHqlHelper.getWhere(dtoGastosFilter);
		if (!Checks.esNulo(motivosAvisoWhere)) {
			hb.appendWhere(motivosAvisoWhere);
		}

		return hb;

	}

	@Override
	public Long getNextNumGasto() {

		String sql = "SELECT S_GPV_NUM_GASTO_HAYA.NEXTVAL FROM DUAL ";
		return ((BigDecimal) this.getSessionFactory().getCurrentSession().createSQLQuery(sql).uniqueResult())
				.longValue();

	}

	@Override
	public void deleteGastoTrabajoById(Long id) {

		StringBuilder sb = new StringBuilder("delete from GastoProveedorTrabajo gpt where gpt.id = " + id);
		this.getSessionFactory().getCurrentSession().createQuery(sb.toString()).executeUpdate();

	}

	public GastoProveedor getGastoById(Long id) {

		HQLBuilder hb = new HQLBuilder("from GastoProveedor gpv");
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "id", id);

		return HibernateQueryUtils.uniqueResult(this, hb);
	}

	// Convierte una lista en una cadena con los elementos separados por comas
	private String listToCadenaCommas(List<?> lista) {

		String resultado = "";
		if (!Checks.estaVacio(lista))
			resultado = Arrays.toString(lista.toArray()).replace("[", "").replace("]", "");

		return resultado;
	}

	@SuppressWarnings("unchecked")
	@Override
	public DtoPage getListGastosProvision(DtoGastosFilter dtoGastosFilter) {

		String from = "select vgastosprovision from VGastosProvision vgastosprovision";

		HQLBuilder hb = new HQLBuilder(from);

		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "vgastosprovision.idProvision", dtoGastosFilter.getIdProvision());

		Page page = HibernateQueryUtils.page(this, hb, dtoGastosFilter);
		List<VGastosProvision> gastos = (List<VGastosProvision>) page.getResults();

		return new DtoPage(gastos, page.getTotalCount());
	}

	@Override
	public GastoProveedor getGastoPorNumeroGastoHaya(Long numeroGastoHaya) {
		Session session = this.getSessionFactory().getCurrentSession();
		Criteria criteria = session.createCriteria(GastoProveedor.class);
		criteria.add(Restrictions.eq("numGastoHaya", numeroGastoHaya));

		GastoProveedor gastoProveedor = HibernateUtils.castObject(GastoProveedor.class, criteria.uniqueResult());

		return gastoProveedor;
	}
}
