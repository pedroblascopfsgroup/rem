//Ext.define('HreRem.view.activos.detalle.TestigosOfertaGrid', {
//    extend		: 'HreRem.view.common.GridBaseEditableRow',
//    xtype		: 'testigosofertagrid',
//	topBar: false,
//	idPrincipal : 'expediente.id',
//	requires	: [ 'HreRem.view.expedientes.ExpedienteDetalleModel'],
//    bind: {
//        store: '{testigosOferta}'
//    },
//    secFunToEdit: 'EDITAR_TAB_DATOS_BASICOS_OFERTA_EXPEDIENTES',
//    initComponent: function () {
//     	
//     	var me = this;
//
//		me.topBar = $AU.userHasFunction(['EDITAR_TAB_DATOS_BASICOS_OFERTA_EXPEDIENTES']);
//		
//		me.columns = [
//				{
//		            dataIndex: 'id',
//		            flex: 0.3,
//		            hidden: true
//		        },
//		        {
//		            dataIndex: 'fuenteTestigosDesc',
//		            text: HreRem.i18n('title.testigos.fuente'),
//					editor: {
//						xtype: 'combobox',
//		        		bind: {
//		            		store: '{comboDDFuenteTestigos}'
//		            	},
//		            	displayField: 'descripcion',
//						valueField: 'codigo'
//					},
//		            flex: 0.2
//		        },
//		        {
//		        	dataIndex: 'tipoActivoDesc',
//		            text: HreRem.i18n('title.testigos.tipo.activo'),
//					editor: {
//						xtype: 'combobox',
//		        		bind: {
//		            		store: '{comboDDTipoActivo}'
//		            	},
//		            	displayField: 'descripcion',
//						valueField: 'codigo'
//					},
//		            flex: 0.2
//		        },
//		        {
//		        	dataIndex: 'precioMercado',
//		            text: HreRem.i18n('title.testigos.precio.mercado'),
//					editor: {
//		            	xtype: 'textfield'
//		            },
//		            flex: 0.2
//		        },	
//				{
//		        	dataIndex: 'superficie',
//		            text: HreRem.i18n('title.testigos.superficie'),
//					editor: {
//		            	xtype: 'textfield'
//		            },
//		            flex: 0.2
//		        },
//		        {
//		        	dataIndex: 'eurosMetro',
//		            text: HreRem.i18n('title.testigos.euros.metro'),
//					editor: {
//		            	xtype: 'textfield'
//		            },
//		            flex: 0.2
//		        },   
//		        {
//		        	dataIndex: 'enlace',
//		            text: HreRem.i18n('title.testigos.enlace'),
//					editor: {
//		            	xtype: 'textfield'
//		            },
//		            renderer: function(value) {
//						if (value != null && value != undefined)
//		            	return '<a href="' + value + '" target="_blank">' + value + '</a>'
//		        	},
//		            flex: 0.5
//		        },
//		        {
//		        	dataIndex: 'direccion',
//		            text: HreRem.i18n('title.testigos.direccion'),
//					editor: {
//		            	xtype: 'textfield'
//		            },
//		            flex: 0.5
//		        }		
//		    ];
//		    me.dockedItems = [
//		        {
//		            xtype: 'pagingtoolbar',
//		            dock: 'bottom',
//		            inputItemWidth: 60,
//		            displayInfo: true,
//		            bind: {
//		                store: '{testigosOferta}'
//		            }
//		        }
//		    ];
//		    
//		    
//		    me.callParent();
//   }
//
//});