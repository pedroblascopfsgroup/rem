Ext.define('HreRem.view.agrupaciones.AgrupacionesList', {
   	extend: 'HreRem.view.common.GridBaseEditableRow',
    xtype: 'agrupacioneslist',
  //  cls	: 'panel-base shadow-panel',
    /*collapsed: false,
    reference: 'agrupacioneslist',
    scrollable	: 'y',
    layout: 'fit',
    */
    bind: {
		store: '{agrupaciones}'
	},
 	reference: 'agrupacioneslistgrid',
	editOnSelect : false,
    topBar: true,
    
	secFunToEdit: 'EDITAR_LIST_AGRUPACIONES',
	
	secButtons: {
		secFunPermToEnable : 'EDITAR_LIST_AGRUPACIONES'
	},
    
    initComponent: function () {
     	
     	var me = this;
     	me.setTitle(HreRem.i18n('title.listado.agrupaciones'));
     	
     	me.addListener('rowdblclick', 'onAgrupacionesListDobleClick');

     	me.columns = [
			    
		  				{
			            	text	 : HreRem.i18n('header.numero.agrupacion'),
			                flex	 : 1,
			                dataIndex: 'numAgrupacionRem'
			            },
			            {
				            dataIndex: 'tipoAgrupacion',
				            text: HreRem.i18n('header.tipo'),
							width: 250, 
				            renderer: function (value) {
				            	return Ext.isEmpty(value) ? "" : value.descripcion;
				            },
				            editor: {
			        			xtype: 'combobox',
			        			bind: {
				            		store: '{comboTipoAgrupacion}',
				            		value: '{tipoAgrupacion.codigo}'
				            	},					            	
				            	displayField: 'descripcion',
								valueField: 'codigo'								
				        	}		            
				        },
			            {
			         		text	 : HreRem.i18n('header.nombre'),
			                flex	 : 1,
			                dataIndex: 'nombre',
							editor: {xtype:'textfield'}

			            },
			            {
			            	text	 : HreRem.i18n('header.descripcion'),
			                flex	 : 1,
			                dataIndex: 'descripcion',
			                editor: {xtype:'textfield'}
			            },
			            {
				            dataIndex: 'localidad',
				            text: HreRem.i18n('header.provincia'),
				            renderer: function (value) {
				            	return Ext.isEmpty(value) ? "" : value.provincia.descripcion;
				            }
				        },
				        {
				            dataIndex: 'localidad',
				            text: HreRem.i18n('header.municipio'),
				            renderer: function (value) {
				            	return Ext.isEmpty(value) ? "" : value.descripcion;
				            }
				        },
				        {
			            	text	 : HreRem.i18n('header.direccion'),
			                flex	 : 1,
			                dataIndex: 'direccion',
			                editor: {xtype:'textfield'}
			            },
			            {   
			            	text	 : HreRem.i18n('header.fecha.alta'),
			                dataIndex: 'fechaAlta',
					        formatter: 'date("d/m/Y")',
					        width: 130 
					    },
					    {   
			            	text	 : HreRem.i18n('header.fecha.baja'),
			                dataIndex: 'fechaBaja',
					        formatter: 'date("d/m/Y")',
					        width: 130 
					    },
			            {
			            	text	 : HreRem.i18n('header.numero.activos.incluidos'),
			                flex	 : 1,
			                dataIndex: 'activos'
			            },
			            {
			            	text	 : HreRem.i18n('header.numero.activos.publicados'),
			                flex	 : 1,
			                dataIndex: 'publicados'
			            }
		
			        ];
			        
			me.dockedItems = [
			        {
			            xtype: 'pagingtoolbar',
			            dock: 'bottom',
			            itemId: 'agrupacionesPaginationToolbar',
			            displayInfo: true,
			            bind: {
			                store: '{agrupaciones}'
			            }
			        }
			    ];
		    
			me.callParent();
		}
    
});