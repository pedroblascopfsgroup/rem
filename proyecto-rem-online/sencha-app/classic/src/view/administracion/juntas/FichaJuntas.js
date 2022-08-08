Ext.define('HreRem.view.administracion.juntas.FichaJuntas', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'fichajuntas',
    reference: 'fichajuntasRef',
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    scrollable	: 'y',
    recordName: "juntaactual",
    //controller: 'administracion',
	recordClass: "HreRem.model.JuntasPropietarios",
    requires: ['HreRem.model.FichaProveedorModel', 'HreRem.view.common.ItemSelectorBase', 'HreRem.model.JuntasPropietarios',
    	       'HreRem.view.common.ItemSelectorBase',
               'HreRem.view.configuracion.administracion.proveedores.detalle.DireccionesDelegacionesList',
               'HreRem.view.configuracion.administracion.proveedores.detalle.PersonasContactoList',
               'HreRem.view.configuracion.administracion.proveedores.detalle.ActivosIntegradosList', 'HreRem.model.DatosContactoModel'], 

 

               initComponent: function() {
               	var me = this;
               	
              
               		me.setTitle(HreRem.i18n('title.datos'));
           	    	
           	    	me.items= [
    					
           							           	{
           											xtype:'fieldsettable',
           											collapsible: false,
           											defaultType: 'textfieldbase',
           											cls: 'panel-base shadow-panel',
           											margin: '10 10 10 10',
           											layout: {
           										        type: 'table',
           										        columns: 2,
           										        tdAttrs: {width: '55%'}
           											},
           											title: HreRem.i18n('fieldlabel.juntas.datosidentificativos'),
           											items :
           												[
           													{
           														xtype: 'datefieldbase',
           											        	fieldLabel: HreRem.i18n('fieldlabel.juntas.fecha.junta'),
           														reference: 'fechajunta',
           														name: 'fechajunta',
           														bind: '{junta.fechaJunta}'
           											        },
           											        {
           											        	fieldLabel: HreRem.i18n('title.comunidad'),
           														reference: 'comunidad',
           														name: 'comunidad',
           											        	bind: '{junta.codProveedor}'
           							                		},
           													{
           											        	fieldLabel:  HreRem.i18n('fieldlabel.entidad.propietaria'),
           											        	reference: 'cartera',
           											        	name: 'cartera',
           											        	bind: '{junta.cartera}'
           											        },
           											        {
           											        	fieldLabel:  HreRem.i18n('header.numero.activo.haya'),
           											        	reference: 'numactivo',
           											        	name: 'numactivo',
           											        	bind: '{junta.numActivo}'
           											        },
           											        {
           											        	fieldLabel:  HreRem.i18n('fieldlabel.direccion'),
           											        	reference: 'direccion',
           											        	name: 'direccion',
           											        	bind: '{junta.localizacion}'
           											        },
           											        {
           											        	xtype: 'numberfieldbase',
           														fieldLabel: HreRem.i18n('fieldlabel.juntas.porcetnaje.participacion'),
           														reference: 'pparticipacion',
           														symbol: HreRem.i18n("symbol.porcentaje"),
           														name: 'pparticipacion',
           														bind: '{junta.porcentaje}'
           													}
           												]
           											        
           							           },
           							           {
           							           		xtype:'fieldsettable',
           											collapsible: false,
           											defaultType: 'textfieldbase',
           											cls: 'panel-base shadow-panel',
           											margin: '10 10 10 10',
           											layout: {
           										        type: 'table',
           										        columns: 2,
           										        tdAttrs: {width: '55%'}
           											},
           											title: HreRem.i18n('fieldlabel.juntas.promociones'),
           											items :
           												[
           													{
           														xtype: 'comboboxfieldbase',
           												        fieldLabel: HreRem.i18n('fieldlabel.juntas.promocion'),
           														reference: 'promocion',
           														name: 'promocion',
           														bind: {
           															store: '{comboSiNoJuntas}',
           															value: '{junta.promoMayor50}'
           														}
           													},
           													{
           														xtype: 'comboboxfieldbase',
           												        fieldLabel: HreRem.i18n('fieldlabel.juntas.promocion.perjuicio'),
           														reference: 'perjuicio',
           														name: 'perjuicio',
           														bind: {
           															store: '{comboSiNoJuntas}',
           															value: '{junta.promo20a50}'
           														}
           													}
           												]
           							           },
           							           {
           							           		xtype:'fieldsettable',
           											collapsible: false,
           											defaultType: 'textfieldbase',
           											cls: 'panel-base shadow-panel',
           											margin: '10 10 10 10',
           											layout: {
           										        type: 'table',
           										        columns: 2,
           										        tdAttrs: {width: '55%'}
           											},
           											title: HreRem.i18n('fieldlabel.juntas.puntos'),
           											items :
           												[
           													{
           												        fieldLabel: HreRem.i18n('fieldlabel.juntas.jgo.je'),
           														reference: 'jgoje',
           														name: 'jgoje',
           														bind: '{junta.junta}'
           													},
           													{
           														xtype: 'comboboxfieldbase',
           												        fieldLabel: HreRem.i18n('fieldlabel.juntas.act.judic'),
           														reference: 'judicial',
           														name: 'judicial',
           														bind: {
           															store: '{comboSiNoJuntas}',
           															value: '{junta.judicial}'
           														}
           													},
           													{
           														xtype: 'comboboxfieldbase',
           												        fieldLabel: HreRem.i18n('fieldlabel.juntas.derrama'),
           														reference: 'derrama',
           														name: 'codTipoDocumento',
           														bind: {
           															store: '{comboSiNoJuntas}',
           															value: '{junta.derrama}'
           														}
           													},
           													{
           														xtype: 'comboboxfieldbase',
           												        fieldLabel: HreRem.i18n('fieldlabel.juntas.mod.estatutos'),
           														reference: 'estatutos',
           														name: 'estatutos',
           														bind: {
           															store: '{comboSiNoJuntas}',
           															value: '{junta.estatutos}'
           														}
           													},
           													{
           														xtype: 'comboboxfieldbase',
           												        fieldLabel: HreRem.i18n('fieldlabel.juntas.ite'),
           														reference: 'ite',
           														name: 'ite',
           														bind: {
           															store: '{comboSiNoJuntas}',
           															value: '{junta.ite}'
           														}
           													},
           													{
           														xtype: 'comboboxfieldbase',
           												        fieldLabel: HreRem.i18n('fieldlabel.juntas.morosos'),
           														reference: 'morosos',
           														name: 'morosos',														
           														bind: {
           															store: '{comboSiNoJuntas}',
           															value: '{junta.morosos}'
           														}
           													},
           													{
           														xtype: 'comboboxfieldbase',
           												        fieldLabel: HreRem.i18n('fieldlabel.juntas.cuota'),
           														reference: 'cuota',
           														name: 'cuota',
           														bind: {
           															store: '{comboSiNoJuntas}',
           															value: '{junta.cuota}'
           														}
           													},
           													{
           												        fieldLabel: HreRem.i18n('fieldlabel.otros'),
           														reference: 'otros',
           														name: 'otros',
           														bind: '{junta.otros}'
           													},
           													{
           														xtype: 'currencyfieldbase',
           												        fieldLabel: HreRem.i18n('header.importe'),
           														reference: 'importe',
           														name: 'importe',
           														bind: '{junta.importe}'
           													}
           												]
           							           },
           							           {
           							           		xtype:'fieldsettable',
           											collapsible: false,
           											defaultType: 'textfieldbase',
           											cls: 'panel-base shadow-panel',
           											margin: '10 10 10 10',
           											layout: {
           										        type: 'table',
           										        columns: 2,
           										        tdAttrs: {width: '55%'}
           											},
           											title: HreRem.i18n('fieldlabel.juntas.pago.programado'),
           											items :
           												[
           													{
           														xtype: 'currencyfieldbase',
           												        fieldLabel: HreRem.i18n('fieldlabel.juntas.cuota.ordinaria'),
           														reference: 'ordinaria',
           														name: 'ordinaria',
           														bind: '{junta.ordinaria}'
           													},
           													{
           														xtype: 'currencyfieldbase',
           												        fieldLabel: HreRem.i18n('fieldlabel.juntas.cuota.extra'),
           														reference: 'extra',
           														name: 'extra',
           														bind: '{junta.extra}'
           													},
           													{
           														xtype: 'currencyfieldbase',
           												        fieldLabel: HreRem.i18n('fieldlabel.juntas.suministros'),
           														reference: 'suministros',
           														name: 'suministros',
           														bind: '{junta.suministros}'
           													}
           												]
           							           },
           							           {
           											xtype:'fieldsettable',
           											collapsible: false,
           											defaultType: 'textfieldbase',
           											cls: 'panel-base shadow-panel',
           											margin: '10 10 10 10',
           											layout: {
           										        type: 'table',
           										        columns: 2,
           										        tdAttrs: {width: '55%'}
           											},
           											items: [
           												{
           											        fieldLabel: HreRem.i18n('btn.propuesta.oferta'),
           													reference: 'oferta',
           													name: 'oferta',
           													bind: '{junta.propuesta}'
           												},
           												{
           											        fieldLabel: HreRem.i18n('fieldlabel.juntas.guion.voto'),
           													reference: 'voto',
           													name: 'voto',
           													bind: '{junta.voto}'
           												},
           												{
           											        fieldLabel: HreRem.i18n('fieldlabel.juntas.indicaciones'),
           													reference: 'indicaciones',
           													name: 'indicaciones',
           													bind: '{junta.indicaciones}'
           												}
           											]
           							           }		
           	    	];

           		me.callParent();
               },
               actualizarTabJuntas: function(){
               	me.funcionRecargar();
               },
               funcionRecargar: function() {
               	var me = this; 
           		me.recargar = false;
           		me.lookupController().cargarTabData(me);
           		Ext.Array.each(me.query('grid'), function(grid) {
             			grid.getStore().load();
             		});
               }               
               
});