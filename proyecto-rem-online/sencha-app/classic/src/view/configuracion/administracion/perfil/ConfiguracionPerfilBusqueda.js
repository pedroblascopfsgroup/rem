Ext.define('HreRem.view.configuracion.administracion.perfiles.ConfiguracionPerfilesBusqueda', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'configuracionperfilesbusqueda',
    reference: 'configuracionPerfilesBusqueda',
    isSearchPerfilesForm: true,
    cls	: 'panel-base shadow-panel',
    collapsible: true,
    collapsed: false,    
    layout: {
        type: 'accordion',
        titleCollapse: false,
        animate: true,
        vertical: true,
        multi: true
    },
    recordName: "funcion",
    recordClass: "HreRem.model.Funcion",
    requires: ['HreRem.model.Funcion'],

	initComponent: function() {
	
		var me = this;
    	me.setTitle(HreRem.i18n('title.configuracion.perfiles.perfiles'));
	    me.items= [
	         {
    			xtype: 'panel',
    			collapsible: false,
    			layout: 'column',
    			title: HreRem.i18n('title.configuracion.perfiles.busqueda'),
    			cls: 'panel-busqueda-avanzada',
    			defaults: {
			        layout: 'form',
			        xtype: 'container',
			        defaultType: 'textfield'
			    },
				items: [
							{
								columnWidth: 1,
								items:[    			
	
										{    			                
											xtype:'fieldsettable',
											defaultType: 'textfield',
											colspan: 3,
								    		defaults: {							        
												addUxReadOnlyEditFieldPlugin: false,
												style: 'width: 50%'
											},
											items :	[
												{ 
													fieldLabel:  HreRem.i18n('fieldlabel.configuracion.perfiles.descripcion'),
													name: 'perfilDescripcion',
													colspan: 3
												},
												{ 
													fieldLabel:  HreRem.i18n('fieldlabel.configuracion.perfiles.codigo.perfil'),
													name: 'perfilCodigo',
													colspan: 3
												},
												{
										            xtype: 'itemselectorbase',
										            name: 'funcionDescripcionLarga',
										            reference: 'itemselFunciones',
										            fieldLabel: HreRem.i18n('fieldlabel.configuracion.perfiles.funciones'),
										            store: {
										            	model: 'HreRem.model.Funcion',
														proxy: {
															type: 'uxproxy',
															remoteUrl: 'funciones/getFunciones',
															actionMethods: {create: 'POST', read: 'POST', update: 'POST', destroy: 'POST'}
														},
														autoLoad: true
										            },
										            valueField: 'descripcion',
										            loadSource: true,
										            labelAlign: 'left',
										        	height: 300,
										        	maxHeight: 300,
										        	width: 841,
										        	maxWidth: 841
										        }
											]
							                
							            }
	            				]			
	            			}
				]
    		}
	    ];
	   	
	    me.callParent();
	}
});