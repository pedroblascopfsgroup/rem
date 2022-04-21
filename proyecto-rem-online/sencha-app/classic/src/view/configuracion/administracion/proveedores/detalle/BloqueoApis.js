Ext.define('HreRem.view.configuracion.administracion.proveedores.detalle.BloqueoApis', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'bloqueoApis',
    reference: 'bloqueoApis',
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    scrollable	: 'y',
    recordName: "bloqueo",
	recordClass: "HreRem.model.BloqueoApis",
	requires: ['HreRem.model.FichaProveedorModel','HreRem.model.BloqueoApis', 'HreRem.view.common.ItemSelectorBase', 'HreRem.model.BloqueoApis'],
	listeners	: {
			boxready:'cargarTabData'
	},
    initComponent: function () {
        var me = this;

        me.setTitle(HreRem.i18n('title.bloqueo.apis'));
        
        me.items= [

		            {
						xtype:'fieldsettable',
						defaultType: 'textfieldbase',						
						collapsible: false,
						items :
							[

					            {
									xtype:'fieldsettable',
									defaultType: 'textfieldbase',						
									title: HreRem.i18n('title.bloqueo.apis.actual'),
									collapsible: true,
									width: "100%", 
									colspan: 3,
									items :
										[
											
											{
									            xtype: 'itemselectorbase',
									            reference: 'itemselCartera',
									            fieldLabel: HreRem.i18n('fieldlabel.cartera'),
									            store: {
									            	model: 'HreRem.model.ComboBase',
													proxy: {
														type: 'uxproxy',
														remoteUrl: 'generic/getDiccionario',
														extraParams: {diccionario: 'entidadesPropietarias'}
													},
													autoLoad: true
									            },
									            bind: {
									            	value: '{bloqueo.carteraCodigo}'
									            },
                                                listeners:{
                                                    change: function(){
                                                        var me = this;
                                                        var observaciones = me.lookupController('proveedordetalle').lookupReference('observaciones'),
                                                        motivoActual = me.lookupController('proveedordetalle').getView().getViewModel().get('bloqueo.motivo'),
                                                        motivoAntiguo = me.lookupController('proveedordetalle').getView().getViewModel().get('bloqueo.motivoAnterior'),
                                                        form = me.up('tabpanel').getActiveTab();

                                                        if(motivoAntiguo == motivoActual){
                                                            observaciones.setValue("");
                                                            form.isFormValid();
                                                        }
                                                    }
                                                }
									        },
									        {
									            xtype: 'itemselectorbase',
									            reference: 'itemselLineaNegocio',
									            fieldLabel: HreRem.i18n('title.linea.negocio'),
									            store: {
									            	model: 'HreRem.model.ComboBase',
													proxy: {
														type: 'uxproxy',
														remoteUrl: 'generic/getDiccionario',
														extraParams: {diccionario: 'tiposComercializacionActivo'}
													},
													autoLoad: true
									            },
									            bind: {
									            	value: '{bloqueo.lineaNegocioCodigo}'
									            },
                                                listeners:{
                                                    change: function(){
                                                        var me = this;
                                                        var observaciones = me.lookupController('proveedordetalle').lookupReference('observaciones'),
                                                        motivoActual = me.lookupController('proveedordetalle').getView().getViewModel().get('bloqueo.motivo'),
                                                        motivoAntiguo = me.lookupController('proveedordetalle').getView().getViewModel().get('bloqueo.motivoAnterior'),
                                                        form = me.up('tabpanel').getActiveTab();

                                                        if(motivoAntiguo == motivoActual){
                                                           observaciones.setValue("");
                                                           form.isFormValid();
                                                        }
                                                     }
                                                 }
									        },
									        {
									            xtype: 'itemselectorbase',
									            reference: 'itemselEspecialidad',
									            fieldLabel: HreRem.i18n('title.especialidad'),
									            store: {
									            	model: 'HreRem.model.ComboBase',
													proxy: {
														type: 'uxproxy',
														remoteUrl: 'generic/getDiccionario',
														extraParams: {diccionario: 'especialidad'}
													},
													autoLoad: true
									            },
									            bind: {
									            	value: '{bloqueo.especialidadCodigo}'
									            },
                                                listeners:{
                                                    change: function(){
                                                        var me = this;
                                                        var observaciones = me.lookupController('proveedordetalle').lookupReference('observaciones'),
                                                        motivoActual = me.lookupController('proveedordetalle').getView().getViewModel().get('bloqueo.motivo'),
                                                        motivoAntiguo = me.lookupController('proveedordetalle').getView().getViewModel().get('bloqueo.motivoAnterior'),
                                                        form = me.up('tabpanel').getActiveTab();

                                                        if(motivoAntiguo == motivoActual){
                                                            observaciones.setValue("");
                                                            form.isFormValid();
                                                        }
                                                    }
                                                }
									        },
									        {
									            xtype: 'itemselectorbase',
									            reference: 'itemselProvincia',
									            fieldLabel: HreRem.i18n('fieldlabel.provincia'),
									            store: {
									            	model: 'HreRem.model.ComboBase',
													proxy: {
														type: 'uxproxy',
														remoteUrl: 'generic/getDiccionario',
														extraParams: {diccionario: 'provincias'}
													},
													autoLoad: true
									            },
									            bind: {
									            	value: '{bloqueo.provinciaCodigo}'
									            },
                                                listeners:{
                                                    change: function(){
                                                        var me = this;
                                                        var observaciones = me.lookupController('proveedordetalle').lookupReference('observaciones'),
                                                        motivoActual = me.lookupController('proveedordetalle').getView().getViewModel().get('bloqueo.motivo'),
                                                        motivoAntiguo = me.lookupController('proveedordetalle').getView().getViewModel().get('bloqueo.motivoAnterior'),
                                                        form = me.up('tabpanel').getActiveTab();

                                                        if(motivoAntiguo == motivoActual){
                                                            observaciones.setValue("");
                                                            form.isFormValid();
                                                        }
                                                    }
                                                }
									        },
									        {
												xtype : "textareafieldbase",
												fieldLabel : HreRem.i18n('fieldlabel.comerical.oferta.detalle.cajamar.observaciones'),
												reference: 'observaciones',
												labelAlign: 'top',
												grow: true,
												anchor: '100%',
												bind : {
													value: '{bloqueo.motivo}'
												},
												width: '100%',
                                                allowBlank: false
											}
											
										]
					            },
					         // Fila 8 (Mediador)
					            {
									xtype:'fieldsettable',
									defaultType: 'textfieldbase',						
									title: HreRem.i18n('title.bloqueo.apis.historico'),
									collapsible: false,
									colspan: 3,
									items :
										[
											{
												xtype : 'bloqueoApisHistoricoGrid'
											}
										]
					            }
							]
		           }
        ];
        
    	me.callParent();
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