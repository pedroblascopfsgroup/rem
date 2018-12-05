Ext.define('HreRem.view.activos.detalle.CabeceraActivo', {
	extend: 'Ext.container.Container',
	xtype: 'cabeceraactivo',
	requires: ['HreRem.view.common.ToolFieldSet', 'HreRem.ux.button.BotonFavorito'],
	layout: 'fit',
	initComponent: function () {

		var me = this;

		me.menu = Ext.create("Ext.menu.Menu", {
			width: 150,
			cls: 'menu-favoritos',
			plain: true,
			floating: true,
			items: [
				{
					text: HreRem.i18n('btn.cerrar.pestanya'),
					handler: 'onClickBotonCerrarPestanya'
				},
				{
					text: HreRem.i18n('btn.cerrar.todas'),
					handler: 'onClickBotonCerrarTodas'
				},
				{
					text: HreRem.i18n('btn.nueva.notificacion'),
					handler: 'onNotificacionClick',
					secFunPermToShow: 'BOTON_CREAR_NOTIFICACION',
					hidden: (me.lookupController().getViewModel().get('activo').get('incluidoEnPerimetro')=="false")
				},
				{
					text: HreRem.i18n('btn.nuevo.tramite'),
					handler: 'onTramiteClick',
					secFunPermToShow: 'BOTON_CREAR_TRAMITE',
					hidden: (me.lookupController().getViewModel().get('activo').get('incluidoEnPerimetro')=="false")
				},
				{
					text: 'Lanzar T. de Publicacion',
					handler: 'onTramitePublicacionClick',
					hidden: (me.lookupController().getViewModel().get('activo').get('incluidoEnPerimetro')=="false")
				}
			]
		});

		me.gmap = Ext.create('HreRem.ux.panel.GMapPanel', {
				gmapType: 'map',
				center: {},
				mapOptions : {
					disableDefaultUI: true,
					mapTypeId: google.maps.MapTypeId.ROADMAP,
					zoom: 16
				},
				listeners: {
					mapready: function(gmap, map) {
						if(map.center.marker){
							gmap.addMarker(map.center.marker);
						}
					}
				}
		});	

		me.items = [
					{
						xtype:'toolfieldset',
						height: 175,
						bind: {
						 title: 'ACTIVO {activo.numActivo} / ORIGEN {activo.tipoTitulo} / TIPO {activo.tipoActivoDescripcion} - {activo.subtipoActivoDescripcion}'
						},
						cls: 'fieldsetBase cabecera',
						border: false,
						collapsible: true,
						collapsed: false,
						layout: {
							type: 'hbox'
						},
						tools: [
							{
								xtype: 'button',
								cls: 'btn-tbfieldset delete-focus-bg no-pointer',
								bind: {
									iconCls: '{getIconClsEstadoAdmision}'
								},
								iconAlign: 'right',
								text: 'ADMISION'
							},
							{
								xtype: 'button',
								cls: 'btn-tbfieldset delete-focus-bg no-pointer',
								bind: {
									iconCls: '{getIconClsEstadoGestion}'
								},
								iconAlign: 'right',
								text: 'GESTION'
							},
							{
								xtype: 'button',
								cls: 'btn-tbfieldset delete-focus-bg no-pointer',
								bind: {
									iconCls: '{getIconClsPrecioAprobadoVentaRenta}'
								},
								iconAlign: 'right',
								text: 'PRECIOS'
							},
							{
								xtype: 'button',
								cls: 'btn-tbfieldset delete-focus-bg no-pointer',
								bind: {
									iconCls: '{getIconClsEstadoVenta}',
									hidden: '{!activo.incluyeDestinoComercialVenta}'
								},
								iconAlign: 'right',
								text: HreRem.i18n('title.publicaciones.indicador.venta')
							},
							{
								xtype: 'button',
								cls: 'btn-tbfieldset delete-focus-bg no-pointer',
								bind: {
									iconCls: '{getIconClsestadoAlquiler}',
									hidden: '{!activo.incluyeDestinoComercialAlquiler}'
								},
								iconAlign: 'right',
								text: HreRem.i18n('title.publicaciones.indicador.alquiler')
							},
							{
								xtype: 'tbfill'
							},
							{
								xtype: 'button',
								cls: 'boton-cabecera',
								iconCls: 'ico-crear-trabajo',
								tooltip: HreRem.i18n('btn.nueva.peticion.trabajo'),
								handler: 'onClickCrearTrabajo',
								secFunPermToShow: 'BOTON_CREAR_TRABAJO',
								hidden: (me.lookupController().getViewModel().get('activo').get('incluidoEnPerimetro')=="false")
							},
							{
								xtype: 'button',
								cls: 'boton-cabecera',
								iconCls: 'ico-refrescar',
								handler	: 'onClickBotonRefrescar',
								tooltip: HreRem.i18n('btn.refrescar')
							},
							{
								xtype: 'botonfavorito',
								cssFavorito: 'ico-pestana-activos',
								tipoId: 'activo'
							},
							{
								xtype: 'button',
								cls: 'boton-cabecera',
								iconCls: 'x-fa fa-bars',
								arrowVisible: false,
								menuAlign: 'tr-br',
								menu:  me.menu
							}
						],
						items: [
							{
								xtype: 'container',
								layout: 'hbox',
								items: [
									{
										xtype: 'panel',
										tipo: 'panelgmap',
										layout: 'fit',
										width: 225,
										height: 125,
										cls: 'cabecera-mapa',
										margin: '10 10 10 20'
									},
									{
										xtype: 'image',
										height: 125,
										width: 120,
										margin: '0 10 0 10 ',
										cls: 'cabecera-rating',
										bind: {
											src: 'resources/images/rating_{activo.rating}.svg'
										},
										alt: 'Rating'
									}
								]
							},
							{
								xtype:'container',
								flex: 4,
								maxWidth: 800,
								height: 125,
								margin: '5 10 10 10 ',
								defaultType: 'displayfield',
								defaults: {
									labelWidth: 80
								},
								autoScroll: true,
								layout: {
									type: 'table',
									columns: 2,
									tdAttrs: {width: '50%',  pading: 0},
									tableAttrs: {
										style: {
											width: '100%'
										}
									}
								},
								cls: 'cabecera-apartado cabecera-info',
								items: [
									{
										fieldLabel: HreRem.i18n('title.publicaciones.venta'),
										cls: 'cabecera-info-field',
										bind: {
											hidden: '{!activo.incluyeDestinoComercialVenta}',
											value: '{activo.estadoVentaDescripcion}'
										}
									},
									{
										fieldLabel: HreRem.i18n('title.publicaciones.alquiler'),
										cls: 'cabecera-info-field',
										bind: {
											hidden: '{!activo.incluyeDestinoComercialAlquiler}',
											value: '{activo.estadoAlquilerDescripcion}'
										}
									},
									{
										fieldLabel: HreRem.i18n('fieldlabel.enlace.externo'),
										cls: 'cabecera-info-field',
										bind: {
											hidden: '{!estaPublicadoVentaOAlquiler}',
											value: '<a href="' + HreRem.i18n('fieldlabel.link.web.haya') + '{getLinkHayaActivo}" target="_blank">' + HreRem.i18n('fieldlabel.web.haya') + '</a>'
										}
									},
									{
										fieldLabel: HreRem.i18n('fieldlabel.id.activo.haya'),
										cls: 'cabecera-info-field',
										bind: '{activo.numActivo}'
									},
									{
										xtype: 'imagefield',
										fieldLabel: HreRem.i18n('fieldlabel.entidad.propietaria'),
										cls: 'cabecera-info-field',
										width: 70,
										bind: {
											src: '{getSrcCartera}',
											alt: '{activo.entidadPropietariaDescripcion}'
										}
									},
									{
										fieldLabel: HreRem.i18n('fieldlabel.tipo'),
										cls: 'cabecera-info-field',
										bind: '{activo.tipoActivoDescripcion}'
									},
									{
										fieldLabel: HreRem.i18n('fieldlabel.proveedores.subcartera'),
										cls: 'cabecera-info-field',
										bind: '{activo.subcarteraDescripcion}'
									},
									{
										fieldLabel: HreRem.i18n('fieldlabel.direccion'),
										cls: 'cabecera-info-field',
										bind: '{activo.tipoViaDescripcion} {activo.nombreVia} {activo.numeroDomicilio}'
									},
									{
										fieldLabel: HreRem.i18n('fieldlabel.subtipo'),
										cls: 'cabecera-info-field',
										bind: '{activo.subtipoActivoDescripcion}'
									},
									{
										fieldLabel: HreRem.i18n('fieldlabel.municipio'),
										cls: 'cabecera-info-field',
										bind: '{activo.municipioDescripcion} {activo.codPostalFormateado}'
									},
									{
										fieldLabel: HreRem.i18n('fieldlabel.provincia'),
										cls: 'cabecera-info-field',
										bind: '{activo.provinciaDescripcion}'
									},
									{
										fieldLabel: HreRem.i18n('fieldlabel.origen'),
										cls: 'cabecera-info-field',
										bind: '{activo.tipoTitulo}'
									},
									{
										fieldLabel: HreRem.i18n('fieldlabel.clase'),
										cls: 'cabecera-info-field',
										bind:{
											value: '{activo.claseActivoDescripcion}',
											disabled: '{!activo.claseActivoDescripcion}'
										}
									}
								]
							},
							{
								xtype:'container',
								style: 'float: right;',
								maxWidth: 400,
								bind: {
									hidden: '{!avisos.descripcion}'
								},
								padding: '10 30 0 30',
								flex: 2.5,
								height: 125,
								autoScroll: true,
								defaultType: 'displayfield',
								cls: 'cabecera-apartado cabecera-avisos',
								items: [
									{
										cls: 'display-field-avisos',
										bind: {
											value: '{avisos.descripcion}'
										}
									}
								]
							},
							{
								xtype: 'image',
								style: 'float: right;',
								height: 110,
								width: 110,
								margin: '15 10 0 10 ',
								cls: 'cabecera-sello',
								bind: {
									src: '{getSrcSelloCalidad}'
								},
								alt: 'Calidad'
							}
						]
					}
	];

	me.callParent();

	},

	refreshData:function(data) {
		var me = this,
		token = "",
		title = "Activo " + data.get("numActivo");

		var tipoVia = Ext.isEmpty(data.get('tipoViaDescripcion')) ? "" : data.get('tipoViaDescripcion'),
		nombreVia = Ext.isEmpty(data.get('nombreVia')) ? "" : data.get('nombreVia'),
		numero = Ext.isEmpty(data.get('numeroDomicilio')) ? "" : data.get('numeroDomicilio'),
		municipio = Ext.isEmpty(data.get('municipioDescripcion')) ? "" : data.get('municipioDescripcion'),
		provincia = Ext.isEmpty(data.get('provinciaDescripcion')) ? "" : data.get('provinciaDescripcion'),
		token = tipoVia + " " + nombreVia + " " + numero + " " + municipio + " " + provincia,
		longitud = data.get('longitud'),
		latitud =  data.get('latitud'),
		center= null;

		me.down('botonfavorito').setOpenId(data.get("id"));

		me.gmap.configurarMapa(latitud, longitud, token, title);

		me.down('[tipo=panelgmap]').add(me.gmap);
	}
});
